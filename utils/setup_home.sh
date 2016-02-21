#!/bin/sh
# setup_home.sh - Clone and configure my standard config repos

GITHUB_USER="jhillyerd"
GITHUB_BASE="https://$GITHUB_USER@github.com/$GITHUB_USER"
PROXY_HOST="proxysg.noa.com"
PROXY_PORT="8080"

if ping -c 1 $PROXY_HOST >/dev/null 2>&1; then
  export HTTP_PROXY="$PROXY_HOST:$PROXY_PORT"
  export HTTPS_PROXY="$PROXY_HOST:$PROXY_PORT"
  export http_proxy="$PROXY_HOST:$PROXY_PORT"
  export https_proxy="$PROXY_HOST:$PROXY_PORT"
  echo "## Using proxy $HTTP_PROXY"
else
  echo "## Proxy server $PROXY_HOST not found, going direct"
fi

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

if install_repo dotfiles .dotfiles; then
  $HOME/.dotfiles/install.sh
fi

if install_repo dotvim .vim; then
  source ~/.vim/init-vundle.sh
fi

# Setup oh-my-fish
# TODO if repo ever comes back

# Setup golang dev dirs
mkdir -p "devel/gocode/src/github.com/$GITHUB_USER"
mkdir -p "devel/godeps"
