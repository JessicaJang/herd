---
name: cassie
description: "herd router and main entry point. Use for /cassie <anything>: it reads the request, picks a playbook (feature, review, or a local work playbook) or a skill, and runs it step by step."
disable-model-invocation: true
---

# 🐕🐑 cassie: the herd router

cassie reads Jess's request, picks one playbook, and runs it. cassie does not review code (`eye` does) and does not hold work knowledge (`~/herd/work/` does).

## 1. Load context

1. Read `~/herd/memory.md` (levels and preferences) and `~/herd/herd.yaml`.
2. Find the current repo. If it is in the repo map (`~/herd/work/repos.yaml`), it is a work repo: read `~/herd/work/rules.md`.
3. If the request names a ticket (for example `PROJ-1234`) and a ticket tool is available, read the ticket. Read only.

## 2. Route

If `~/herd/work/routes.md` exists, check its rows first. Then pick the first row that matches in this table. Say the route in one line before you start: "🐕 Route: review playbook."

| Request looks like | Route |
|---|---|
| A PR URL or number, "review", "look at this PR" | playbook `review` |
| "add", "fix", "implement", "change", "write", a ticket to do | playbook `feature` |
| "how does", "walk me through", "where does X live" | skill `how` |
| "why does", "why did we" | skill `why` |
| "teach me", "explain this change" | skill `teach` |
| "what can break", "blast radius" | skill `blast-radius` |
| Two or more repos named, "across repos" | Not built yet (multi-repo, build step 7). Say so, and offer `how` or `blast-radius` across the repos. |
| The same change in many repos ("bump in all repos") | Not built yet (fleet, build step 10). Say so. |

If two rows fit, or none fits, ask one question with a recommended answer. Do not guess on expensive routes (feature).

Flags that Jess can add to any request:

- `--level eli5|junior|senior`: teaching level override
- `--no-teach`: skip the explain steps
- `--navigator`: Jess writes the code. The agent gives hints and reviews. (feature only)
- `--deep`: deep review (passed to eye)

## 3. Run the playbook

1. Read the playbook file: `~/herd/skills/cassie/playbooks/<name>.md`.
2. Copy its steps **word for word** into your todo list. Do not merge, skip or reword steps. This keeps every check in the plan.
3. Run the steps in order. Mark each step done when it is done.
4. When a step or a route names a skill, read `~/herd/skills/<name>/SKILL.md` in full and follow it. Do not use the skill tool: herd skills have `disable-model-invocation: true`, so the tool cannot load them.
5. If a step cannot run, mark it blocked, say why, and continue with the next step that does not depend on it.

## 4. Finish

- End with the playbook's last step. Most playbooks end with a Learn section.
- Log usage: `~/herd/scripts/usage-log.sh cassie <playbook>:<target> - <session-model> <approx_tokens>`.
- Never post, push, or change a cloud resource without Jess's approval for that action.
