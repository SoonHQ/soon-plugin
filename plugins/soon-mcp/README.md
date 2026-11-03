# Soon MCP Codex Plugin

This plugin connects Codex to the Soon MCP server. It bundles:

- `.codex-plugin/plugin.json` with Codex plugin metadata
- `.mcp.json` with the Soon Streamable HTTP MCP server declaration
- `skills/soon/SKILL.md` with Soon scheduling workflow guidance

## Local Development

The checked-in `.mcp.json` points at the public production MCP server:

```json
{
  "mcpServers": {
    "soon": {
      "type": "http",
      "url": "https://mcp.soon.works/mcp"
    }
  }
}
```

Use the repo-local marketplace at `.agents/plugins/marketplace.json` to install
the plugin in Codex during development.

For local backend testing only, temporarily change the URL to
`http://localhost:4040/mcp`, then run `npm run local:start` from `soon-server`.
Do not publish that local URL.

For local authenticated testing, mint a dev token with:

```bash
npm run mcp:dev-token -- <userId> [teamId]
```

## Production Release

The marketplace release must point `.mcp.json` at the public HTTPS MCP origin:

```json
{
  "mcpServers": {
    "soon": {
      "type": "http",
      "url": "https://mcp.soon.works/mcp"
    }
  }
}
```

The production Soon MCP server must expose OAuth metadata, dynamic client
registration, and `POST /mcp` over HTTPS.

## Security

Soon MCP tokens are OAuth-issued and team-scoped. The server enforces role-capped
scopes, actor board permissions, and audit logging for tool calls. The plugin
does not ship secrets.
