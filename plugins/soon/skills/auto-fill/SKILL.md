---
name: auto-fill
description: Use when the user wants Soon to plan or fill a whole period of the schedule automatically, staff open shifts with the optimizing solver, generate shifts from opening hours, or apply an Auto-fill plan. Runs Auto-fill, shows the plan, and applies it only after the user agrees.
---

# Auto-fill

Auto-fill is Soon's optimizing solver. It staffs open seats and can generate
shifts from opening hours, within each person's availability, contract hours,
leave and skills.

## Flow

1. **Scope.** `get_me` for the user's boards. Agree the boards and the date
   range (inclusive, YYYY-MM-DD).
2. **Start.** `start_auto_fill { boardIds, startDate, endDate }`.
   - Without `demand`, it uses each board's own setup: the open seats in the
     range and the rules of the board's last Auto-fill run.
   - When a board has no shifts in the range and no earlier run, pass
     `demand: { openHours: [{ days: [0..6], start, end }], minimumPeople,
     maximumPeople }`. Days are Monday = 0 to Sunday = 6.
   - Optional `preset`: `fast` (30 s), `balanced` (default, 90 s), `deep`,
     `ultra`.
   - If it returns `started: false`, tell the user the blocking issues; do not
     retry blindly.
3. **Wait.** Call `get_auto_fill_run { runId }` until `finished` is true. Each
   call waits up to 25 s, so a normal run needs a few calls.
4. **Show the plan.** From the COMPLETED run: hours assigned and uncovered,
   coverage gaps, hours per person, and the proposed shifts (names and local
   times; page with `shiftOffset` / `shiftLimit`).
5. **Apply only after the user agrees.** `apply_auto_fill_run { runId,
   dryRun: true }` first, report what would be created and rejected, then the
   same call without `dryRun`. Pass `shiftIds` to apply part of the plan.
   - Applied shifts are drafts (unpublished). Publishing notifies people:
     `publish_shifts` only when the user asks.
   - `confirmPublished` clears replanned seats on published shifts and
     notifies those people. Never set it without the user's explicit yes.
