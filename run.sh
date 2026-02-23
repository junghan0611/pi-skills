#!/usr/bin/env bash
# run.sh — Build all custom CLIs (x86_64 + arm64) and place in skill folders
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPOS="$HOME/repos/gh"

build_cli() {
  local name=$1 src_dir=$2 skill_dir=$3 bin_name=$4

  echo "=== $name ==="
  if [ ! -d "$src_dir" ]; then
    echo "  ❌ source not found: $src_dir"
    return
  fi

  cd "$src_dir"

  # x86_64
  echo "  Building linux/amd64..."
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o "$skill_dir/$bin_name" .
  echo "  ✅ $skill_dir/$bin_name ($(du -h "$skill_dir/$bin_name" | cut -f1))"

  # arm64
  echo "  Building linux/arm64..."
  CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o "$skill_dir/${bin_name}-linux-arm64" .
  echo "  ✅ $skill_dir/${bin_name}-linux-arm64 ($(du -h "$skill_dir/${bin_name}-linux-arm64" | cut -f1))"

  # Install x86_64 to ~/.local/bin
  cp "$skill_dir/$bin_name" "$HOME/.local/bin/$bin_name"
  echo "  ✅ ~/.local/bin/$bin_name"
  echo ""
}

echo "Building all pi-skills CLIs..."
echo ""

build_cli "denotecli" "$REPOS/denotecli/denotecli" "$SCRIPT_DIR/denotecli" "denotecli"
build_cli "gitcli"    "$REPOS/gitcli/gitcli"       "$SCRIPT_DIR/gitcli"    "gitcli"
build_cli "lifetract" "$REPOS/lifetract/lifetract"  "$SCRIPT_DIR/lifetract" "lifetract"
build_cli "bibcli"    "$REPOS/zotero-config/bibcli" "$SCRIPT_DIR/bibcli"    "bibcli"

echo "=== Done ==="
echo ""
echo "Binaries in skill folders:"
for dir in denotecli gitcli lifetract bibcli; do
  ls -lh "$SCRIPT_DIR/$dir/"*-linux-* "$SCRIPT_DIR/$dir/$dir" 2>/dev/null | awk '{print "  " $NF " (" $5 ")"}'
done
echo ""
echo "ARM64 binaries for Oracle VM:"
echo "  scp pi-skills/{denotecli,gitcli,lifetract,bibcli}/*-linux-arm64 user@oracle:~/.local/bin/"
