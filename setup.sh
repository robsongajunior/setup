#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

brew install scc
brew install htop

echo "CONFIGURING /Users/$USER/.vimrc ... Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp $(pwd)/.vim/.vimrc /Users/$USER/.vimrc

