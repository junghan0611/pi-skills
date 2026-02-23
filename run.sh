#!/usr/bin/env bash
# run.sh — Build, install, and deploy all custom CLIs
# Usage:
#   ./run.sh              # build + local install
#   ./run.sh --deploy     # build + local install + Oracle VM deploy
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPOS="$HOME/repos/gh"
DEPLOY="${1:-}"

CLIS=(
  "denotecli|$REPOS/denotecli/denotecli|$SCRIPT_DIR/denotecli|denotecli"
  "gitcli|$REPOS/gitcli/gitcli|$SCRIPT_DIR/gitcli|gitcli"
  "lifetract|$REPOS/lifetract/lifetract|$SCRIPT_DIR/lifetract|lifetract"
  "bibcli|$REPOS/zotero-config/bibcli|$SCRIPT_DIR/bibcli|bibcli"
)

build_cli() {
  local name=$1 src_dir=$2 skill_dir=$3 bin_name=$4

  echo "=== $name ==="
  if [ ! -d "$src_dir" ]; then
    echo "  ❌ source not found: $src_dir"
    return 1
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

deploy_oracle() {
  echo ""
  echo "=== Deploy to Oracle VM (arm64) ==="
  if ! ssh -o ConnectTimeout=5 oracle true 2>/dev/null; then
    echo "  ❌ Cannot connect to oracle — skipping deploy"
    return 1
  fi

  ssh oracle "mkdir -p ~/.local/bin ~/.config/gitcli"

  for entry in "${CLIS[@]}"; do
    IFS='|' read -r name src_dir skill_dir bin_name <<< "$entry"
    local arm_bin="$skill_dir/${bin_name}-linux-arm64"
    if [ -f "$arm_bin" ]; then
      scp -q "$arm_bin" "oracle:~/.local/bin/$bin_name"
      echo "  ✅ oracle:~/.local/bin/$bin_name"
    fi
  done

  # Sync config files
  if [ -f "$HOME/.config/gitcli/authors" ]; then
    scp -q "$HOME/.config/gitcli/authors" oracle:~/.config/gitcli/authors
    echo "  ✅ oracle:~/.config/gitcli/authors"
  fi

  # Verify
  echo ""
  echo "=== Oracle verification ==="
  ssh oracle "export PATH=\$PATH:\$HOME/.local/bin && \
    echo \"  denotecli: \$(denotecli version 2>&1)\" && \
    echo \"  gitcli:    \$(gitcli version 2>&1)\" && \
    echo \"  lifetract: \$(lifetract --version 2>&1)\" && \
    echo \"  bibcli:    \$(bibcli --help 2>&1 | head -1)\""
}

# --- Main ---

echo "Building all pi-skills CLIs..."
echo ""

for entry in "${CLIS[@]}"; do
  IFS='|' read -r name src_dir skill_dir bin_name <<< "$entry"
  build_cli "$name" "$src_dir" "$skill_dir" "$bin_name"
done

echo "=== Build complete ==="

if [ "$DEPLOY" = "--deploy" ]; then
  deploy_oracle
else
  echo ""
  echo "Run with --deploy to push arm64 binaries to Oracle VM:"
  echo "  ./run.sh --deploy"
fi
