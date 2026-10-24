#!/bin/bash
# Installs or updates the graph-guard plugin in Claude Code cloud sessions,
# whose fresh containers do not install plugins declared in project settings.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

marketplace="curioseando-y-probando"
repo="milianjd951117-hub/curioseando-y-probando"
plugin="graph-guard"

# A failure only warns, so the session still starts.
if claude plugin marketplace list 2>/dev/null | grep -q "$marketplace"; then
  claude plugin marketplace update "$marketplace" >/dev/null 2>&1 || true
else
  claude plugin marketplace add "$repo" || echo "warn: could not add marketplace $repo" >&2
fi
if claude plugin list 2>/dev/null | grep -q "$plugin@$marketplace"; then
  claude plugin update "$plugin@$marketplace" >/dev/null 2>&1 || true
else
  claude plugin install "$plugin@$marketplace" --scope user || echo "warn: could not install $plugin@$marketplace" >&2
fi
