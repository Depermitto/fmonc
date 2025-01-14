#!/usr/bin/bash


# 1. Scan for git changes using gs:
#   1.1 If they differ from local, save them to a variable
#
#   1.2 If not or a new file, do nothing
# 2. Scan for local changes - compare local version of files to the git repo at ~/Gitlab/: 
#   2.1 If they exist, save them to a variable
#   2.2 If not, do nothing
# 3. Sync:
#   3.1 Link git changes to the local storage
#   3.2 Link local changes to the git storage


function git_changes() {
    difference=$(gs -s | cut -d ' ' -f 2)
}
