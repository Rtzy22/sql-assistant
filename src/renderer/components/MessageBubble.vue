<template>
  <div class="message-bubble" :class="msg.role">
    <div class="bubble-avatar">
      <n-avatar :size="32" round>
        {{ msg.role === 'user' ? '我' : 'AI' }}
      </n-avatar>
    </div>
    <div class="bubble-body">
      <div class="bubble-content" v-html="renderedContent"></div>
      <div v-if="msg.sqls && msg.sqls.length" class="bubble-sqls">
        <SqlPreview
          v-for="(item, idx) in msg.sqls"
          :key="idx"
          :sql="item.sql"
          :description="item.description"
          :result="item.result"
          :status="item.status"
          @execute="$emit('execute-sql', idx)"
          @skip="$emit('skip-sql', idx)"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { NAvatar } from 'naive-ui'
import { marked } from 'marked'
import hljs from 'highlight.js/lib/core'
import sql from 'highlight.js/lib/languages/sql'
import json from 'highlight.js/lib/languages/json'
import SqlPreview from './SqlPreview.vue'

hljs.registerLanguage('sql', sql)
hljs.registerLanguage('json', json)

const props = defineProps({
  msg: { type: Object, required: true },
})

defineEmits(['execute-sql', 'skip-sql'])

marked.setOptions({
  highlight(code, lang) {
    if (lang && hljs.getLanguage(lang)) {
      return hljs.highlight(code, { language: lang }).value
    }
    return code
  },
})

const renderedContent = computed(() => {
  if (!props.msg.content) return ''
  return marked.parse(props.msg.content)
})
</script>

<style scoped>
.message-bubble {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.message-bubble.user {
  flex-direction: row-reverse;
}

.message-bubble.user .bubble-content {
  background: #2a6e4e;
  border-radius: 12px 2px 12px 12px;
}

.bubble-body {
  max-width: 80%;
  min-width: 100px;
}

.bubble-content {
  background: rgba(255, 255, 255, 0.08);
  border-radius: 2px 12px 12px 12px;
  padding: 12px 16px;
  line-height: 1.6;
  word-break: break-word;
}

.bubble-content :deep(p) {
  margin: 0 0 8px;
}

.bubble-content :deep(p:last-child) {
  margin-bottom: 0;
}

.bubble-content :deep(pre) {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 6px;
  padding: 12px;
  overflow-x: auto;
  margin: 8px 0;
}

.bubble-content :deep(code) {
  font-family: 'Fira Code', 'Consolas', monospace;
  font-size: 13px;
}

.bubble-sqls {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
</style>
