# How herd skills start subagents

Every herd skill that starts a subagent follows this file. It replaces the pstack model sheet and the poteto-mode "Subagents" section.

## The herd agents

`~/herd/scripts/gen-agents.sh` makes these OpenCode agents from `~/herd/herd.yaml`:

| Agent | Model (herd.yaml) | Can edit | Used by |
|---|---|---|---|
| `herd-explainer` | `models.judgment` | no | how, why, teach |
| `herd-runner-<n>` | `models.panel[n]` | yes, only in its own worktree | arena, interrogate, blast-radius |
| `herd-judge` | `models.judge` | no | arena (cross-judge), show-me-your-work (trail review) |
| `eye-*` | see the eye skill | no | eye only |

## How to start one

- **OpenCode:** use the task tool with the agent name from the table.
- **Claude Code:** use the Agent tool with `subagent_type: general-purpose`. Put the agent's role at the top of the prompt, for example "You are herd-runner-1. You can edit files only in <worktree>." herd.yaml models do not apply in Claude Code. Subagents use the session model, so "different model families" is not possible there. Say so in the result.

## Rules for every subagent

1. Give it file paths and short pointers, not long pasted context, unless the skill says to paste.
2. Start independent subagents in one message, so that they run at the same time.
3. A read-only agent never edits and never posts.
4. A runner edits only inside the worktree that the skill gives it.
5. If an agent name does not exist, or its model is rejected, run that seat on the session model, and say so in the result. Do not stop.
6. Never let a subagent post to a forge or ticket system, push, or change a cloud resource. The safety rules in `~/herd/AGENTS.md` apply to subagents too.

## Worktrees for runners

Make one worktree for each runner, next to the repo's `.herd` work folder:

```bash
git worktree add ~/branches/.herd/arena/<slug>/<n> HEAD
```

Copy the scope's uncommitted changes into each worktree when the skill says so. When the skill ends, list the worktrees and ask Jess before you remove them with `git worktree remove`.
