#!/usr/bin/env bash
#
# This script keeps the *main* branch in this repo aligned with the highest-numbered
# `w1-XX` branch in StefanMaron/MSDyn365BC.Sandbox.Code.History.
# It creates ONE commit that contains the diff to the previous state,
# while preserving the .github folder (so the workflow keeps working).
#
# Steps:
#   1. Ensure both remotes (origin, upstream) exist and fetch all refs
#   2. Find the highest-numbered upstream w1-XX branch
#   3. Determine the version currently stored on main
#   4. If main is outdated, update it with the latest upstream branch (preserving .github)
#   5. Commit and push the update

set -euo pipefail  # Exit on error, unset variable, or failed pipe

# Script version
SCRIPT_VERSION="2.1.1"

UPSTREAM_URL="https://github.com/StefanMaron/MSDyn365BC.Sandbox.Code.History.git"  # Upstream repo URL

echo "🚀 Starting Business Central $BRANCH_PREFIX branch sync process (v${SCRIPT_VERSION})"
echo "Upstream: $UPSTREAM_URL"
echo "Branch prefix: $BRANCH_PREFIX"
echo "Working directory: $(pwd)"
echo ""

# --------------------------------------------------------------------
# 1) Ensure we have both remotes and all refs
# --------------------------------------------------------------------
echo "=== Step 1: Setting up remotes and fetching refs (v${SCRIPT_VERSION}) ==="

# Add the upstream remote if it doesn't exist
echo "Adding upstream remote: $UPSTREAM_URL"
if git remote add upstream "$UPSTREAM_URL" 2>/dev/null; then
  echo "✓ Upstream remote added successfully"
else
  echo "✓ Upstream remote already exists"
fi

# List current remotes for debugging
echo "Current remotes:"
git remote -v

# Fetch all branches from origin (our repo)
echo "Fetching from origin..."
git fetch --quiet origin
echo "✓ Origin fetch completed"

# Fetch all w1-* branches from upstream as remote-tracking branches
echo "Fetching $BRANCH_PREFIX* branches from upstream..."
git fetch --quiet upstream "+refs/heads/$BRANCH_PREFIX*:refs/remotes/upstream/$BRANCH_PREFIX*"
echo "✓ Upstream $BRANCH_PREFIX* branches fetch completed"

# Debug: Show what branches we got from upstream
echo "Available upstream $BRANCH_PREFIX* branches:"
git for-each-ref --format='  %(refname:short)' "refs/remotes/upstream/$BRANCH_PREFIX*" || echo "  No $BRANCH_PREFIX* branches found"

# --------------------------------------------------------------------
# 2) Find the highest-numbered upstream branch (e.g. w1-26)
# --------------------------------------------------------------------
echo ""
echo "=== Step 2: Finding highest-numbered upstream branch (v${SCRIPT_VERSION}) ==="

# List all remote-tracking w1-* branches from upstream, strip the prefix,
# sort numerically by the number after w1-, exclude branches ending with "vNext", and pick the highest one.
echo "Processing upstream branches to find the latest..."

latest_upstream_branch=$(git for-each-ref --format='%(refname:short)' \
                         "refs/remotes/upstream/$BRANCH_PREFIX*" |
                         grep -v 'vNext$' |
                         sort -t- -k2 -n | tail -1)

echo "Debug: Found branches (sorted by version, excluding vNext):"
git for-each-ref --format='  %(refname:short)' "refs/remotes/upstream/$BRANCH_PREFIX*" | grep -v 'vNext$' | sort -t- -k2 -n || echo "  No branches found"

if [[ -z "$latest_upstream_branch" ]]; then
  echo "❌ ERROR: no $BRANCH_PREFIX branches found in upstream"
  echo "Debug: Checking what refs we have from upstream:"
  git for-each-ref --format='  %(refname)' "refs/remotes/upstream/*" || echo "  No upstream refs found"
  exit 1
fi

echo "✓ Newest upstream branch is: $latest_upstream_branch"

# --------------------------------------------------------------------
# 3) Determine the version and SHA currently stored on main (if any)
#    We parse the latest commit message for 'w1-XX' and 'SHA: xxxxxxx'.
# --------------------------------------------------------------------
echo ""
echo "=== Step 3: Checking current version and SHA on main (v${SCRIPT_VERSION}) ==="

# Check if main exists, then extract the w1-XX version and SHA from the latest commit message.
# If not found, set to 'none'.
echo "Checking main branch for current version and SHA..."

if git rev-parse --verify -q refs/heads/main >/dev/null; then
  echo "✓ Main branch exists"

  # Look for the most recent sync commit in the commit history
  # Try both old and new commit message formats
  sync_commit_msg=$(git log --pretty=%B --grep="Sync to upstream" -1 main || true)

  if [[ -n "$sync_commit_msg" ]]; then
    echo "Latest sync commit message found:"
    echo "  $sync_commit_msg"

    # Extract version and SHA from different possible commit message formats
    # New format: "Sync to upstream w1-26 (SHA: abc123)"
    # Old format: "Sync to upstream upstream/w1-26"
    current_version=$(echo "$sync_commit_msg" | grep -oE "(upstream/)?$BRANCH_PREFIX[0-9]+" | sed 's|upstream/||' || true)
    current_sha=$(echo "$sync_commit_msg" | grep -oE "SHA: [a-f0-9]+" | cut -d' ' -f2 || true)
  else
    echo "No previous sync commit found on main"
    echo "Latest commit message on main:"
    echo "  $(git log -1 --pretty=%B main)"
    current_version="none"
    current_sha="none"
  fi

  if [[ -n "$current_version" && "$current_version" != "none" ]]; then
    echo "✓ Found version in sync commit: $current_version"
  else
    echo "⚠ No version found in sync commit"
    current_version="none"
  fi

  if [[ -n "$current_sha" && "$current_sha" != "none" ]]; then
    echo "✓ Found SHA in sync commit: $current_sha"
  else
    echo "⚠ No SHA found in sync commit"
    current_sha="none"
  fi
