const { getConfig } = require('./store')
const { buildSystemPrompt } = require('./schema')

async function callLLM(event, userMessages) {
  const llmConfig = getConfig('llm')
  if (!llmConfig.baseUrl || !llmConfig.apiKey) {
    throw new Error('请先在设置页面配置大模型 API')
  }

  const systemPrompt = buildSystemPrompt()
  const messages = [
    { role: 'system', content: systemPrompt },
    ...userMessages,
  ]

  const url = `${llmConfig.baseUrl.replace(/\/+$/, '')}/chat/completions`

  const resp = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${llmConfig.apiKey}`,
    },
    body: JSON.stringify({
      model: llmConfig.model || 'gpt-4o',
      messages,
      temperature: 0,
      stream: true,
    }),
  })

  if (!resp.ok) {
    const text = await resp.text()
    throw new Error(`LLM API 错误: ${resp.status} ${text}`)
  }

  let fullContent = ''
  const reader = resp.body.getReader()
  const decoder = new TextDecoder()

  while (true) {
    const { done, value } = await reader.read()
    if (done) break

    const chunk = decoder.decode(value, { stream: true })
    const lines = chunk.split('\n').filter(l => l.startsWith('data: '))

    for (const line of lines) {
      const data = line.slice(6).trim()
      if (data === '[DONE]') continue

      try {
        const parsed = JSON.parse(data)
        const delta = parsed.choices?.[0]?.delta?.content
        if (delta) {
          fullContent += delta
          event.sender.send('llm:stream', delta)
        }
      } catch {
        // skip malformed chunks
      }
    }
  }

  return fullContent
}

module.exports = { callLLM }
