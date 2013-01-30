#!/bin/bash
#  PiCam install script for initializing Raspberry Pi

echo -e "====Installing dependencies====\n"
apt-get install -y build-essential subversion libjpeg8-dev imagemagick
echo -e "====Installing mpeg-streamer====\n"
mkdir tmp
cd tmp
svn co https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer mjpg-streamer
cd mjpg-streamer
make
echo -e "====DONE====\n"
