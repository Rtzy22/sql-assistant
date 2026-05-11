<template>
  <n-modal
    v-model:show="showModal"
    preset="dialog"
    title="MFA 验证"
    positive-text="提交"
    negative-text="取消"
    @positive-click="submit"
    @negative-click="cancel"
    :mask-closable="false"
  >
    <n-text>Cookie 可能已过期，请输入 MFA 验证码：</n-text>
    <n-input
      v-model:value="mfaCode"
      placeholder="输入 6 位 MFA 码"
      :maxlength="6"
      style="margin-top: 12px"
      @keydown.enter="submit"
    />
  </n-modal>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { NModal, NInput, NText } from 'naive-ui'

const showModal = ref(false)
const mfaCode = ref('')
let removeListener = null

onMounted(() => {
  if (!window.electronAPI) return
  removeListener = window.electronAPI.onMfaRequest(() => {
    mfaCode.value = ''
    showModal.value = true
  })
})

onUnmounted(() => {
  if (showModal.value && window.electronAPI?.cancelMfa) {
    window.electronAPI.cancelMfa()
  }
  if (removeListener) removeListener()
})

function submit() {
  if (!mfaCode.value.trim()) return false
  if (window.electronAPI) {
    window.electronAPI.submitMfa(mfaCode.value.trim())
  }
  mfaCode.value = ''
  showModal.value = false
}

function cancel() {
  if (window.electronAPI?.cancelMfa) {
    window.electronAPI.cancelMfa()
  }
  mfaCode.value = ''
  showModal.value = false
}
</script>
