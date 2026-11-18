---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, and placement or ownership questions (\"where should this live\", \"which repo owns this\", \"is this the right layer\"). Explains architecture and runtime flow at Jess's level. Use why for motivation."
disable-model-invocation: true
---

# How

Explore the code to answer "how does X work?" questions.

If the scope is ambiguous, state your interpretation and explore. Jess can redirect.

## 0. Context

1. Read the Concepts table in `~/herd/memory.md`. Pick the level for each concept: `known` → senior, `learning` or missing → junior. A `--level` flag overrides this. Use `teaching.default_level` from `~/herd/herd.yaml` when nothing else applies.
2. If the repo is in the repo map (`~/herd/work/repos.yaml`) and the question crosses repos, use the `stages` and `chains` there to find the other repos. Read other repos only through those links. For a work repo, also read `~/herd/work/rules.md`.

## 1. Explain

Start one `herd-explainer` subagent (see `~/herd/skills/_shared/subagents.md`) that explores and explains in one pass. Give it the question, the repo paths, the level for each concept, and this brief:

> You are writing an architectural explanation for an engineer who is new to this area. Explore the code and write an explanation that lets them build a solid mental model and start working in it confidently. Explain at this level for each concept: <levels>. Point to real code as `repo:file:line`. If the flow crosses repos, follow it through the repos you were given and say where each step lives. You have read-only access.

## 2. Present

Present the subagent's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.
