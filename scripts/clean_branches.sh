#!/bin/bash

echo "=== Git Branch Cleanup ==="
echo "1. Delete Stale Branches (no longer exist on remote)"
echo "2. Delete Merged Branches"
echo "3. Cancel"
echo -n "Choose an option (1/2/3): "
read choice

case $choice in
  1)
    echo "Fetching latest changes..."
    git fetch --prune
    branches_to_delete=$(git branch -vv | grep ': gone]' | awk '{print $1}')
    if [ -z "$branches_to_delete" ]; then
      echo "✅ No stale branches found."
    else
      echo "The following branches will be deleted:"
      echo "$branches_to_delete"
      echo -n "Confirm? (y/n): "
      read confirm
      if [ "$confirm" = "y" ]; then
        echo "$branches_to_delete" | xargs git branch -D
        echo "✅ Branches deleted."
      else
        echo "❌ Cancelled."
      fi
    fi
    ;;
  2)
    branches_to_delete=$(git branch --merged | grep -v '\*\|main\|master')
    if [ -z "$branches_to_delete" ]; then
      echo "✅ No merged branches found (except main/master)."
    else
      echo "The following branches will be deleted:"
      echo "$branches_to_delete"
      echo -n "Confirm? (y/n): "
      read confirm
      if [ "$confirm" = "y" ]; then
        echo "$branches_to_delete" | xargs git branch -d
        echo "✅ Branches deleted."
      else
        echo "❌ Cancelled."
      fi
    fi
    ;;
  *)
    echo "❌ Cancelled."
    ;;
esac
