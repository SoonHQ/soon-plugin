# Soon for Claude Code

Manage your [Soon](https://soon.works) work schedule directly from Claude —
read rosters, find coverage, create and publish shifts, and resolve schedule
change requests, all with your real Soon team and board permissions enforced.

## Install

```
/plugin marketplace add SoonHQ/soon-claude-plugin
/plugin install soon@soon
```

On first use, Claude opens your browser to sign in to Soon and authorize access
(OAuth). You'll pick the team to connect. Your granted permissions match your
Soon role — admins can make changes; members get read access and self-service.

## What you can do

- "Show next week's schedule for the Operations board."
- "Where do we have gaps next week, and who's available to fill them?"
- "Create a draft shift on Thursday 9–5 and assign Levi."
- "Publish the unpublished shifts for this week."
- "Show pending schedule-change requests and approve the cover request from Mira."

Destructive actions (delete, publish, close, bulk reassign) require an approval
step before they run.

## Security

The connection is OAuth-based; Claude never sees your password. Every request is
scoped to a single team, and the server re-checks your role and board rights on
every action — a connected member cannot perform admin-only operations. You can
disconnect anytime from your Soon account settings.

## Support

Questions or issues: developers@soonapp.io
