const { ipcMain } = require('electron')
const { getConfig, setConfig } = require('./store')
const { callLLM } = require('./llm-service')
const { executeSQL, listDatabases } = require('./sre-client')
const { getSchemaText, getKnowledgeDoc, setKnowledgeDoc } = require('./schema')

function registerIpcHandlers() {
  ipcMain.handle('config:get', (_event, key) => getConfig(key))
  ipcMain.handle('config:set', (_event, key, value) => setConfig(key, value))

  ipcMain.handle('llm:chat', async (event, messages) => {
    return callLLM(event, messages)
  })

  ipcMain.handle('sre:execute-sql', async (_event, params) => {
    return executeSQL(params)
  })

  ipcMain.handle('sre:list-databases', async (_event, unitId) => {
    return listDatabases(unitId)
  })

  ipcMain.handle('schema:get', () => getSchemaText())
  ipcMain.handle('schema:get-knowledge', () => getKnowledgeDoc())
  ipcMain.handle('schema:set-knowledge', (_event, content) => setKnowledgeDoc(content))

  ipcMain.handle('mfa:response', (_event, code) => {
    if (global.mfaResolve) {
      global.mfaResolve(code)
      global.mfaResolve = null
    }
    return true
  })

  ipcMain.handle('mfa:cancel', () => {
    if (global.mfaResolve) {
      global.mfaResolve(null)
      global.mfaResolve = null
    }
    return true
  })
}

module.exports = { registerIpcHandlers }
