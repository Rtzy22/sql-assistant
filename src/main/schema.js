const fs = require('fs')
const path = require('path')
const { app } = require('electron')
const { getConfig, setConfig } = require('./store')

let cachedSchema = null

function findSqlFile() {
  const candidates = [
    path.join(__dirname, '../../curl/migrate_project.sql'),
    path.join(process.resourcesPath || '', 'curl/migrate_project.sql'),
  ]
  try {
    candidates.push(path.join(app.getAppPath(), 'curl/migrate_project.sql'))
  } catch {}
  for (const p of candidates) {
    if (fs.existsSync(p)) return p
  }
  return null
}

function parseSchemaSQL() {
  if (cachedSchema) return cachedSchema

  const sqlPath = findSqlFile()
  if (!sqlPath) {
    cachedSchema = '(未找到 schema 文件)'
    return cachedSchema
  }

  const sql = fs.readFileSync(sqlPath, 'utf-8')
  const tables = []
  const tableRegex = /CREATE TABLE IF NOT EXISTS `(\w+)`\s*\(([\s\S]*?)\)\s*ENGINE/g

  let match
  while ((match = tableRegex.exec(sql)) !== null) {
    const tableName = match[1]
    // skip shard tables like _00, _01, etc
    if (/_(0[0-9]|[12][0-9]|3[01])$/.test(tableName)) continue

    const body = match[2]
    const columns = []
    const colRegex = /`(\w+)`\s+([\w()]+(?:\s+unsigned)?)\s+.*?COMMENT\s+'([^']*)'/g
    let colMatch
    while ((colMatch = colRegex.exec(body)) !== null) {
      columns.push({
        name: colMatch[1],
        type: colMatch[2],
        comment: colMatch[3],
      })
    }
    tables.push({ name: tableName, columns })
  }

  const shardedTables = [
    'ms_drive_item', 'ms_drive_item_permission', 'ms_drive_item_raw_permission',
    'wps_file', 'wps_file_permission',
  ]

  let text = '## 数据库表结构\n\n'
  text += '数据库名格式: migrate_project_{企业id}\n\n'
  text += '### 分表规则\n'
  text += `以下表有 _00 到 _31 共 32 张分表: ${shardedTables.join(', ')}\n`
  text += '查询分表时默认 UNION ALL 所有分表，WHERE 条件必须包含命中索引的字段\n\n'

  for (const table of tables) {
    text += `### ${table.name}\n`
    if (shardedTables.includes(table.name)) {
      text += '(分表: _00 ~ _31)\n'
    }
    text += '| 字段 | 类型 | 说明 |\n|---|---|---|\n'
    for (const col of table.columns) {
      text += `| ${col.name} | ${col.type} | ${col.comment} |\n`
    }
    text += '\n'
  }

  cachedSchema = text
  return cachedSchema
}

function getSchemaText() {
  return parseSchemaSQL()
}

function getKnowledgeDoc() {
  return getConfig('knowledgeDoc') || ''
}

function setKnowledgeDoc(content) {
  setConfig('knowledgeDoc', content)
}

function buildSystemPrompt() {
  const schema = getSchemaText()
  const knowledge = getKnowledgeDoc()
  const sre = getConfig('sre') || {}
  const hasUnitId = Array.isArray(sre.unitIds) && sre.unitIds.some(id => String(id || '').trim())
  const configuredCompanyId = String(sre.companyId || '').trim()
  const hasCompanyId = /^\d+$/.test(configuredCompanyId)

  let prompt = `你是一个数据库排障助手，帮助用户查询微软云文档迁移系统的数据库。

## 核心规则
1. 数据库使用 migrate_project_{企业id} 逻辑库
2. 以下表有 _00 到 _31 共 32 张分表，查询时必须 UNION ALL 所有分表:
   - ms_drive_item, ms_drive_item_permission, ms_drive_item_raw_permission
   - wps_file, wps_file_permission
3. WHERE 条件必须包含命中索引的字段（如 file_id, item_id, third_id, drive_id 等）
4. 不要生成 UPDATE/DELETE/DROP 等写操作

## 输出格式
请返回一个 JSON 数组（不要包含 markdown 代码块标记），每个元素包含:
- "sql": SQL 语句（注意分表要 UNION ALL）
- "description": 这条 SQL 查询的目的

示例: [{"sql":"SELECT * FROM ...","description":"查询文件迁移状态"}]

${schema}
`

  if (hasCompanyId) {
    prompt += `
## 交互约束
- 当前已配置固定 company_id: ${configuredCompanyId}。
- 返回的 SQL 必须使用 migrate_project_${configuredCompanyId}.表名 形式的库前缀（如 migrate_project_${configuredCompanyId}.wps_file_00）。
- 不要使用问题里出现的其他企业ID覆盖该 company_id。
`
  } else if (hasUnitId) {
    prompt += `
## 交互约束
- 当前已配置数据库实例 unit_id。
- 当用户问题没有给出企业ID时，也要直接返回可执行的查询 SQL，不要追问企业ID。
- 返回的 SQL 语句禁止包含 migrate_project_数字.表名 这样的库名前缀，只能使用表名（如 wps_file_00）。
- 数据库定位由执行参数 unit_id + db_name 负责，不要在 SQL 文本中重复写库名前缀。
`
  } else {
    prompt += `
## 交互约束
- 当前未配置数据库实例 unit_id。
- 如果用户没有提供企业ID，请先提醒补充企业ID再生成 SQL。
`
  }

  if (knowledge.trim()) {
    prompt += `\n## 业务知识\n${knowledge}\n`
  }

  return prompt
}

module.exports = { getSchemaText, getKnowledgeDoc, setKnowledgeDoc, buildSystemPrompt }
