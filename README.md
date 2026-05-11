# SQL Assistant - 数据迁移排障智能问答助手

通过大模型自动生成 SQL，经 SRE 工单系统 API 执行查询，快速定位微软云文档迁移数据问题。

## 快速开始

```bash
npm install

# 开发模式（Vite + Electron 联合启动）
npm run dev:electron

# 或分步启动：
npm run dev          # 启动 Vite dev server
npm run start -- --dev  # 启动 Electron（开发模式）
```

## 使用流程

1. **设置页面** - 配置大模型 API（Base URL / API Key / Model）和 SRE 工单系统（Cookie / unit_id）
2. **知识库页面** - 查看内置表结构，编写业务知识文档提高问答准确性
3. **智能问答** - 在聊天框输入自然语言问题，如"查企业 648787953 文件 xxx 的迁移状态"

## 技术栈

- Electron 42 + Vite 6
- Vue 3 + Naive UI
- marked + highlight.js
