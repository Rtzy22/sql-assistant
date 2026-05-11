<template>
  <div class="result-table" v-if="rows.length > 0">
    <n-collapse>
      <n-collapse-item :title="`查询结果 (${rows.length} 行)`" name="result">
        <n-data-table
          :columns="columns"
          :data="rows"
          :max-height="300"
          :scroll-x="scrollX"
          size="small"
          bordered
          striped
        />
      </n-collapse-item>
    </n-collapse>
  </div>
  <div v-else-if="data" class="result-empty">
    <n-text depth="3" style="font-size: 12px">无数据返回</n-text>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { NCollapse, NCollapseItem, NDataTable, NText } from 'naive-ui'

const props = defineProps({
  data: { type: [Object, null], default: null },
})

const rows = computed(() => {
  if (!props.data) return []
  if (Array.isArray(props.data)) return props.data
  if (props.data.data && Array.isArray(props.data.data)) return props.data.data
  if (props.data.rows && Array.isArray(props.data.rows)) return props.data.rows
  return []
})

const columns = computed(() => {
  if (rows.value.length === 0) return []
  const keys = Object.keys(rows.value[0])
  return keys.map(key => ({
    title: key,
    key,
    ellipsis: { tooltip: true },
    width: Math.max(100, Math.min(key.length * 12, 300)),
    render(row) {
      const val = row[key]
      return val === null ? 'NULL' : String(val)
    },
  }))
})

const scrollX = computed(() => {
  return columns.value.reduce((sum, col) => sum + (col.width || 150), 0)
})
</script>

<style scoped>
.result-table {
  margin-top: 8px;
}

.result-empty {
  margin-top: 4px;
}
</style>
