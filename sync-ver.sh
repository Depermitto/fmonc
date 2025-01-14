#!/usr/bin/bash


# 1. Scan for git changes using gs:
#   1.1 If they differ from local, save them to a variable
#   1.2 If not or a new file, do nothing
# 2. Scan for local changes - compare local version of files to the git repo at ~/Gitlab/: 
#   2.1 If they exist, save them to a variable
#   2.2 If not, do nothing
# 3. Sync:
#   3.1 Link git changes to the local storage
#   3.2 Link local changes to the git storage


local_config_files=["~/.config/nvim/init.vim" "~/.config/fish/config.fish" "~/.config/alacritty/alacritty.yml" "~/.bashrc" "~/.vimrc" "~/.config/qtile/config.py"]
gitlab_config_files=["~/Gitlab/Nvim/init.vim" "~/Gitlab/Fish/config.fish" "~/Gitlab/Alacritty/alacritty.yml" "~/Gitlab/Bash/.bashrc" "~/Gitlab/Vim/.vimrc" "~/Gitlab/qtile/config.py"]


function get_file_age() {
    # Find time of last modification
    return $(stat -c %y $1 | cut -d ' ' -f 2 | cut -d '.' -f 1) 
}


function git_changes() {
}
