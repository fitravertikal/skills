#!/bin/bash
# SessionStart hook: install Python dependencies for skill scripts so they're
# runnable in Claude Code on the web (e.g. mcp-builder, slack-gif-creator).
# This repo has no root-level manifest or test suite; deps live per-skill.
set -euo pipefail

# Only run in the remote (web) environment. Locally you manage your own env.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Install into the user site so we don't fight Debian's system packages.
# Idempotent: pip is a no-op when requirements are already satisfied.
find skills -name requirements.txt -print0 | while IFS= read -r -d '' req; do
  echo "Installing deps from $req"
  pip3 install --user --quiet -r "$req"
done

echo "SessionStart hook: skill dependencies installed."
