---
description: Design and run intraday scheduling — the activities (lunch, breaks, admin blocks, calls) that happen WITHIN each shift. Use when the user describes how time inside shifts should be organized, wants to set breaks/lunches/coverage rules, build or save an intraday configuration, or optimize activities with the intraday solver.
---

# Intraday design

Intraday scheduling places **activities** (lunch, breaks, admin, calls, training)
*inside* people's shifts, subject to constraints, and optimizes them with the
intraday solver. Your job: turn the user's plain-English description into a valid
constraint **config**, save it, run the solver, and apply the result.

## Flow

1. **Resolve scope.** Identify the board and the shifts/day. Use `find_shifts`
   (or `get_schedule`) to get the shift (event) ids. Use `get_intraday` to see
   what's already scheduled inside them.
2. **Know the building blocks.** Call `list_activity_types` to get the board's
   activity types and their ids. If the user names a block that doesn't exist
   (e.g. "Training"), create it with `create_activity_type` (set `paid:false`
   for unproductive blocks like breaks).
3. **Build the config** from their words (see the constraint reference below),
   and read your interpretation back to the user in plain language before saving.
4. **Save** it: `save_intraday_config { boardId, name, config }`. It is validated;
   fix any reported errors.
5. **Run** it: `run_intraday_solver { boardId, shiftIds, configId }` (or pass
   `config` inline). This returns *proposed* activities — it does not save them.
   Check `status`; if `no_solution_found`, a hard constraint is likely
   infeasible — relax one (make it soft) and rerun.
6. **Apply** the proposal with `update_intraday_activities`, passing the
   `proposedActivities` as `create` items. This step asks the user to confirm.
7. **Summarize** what was scheduled and any constraints that were relaxed.

## The config shape

```json
{
  "activity_types": [
    { "id": "<activityTypeId>", "config": { /* constraints for this block */ } }
  ],
  "settings": { "wait_time": "Up to 1 minute" }
}
```

## Constraint reference (how to translate words → config)

Times for `consecutive` are in **15-minute slots** (so 1 hour = 4). Make any
constraint *soft* (a preference, not a hard rule) with
`"soft": { "enabled": true, "penalty": "low" | "medium" | "high" }`.

| User says… | Constraint | Example |
|---|---|---|
| "lunch near the middle of the shift" | `window` (relative) | `"window": { "type": "relative", "relative": { "type": "percentage", "value": 50, "duration": 30 } }` |
| "admin only in the afternoon" | `window` (absolute) | `"window": { "type": "absolute", "absolute": { "start": "13:00", "end": "18:00" } }` |
| "a 30-minute lunch" / "1-hour block" | `consecutive` (slots) | `"consecutive": { "min": 2, "max": 2 }` (30m) · `{ "min": 4, "max": 4 }` (1h) |
| "everyone gets one lunch" / "two admin blocks" | `occurrences` | `"occurrences": { "min": 1, "max": 1, "level": "user" }` |
| "never more than half the floor on break at once" | `concurrency` | `"concurrency": { "max": "50%" }` |
| "at least 3 people on calls 9–12" | `staffingRequirement` | `"staffingRequirement": { "enabled": true, "requireds": [{ "start": "09:00", "end": "12:00", "min": 3, "max": 99 }] }` |
| "about 2 hours of admin per person" | `total_minutes_required` | `"total_minutes_required": { "min": 120, "range": "user" }` |
| "only these people do X" | `users_allowed` | `"users_allowed": { "users": ["<userId>"] }` |

### Rules the validator enforces — get these right
- **Soft vs hard is the `soft` block.** There is NO `enforcement` field — don't use it.
- **`concurrency.max` must be a percentage *string*** like `"50%"` (not `0.5`).
- **`total_minutes_required.range` must be `"user"`, `"day"`, or `"week"`** — never
  `"global"` (the solver ignores it).
- **`consecutive.max` must be ≥ `min`.**

Default to **soft** for preferences ("try to", "prefer", "around") and **hard**
(omit `soft`) only for firm rules ("must", "always", "never"). When the solver
returns no solution, the fix is almost always to soften an over-strict rule.
