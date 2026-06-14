#!/usr/bin/env bash
# Sync manomatika, matika, eyerate, ahimsa: switch to main and fast-forward to origin/main.
# Note: --prune only clears stale remote-tracking refs (origin/*) for branches
# already deleted on GitHub. It does NOT delete local branches — remove those
# by hand per wave (and never delete an unmerged/gated branch like fix/30-org-migration).
set -euo pipefail
for r in manomatika matika eyerate ahimsa; do
  echo "===== $r ====="
  git -C ~/dev/projects/"$r" checkout main
  git -C ~/dev/projects/"$r" fetch --prune origin
  git -C ~/dev/projects/"$r" pull --ff-only origin main
  git -C ~/dev/projects/"$r" branch
  echo
done
