#!/usr/bin/env bash
# setup.sh: link herd into the global folders of Claude Code and OpenCode.
# It is safe to run more than once. It never overwrites a real file or folder.
set -euo pipefail

HERD="$(cd "$(dirname "$0")" && pwd)"
OC="$HOME/.config/opencode"
TILDE="~"

ok()   { echo "  ok    $1"; }
skip() { echo "  SKIP  $1"; }

# link SOURCE TARGET: make TARGET a link to SOURCE, unless TARGET is a real file or folder.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    skip "$dst is a real file or folder. Move its contents into herd, remove it, then run setup.sh again."
    return
  fi
  ln -sfn "$src" "$dst"
  ok "$dst -> $src"
}

echo "Local files (not in git):"
for pair in "herd.example.yaml:herd.yaml" "memory.example.md:memory.md"; do
  src="${pair%%:*}" dst="${pair##*:}"
  if [ -e "$HERD/$dst" ]; then
    ok "$dst exists"
  else
    cp "$HERD/$src" "$HERD/$dst"
    ok "$dst made from $src. Fill in your values."
  fi
done
if [ -d "$HERD/work" ]; then
  ok "work/ exists"
  if [ -f "$HERD/work/git-exclude" ]; then
    grep -v '^#' "$HERD/work/git-exclude" | while read -r line; do
      grep -qxF "$line" "$HERD/.git/info/exclude" 2>/dev/null || echo "$line" >> "$HERD/.git/info/exclude"
    done
    ok "work paths added to .git/info/exclude"
  fi
else
  skip "work/ is missing. Copy it from your private backup (it is not in git)."
fi

echo "Skills (Claude Code, OpenCode, Copilot CLI):"
link "$HERD/skills" "$HOME/.claude/skills"

echo "Global rules:"
link "$HERD/AGENTS.md" "$OC/AGENTS.md"
link "$HERD/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "OpenCode agents:"
"$HERD/scripts/gen-agents.sh"
for f in "$HERD"/.opencode/agents/*.md; do
  [ -e "$f" ] && link "$f" "$OC/agents/$(basename "$f")"
done

echo "OpenCode commands:"
for f in "$HERD"/.opencode/commands/*.md; do
  [ -e "$f" ] && link "$f" "$OC/commands/$(basename "$f")"
done

echo "Work folders:"
mkdir -p "$HOME/branches/.herd/tasks" "$HOME/branches/.herd/drafts"
ok "$HOME/branches/.herd/{tasks,drafts}"

echo "Shortcuts (herd/bin on PATH):"
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  if grep -q 'herd/bin' "$rc"; then
    ok "${rc/#$HOME/$TILDE} already adds herd/bin to PATH"
  else
    echo "export PATH=\"$HERD/bin:\$PATH\"" >> "$rc"
    ok "${rc/#$HOME/$TILDE}: added herd/bin to PATH (open a new terminal)"
  fi
done

echo "Safety rules:"
if [ "${OPENCODE_CONFIG:-}" = "$HERD/opencode/permissions.jsonc" ]; then
  ok "OPENCODE_CONFIG points to herd's permissions.jsonc"
else
  skip "OPENCODE_CONFIG is not set to $HERD/opencode/permissions.jsonc. See README step 4."
fi
