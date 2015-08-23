#!/bin/bash
# setup_home.sh - Clone and configure my standard config repos

GITHUB_BASE=https://jhillyerd@github.com/jhillyerd
PROXY_HOST=proxysg.noa.com
PROXY_PORT=8080

if ping -c 1 $PROXY_HOST >/dev/null 2>&1; then
  export HTTP_PROXY="$PROXY_HOST:$PROXY_PORT"
  export HTTPS_PROXY="$PROXY_HOST:$PROXY_PORT"
  export http_proxy="$PROXY_HOST:$PROXY_PORT"
  export https_proxy="$PROXY_HOST:$PROXY_PORT"
  echo "## Using proxy $HTTP_PROXY"
else
  echo "## Proxy server $PROXY_HOST not found, going direct"
fi

function install_repo() {
  repo_name="$1"
  target_dir="$2"
  cd $HOME
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
install_repo oh-my-fish .oh-my-fish

if install_repo dotfiles .dotfiles; then
  $HOME/.dotfiles/install.sh
fi

if install_repo dotvim .vim; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  ln -s ~/.vim/vimrc ~/.vimrc
  vim +PluginInstall +qall
fi
