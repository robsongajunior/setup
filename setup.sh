#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

brew install scc
brew install htop

echo "CONFIGURING /Users/$USER/.vimrc"
cp $(pwd)/.vim/.vimrc /Users/$USER/.vimrc

