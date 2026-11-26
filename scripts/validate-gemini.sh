#!/usr/bin/env bash
# Validate the Gemini CLI extension at the repo root and the JSON of the
# Antigravity plugin. Needs `gemini` (npm i -g @google/gemini-cli).
set -euo pipefail
cd "$(dirname "$0")/.."
for f in gemini-extension.json mcp_config.json .antigravity-plugin/plugin.json; do
  node -e "JSON.parse(require('fs').readFileSync('$f','utf8'))" || { echo "invalid JSON: $f"; exit 1; }
done
ctx=$(node -p "require('./gemini-extension.json').contextFileName")
[ -f "$ctx" ] || { echo "contextFileName missing: $ctx"; exit 1; }
url=$(node -p "require('./gemini-extension.json').mcpServers.soon.url")
[ "$url" = "https://mcp.soon.works/mcp" ] || { echo "unexpected MCP url: $url"; exit 1; }
gemini extensions validate . 2>&1 | grep -q "successfully validated" || { echo "gemini extensions validate failed"; exit 1; }
if command -v agy >/dev/null; then agy plugin validate --strict .; fi
echo "Gemini/Antigravity manifests OK"
