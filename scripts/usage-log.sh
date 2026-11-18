#!/usr/bin/env bash
# usage-log.sh: add one row to the herd usage log (budget.log in herd.yaml).
# Usage: usage-log.sh <skill> <target> <tier> <model> <approx_tokens>
# Example: usage-log.sh eye owner/repo#123 standard github-copilot/claude-opus-5.5 42000
set -euo pipefail

LOG="${HERD_USAGE_LOG:-$HOME/branches/.herd/usage.tsv}"
mkdir -p "$(dirname "$LOG")"
[ -f "$LOG" ] || printf 'date\tskill\ttarget\ttier\tmodel\tapprox_tokens\n' > "$LOG"

if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <skill> <target> <tier> <model> <approx_tokens>" >&2
  exit 2
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$(date -Iseconds)" "$@" >> "$LOG"
