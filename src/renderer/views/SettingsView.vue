<template>
  <div class="settings-view">
    <n-scrollbar>
      <div class="settings-content">
        <n-h2>设置</n-h2>

        <n-card title="大模型配置" size="small">
          <n-form label-placement="left" label-width="120">
            <n-form-item label="API Base URL">
              <n-input v-model:value="llmConfig.baseUrl" placeholder="https://api.openai.com/v1" />
            </n-form-item>
            <n-form-item label="API Key">
              <n-input v-model:value="llmConfig.apiKey" type="password" show-password-on="click" placeholder="sk-..." />
            </n-form-item>
            <n-form-item label="模型名称">
              <n-input v-model:value="llmConfig.model" placeholder="gpt-4o" />
            </n-form-item>
          </n-form>
        </n-card>

        <n-card title="SRE 工单系统配置" size="small" style="margin-top: 16px">
          <n-form label-placement="left" label-width="120">
            <n-form-item label="SRE 地址">
              <n-input v-model:value="sreConfig.baseUrl" placeholder="https://sre.wps.cn" />
            </n-form-item>
            <n-form-item label="Cookie">
              <n-input
                v-model:value="sreConfig.cookie"
                type="textarea"
                :autosize="{ minRows: 3, maxRows: 6 }"
                placeholder="从浏览器复制 Cookie 粘贴到此处"
              />
            </n-form-item>
            <n-form-item label="MySQL 实例">
              <n-dynamic-input
                v-model:value="sreConfig.unitIds"
                placeholder="输入 unit_id，如 4925"
                :min="1"
              />
            </n-form-item>
            <n-form-item label="company_id">
              <n-input
                v-model:value="sreConfig.companyId"
                placeholder="输入企业ID，如 648787953"
              />
            </n-form-item>
          </n-form>
        </n-card>

        <div style="margin-top: 16px; text-align: right">
          <n-button type="primary" @click="saveConfig" :loading="saving">
            保存配置
          </n-button>
        </div>
      </div>
    </n-scrollbar>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  NScrollbar, NH2, NCard, NForm, NFormItem, NInput, NDynamicInput, NButton,
  useMessage,
} from 'naive-ui'

const message = useMessage()
const saving = ref(false)

const llmConfig = ref({
  baseUrl: '',
  apiKey: '',
  model: 'gpt-4o',
})

const sreConfig = ref({
  baseUrl: 'https://sre.wps.cn',
  cookie: '',
  unitIds: [],
  companyId: '',
})

onMounted(async () => {
  if (!window.electronAPI) return
  try {
    const llm = await window.electronAPI.getConfig('llm')
    if (llm) llmConfig.value = { ...llmConfig.value, ...llm }
    const sre = await window.electronAPI.getConfig('sre')
    if (sre) sreConfig.value = { ...sreConfig.value, ...sre }
  } catch (e) {
    console.error('加载配置失败', e)
  }
})

async function saveConfig() {
  if (!window.electronAPI) {
    message.warning('Electron API 不可用（仅在 Electron 环境中生效）')
    return
  }
  saving.value = true
  try {
    await window.electronAPI.setConfig('llm', JSON.parse(JSON.stringify(llmConfig.value)))
    await window.electronAPI.setConfig('sre', JSON.parse(JSON.stringify(sreConfig.value)))
    message.success('配置已保存')
  } catch (e) {
    message.error('保存失败: ' + e.message)
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.settings-view {
  height: 100vh;
}

.settings-content {
  max-width: 700px;
  margin: 0 auto;
  padding: 24px;
}
</style>
