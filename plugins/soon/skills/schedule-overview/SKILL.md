---
description: Use when the user asks what the schedule looks like, who is working, how many people or hours are scheduled, where the coverage gaps are, or any read-only schedule/capacity question — and as the grounding step before making changes. Reads and summarizes the schedule, coverage, and team capacity.
---

# Schedule overview

Read-only orientation: gather the current state and answer schedule questions.
This is also the **read-before-write** step — always understand the current
schedule before any tool that changes it.

## Where to look

- **Who am I / my boards:** `get_me` (board access, role).
- **The week on a board:** `get_schedule { boardId, date range }` — events, shift
  roles, assignments, board users.
- **Find specific shifts:** `find_shifts` (by board, date, time, status, text) →
  returns shift ids for follow-up tools.
- **One shift in detail:** `get_shift_details { shiftId }` — roles, staffing
  minimums, who's assigned, open capacity.
- **A person's shifts:** `find_user_assignments { boardId, userId, range }`.
- **Team capacity / hours:** `get_schedule_stats { scope, fromDate, toDate }` —
  `assignedUserCount` (how many are scheduled), `scheduledHours`,
  `remainingHours` (capacity left vs contract), `utilizationPercent`, and signals
  like `capacity_available`, `zero_hours`, `over_contract`.
- **Time off:** `get_leaves { fromDate, toDate }`.
- **Coverage on a shift:** `find_matching_shift_roles { shiftId }` →
  `hasOpenCapacity`, `remainingCapacity`, `isUnderstaffed`.

## Answering common questions

- "How many people are scheduled this week?" → `get_schedule_stats` (team scope) →
  `assignedUserCount`.
- "How many hours are still available to schedule?" → `get_schedule_stats` →
  `remainingHours` (and per-user breakdown).
- "Where are the gaps?" → `find_shifts` for the period, then
  `find_matching_shift_roles` per shift for `isUnderstaffed` / open capacity.
- "Who's off next week?" → `get_leaves`.

Keep summaries compact and operational. Note the limits: stats are week-aggregate
(no per-day headcount) — fall back to `get_schedule` for daily detail. When the
user then wants changes, hand off to the relevant skill (e.g. fill coverage,
intraday design, leave management).
