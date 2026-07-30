# Soon — Claude plugin marketplace

This repository is the [Claude Code](https://code.claude.com/docs/en/plugins)
plugin marketplace for [Soon](https://soon.works). It distributes the **`soon`**
plugin, which connects Claude to Soon's scheduling platform over a remote,
OAuth-protected MCP server.

## Install

```
/plugin marketplace add SoonHQ/soon-claude-plugin
/plugin install soon@soon
```

On first use, Claude opens your browser to sign in to Soon and authorize access.
Your in-app team and board permissions are enforced on every action.

## What's here

```
.claude-plugin/marketplace.json     # the marketplace catalog
plugins/soon/                        # the Soon plugin
├── .claude-plugin/plugin.json       # plugin manifest
├── .mcp.json                        # remote MCP server (https://mcp.soon.works/mcp)
├── skills/                          # model-invoked scheduling workflows
└── README.md                        # plugin usage + security
```

The MCP **server** itself (the tools, OAuth, and data access) lives in Soon's
backend, not here — this repo only packages the connector + skills for Claude.

## Develop / test locally

```
claude plugin validate ./plugins/soon
claude plugin validate .
claude --plugin-dir ./plugins/soon
```

The published manifest uses the public `https` URL and OAuth at runtime.

## Releasing

Bump `version` in `plugins/soon/.claude-plugin/plugin.json` per release. The
community marketplace pins to a commit SHA; pushing new commits bumps the pin.

## Learn more

- Setup guide: https://soon.works/integrations/ai-connector
- Privacy notice: https://soon.works/legal/mcp-privacy

## Support

developers@soonapp.io
