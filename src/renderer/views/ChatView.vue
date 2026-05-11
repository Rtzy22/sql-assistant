<template>
  <div class="chat-view">
    <div class="chat-header">
      <n-space align="center" justify="space-between" style="width: 100%">
        <n-space align="center">
          <n-tag :type="configReady ? 'success' : 'warning'" size="small">
            {{ configReady ? '已配置' : '未配置' }}
          </n-tag>
          <n-text depth="3">智能排障助手</n-text>
        </n-space>
        <n-button size="small" quaternary @click="clearChat">清空对话</n-button>
      </n-space>
    </div>

    <div class="chat-messages" ref="messagesRef">
      <div v-if="messages.length === 0" class="empty-state">
        <n-empty size="large">
          <template #description>
            <n-text depth="3">
              输入问题开始排障<br/>
              例如：查企业 648787953 中文件 bsvuiHf6qxMvVTv9Bmva1xNN1ggPbSZWz 的迁移状态
            </n-text>
          </template>
        </n-empty>
      </div>
      <MessageBubble
        v-for="(msg, idx) in messages"
        :key="idx"
        :msg="msg"
        @execute-sql="(sqlIdx) => onExecuteSql(idx, sqlIdx)"
        @skip-sql="(sqlIdx) => onSkipSql(idx, sqlIdx)"
      />
      <div v-if="loading" class="loading-indicator">
        <n-spin size="small" />
        <n-text depth="3" style="margin-left: 8px">思考中...</n-text>
      </div>
    </div>

    <div class="chat-input">
      <n-input
        v-model:value="inputText"
        type="textarea"
        placeholder="输入你的问题..."
        :autosize="{ minRows: 1, maxRows: 4 }"
        :disabled="loading"
        @keydown.enter.exact.prevent="sendMessage"
      />
      <n-button
        type="primary"
        @click="sendMessage"
        :disabled="!inputText.trim() || loading"
        :loading="loading"
      >
        发送
      </n-button>
    </div>

    <MfaDialog />
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted, onUnmounted } from 'vue'
import { NInput, NButton, NSpace, NTag, NText, NEmpty, NSpin, useMessage } from 'naive-ui'
import MessageBubble from '../components/MessageBubble.vue'
import MfaDialog from '../components/MfaDialog.vue'

const message = useMessage()
const inputText = ref('')
const messages = ref([])
const loading = ref(false)
const configReady = ref(false)
const messagesRef = ref(null)
const CHAT_HISTORY_KEY = 'chatHistory'

let removeStreamListener = null
let persistTimer = null
let persistQueue = Promise.resolve()

onMounted(async () => {
  if (!window.electronAPI) return
  try {
    const llm = await window.electronAPI.getConfig('llm')
    configReady.value = !!(llm && llm.baseUrl && llm.apiKey)
  } catch {}
  try {
    const chatHistory = await window.electronAPI.getConfig(CHAT_HISTORY_KEY)
    if (Array.isArray(chatHistory)) {
      messages.value = chatHistory
      scrollToBottom()
    }
  } catch (e) {
    console.error('加载聊天记录失败', e)
  }

  removeStreamListener = window.electronAPI.onLLMStream((chunk) => {
    const lastMsg = messages.value[messages.value.length - 1]
    if (lastMsg && lastMsg.role === 'assistant') {
      lastMsg.content += chunk
      schedulePersist(300)
    }
  })
})

onUnmounted(() => {
  if (removeStreamListener) removeStreamListener()
  flushPersistNow()
  if (persistTimer) {
    clearTimeout(persistTimer)
    persistTimer = null
  }
})

