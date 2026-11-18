---
name: eye
description: Layered code review that teaches. Use when Jess asks to review a PR, a branch or her own changes, or types /eye. Runs mechanical checks, triage, one or more reviewer subagents, then one ranked report with a Learn section.
disable-model-invocation: true
---

# eye: layered code review

eye reviews a diff in layers and teaches Jess while it reviews. It never edits code and never posts anything.

Version: v1. It has the **quick** and **standard** tiers and GitHub only. The deep tier, spec check and chain blast radius come later (herd build step 8). Other forges come later.

## Input

`/eye [target] [--quick | --standard | --deep] [--level eli5|junior|senior]`

| Target | Meaning |
|---|---|
| nothing | The current branch, compared with its merge base on the default branch |
| a branch name | That branch, compared with its merge base |
| a PR URL or number | That GitHub PR |

## Step 0: Load context

1. Read `~/herd/herd.yaml`. Use `review`, `teaching`, `models`, `me` and `paths`.
2. Read the Concepts table in `~/herd/memory.md`.
3. Find the repo in the repo map, `~/herd/work/repos.yaml`, by path or remote. If it is a work repo, also read `~/herd/work/rules.md`. Get `test_cmd`, `forge` and `canonical_path`.
   - If `canonical_path: false`, stop. Tell Jess the path of the canonical copy.
   - If the repo is not in the repo map, continue. At the end, ask Jess if it is a work repo that belongs in the map.
4. Get the diff and the intent:
   - PR: `gh pr view <target> --json number,title,body,author,baseRefName,headRefName,files,additions,deletions,url` and `gh pr diff <target>`.
     **For a PR, the diff is the output of `gh pr diff` only.** Do not use `git diff origin/<base>...`. A local base branch can be out of date and add lines from other PRs.
   - Branch: run `git fetch origin <default>` first. Then `git merge-base HEAD origin/<default>`, `git diff <base>...HEAD` and `git log <base>..HEAD --format=%s%n%b`.
   - Check: the changed-line count must match `additions + deletions` from `gh pr view`. If it does not match, stop and find out why before you continue.
5. **PR only: check for a stack.** Run `gh stack view --json` in the repo (if the `gh stack` extension is installed). If the PR is in a stack:
   - Review only this layer. `gh pr diff` already shows only this layer, because the base of the PR is the branch of the layer below.
   - Put the stack in the packet: the layer number, the PR below and the PRs above, with their titles.
   - Tell reviewers: "Problems in lower layers are out of scope. If this layer breaks an upper layer, report it under downstream."
   - Never run `gh stack` commands that change anything (`sync`, `rebase`, `push`, `submit`, `merge`).
   If `gh stack` is not installed or the PR is not in a stack, continue normally.
6. **PR only:** fetch the PR head into a local ref, so that you and the reviewers can read changed files without `gh api`:
   ```bash
   git fetch origin pull/<number>/head:eye/pr-<number>
   ```
   Read a file at the PR head with `git show eye/pr-<number>:<path>`. Do not check out the PR. Do not use `gh api` to read files.
   If the PR comes from a fork and the fetch fails, read only the diff, and say so in the report.
7. Set **owner**: `mine` if the PR author is `me.github`, or if the target is a local branch. Otherwise `other`.

## Step 1: Mechanical checks (layer 1, no model)

Start these at the same time as step 2. Do not wait for them before triage.

- PR: run `gh pr checks <target>`. Use the CI result. Do not check out another person's PR.
- Own branch: run `test_cmd` from the repo map in the background. If the repo has no `test_cmd`, use the test command that the repo documents. Time limit: 10 minutes.
- If there is no CI and no `test_cmd`, record "no mechanical checks" in the report.

## Step 2: Pick the tier (layer 2)

