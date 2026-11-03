# End-user testing

Use this checklist to test the Soon Codex plugin the way a customer or
marketplace reviewer will experience it.

## 1. Public endpoint preflight

From this repo:

```bash
./scripts/validate-codex.sh
./scripts/check-public-mcp.sh
```

Expected:

- `/.well-known/oauth-protected-resource/mcp` returns HTTP 200.
- `/oauth` returns HTTP 200.
- unauthenticated `POST /mcp` returns an auth challenge, usually HTTP 401 or
  HTTP 403, not a DNS/TLS/proxy failure.

If DNS fails for `mcp.soon.works`, fix the public hostname before testing the
Codex install path.

## 2. Install from the local marketplace

Use a clean Codex profile or remove any previously installed Soon plugin first.

From the repo root:

```bash
codex plugin marketplace add "$(pwd)"
codex plugin add soon-mcp@soon
```

Start a new Codex thread after install. New skills and MCP tools are picked up
at session start.

## 3. Verify the plugin appears

In the Codex app, open the plugin details page for `soon-mcp`.

Check:

- display name is `Soon`;
- description says it connects to Soon over OAuth and MCP;
- starter prompts are scheduling-specific;
- MCP server is listed as `soon`;
- the Soon skill is available.

## 4. Run the first-user flow

In a new Codex thread, ask:

```text
Use Soon to show me who I am and what boards I can access.
```

Expected:

1. Codex tries Soon MCP.
2. If not authenticated, Codex asks you to connect/sign in.
3. The browser opens the Soon OAuth consent flow.
4. You sign in, pick the test workspace, and approve scopes.
5. Returning to Codex, retrying the prompt succeeds with `get_me`.

## 5. Run safe customer prompts

Use a test workspace where changes are allowed.

```text
Show me this week's schedule and open roles.
```

Expected: Codex reads schedule data before suggesting changes.

```text
Create a draft shift next Monday from 9:00 to 17:00.
```

Expected: Codex confirms board/date details, then creates a draft shift only if
the authenticated user has permission.

```text
Summarize pending leave and schedule-change requests.
```

Expected: Codex lists pending items and clearly separates read-only summary from
any approval/rejection action.

## 6. Verify permissions and disconnect

Test with a lower-permission account:

- read prompts should work for accessible boards;
- write prompts should be denied if the user lacks the required Soon role or
  board permission.

Finally revoke/disconnect the plugin from Codex or Soon, then retry `get_me`.
Expected: Codex requests authentication again.
