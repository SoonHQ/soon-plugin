---
description: Manage time-off / leave — list pending and approved leave, create leave requests, and approve/reject/cancel them, with coverage impact in mind. Use when the user asks about leave, time off, PTO, holidays, who's off, approving or rejecting leave requests, or deciding which requests are safe to approve.
---

# Leave management

You can read leave, create leave requests, and approve/reject/cancel them.
Approving is an admin action; a non-admin can only request their own leave.

## Reading leave

- `get_leaves { fromDate, toDate, statuses?, userIds? }` lists leave for a range.
  Filter `statuses: ["PENDING"]` for requests awaiting a decision, or
  `["APPROVED"]` for confirmed time off.

## Creating a request

- `request_leave { userId, startTime, endTime, categoryId?, status? }`. Resolve
  the user with `list_team_users` first. A member may only request their own
  leave (PENDING). Only an admin can request on behalf of others or pre-approve
  (`status: "APPROVED"`).

## Approving / rejecting / cancelling

- `respond_leave_request { leaveId, decision }` where decision is `APPROVED`,
  `REJECTED`, `CANCELLATION_REQUESTED`, or `CANCELLED`. Get the `leaveId` from
  `get_leaves`. Valid transitions:
  - `PENDING` → APPROVED / REJECTED / CANCELLED
  - `APPROVED` → CANCELLATION_REQUESTED / CANCELLED
  - `CANCELLATION_REQUESTED` → CANCELLED / APPROVED

## Helping decide which to approve

When the user asks you to approve leave "that doesn't break coverage", don't just
approve everything — assess impact first:

1. List the `PENDING` leave with `get_leaves`.
2. For each request, check the overlap with the schedule:
   - `check_user_conflicts` to see if the person is assigned during the leave, and
   - `get_schedule_stats` (team scope, that range) to see how thin coverage is
     (`assignedUserCount`, `remainingHours`, the `capacity_available` signal).
3. Recommend approving requests with little/no coverage impact and flag the risky
   ones for the user, with the reason. Only call `respond_leave_request` after the
   user agrees (each call is confirmed anyway).

Be transparent about permission errors — if a tool says the action needs an admin,
say so rather than retrying.
