---
name: soon
description: Manage schedules, boards, shifts, and planning workflows in Soon. Use when the user wants to read or update Soon scheduling data.
metadata:
  short-description: Manage Soon schedules in Codex
---

# Soon

## Overview

This skill provides a structured workflow for working with Soon data from Codex. It assumes the bundled Soon plugin is installed and that the Soon MCP tools are available for schedule, board, and planning workflows.

## Prerequisites

- The bundled Soon plugin must be enabled for the current session.
- Soon MCP tools must be available and, for protected actions, authenticated.
- Confirm access to the relevant Soon workspace before making read or write changes.

## Required Workflow

**Follow these steps in order. Do not skip steps.**

### Step 0: Connect the Soon plugin (if not already configured)

If Soon tools are unavailable or Codex reports that auth is required:

1. Ask the user to open the Soon plugin's auth/connect flow in Codex.
2. Tell the user to sign in to Soon, choose the right workspace, and approve the requested scopes.
3. Tell the user to retry their original request after returning to Codex.
4. If the tools still do not appear, ask the user to restart Codex or start a new session.

After the user connects Soon, finish your answer and tell them to retry so work can continue with Step 1.

### Step 1

Clarify the user’s scheduling goal and scope. Confirm the relevant workspace context, board, date range, permissions, and whether the task is read-only or write-capable.

### Step 2

Select the appropriate workflow and identify the Soon MCP tools you need. Prefer read operations first to build context before making changes.

### Step 3

Execute Soon tool calls in logical batches:

- Read first to gather context.
- Then make updates or follow-up calls only after the relevant board, shift, or schedule context is clear.
- For write operations, summarize the intended change before performing it when the outcome could be surprising.

### Step 4

Summarize results, call out blockers or missing authentication, and propose the most useful next action.

## Available Tools

Connectivity: verify MCP with `tools/list` or an authenticated read tool.

Core reads: `get_me`, `get_schedule`, `get_schedule_stats`, `get_shift_details`, `find_shifts`, `list_team_users`, `list_team_roles`, `list_schedule_changes`, `get_leaves`.

Core writes: `create_shift`, `create_shifts`, `update_shift`, `publish_shifts`, `assign_user_to_shift`, `assign_users_to_shift`, `request_leave`, `respond_leave_request`.

Intraday: `list_activity_types`, `get_intraday`, `list_intraday_configs`, `save_intraday_config`, `run_intraday_solver`, `update_intraday_activities`.

Use `tools/list` as the source of truth if this list drifts from the installed MCP server.

## Practical Workflows

- First-time Setup: guide the user through the Codex plugin auth/connect flow, then retry the original Soon request.
- Workspace Discovery: Use `get_me` to understand the authenticated user, workspace, boards, and permissions before discussing schedule changes.
- Planning Triage: Start by listing boards, identify the relevant workspace, then narrow the next read or write operation to that board.
- Connectivity Debugging: Confirm the MCP session lists Soon tools (`tools/list`); separate transport issues from auth (missing bearer / scopes).

## Tips for Maximum Productivity

- Treat connectivity and authentication as separate checks: tool listing proves the MCP session, while protected Soon tools prove auth.
- When auth is missing, do not keep retrying protected tools. Guide the user through the plugin auth/connect flow first.
- Reuse the board context you already discovered instead of re-listing boards repeatedly.
- When tools are missing from the session, explain that the plugin may need a fresh session after install or reconnect.

## Troubleshooting

- Authentication: Ask the user to complete the Soon plugin auth/connect flow, sign in on the Soon page, then retry the original request.
- Tools unavailable: Confirm the Soon plugin is enabled in the session and suggest restarting Codex if the tools were installed recently.
- Missing data: Verify the user is authenticated into the correct Soon workspace and retry the relevant read tool.
- Connectivity: If `tools/list` works but protected tools fail, the issue is usually auth or scopes, not MCP transport.
