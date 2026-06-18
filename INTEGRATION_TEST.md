# End-to-end test checklist

Run before flipping this marketplace public. Goal: verify the **full end-user
OAuth flow** and that the skills/agent behave as expected against a real
soon-server.

## Prerequisites (one environment, reachable over public HTTPS)

Stand up soon-server (the `soon-mcp` branch) somewhere reachable — a deploy, or a
tunnel (ngrok / cloudflared) to a local instance. On that environment:

- [ ] `OAUTH_ISSUER_URL` = the public origin (e.g. `https://mcp.soon.works`)
- [ ] `PLANNER_URL` = a planner that serves `/oauth/authorize` and can redirect back
- [ ] `INTRASOLVER_URL`, `SOON_SOLVER_SYNC_URL`, `SOON_SOLVER_SYNC_TOKEN` (to exercise the solvers)
- [ ] `OauthRefreshToken` migration applied to that DB
- [ ] `/mcp` reachable: `curl https://<origin>/.well-known/oauth-protected-resource/mcp`
- [ ] Point `plugins/soon/.mcp.json` `url` at `https://<origin>/mcp` (placeholder is `mcp.soon.works`)

## Install in your Claude

```
/plugin marketplace add SoonHQ/soon-claude-plugin
/plugin install soon@soon
```

## 1. Auth flow (the main thing to verify)

- [ ] First tool use opens the browser → Soon login → team select → consent screen shows the requested scopes.
- [ ] Redirect returns to Claude and a tool call succeeds (`get_me` shows the right user/team).
- [ ] **Role capping:** an ADMIN can run write tools; a MEMBER is refused write tools (403 insufficient_scope) and admin-only actions.
- [ ] **Board rights:** an admin who isn't owner/admin of a board can't write that board.
- [ ] Disconnect/reconnect works; revoking from Soon account settings invalidates the session.

## 2. Skills / behavior

- [ ] **schedule-overview:** "show next week's schedule / how many hours are still open" → reads, doesn't write.
- [ ] **leave-management:** "list pending leave", "approve the ones that don't hurt coverage" → assesses impact, asks before approving, respects the transition map.
- [ ] **intraday-design (flagship):** "give everyone a 30-min lunch near the middle and keep at least half the floor working" → builds a valid config, saves it, runs the solver, applies via the approval card.
- [ ] Every write surfaces an **approval card** before committing.
- [ ] Server log shows one `[SOON][MCP][AUDIT]` line per tool call (actor/team/tool/outcome).

## Notes
- The local `npm run mcp:dev-token` path (header-based) is faster but **bypasses the browser OAuth**, so use it only for tool/skill smoke tests — not for validating the auth flow itself.
- Known unrelated: 5 pre-existing `replaceAssignmentsForMcp` test failures in soon-server (fail on `main` too).
