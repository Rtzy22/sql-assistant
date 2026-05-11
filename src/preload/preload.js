const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  // Config
  getConfig: (key) => ipcRenderer.invoke('config:get', key),
  setConfig: (key, value) => ipcRenderer.invoke('config:set', key, value),

  // LLM
  chatWithLLM: (messages) => ipcRenderer.invoke('llm:chat', messages),
  onLLMStream: (callback) => {
    const handler = (_event, chunk) => callback(chunk)
    ipcRenderer.on('llm:stream', handler)
    return () => ipcRenderer.removeListener('llm:stream', handler)
  },

  // SRE
  executeSQL: (params) => ipcRenderer.invoke('sre:execute-sql', params),
  listDatabases: (unitId) => ipcRenderer.invoke('sre:list-databases', unitId),

  // MFA
  onMfaRequest: (callback) => {
    const handler = (_event) => callback()
    ipcRenderer.on('mfa:request', handler)
    return () => ipcRenderer.removeListener('mfa:request', handler)
  },
  submitMfa: (code) => ipcRenderer.invoke('mfa:response', code),
  cancelMfa: () => ipcRenderer.invoke('mfa:cancel'),

  // Schema
  getSchema: () => ipcRenderer.invoke('schema:get'),
  getKnowledgeDoc: () => ipcRenderer.invoke('schema:get-knowledge'),
  setKnowledgeDoc: (content) => ipcRenderer.invoke('schema:set-knowledge', content),
})
