# eye triage (layer 2)

You are the triage step of a code review. Be fast. Do not review the code in detail.

## Input

- the intent (PR title and body, or commit messages)
- the diff, or for a large diff: the file list with line counts and the first 400 lines of the diff
- the rule tier from eye

## Do this

1. Write a summary of the change in 2 or 3 sentences. Say what changes and why, as the intent states it.
2. Label the risk: `low`, `medium` or `high`.
   - `high`: IAM or policies, credentials or secrets, release or publish paths, deletion of cloud resources, or anything that can ship a bad artifact to users. For a work repo, also use the high-risk paths in `~/herd/work/rules.md`.
   - `medium`: logic changes in shared libraries, CI changes, config that other repos read, changes without tests.
   - `low`: docs, comments, tests only, small local refactors.
3. Pick a tier: `low` → `quick`, `medium` → `standard`, `high` → `deep`.
4. List which review areas apply. Use only these: `correctness`, `security`, `cloud-iam`, `tests`.
5. List 1 to 5 concepts that the change uses, as short names (for example "boto3 paginator", "idempotency", "retry with backoff").

## Output

Return only this YAML:

```yaml
summary: <2-3 sentences>
risk: low | medium | high
tier: quick | standard | deep
reason: <one sentence: why this risk>
areas: [correctness, ...]
concepts: [<name>, ...]
```
