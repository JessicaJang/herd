---
name: why
description: "Use for 'why does X work this way', 'why did we pick Y', design rationale, regressions, postmortems, or thresholds. Returns a cited read on decisions and tradeoffs from commits, PRs and tickets. Use how for runtime behavior."
disable-model-invocation: true
---

# Why

Answer from the record, not the code. Read the commits and PR discussions that introduced the target and each later change, and other sources if the trail is thin. Cite what the authors wrote, mark your own inferences as inferences, and say what the record does not answer.

## Where to look

1. **git:** `git log -S '<symbol>'`, `git log -L <range>:<file>`, `git blame <file>`, `git show <sha>`.
2. **GitHub PRs:** `gh pr list --search <sha> --state merged`, then `gh pr view <n> --comments`.
3. **Other forges:** if the repo uses another forge (the repo map's `forge` field), say whether you could read its review record. If you could not, say so.
4. **Tickets:** if a commit or PR names a ticket and a tool for that ticket system is available, read the ticket. Read only.
5. **Docs:** the repo's own docs.
6. **Work repos:** use the extra places in "Where to look for the record" in `~/herd/work/rules.md`.

## Rules

- Read only. Do not post, comment or change anything.
- Explain at Jess's level for each concept, from the Concepts table in `~/herd/memory.md`.
- Keep the confidence words. "The commit says" and "I infer" are different findings.

For a long trail, start one `herd-explainer` subagent (see `~/herd/skills/_shared/subagents.md`) with the target and this file. Present its output with light edits only.
