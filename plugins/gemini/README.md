# Soon for Gemini CLI and Antigravity

Gemini CLI reads `gemini-extension.json` from the **repository root** (the
extensions gallery and `gemini extensions install` only look there), so the
manifest lives at the root and points its context file here:

| File | Used by |
| --- | --- |
| `/gemini-extension.json` | Gemini CLI: MCP server (`url` + `type: "http"`) and context file |
| `plugins/gemini/GEMINI.md` | Gemini CLI: how to work with Soon (self-contained; Gemini CLI loads skills only from a root `skills/` folder) |
| `/.antigravity-plugin/plugin.json` | Antigravity: plugin manifest; its skills are `plugins/soon/skills` |
| `/mcp_config.json` | Antigravity: MCP server (`serverUrl`) |

Both connect to `https://mcp.soon.works/mcp` over OAuth (DCR + PKCE). On first
use the browser opens the Soon sign-in screen.

## Install

```
gemini extensions install https://github.com/SoonHQ/soon-plugin
```

```
git clone https://github.com/SoonHQ/soon-plugin
agy plugin install ./soon-plugin
```

## Gallery

The Gemini CLI extensions gallery lists repositories with the
`gemini-cli-extension` topic and a tagged release; keep
`gemini-extension.json`'s `version` equal to the release tag.
