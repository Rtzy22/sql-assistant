const fs = require('fs')
const path = require('path')
const { app } = require('electron')

let configPath = ''
let configData = {}

function getConfigPath() {
  if (configPath) return configPath
  try {
    const userDataPath = app.getPath('userData')
    configPath = path.join(userDataPath, 'sql-assistant-config.json')
  } catch {
    configPath = path.join(process.cwd(), '.sql-assistant-config.json')
  }
  return configPath
}

function loadConfig() {
  try {
    const filePath = getConfigPath()
    if (fs.existsSync(filePath)) {
      const raw = fs.readFileSync(filePath, 'utf-8')
      configData = JSON.parse(raw)
    }
  } catch (e) {
    console.error('加载配置失败:', e.message)
    configData = {}
  }
}

function saveConfig() {
  try {
    const filePath = getConfigPath()
    fs.writeFileSync(filePath, JSON.stringify(configData, null, 2), 'utf-8')
  } catch (e) {
    console.error('保存配置失败:', e.message)
  }
}

function getConfig(key) {
  if (Object.keys(configData).length === 0) loadConfig()
  return configData[key] ?? getDefaults()[key]
}

function setConfig(key, value) {
  if (Object.keys(configData).length === 0) loadConfig()
  configData[key] = value
  saveConfig()
}

function getDefaults() {
  return {
    llm: {
      baseUrl: '',
      apiKey: '',
      model: 'gpt-4o',
    },
    sre: {
      baseUrl: 'https://sre.wps.cn',
      cookie: '',
      unitIds: [],
      companyId: '',
    },
    knowledgeDoc: '',
    chatHistory: [],
  }
}

module.exports = { getConfig, setConfig }
