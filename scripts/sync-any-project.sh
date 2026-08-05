#!/bin/bash
set +e
PROJECTS_DIR="$HOME/repos"
CURRENT_DIR="$PWD"
detect_project() {
  local dir="$1"
  while [ "$dir" != "/" ] && [ -n "$dir" ]; do
    if [ -d "$dir/.git" ]; then echo "$dir"; return 0; fi
    dir=$(dirname "$dir")
  done
  return 1
}
sync_project() {
  local project_dir="$1"
  if [ ! -d "$project_dir" ]; then return 1; fi
  cd "$project_dir" || return 1
  if [ -x "scripts/sync-all-auto.sh" ]; then
    bash scripts/sync-all-auto.sh 2>/dev/null || true; return 0
  elif [ -x "scripts/sync-memories.sh" ]; then
    bash scripts/sync-memories.sh 2>/dev/null || true; return 0
  elif [ -x "sync-all.sh" ]; then
    bash sync-all.sh 2>/dev/null || true; return 0
  elif [ -f ".sync-config" ] || [ -f ".sync" ]; then
    git fetch origin 2>/dev/null || true
    git pull --ff-only 2>/dev/null || true
    git submodule update --remote --merge 2>/dev/null || true
    return 0
  fi
  return 1
}
project=$(detect_project "$CURRENT_DIR")
if [ -n "$project" ]; then sync_project "$project" 2>/dev/null || true; fi
exit 0
