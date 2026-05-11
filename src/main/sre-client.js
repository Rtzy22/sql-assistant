const { BrowserWindow } = require('electron')
const { getConfig } = require('./store')

const MFA_TIMEOUT_MS = 120000
const MAX_MFA_RETRY = 1
let sessionCookie = ''

function getSreCookie() {
  if (sessionCookie) return sessionCookie
  const sre = getConfig('sre')
  return sre.cookie || ''
}

function getSreHeaders(options = {}) {
  const { cookie, extraHeaders } = options
  const sre = getConfig('sre')
  const headers = {
    'accept': '*/*',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'no-cache',
    'content-type': 'application/json',
    'cookie': cookie ?? getSreCookie(),
    'sre-mfa-request-id': String(Date.now()),
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36',
  }
  if (extraHeaders && typeof extraHeaders === 'object') {
    return { ...headers, ...extraHeaders }
  }
  return headers
}

function getBaseUrl() {
  const sre = getConfig('sre')
  return sre.baseUrl || 'https://sre.wps.cn'
}

function safeJsonParse(text) {
  if (!text) return null
  try {
    return JSON.parse(text)
  } catch {
    return null
  }
}

function getSetCookieHeaders(headers) {
  if (typeof headers.getSetCookie === 'function') {
    return headers.getSetCookie()
  }
  const raw = headers.get('set-cookie')
  return raw ? [raw] : []
}

function parseCookieMap(cookieHeader = '') {
  const map = new Map()
  cookieHeader
    .split(';')
    .map(item => item.trim())
    .filter(Boolean)
    .forEach((cookieItem) => {
      const idx = cookieItem.indexOf('=')
      if (idx <= 0) return
      const key = cookieItem.slice(0, idx).trim()
      const value = cookieItem.slice(idx + 1).trim()
      if (key && value) map.set(key, value)
    })
  return map
}

function mergeCookieHeader(baseCookie, setCookieHeaders = []) {
  const cookieMap = parseCookieMap(baseCookie)
  setCookieHeaders.forEach((setCookie) => {
    const pair = String(setCookie || '').split(';')[0]
    const idx = pair.indexOf('=')
    if (idx <= 0) return
    const key = pair.slice(0, idx).trim()
    const value = pair.slice(idx + 1).trim()
    if (!key || !value) return
    cookieMap.set(key, value)
  })
  return Array.from(cookieMap.entries())
    .map(([key, value]) => `${key}=${value}`)
    .join('; ')
}

function updateSessionCookieFromResponse(resp, currentCookie) {
  const setCookieHeaders = getSetCookieHeaders(resp.headers)
  if (!setCookieHeaders.length) return currentCookie
  const merged = mergeCookieHeader(currentCookie, setCookieHeaders)
  if (merged) sessionCookie = merged
  return merged || currentCookie
}

function isMfaRequired(status, payload, text) {
  if (payload?.code === 40304) return true
  if (String(payload?.code || '') === '40304') return true
  if (status === 401 && /40304|高风险操作/.test(String(text || ''))) return true
  return false
}

function hasBizError(payload) {
  if (!payload || typeof payload !== 'object' || payload.code === undefined || payload.code === null) {
    return false
  }
  const codeNum = Number(payload.code)
  if (Number.isFinite(codeNum)) {
    return codeNum !== 0
  }
  return String(payload.code) !== '0'
}

function formatHttpError(prefix, status, payload, text) {
  const detail = payload ? JSON.stringify(payload) : text
  return `${prefix}: ${status} ${detail || '未知错误'}`
}

async function readResponse(resp) {
  const text = await resp.text()
  const payload = safeJsonParse(text)
  return { text, payload }
}

async function requestMfaFromUser(timeoutMs = MFA_TIMEOUT_MS) {
  const wins = BrowserWindow.getAllWindows()
  if (wins.length === 0) return null

  return new Promise((resolve) => {
    let finished = false
    let timer = null
    const finish = (value) => {
      if (finished) return
      finished = true
      if (timer) clearTimeout(timer)
      if (global.mfaResolve === finish) {
        global.mfaResolve = null
      }
      resolve(value)
    }

    global.mfaResolve = finish
    wins[0].webContents.send('mfa:request')
    timer = setTimeout(() => finish(null), timeoutMs)
  })
}

