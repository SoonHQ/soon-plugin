# Soon

Soon is a work-scheduling platform: boards hold shifts, shifts have roles
(seats), and people are assigned to seats. The `soon` MCP server acts as the
signed-in user, with that user's own team and board permissions.

## How to work

- **Read before you write.** Use the read tools first (`get_me`,
  `get_schedule`, `find_shifts`, `get_shift_details`, `find_user_assignments`,
  `get_schedule_stats`, `get_leaves`). Never invent board, shift, role, user,
  leave or request ids: take them from tool results.
- **"My schedule":** `get_me`, then `find_user_assignments` with that userId
  and no boardId. One call searches every board.
- **Only write when asked.** Create, update, assign, publish, close, delete or
  approve only when the user clearly asks. Before a write, describe each
  target by title, date and local time, never by bare ids.
- **Publishing notifies people.** Shifts you create are drafts until
  `publish_shifts`.
- **Leave:** `get_leaves` to read; `request_leave` and
  `respond_leave_request` to write. Check coverage before approving.

## Making a schedule

When the user asks to create, build, make or fill a schedule, roster or rota,
use Soon's solvers, not shift-by-shift creates and assigns:

- who works which shifts over a period, or new shifts from opening hours:
  Auto-fill (below);
- activities inside shifts (breaks, tasks, hour targets per activity,
  spreading out peaks): the intraday solver (below);
- a whole new schedule: Auto-fill first, then the intraday solver on its
  shifts.

Build shifts by hand only when the user gives exact shifts.

## Auto-fill (whole-period planning)

1. Agree the boards and the date range (inclusive, YYYY-MM-DD).
2. `start_auto_fill { boardIds, startDate, endDate }`. Without `demand` it
   uses each board's own setup (open seats, the rules of its last run). For a
   board with no shifts and no earlier run, pass
   `demand: { openHours: [{ days, start, end }], minimumPeople, maximumPeople }`
   (days: Monday = 0 to Sunday = 6). If it returns `started: false`, report
   the blocking issues.
3. `get_auto_fill_run { runId }` until `finished` (each call waits up to 25 s).
4. Show the plan: hours assigned and uncovered, gaps, hours per person, the
   proposed shifts.
5. Only after the user agrees: `apply_auto_fill_run { runId, dryRun: true }`,
   report, then the same call without `dryRun`. Applied shifts are drafts.
   Never pass `confirmPublished` without the user's explicit yes: it clears
   replanned seats on published shifts and notifies those people.

## Breaks, lunch and tasks inside shifts

Read the day with `get_intraday_day` and `list_coverage_requirements`. Draft
an intraday config from the user's rules (hour targets per activity are
`total_minutes_required`, peak limits are `concurrency` or
`staffingRequirement`), check it with
`validate_intraday_config` until it is valid, then `save_intraday_config` and
`run_intraday_solver`. Write the result with `update_intraday_activities` only
when the user accepts it.

Times are shown in the user's zone; tool results also carry ISO times.
