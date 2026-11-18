---
name: arena
description: "Start N parallel candidates at the same task, pick a base, and graft the strongest parts of the others into it. Use for /arena, 'arena this', or when one attempt at a non-trivial artifact would lock in the wrong shape. Expensive: it runs one model per panel seat."
disable-model-invocation: true
---

# Arena

Open a todo list with one entry per phase (Frame, Fan out, Cross-judge, Pick, Graft, Verify) before you start anything.

Note: arena runs one full candidate per panel seat. It uses many tokens. Use it only when Jess asks, or when a skill such as `blast-radius` or `interrogate` calls it for a deep-tier change.

## Phase A: Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive the rubric: 3 to 6 concrete, gradeable criteria for what success looks like on *this* task. It is the picker's tool in Phase D. Candidates only see the task.
3. Pick the runners: one `herd-runner-<n>` agent for each model in `models.panel` in `~/herd/herd.yaml` (see `~/herd/skills/_shared/subagents.md`). Keep at least two runners. If a runner fails to start, drop that seat and say so. Spawn more for multiple design directions, and repeat one model when the work is generation-bound, not judgment-sensitive.
4. Give each candidate its own git worktree, as `~/herd/skills/_shared/subagents.md` describes. Candidates must never write to the same files.

## Phase B: Fan out

Start all N runners in one message, each with the task, the path to the shared grounding, its own worktree path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.

If a candidate produces no output, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

After all Phase B candidates complete, start one `herd-judge` agent. It is read-only. The judge model (`models.judge`) must be from a different model family than the session model. If it is the same family, say so. While you read in Phase D, the judge scores each candidate, by path label, on each rubric criterion and recommends a base.

## Phase D: Pick a base

Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API, per the **principle-laziness-protocol** skill.

## Phase E: Graft

Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, so that the result stays coherent under one mental model. Don't paste mechanically.

If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape. No graft is needed. If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F: Verify

Verify the synthesized artifact like any other output, per the **principle-prove-it-works** skill. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.

## Outputs

One synthesized artifact, with a short synthesis note alongside naming the base and why, the cross-judge's verdict or that Phase C skipped the judge, each graft with its source candidate, what was rejected and why, any convergence or dropouts, and the verification result.

Log the run: `~/herd/scripts/usage-log.sh arena <target> - <judge-model> <approx_tokens>`.
