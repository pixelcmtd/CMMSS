#!/bin/sh
mkdir -p ~/.bin

export PATH="$PATH:/opt/local/bin:/opt/homebrew/bin:/usr/local/bin"

netpkg() {
        TMP="$(mktemp).pkg"
        curl -Lo "$TMP" "$1"
        sudo installer -pkg "$TMP" -target /
        rm -f "$TMP"
}

MACPORTS='https://distfiles.macports.org/MacPorts/MacPorts-2.6.4_1-11-BigSur.pkg'

command -v brew >/dev/null || netsh -f install.sh gh://Homebrew/install
command -v port >/dev/null || netpkg "$MACPORTS"

brew install $(cat packages.brew)
sudo port install $(cat packages.port)
pip3 install --user $(cat packages.pip3)

#
# configuration
#

cp -f zshrc "$HOME/.zshrc"
cp -f zshtheme "$HOME/.zshtheme"
cp -f vimrc "$HOME/.vimrc"
cp -f editorconfig "$HOME/.editorconfig"
cp -f env "$HOME/.env"
