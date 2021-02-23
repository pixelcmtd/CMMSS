#!/bin/sh
mkdir -p ~/.bin

netpkg() {
        curl -Lo temp.pkg "$1"
        sudo installer -pkg temp.pkg -target /
        rm -f temp.pkg
}

MACPORTS='https://distfiles.macports.org/MacPorts/MacPorts-2.6.4_1-11-BigSur.pkg'

[ ! -d /usr/local/Homebrew ] && netsh -f install.sh gh://Homebrew/install
[ ! -f /opt/local/bin/port ] && netpkg "$MACPORTS"

sudo chown -R $USER /opt/local

brew install $(cat packages.brew)
sudo port install $(cat packages.brew)
pip3 install --user $(cat packages.pip3)
