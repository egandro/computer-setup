#/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export NONINTERACTIVE=1

brew install --cask google-chrome
brew install --cask visual-studio-code
brew install mc
brew install node
brew install wget
brew install kubernetes-cli
brew install helm
brew install go
brew install --cask another-redis-desktop-manager 
brew install --cask openlens
brew install --cask firefox
brew install fzf
brew install tmux
brew install jq
brew install docker
brew install docker-compose
#brew install --cask foxitreader
#brew install openjdk


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
