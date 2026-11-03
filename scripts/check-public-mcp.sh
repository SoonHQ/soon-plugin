#!/usr/bin/env bash
set -euo pipefail

base_url="${SOON_MCP_BASE_URL:-https://mcp.soon.works}"
mcp_url="$base_url/mcp"
resource_url="$base_url/.well-known/oauth-protected-resource/mcp"
oauth_metadata_url="$base_url/.well-known/oauth-authorization-server"

check_get() {
  local label="$1"
  local url="$2"
  local status

  if ! status="$(curl -L -s -o /dev/null -w '%{http_code}' "$url")"; then
    echo "FAIL $label: curl could not reach $url" >&2
    return 1
  fi

  if [[ "$status" != "200" ]]; then
    echo "FAIL $label: expected HTTP 200, got $status ($url)" >&2
    return 1
  fi

  echo "OK   $label: HTTP $status"
}

check_mcp_initialize() {
  local body

  if ! body="$(
    curl -L -s \
      -H 'content-type: application/json' \
      -H 'accept: application/json, text/event-stream' \
      --data '{"jsonrpc":"2.0","id":"soon-smoke","method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"soon-smoke","version":"0.1.0"}}}' \
      "$mcp_url"
  )"; then
    echo "FAIL MCP initialize: curl could not reach $mcp_url" >&2
    return 1
  fi

  if ! grep -q '"name":"soon-mcp"' <<<"$body"; then
    echo "FAIL MCP initialize: expected serverInfo.name soon-mcp, got: $body" >&2
    return 1
  fi

  echo "OK   MCP initialize: soon-mcp"
}

check_mcp_auth_challenge() {
  local status

  if ! status="$(
    curl -L -s -o /dev/null -w '%{http_code}' \
      -H 'content-type: application/json' \
      -H 'accept: application/json, text/event-stream' \
      --data '{"jsonrpc":"2.0","id":"soon-smoke-auth","method":"tools/call","params":{"name":"get_me","arguments":{}}}' \
      "$mcp_url"
  )"; then
    echo "FAIL MCP auth challenge: curl could not reach $mcp_url" >&2
    return 1
  fi

  case "$status" in
    401|403)
      echo "OK   MCP auth challenge: HTTP $status"
      ;;
    *)
      echo "FAIL MCP auth challenge: expected HTTP 401 or 403, got $status ($mcp_url)" >&2
      return 1
      ;;
  esac
}

check_get "OAuth protected resource metadata" "$resource_url"
check_get "OAuth authorization server metadata" "$oauth_metadata_url"
check_mcp_initialize
check_mcp_auth_challenge

echo "Public Soon MCP endpoint preflight passed for $base_url."
