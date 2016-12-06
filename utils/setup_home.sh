#!/bin/sh
# setup_home.sh
# description: Clone and configure my standard config repos

GITHUB_USER="jhillyerd"
GITHUB_BASE="https://$GITHUB_USER@github.com/$GITHUB_USER"

install_repo() {
  local repo_name="$1"
  local target_dir="$2"
  cd "$HOME"
  if [ -d "$target_dir" ]; then
    echo "## Target $target_dir exists, skipping"
    return 1
  else
    echo "## Cloning repo $repo_name into $target_dir"
    git clone "$GITHUB_BASE/$repo_name" "$target_dir"
    return $?
  fi
}

install_repo binfiles bin
install_repo dotvim .vim

if install_repo dotfiles .dotfiles; then
  $HOME/.dotfiles/install.sh
fi

# Setup golang dev dirs
mkdir -p "go/src/github.com/$GITHUB_USER"
mkdir -p "go/bin"

# Install oh-my-fish
if [ -x /usr/bin/fish ]; then
  curl -L http://get.oh-my.fish | fish
fi