async function verifyMfaCode(mfaCode, currentCookie) {
  const baseUrl = getBaseUrl()
  const verifyUrl = `${baseUrl}/core/user_center/api/v1/verify_mfa_code`
  const verifyResp = await fetch(verifyUrl, {
    method: 'POST',
    headers: getSreHeaders({ cookie: currentCookie }),
    body: JSON.stringify({ mfa_code: mfaCode, mfa_method: 'totp' }),
  })

  let cookieAfterVerify = updateSessionCookieFromResponse(verifyResp, currentCookie)
  const { text: verifyText, payload: verifyPayload } = await readResponse(verifyResp)

  if (!verifyResp.ok) {
    throw new Error(formatHttpError('MFA 验证失败', verifyResp.status, verifyPayload, verifyText))
  }
  if (hasBizError(verifyPayload)) {
    throw new Error(`MFA 验证失败: ${verifyPayload.code} ${verifyPayload.msg || '未知错误'}`)
  }

  const mfaSsid =
    verifyPayload?.data?.sre_mfa_ssid ||
    verifyPayload?.sre_mfa_ssid ||
    verifyPayload?.data?.mfa_ssid ||
    ''

  if (mfaSsid) {
    const loginUrl = `${baseUrl}/core/user_center/api/v1/mfa_login?sre_mfa_ssid=${encodeURIComponent(mfaSsid)}`
    const loginResp = await fetch(loginUrl, {
      method: 'GET',
      headers: getSreHeaders({
        cookie: cookieAfterVerify,
        extraHeaders: { accept: 'application/json' },
      }),
    })

    cookieAfterVerify = updateSessionCookieFromResponse(loginResp, cookieAfterVerify)
    const { text: loginText, payload: loginPayload } = await readResponse(loginResp)

    if (!loginResp.ok) {
      throw new Error(formatHttpError('MFA 登录失败', loginResp.status, loginPayload, loginText))
    }
    if (hasBizError(loginPayload)) {
      throw new Error(`MFA 登录失败: ${loginPayload.code} ${loginPayload.msg || '未知错误'}`)
    }
  }

  sessionCookie = cookieAfterVerify || currentCookie
}

async function resolveMfaChallenge(currentCookie) {
  const mfaCode = await requestMfaFromUser()
  if (!mfaCode) {
    throw new Error('MFA 验证已取消或超时，请重试')
  }
  await verifyMfaCode(mfaCode, currentCookie)
}

async function listDatabases(unitId) {
  const baseUrl = getBaseUrl()
  const url = `${baseUrl}/dbops/api/dbops/mysql/unit/${unitId}/databases`
  const resp = await fetch(url, { headers: getSreHeaders() })
  if (!resp.ok) {
    throw new Error(`获取数据库列表失败: ${resp.status} ${resp.statusText}`)
  }
  updateSessionCookieFromResponse(resp, getSreCookie())
  return resp.json()
}

async function executeSQL({ unitId, dbName, sql, limit = 1000, queryTime = 30 }) {
  const baseUrl = getBaseUrl()
  const url = `${baseUrl}/dbops/api/dbops/mysql/cmd/execute`

  const body = {
    command_line: sql,
    db_name: dbName,
    limit,
    query_time: queryTime,
    unit_id: Number(unitId),
    exec_mode: 'query',
  }

  let currentCookie = getSreCookie()

  for (let attempt = 0; attempt <= MAX_MFA_RETRY; attempt += 1) {
    const resp = await fetch(url, {
      method: 'POST',
      headers: getSreHeaders({ cookie: currentCookie }),
      body: JSON.stringify(body),
    })
    currentCookie = updateSessionCookieFromResponse(resp, currentCookie)

    const { text, payload } = await readResponse(resp)
    const mfaRequired = isMfaRequired(resp.status, payload, text)

    if (mfaRequired && attempt < MAX_MFA_RETRY) {
      await resolveMfaChallenge(currentCookie)
      currentCookie = getSreCookie()
      continue
    }

    if (!resp.ok) {
      throw new Error(formatHttpError('SQL 执行失败', resp.status, payload, text))
    }

    if (mfaRequired) {
      throw new Error('SQL 执行失败: MFA 验证未通过，请重试')
    }

    if (hasBizError(payload)) {
      throw new Error(`SQL 执行失败: ${payload.code} ${payload.msg || text || '未知错误'}`)
    }

    return payload ?? { raw: text }
  }

  throw new Error('SQL 执行失败: MFA 重试次数已用尽')
}

module.exports = { executeSQL, listDatabases, requestMfaFromUser }
