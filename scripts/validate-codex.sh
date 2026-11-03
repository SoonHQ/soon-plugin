#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugin_path="$repo_root/plugins/soon-mcp"
validator="$HOME/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py"

if [[ ! -f "$validator" ]]; then
  echo "Missing Codex plugin validator: $validator" >&2
  exit 1
fi

python3 -m json.tool "$repo_root/.agents/plugins/marketplace.json" >/dev/null
python3 -m json.tool "$plugin_path/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$plugin_path/.mcp.json" >/dev/null
python3 "$validator" "$plugin_path"

echo "Soon Codex plugin plugin validation passed."
