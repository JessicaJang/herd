---
name: interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Adversaries try to break a change or design, and only findings proven by a run survive. Slower and more expensive than eye."
disable-model-invocation: true
---

# Interrogate

Adversaries try to break a change or a design. A finding survives only when a run proves it. Report the findings. Do not apply fixes.

Note: `eye` is the daily review. It reads the code. interrogate runs the code to prove each finding. The eye deep tier will call interrogate later (herd build step 8).

## Frame

The scope is what Jess names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree. For a PR, get the diff with `gh pr diff` (see the eye skill, step 0). State the intent with the **in-your-own-words** skill, from Jess's message, the commits, and the PR description. Ask Jess when the intent is unclear.

## Fan out

Run Phase A steps 3 and 4 and Phase B of the **arena** skill, with these changes. Copy the scope's uncommitted changes into each worktree. Use the repo's `test_cmd` from the repo map (`~/herd/work/repos.yaml`), or the repo's documented test command, to run things. In place of the arena task and rationale, give each adversary the scope, the intent, and this brief:

> Break this change. Prove each finding with a run against the real code, such as a failing test, a repro script, or command output that shows the wrong behavior. For a design or plan, run a prototype or probe the current tree. Keep repros in your own worktree. Report each finding with a title, the exact command, the output it printed, and the output the intent requires. Leave out anything you did not run. That covers style, naming, structure, and risks that need a future change to matter. No findings is a valid result. Never call a real cloud API that changes something. Use local runs, dry runs or mocks.

## Verify

Verify each finding per arena Phase F by rerunning its command. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause.

Skip arena Phases C, D, and E. Adversaries find different failures, so the verdict keeps every verified finding, not one adversary's list.

## Output

- **Intent**: the restatement.
- **Findings**: for each verified finding, the command, its output, how it breaks the intent, and the adversaries that found it. Say "no verified findings" when none survive.
- **Dropped**: for each adversary, the count of dropped findings and why.
- **Learn**: 1 to 3 concepts behind the findings, at Jess's level from `~/herd/memory.md`, each with a `repo:file:line` pointer, and 1 question. Add the question to Pending questions in `memory.md`.
