# Playbook: review

Review a PR. The result stays private until Jess approves each comment.

1. Run the `eye` skill on the PR, with any `--deep` or `--level` flag from the request.
2. Show the eye report to Jess.
3. If the PR is from another person: show the draft comments file that eye wrote (`paths.drafts` in herd.yaml). Ask Jess which comments to post: all, some, none, or edit first.
4. Post only the comments that Jess approved, with `gh pr review` or `gh pr comment`. Show each command before you run it.
5. If the PR is Jess's own: ask which findings to fix. Fix only those, then run eye again in the quick tier on the new diff.
6. Ask Jess the Learn question from the eye report. Accept "skip". If she answers, update `memory.md` as eye step 6 says.