function scrollToBottom() {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

function clearChat() {
  messages.value = []
  schedulePersist(0)
}

function normalizeUnitId(unitIds) {
  if (!Array.isArray(unitIds)) return ''
  return String(unitIds.find(id => String(id || '').trim()) || '').trim()
}

function normalizeCompanyId(companyId) {
  const text = String(companyId || '').trim()
  return /^\d+$/.test(text) ? text : ''
}

function extractCompanyIdFromMessages() {
  const text = messages.value
    .filter(m => m.role === 'user')
    .map(m => m.content)
    .join(' ')
  const match = text.match(/企业(?:id|ID)?\s*[:：]?\s*(\d+)|company[_\s-]*id\s*[:=]?\s*(\d+)/i)
  return match?.[1] || match?.[2] || ''
}

function transformSqlOutsideProtectedSegments(sql, transformPlainSegment) {
  const source = String(sql || '')
  if (!source) return source

  let output = ''
  let plainText = ''
  let inSingleQuote = false
  let inDoubleQuote = false
  let inBacktick = false
  let inLineComment = false
  let inBlockComment = false

  for (let i = 0; i < source.length; i += 1) {
    const ch = source[i]
    const next = source[i + 1] || ''
    const next2 = source[i + 2] || ''

    if (inLineComment) {
      output += ch
      if (ch === '\n') inLineComment = false
      continue
    }

    if (inBlockComment) {
      output += ch
      if (ch === '*' && next === '/') {
        output += next
        i += 1
        inBlockComment = false
      }
      continue
    }

    if (inSingleQuote) {
      output += ch
      if (ch === '\'' && source[i - 1] !== '\\') inSingleQuote = false
      continue
    }

    if (inDoubleQuote) {
      output += ch
      if (ch === '"' && source[i - 1] !== '\\') inDoubleQuote = false
      continue
    }

    if (inBacktick) {
      output += ch
      if (ch === '`' && next === '`') {
        output += next
        i += 1
        continue
      }
      if (ch === '`') inBacktick = false
      continue
    }

    if (ch === '-' && next === '-' && (!next2 || /\s/.test(next2))) {
      output += transformPlainSegment(plainText)
      plainText = ''
      output += ch + next
      i += 1
      inLineComment = true
      continue
    }

    if (ch === '/' && next === '*') {
      output += transformPlainSegment(plainText)
      plainText = ''
      output += ch + next
      i += 1
      inBlockComment = true
      continue
    }

    if (ch === '\'') {
      output += transformPlainSegment(plainText)
      plainText = ''
      output += ch
      inSingleQuote = true
      continue
    }

    if (ch === '"') {
      output += transformPlainSegment(plainText)
      plainText = ''
      output += ch
      inDoubleQuote = true
      continue
    }

    if (ch === '`') {
      output += transformPlainSegment(plainText)
      plainText = ''
      output += ch
      inBacktick = true
      continue
    }

    plainText += ch
  }

  output += transformPlainSegment(plainText)
  return output
}

function stripDatabasePrefix(sql) {
  return transformSqlOutsideProtectedSegments(sql, segment =>
    segment.replace(/\bmigrate_project_\d+\s*\.\s*/gi, '')
  )
}

function addDatabasePrefix(sql, dbName) {
  const cleanSql = stripDatabasePrefix(sql)
  if (!dbName) return cleanSql
  return transformSqlOutsideProtectedSegments(cleanSql, segment =>
    segment.replace(
      /\b(from|join|update|into|table)\s+(`?[a-zA-Z_][\w$]*`?(?:\s*\.\s*`?[a-zA-Z_][\w$]*`?)?)/gi,
      (_full, keyword, tableExpr) => {
        const tableName = String(tableExpr).split('.').pop().trim()
        return `${keyword} ${dbName}.${tableName}`
      }
    )
  )
}

function collectDatabaseNames(payload, result = new Set()) {
  if (typeof payload === 'string') {
    if (/^migrate_project_\d+$/i.test(payload)) {
      result.add(payload)
    }
    return result
  }

  if (Array.isArray(payload)) {
    payload.forEach(item => collectDatabaseNames(item, result))
    return result
  }

  if (!payload || typeof payload !== 'object') return result

  Object.entries(payload).forEach(([key, value]) => {
    if (typeof value === 'string') {
      const lowerKey = key.toLowerCase()
      if (
        /^migrate_project_\d+$/i.test(value) ||
        lowerKey.includes('db') ||
        lowerKey.includes('database')
      ) {
        result.add(value)
      }
      return
    }
    collectDatabaseNames(value, result)
  })

  return result
}

function normalizeColumns(columns) {
  if (!Array.isArray(columns)) return []
  return columns
    .map((col, idx) => {
      if (col && typeof col === 'object' && col.name) {
        return String(col.name).trim()
      }
      if (typeof col === 'string' && col.trim()) {
        return col.trim()
      }
      return `column_${idx}`
    })
    .filter(Boolean)
}

function mapRowsWithColumnNames(rows, columnNames) {
  if (!Array.isArray(rows) || rows.length === 0) return rows
  if (!Array.isArray(columnNames) || columnNames.length === 0) return rows
  if (!rows.every(row => Array.isArray(row))) return rows

  return rows.map((row) => {
    const mapped = {}
    columnNames.forEach((name, idx) => {
      mapped[name] = idx < row.length ? row[idx] : null
    })
    if (row.length > columnNames.length) {
      mapped.__extra_values = row.slice(columnNames.length)
    }
    return mapped
  })
}

function normalizeExecuteResult(result) {
  if (!result || typeof result !== 'object') return result

  const topLevelColumns = normalizeColumns(result.columns)
  if (Array.isArray(result.rows) && topLevelColumns.length > 0) {
    return {
      ...result,
      rows: mapRowsWithColumnNames(result.rows, topLevelColumns),
    }
  }

  if (result.data && typeof result.data === 'object') {
    const nestedColumns = normalizeColumns(result.data.columns)
    if (Array.isArray(result.data.rows) && nestedColumns.length > 0) {
      return {
        ...result,
        data: {
          ...result.data,
          rows: mapRowsWithColumnNames(result.data.rows, nestedColumns),
        },
      }
    }
  }

  return result
}

async function resolveDbName(unitId, companyId) {
  if (!unitId) {
    if (companyId) {
      throw new Error('未配置 unit_id，请先在设置页填写数据库实例')
    }
    throw new Error('未配置 unit_id，且问题中未包含企业ID，请在问题中补充企业ID')
  }

  if (companyId) return `migrate_project_${companyId}`

  const listResp = await window.electronAPI.listDatabases(unitId)
  const dbNames = Array.from(collectDatabaseNames(listResp))
  const migrateDbNames = dbNames.filter(name => /^migrate_project_\d+$/i.test(name))
  const candidates = migrateDbNames.length > 0 ? migrateDbNames : dbNames

  if (candidates.length === 0) {
    throw new Error('已配置 unit_id，但未获取到数据库名，请在问题中补充企业ID')
  }

  candidates.sort()
  return candidates[0]
}

function flushPersistNow() {
  if (!window.electronAPI) return
  const snapshot = JSON.parse(JSON.stringify(messages.value))
  persistQueue = persistQueue
    .catch(() => {})
    .then(() => window.electronAPI.setConfig(CHAT_HISTORY_KEY, snapshot))
    .catch((e) => console.error('保存聊天记录失败', e))
}

function schedulePersist(delay = 150) {
  if (!window.electronAPI) return
  if (persistTimer) clearTimeout(persistTimer)
  persistTimer = setTimeout(() => {
    persistTimer = null
    flushPersistNow()
  }, delay)
}

async function sendMessage() {
  const text = inputText.value.trim()
  if (!text || loading.value) return

  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  scrollToBottom()

  loading.value = true
  messages.value.push({ role: 'assistant', content: '', sqls: null })
  schedulePersist(0)
  scrollToBottom()

  try {
    const chatHistory = JSON.parse(JSON.stringify(
      messages.value
        .filter(m => m.role === 'user' || (m.role === 'assistant' && m.content))
        .map(m => ({ role: m.role, content: m.content }))
    ))

    const fullContent = await window.electronAPI.chatWithLLM(chatHistory)

    const lastMsg = messages.value[messages.value.length - 1]
    lastMsg.content = fullContent

    const sqls = parseSqlFromResponse(fullContent)
    if (sqls.length > 0) {
      lastMsg.sqls = sqls.map(s => ({ ...s, status: 'pending', result: null }))
      lastMsg.content = '已为您生成以下查询：'
    }
  } catch (e) {
    const lastMsg = messages.value[messages.value.length - 1]
    lastMsg.content = `错误: ${e.message}`
  } finally {
    loading.value = false
    schedulePersist(0)
    scrollToBottom()
  }
}

function parseSqlFromResponse(content) {
  try {
    const jsonMatch = content.match(/\[[\s\S]*\]/)
    if (jsonMatch) {
      const parsed = JSON.parse(jsonMatch[0])
      if (Array.isArray(parsed) && parsed.length > 0 && parsed[0].sql) {
        return parsed
      }
    }
  } catch {}
  return []
}

async function onExecuteSql(msgIdx, sqlIdx) {
  const msg = messages.value[msgIdx]
  if (!msg || !msg.sqls || !msg.sqls[sqlIdx]) return

  const sqlItem = msg.sqls[sqlIdx]
  sqlItem.status = 'running'
  schedulePersist(0)

  try {
    const sre = await window.electronAPI.getConfig('sre')
    const unitId = normalizeUnitId(sre?.unitIds)
    const configuredCompanyId = normalizeCompanyId(sre?.companyId)
    const companyId = configuredCompanyId || extractCompanyIdFromMessages()
    const dbName = await resolveDbName(unitId, companyId)
    const normalizedSql = configuredCompanyId
      ? addDatabasePrefix(sqlItem.sql, dbName)
      : (unitId ? stripDatabasePrefix(sqlItem.sql) : sqlItem.sql)
    if (normalizedSql !== sqlItem.sql) {
      sqlItem.sql = normalizedSql
    }
    const result = await window.electronAPI.executeSQL({
      unitId,
      dbName,
      sql: normalizedSql,
    })
    sqlItem.status = 'done'
    sqlItem.result = normalizeExecuteResult(result)

    const allDone = msg.sqls.every(s => s.status === 'done' || s.status === 'skipped')
    if (allDone) {
      await summarizeResults(msgIdx)
    }
  } catch (e) {
    sqlItem.status = 'error'
    sqlItem.result = e.message
  }
  schedulePersist(0)
  scrollToBottom()
}

function onSkipSql(msgIdx, sqlIdx) {
  const msg = messages.value[msgIdx]
  if (!msg || !msg.sqls || !msg.sqls[sqlIdx]) return
  msg.sqls[sqlIdx].status = 'skipped'
  schedulePersist(0)

  const allDone = msg.sqls.every(s => s.status === 'done' || s.status === 'skipped')
  if (allDone) {
    summarizeResults(msgIdx)
  }
}

async function summarizeResults(msgIdx) {
  const msg = messages.value[msgIdx]
  const executedResults = msg.sqls
    .filter(s => s.status === 'done')
    .map(s => `### ${s.description}\nSQL: ${s.sql}\n结果: ${JSON.stringify(s.result)}`)
    .join('\n\n')

  if (!executedResults) return

  loading.value = true
  messages.value.push({ role: 'assistant', content: '' })
  schedulePersist(0)
  scrollToBottom()

  try {
    const summaryMessages = [
      { role: 'user', content: `以下是查询结果，请用简洁的中文汇总分析，指出可能的数据问题：\n\n${executedResults}` },
    ]
    const summary = await window.electronAPI.chatWithLLM(summaryMessages)
    messages.value[messages.value.length - 1].content = summary
  } catch (e) {
    messages.value[messages.value.length - 1].content = `汇总失败: ${e.message}`
  } finally {
    loading.value = false
    schedulePersist(0)
    scrollToBottom()
  }
}
</script>

<style scoped>
.chat-view {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.chat-header {
  padding: 12px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.09);
  display: flex;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
}

.chat-input {
  padding: 12px 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.09);
  display: flex;
  gap: 12px;
  align-items: flex-end;
}

.loading-indicator {
  display: flex;
  align-items: center;
  padding: 8px 0;
}
</style>
