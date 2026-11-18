# Skills that came from pstack

Some herd skills started as copies of pstack skills. herd owns them now. They do not update automatically.

## Source

| Field | Value |
|---|---|
| Project | pstack by Lauren Tan |
| Upstream | https://github.com/cursor/plugins, folder `pstack/` |
| Version | 0.15.43 (from `pstack/plugin.json`) |
| Commit | `3fa33bb0f927bea2ccacd48a3cfda95145fb6bae` (2026-11-16) |
| Licence | MIT. The full text is in `LICENSE` next to this file. Keep it. |

Note: `backnotprop/pstack` is a mirror of the upstream, and `michael-denyer/pstack-claude` is a port for other harnesses. herd copies from the upstream.

## Copied skills

| herd skill | Upstream skill | What herd changed |
|---|---|---|
| `how` | `how` | Reads levels from `memory.md`. Crosses repos only through the repo map's chains. Uses `herd-explainer`. |
| `why` | `why` | Adds where to look: git, `gh`, other forges, tickets (read only), docs. Work places come from `work/rules.md`. |
| `teach` | `teach` | Levels from `memory.md`. ASCII diagrams in place of the image tool. Learn questions stay in playbooks. |
| `interrogate` | `interrogate` | Uses herd runners and `test_cmd`. No cloud writes. Adds a Learn section. |
| `blast-radius` | `blast-radius` | Uses the repo map's stages and chains, and the work facts in `work/rules.md`. No cloud writes. |
| `arena` | `arena` | Runners and judge from `herd.yaml`. Worktrees in `~/branches/.herd/arena/`. Usage log. |
| `tdd` | `tdd` | Runs `test_cmd` from the repo map. |
| `show-me-your-work` | `show-me-your-work` | Log in the herd task folder. Audits this conversation only. Uses `herd-judge`. |
| `unslop` | `unslop` | Follows the writing preferences in `memory.md`. |
| `in-your-own-words` | `in-your-own-words` | No change. |
| `principle-prove-it-works` | same | No change. |
| `principle-laziness-protocol` | same | No change. |
| `principle-subtract-before-you-add` | same | No change. |

In every copied skill, herd also removed `disable-model-invocation`, so that `cassie` can call the skills. herd removed the pstack model sheet, `/setup-pstack` and the poteto-mode subagent rules. `skills/_shared/subagents.md` replaces them.

## Not copied

`poteto-mode` (`cassie` replaces it), `swarm`, `architect`, `hillclimb`, and the other principles. They are for large codebases or use many tokens.

## Get upstream changes

Run:

```bash
~/herd/scripts/pstack-upstream.sh
```

It shows what changed upstream in the copied skills since the commit above. Copy what you want by hand. Then update the commit in this file.
