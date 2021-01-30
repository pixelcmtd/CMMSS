#!/bin/sh
cd
git clone https://github.com/ffmpeg/ffmpeg.git
cd ffmpeg
./configure --enable-gpl
make -j7
cp ffmpeg $HOME/.bin
