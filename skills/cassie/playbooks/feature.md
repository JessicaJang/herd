# Playbook: feature

Write a feature or a fix, and teach Jess while you do it. Default mode: driver (the agent writes). With `--navigator`, Jess writes and the agent gives hints and reviews.

1. Load the ticket, if the request names one and a ticket tool is available. Read only. Restate the goal in one or two sentences with the `in-your-own-words` skill. Ask if anything is unclear.
2. Run the `how` skill on the code that will change, and the `why` skill if the current shape looks odd. Use Jess's level for each concept. Skip this step with `--no-teach`.
3. Show a plan: the files to change, the tests to add or change, and the risks. Wait for Jess to approve the plan.
4. Make the change in small parts. After each part, explain it in two or three sentences at Jess's level, and run the narrowest test (the `tdd` skill). In navigator mode, give a hint for each part and review what Jess wrote.
5. Run the repo's full `test_cmd` (from `~/herd/work/repos.yaml`, or the repo's documented test command). Show the result. Do not say "done" if tests fail or did not run.
6. Run the `eye` skill on the branch, in the quick tier unless eye picks higher. Fix the blocking findings after Jess approves.
7. If a ticket was loaded, propose a ticket comment or transition. Post only after Jess approves.
8. End with a Learn section: 1 to 3 concepts from this change, each with a `repo:file:line` pointer, and 1 question. Add the question to Pending questions in `memory.md`.
