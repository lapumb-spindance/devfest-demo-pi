#!/bin/bash -e

USAGE="
Description:
    Recursively update the submodules of a Git repository
"

# Must be done from repo root
GIT_REPO_ROOT=($(git rev-parse --show-toplevel))
cd $GIT_REPO_ROOT

# Add all the submodules of the Git repository (current directory)
SUBMODULE_ARRAY=($(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'))

# Force-remove all submodule directories
for submodule in "${SUBMODULE_ARRAY[@]}"; do
    echo "Deleting directory $submodule"
    rm -rf $submodule
done

# Sync with the latest submodules, update recursively
(git submodule sync --recursive && git submodule update --init --recursive)