else
  echo "⚠ Main branch does not exist yet"
  current_version="none"
  current_sha="none"
fi

echo "Current version on main: $current_version"
echo "Current SHA on main: $current_sha"
echo "Latest upstream version: $latest_upstream_branch"

# Get the latest commit SHA from the upstream branch
latest_upstream_sha=$(git rev-parse "$latest_upstream_branch")
echo "Latest upstream SHA: $latest_upstream_sha"

# Check if we need to update based on version or SHA
needs_update=false

# Extract just the branch name without the remote prefix for comparison
upstream_branch_name=$(echo "$latest_upstream_branch" | sed 's|^upstream/||')

if [[ "$current_version" != "$upstream_branch_name" ]]; then
  echo "🔄 Version update needed: $current_version → $upstream_branch_name"
  needs_update=true
elif [[ -n "$current_sha" && "$current_sha" != "none" && "$current_sha" != "$latest_upstream_sha" ]]; then
  echo "🔄 Same version but SHA update needed: $current_sha → $latest_upstream_sha"
  needs_update=true
elif [[ -z "$current_sha" || "$current_sha" == "none" ]]; then
  # For old format commits without SHA, compare tree content instead
  echo "Comparing repository content with upstream (old commit format)..."
  if ! git diff --quiet HEAD "$latest_upstream_branch" -- ':!.github'; then
    echo "🔄 Content differs from upstream - update needed"
    needs_update=true
  else
    echo "✓ Content matches upstream - no update needed"
    echo "✓ Repository already synchronized to latest commit – nothing to do."
    exit 0
  fi
else
  echo "✓ Repository already synchronized to latest commit – nothing to do."
  exit 0
fi

# --------------------------------------------------------------------
# 4) Check out main and bring in upstream files
# --------------------------------------------------------------------
echo ""
echo "=== Step 4: Updating repository with upstream content (v${SCRIPT_VERSION}) ==="

# Switch to main branch
echo "Checking out main branch..."
git checkout main
echo "✓ On main branch"

# Create a temporary directory
echo "Creating temporary directory for upstream snapshot..."
tmp_dir=$(mktemp -d)
echo "✓ Temporary directory created: $tmp_dir"

# Archive the latest upstream branch and extract it into the temp dir
echo "Extracting upstream branch '$latest_upstream_branch' to temp directory..."
git archive "$latest_upstream_branch" | tar -x -C "$tmp_dir"
echo "✓ Upstream content extracted to: $tmp_dir"

# Debug: Show what we got from upstream
echo "Debug: Contents of upstream snapshot:"
ls -la "$tmp_dir" | head -10 || true  # Show first 10 items (|| true prevents broken pipe with pipefail)
echo "  ... (showing first 10 items only)"

# Use rsync to copy all files from temp dir to repo, deleting files that disappeared upstream
# Exclude the .git and .github folders from deletion to preserve Git repo and workflow config
echo "Syncing upstream content to repository (preserving .git and .github folders and README.md)..."
rsync -av --delete \
      --exclude '.git/' \
      --exclude '.github/' \
      --exclude 'README.md' \
      "$tmp_dir"/ ./
echo "✓ Content synchronization completed"

# Safety check before deleting tmp_dir to avoid deleting the repo by accident
echo "Cleaning up temporary directory..."
if [[ -n "$tmp_dir" && "$tmp_dir" != "/" && "$tmp_dir" != "." && "$tmp_dir" != "$(pwd)" ]]; then
  rm -rf "$tmp_dir"
  echo "✓ Temporary directory cleaned up"
else
  echo "❌ Refusing to delete suspicious tmp_dir: $tmp_dir"
  exit 1
fi

# --------------------------------------------------------------------
# 5) Stage, commit, and push the update
# --------------------------------------------------------------------
echo ""
echo "=== Step 5: Committing and pushing changes (v${SCRIPT_VERSION}) ==="

# Stage all changes
echo "Staging all changes..."
git add -A
echo "✓ Changes staged"

# Debug: Show what will be committed
echo "Debug: Files that will be committed:"
# Use a safer approach to avoid broken pipe errors by using printf instead of echo with pipes
files_output=$(git diff --cached --name-status)
file_count=$(echo "$files_output" | wc -l)
if [[ $file_count -gt 20 ]]; then
  printf '%s\n' "$files_output" | head -20 || true
  echo "  ... and $((file_count - 20)) more files"
else
  printf '%s\n' "$files_output"
fi

# If there are no changes, exit
if git diff --cached --quiet; then
  echo "ℹ️ No visible changes after rsync – aborting."
  exit 0
fi

# Otherwise, commit with a message indicating the new upstream version and SHA
echo "Creating commit for sync to $latest_upstream_branch..."
git commit -m "Sync to upstream ${upstream_branch_name} (SHA: ${latest_upstream_sha})"
echo "✓ Commit created successfully"

# Push to origin/main
echo "Pushing changes to origin/main..."
git push origin main
echo "✅ Push completed successfully"

echo ""
echo "🎉 main branch updated to ${upstream_branch_name} (SHA: ${latest_upstream_sha})"