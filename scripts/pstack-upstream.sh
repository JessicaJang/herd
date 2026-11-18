#!/usr/bin/env bash
# pstack-upstream.sh: show what changed upstream in the pstack skills that herd copied.
# Read-only. It clones cursor/plugins into a temp folder and prints a diff.
set -euo pipefail

HERD="$(cd "$(dirname "$0")/.." && pwd)"
ORIGIN="$HERD/skills/_pstack/ORIGIN.md"
BASE="$(grep -oE '[0-9a-f]{40}' "$ORIGIN" | head -1)"
SKILLS="how why teach interrogate blast-radius arena tdd show-me-your-work unslop in-your-own-words principle-prove-it-works principle-laziness-protocol principle-subtract-before-you-add"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone -q --filter=blob:none https://github.com/cursor/plugins "$TMP/plugins"
cd "$TMP/plugins"
HEAD_SHA="$(git rev-parse HEAD)"

echo "Base:    $BASE"
echo "Current: $HEAD_SHA"
echo

if [ "$BASE" = "$HEAD_SHA" ]; then
  echo "No upstream changes."
  exit 0
fi

paths=()
for s in $SKILLS; do paths+=("pstack/skills/$s"); done

git --no-pager diff --stat "$BASE" HEAD -- "${paths[@]}"
echo
git --no-pager diff "$BASE" HEAD -- "${paths[@]}"
