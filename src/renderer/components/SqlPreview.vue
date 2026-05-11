<template>
  <div class="sql-preview">
    <div class="sql-header">
      <n-text depth="3" style="font-size: 12px">{{ description }}</n-text>
      <n-space size="small">
        <n-button
          v-if="status === 'pending'"
          size="tiny"
          type="primary"
          @click="$emit('execute')"
        >
          执行
        </n-button>
        <n-button
          v-if="status === 'pending'"
          size="tiny"
          @click="$emit('skip')"
        >
          跳过
        </n-button>
        <n-tag v-if="status === 'running'" type="info" size="small">执行中...</n-tag>
        <n-tag v-if="status === 'done'" type="success" size="small">已完成</n-tag>
        <n-tag v-if="status === 'skipped'" size="small">已跳过</n-tag>
        <n-tag v-if="status === 'error'" type="error" size="small">失败</n-tag>
      </n-space>
    </div>
    <pre class="sql-code"><code v-html="highlightedSql"></code></pre>
    <ResultTable v-if="result && status === 'done'" :data="result" />
    <n-text v-if="status === 'error' && result" type="error" style="font-size: 12px">
      {{ result }}
    </n-text>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { NButton, NSpace, NTag, NText } from 'naive-ui'
import hljs from 'highlight.js/lib/core'
import sql from 'highlight.js/lib/languages/sql'
import ResultTable from './ResultTable.vue'

hljs.registerLanguage('sql', sql)

const props = defineProps({
  sql: { type: String, required: true },
  description: { type: String, default: '' },
  result: { type: [Object, String, null], default: null },
  status: { type: String, default: 'pending' },
})

defineEmits(['execute', 'skip'])

const highlightedSql = computed(() => {
  return hljs.highlight(props.sql, { language: 'sql' }).value
})
</script>

<style scoped>
.sql-preview {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 8px;
  padding: 10px 14px;
  border: 1px solid rgba(255, 255, 255, 0.06);
}

.sql-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.sql-code {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  padding: 8px 12px;
  overflow-x: auto;
  margin: 0;
  font-family: 'Fira Code', 'Consolas', monospace;
  font-size: 12px;
  line-height: 1.5;
}
</style>