1. Count the changed lines (additions + deletions). Match the changed paths against `review.deep_paths`.
2. Rule tier:
   - any path matches `deep_paths` → `deep`
   - lines < `quick_max_lines` → `quick`
   - lines ≤ `standard_max_lines` → `standard`
   - more → `standard`, and tell Jess that the PR is large and a split can help
3. Send the diff, the intent and the rule tier to the **eye-triage** subagent. It returns a risk label and a tier (see `references/triage.md`).
4. Final tier = the higher of the rule tier and the triage tier. A `--quick`, `--standard` or `--deep` flag overrides both.
5. **v1 limit:** if the final tier is `deep`, run `standard`. Tell Jess at the top of the report: "This change is deep-tier, but deep review is not built yet. I ran standard. Check the risky paths yourself." Never lower a tier silently.

## Step 3: Reviewers (layer 3)

Run the reviewers for the tier in `review.tiers`, **in parallel**:

| Tier | Subagents |
|---|---|
| quick | `eye-reviewer` |
| standard | `eye-panel-0` and `eye-panel-1` |

Give each reviewer the same packet:

- the intent (PR title and body, or commit messages)
- the full diff
- **the full content of each changed file at the PR head**, from `git show eye/pr-<number>:<path>` (or the working tree for a branch). If a file is over 600 lines, give the changed functions and 40 lines around each hunk instead.
- the repo path, so that reviewers can read callers with their read and grep tools
- the repo name and its downstream repos from the repo map's `stages` and `chains` (names only), if the repo is in the map
- the instruction: "Follow ~/herd/skills/eye/references/reviewer.md."

Do not give reviewers the other reviewers' output.

Reviewers must be able to work from the packet alone. If a reviewer reports that it could not read a file or run a command, say so under "Problems during this run" in the report, and check its findings yourself.

**Context limit:** the diff, the files it touches and their direct callers. Reviewers may read those files. They must not read whole repos.

## Step 4: Teaching and synthesis (layers 4 and 5)

- **quick tier:** you do this step yourself, with `references/lead.md`. Do not start a lead subagent.
- **standard tier:** send all reviewer findings, the diff, the intent and the Concepts table to **eye-lead**. It follows `references/lead.md`.

The result is one report in the format in `references/lead.md`.

Fill in the **Run** line truthfully. Name each subagent that you started with the task tool. If you did a layer yourself, write `main` for it. Never write a subagent name for work that you did yourself.

## Step 5: Deliver

1. Show the report to Jess.
2. If owner is `other`: write draft PR comments in Jess's voice to `<paths.drafts>/<repo>-pr<number>.md`. **Do not post.** Post a comment only after Jess approves that comment or that batch, with `gh pr comment` or `gh pr review`.
3. If owner is `mine`: offer to fix the blocking and should findings. Change code only after Jess says yes.
4. Add each Learn question to the Pending questions table in `memory.md`.
5. Log usage: `~/herd/scripts/usage-log.sh eye <repo>#<pr-or-branch> <tier> <lead-model> <approx_tokens>`. Estimate tokens as (characters sent to all subagents) / 4.

## Step 6: After Jess answers a Learn question

- Correct answer: change that concept to `known` in `memory.md`, set "Last checked" to today, and remove the pending question.
- Wrong or partial answer: explain the gap in 2 or 3 sentences. Keep the concept `learning`.
- No answer: do nothing. The question stays pending for `/quiz`.

## Harness notes

- **OpenCode:** start subagents with the task tool, with the agent names above. `scripts/gen-agents.sh` makes those agents from `herd.yaml`.
- **Claude Code:** start each subagent with the Agent tool, `subagent_type: general-purpose`. Put "Read ~/herd/skills/eye/references/<file> and follow it" at the top of the prompt. herd.yaml models do not apply in Claude Code. The subagents use the session model.

## Speed targets

- Steps 0 to 2: under 60 seconds.
- A full review of a PR under 500 lines: 3 to 5 minutes.
- If a step is slow, report what you have and say which part is still running.
