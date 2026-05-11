<template>
  <div class="schema-view">
    <n-scrollbar>
      <div class="schema-content">
        <n-h2>知识库</n-h2>
        <n-grid :cols="2" :x-gap="16" :y-gap="16">
          <n-gi>
            <n-card title="表结构 (只读)" size="small" class="schema-card">
              <n-input
                :value="schemaText"
                type="textarea"
                readonly
                :autosize="{ minRows: 30, maxRows: 50 }"
                placeholder="加载中..."
                style="font-family: monospace; font-size: 12px"
              />
            </n-card>
          </n-gi>
          <n-gi>
            <n-card title="业务知识文档" size="small" class="schema-card">
              <n-input
                v-model:value="knowledgeDoc"
                type="textarea"
                :autosize="{ minRows: 30, maxRows: 50 }"
                placeholder="在此编写业务知识，帮助大模型更好地理解表之间的关联关系。

示例：
- 查文件迁移状态时，ms_drive_item.item_id 对应微软侧文件ID，wps_file.third_id 也存储了同一个值
- wps_file.file_id 是 WPS 侧的文件ID
- ms_drive_item 和 wps_file 通过 third_id = item_id 关联
- user.third_union_id 是微软用户ID，user.wps_user_id 是WPS用户ID"
                style="font-family: monospace; font-size: 12px"
              />
              <template #action>
                <n-space>
                  <n-upload
                    :show-file-list="false"
                    accept=".md,.txt"
                    @before-upload="handleImport"
                  >
                    <n-button size="small">导入文件</n-button>
                  </n-upload>
                  <n-button size="small" type="primary" @click="saveKnowledge" :loading="saving">
                    保存
                  </n-button>
                </n-space>
              </template>
            </n-card>
          </n-gi>
        </n-grid>
      </div>
    </n-scrollbar>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  NScrollbar, NH2, NGrid, NGi, NCard, NInput, NButton, NSpace, NUpload,
  useMessage,
} from 'naive-ui'

const message = useMessage()
const schemaText = ref('加载中...')
const knowledgeDoc = ref('')
const saving = ref(false)

onMounted(async () => {
  if (!window.electronAPI) {
    schemaText.value = '(仅在 Electron 环境中可用)'
    return
  }
  try {
    schemaText.value = await window.electronAPI.getSchema()
    knowledgeDoc.value = await window.electronAPI.getKnowledgeDoc() || ''
  } catch (e) {
    console.error('加载知识库失败', e)
  }
})

function handleImport({ file }) {
  const reader = new FileReader()
  reader.onload = (e) => {
    knowledgeDoc.value += (knowledgeDoc.value ? '\n\n' : '') + e.target.result
    message.success(`已导入: ${file.name}`)
  }
  reader.readAsText(file.file)
  return false
}

async function saveKnowledge() {
  if (!window.electronAPI) return
  saving.value = true
  try {
    await window.electronAPI.setKnowledgeDoc(knowledgeDoc.value)
    message.success('知识库已保存')
  } catch (e) {
    message.error('保存失败: ' + e.message)
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.schema-view {
  height: 100vh;
}

.schema-content {
  padding: 24px;
}

.schema-card {
  height: calc(100vh - 120px);
}
</style>
