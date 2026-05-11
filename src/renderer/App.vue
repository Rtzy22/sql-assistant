<template>
  <n-config-provider :theme="darkTheme" :locale="zhCN" :date-locale="dateZhCN">
    <n-global-style />
    <n-message-provider>
    <n-dialog-provider>
    <n-layout has-sider style="height: 100vh">
      <n-layout-sider
        :width="200"
        :collapsed-width="64"
        collapse-mode="width"
        bordered
        show-trigger
        v-model:collapsed="collapsed"
      >
        <div class="logo" :class="{ collapsed }">
          <span v-if="!collapsed">SQL Assistant</span>
          <span v-else>SA</span>
        </div>
        <n-menu
          :value="activeTab"
          :options="menuOptions"
          :collapsed="collapsed"
          @update:value="activeTab = $event"
        />
      </n-layout-sider>
      <n-layout>
        <ChatView v-if="activeTab === 'chat'" />
        <SettingsView v-else-if="activeTab === 'settings'" />
        <SchemaView v-else-if="activeTab === 'schema'" />
      </n-layout>
    </n-layout>
    </n-dialog-provider>
    </n-message-provider>
  </n-config-provider>
</template>

<script setup>
import { ref, h } from 'vue'
import {
  NConfigProvider, NGlobalStyle, NLayout, NLayoutSider, NMenu,
  NMessageProvider, NDialogProvider,
  darkTheme,
} from 'naive-ui'
import { zhCN, dateZhCN } from 'naive-ui'
import { NIcon } from 'naive-ui'
import {
  ChatbubblesOutline,
  SettingsOutline,
  LibraryOutline,
} from '@vicons/ionicons5'
import ChatView from './views/ChatView.vue'
import SettingsView from './views/SettingsView.vue'
import SchemaView from './views/SchemaView.vue'

const activeTab = ref('chat')
const collapsed = ref(false)

function renderIcon(icon) {
  return () => h(NIcon, null, { default: () => h(icon) })
}

const menuOptions = [
  { label: '智能问答', key: 'chat', icon: renderIcon(ChatbubblesOutline) },
  { label: '知识库', key: 'schema', icon: renderIcon(LibraryOutline) },
  { label: '设置', key: 'settings', icon: renderIcon(SettingsOutline) },
]
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  overflow: hidden;
}

.logo {
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: bold;
  color: #63e2b7;
  border-bottom: 1px solid rgba(255, 255, 255, 0.09);
  transition: all 0.3s;
}

.logo.collapsed {
  font-size: 16px;
}
</style>
