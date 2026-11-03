# Soon plugins for AI assistants

This repository packages [Soon](https://soon.works) for AI assistants. Every
plugin connects to the same remote, OAuth-protected MCP server at
`https://mcp.soon.works/mcp`. Your Soon team and board permissions are
enforced on every action.

| Assistant | Plugin | Manifest |
| --- | --- | --- |
| Claude Code | `plugins/soon` | `.claude-plugin/marketplace.json` |
| OpenAI Codex | `plugins/soon-mcp` | `.agents/plugins/marketplace.json` |
| Any MCP client | n/a | `mcp/server.json` (registry metadata) |

Grok and other assistants can be added the same way, as another plugin folder
with its own manifest. The MCP server is shared, so nothing else changes.

## Install

### Claude Code

```
/plugin marketplace add SoonHQ/soon-plugin
/plugin install soon@soon
```

### Codex

```bash
codex plugin marketplace add SoonHQ/soon-plugin
codex plugin add soon-mcp@soon
```

On first use the assistant opens your browser so you can sign in to Soon and
authorize access. Admins can make changes. Members get read access and
self-service actions.

## What's here

```
.claude-plugin/marketplace.json     # Claude Code marketplace catalog
.agents/plugins/marketplace.json    # Codex marketplace catalog
mcp/server.json                      # public MCP registry metadata
plugins/soon/                        # Claude Code plugin (skills + MCP config)
plugins/soon-mcp/                    # Codex plugin (skill + MCP config)
scripts/                             # validation and endpoint checks
END_USER_TESTING.md                  # fresh-session test checklist for Codex
```

The MCP server itself (tools, OAuth, data access) lives in Soon's private
backend. This repository only packages the connector and skills.

## Develop and test locally

```bash
claude plugin validate ./plugins/soon
claude plugin validate .
./scripts/validate-codex.sh
./scripts/check-public-mcp.sh
```

Published manifests use the public HTTPS URL and OAuth at runtime. Do not
commit a local or dev URL.

## Learn more

- Setup guide: https://soon.works/integrations/ai-connector
- Privacy notice: https://soon.works/legal/mcp-privacy

## Support

developers@soonapp.io
