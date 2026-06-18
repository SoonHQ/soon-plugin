---
description: Use Soon's scheduling tools safely — gather schedule context before acting, then make changes in the right order. Use when the user asks about their Soon schedule, shifts, rosters, coverage, assignments, leave, or schedule-change requests.
---

# Working with Soon schedules

You have access to Soon's MCP tools for reading and acting on scheduling data.
Work in a clear, safe order. The Soon server enforces the user's real team and
board permissions, so a tool may decline an action the user isn't allowed to do
— surface that plainly rather than retrying.

## Workflow

1. **Clarify the goal and the period.** Identify what the user wants (inspect a
   schedule, fill coverage, fetch a user/shift, review conflicts, respond to
   change requests) and the date range and board/team it applies to.

2. **Read context first.** Before any change, gather the minimum context with
   the read tools — typically: confirm who you are (`get_me`), then fetch the
   relevant `get_schedule` / `find_shifts` / `find_users_on_board`, and check
   `check_user_conflicts` or `find_available_users_for_shift` when assigning.

3. **Act second.** Only after reading current state, call the create/update
   tools with explicit identifiers and required fields. Destructive actions
   (delete, publish, close, bulk reassign) surface an approval card — call the
   tool to present it; do not ask the user to type confirmation text in chat.

4. **Summarize clearly.** Report what you found, what changed, and any missing
   context, blockers, or permission errors.

## Tool selection

- `get_*` for one known entity; `list_*` / `find_*` for filtered collections.
- Prefer focused tools over broad ones.
- Confirm team, date range, and entity IDs before a write that affects others.

## Guidelines

- Never make a write call before reading the current state.
- Surface ambiguities and permission denials instead of guessing or retrying.
- Keep responses compact and operational.
