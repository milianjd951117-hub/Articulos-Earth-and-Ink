#!/bin/bash
# Installs or updates this repo's plugins in Claude Code cloud sessions,
# whose fresh containers do not install plugins declared in project settings.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# marketplace name, GitHub repo, plugin (same list as enabledPlugins in settings.json)
PLUGINS=(
  "curioseando-y-probando milianjd951117-hub/curioseando-y-probando graph-guard"
  "addy-agent-skills addyosmani/agent-skills agent-skills"
  "curioseando-y-probando milianjd951117-hub/curioseando-y-probando pulido"
  "curioseando-y-probando milianjd951117-hub/curioseando-y-probando impeccable"
  "curioseando-y-probando milianjd951117-hub/curioseando-y-probando hallmark"
  "curioseando-y-probando milianjd951117-hub/curioseando-y-probando humanizer"
)

# A failing plugin only warns, so the others still install and the session starts.
for entry in "${PLUGINS[@]}"; do
  read -r marketplace repo plugin <<< "$entry"
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
done

# hallmark's in-browser check (sloplint --render) drives the container's Chrome through
# puppeteer-core (Google's Puppeteer team, Apache-2.0; it downloads no browser).
# Pinned and without install scripts, so it does not change unreviewed.
if ! npm ls -g puppeteer-core >/dev/null 2>&1; then
  npm install -g --ignore-scripts puppeteer-core@25.14.0 >/dev/null 2>&1 || echo "warn: could not install puppeteer-core" >&2
fi
