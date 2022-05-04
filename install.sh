#!/bin/sh
set -uxe
mkdir -p ~/.bin

export PATH="$PATH:/opt/local/bin:/opt/homebrew/bin:/usr/local/bin"

netpkg() {
        TMP="$(mktemp).pkg"
        curl -Lo "$TMP" "$1"
        sudo installer -pkg "$TMP" -target /
        rm -f "$TMP"
}

MACPORTS='https://github.com/macports/macports-base/releases/download/v2.7.1/MacPorts-2.7.1-12-Monterey.pkg'

command -v brew >/dev/null || netsh -f install.sh gh://Homebrew/install
brew analytics off

command -v port >/dev/null || netpkg "$MACPORTS"

brew install $(cat packages.brew)
rustup toolchain install nightly
mas install $(cat packages.mas)
sudo port install $(cat packages.port)
pip3 install --user $(cat packages.pip3)
cargo install $(cat packages.cargo)

# configuration

cp -f zshrc "$HOME/.zshrc"
cp -f zshtheme "$HOME/.zshtheme"
cp -f editorconfig "$HOME/.editorconfig"
cp -f env "$HOME/.env"
curl -L https://github.com/pixelcmtd/dotfiles/raw/daddy/install | sh -s vim
