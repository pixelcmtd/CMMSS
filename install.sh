#!/bin/sh
mkdir -p ~/.bin

export PATH="$PATH:/opt/local/bin:/opt/homebrew/bin:/usr/local/bin"

netpkg() {
        curl -Lo temp.pkg "$1"
        sudo installer -pkg temp.pkg -target /
        rm -f temp.pkg
}

MACPORTS='https://distfiles.macports.org/MacPorts/MacPorts-2.6.4_1-11-BigSur.pkg'

command -v brew >/dev/null || netsh -f install.sh gh://Homebrew/install
command -v port >/dev/null || netpkg "$MACPORTS"

sudo chown -R $USER /opt/local

brew install $(cat packages.brew)
sudo port install $(cat packages.port)
pip3 install --user $(cat packages.pip3)

#
# configuration
#

cp -f zshrc "$HOME/.zshrc"
cp -f vimrc "$HOME/.vimrc"
cp -f editorconfig "$HOME/.editorconfig"
