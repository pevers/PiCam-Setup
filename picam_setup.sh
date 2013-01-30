#!/bin/bash
#  PiCam install script for initializing Raspberry Pi

# shows information about how to use this script
function showHelp()
{
    echo ""
    echo "PiCam Setup script"
    echo "====================="
    echo ""
    echo "This script will install the mpeg-streamer to use it as webcam streamer on you RaspBerry Pi."
    echo "Root priviliges is needed because some APT packages are installed."
    echo "Usage:"
    echo "sudo ./picam_setup.sh: That's everyting."
    echo ""
}

#== MAIN LOOP ==#

if [[ "$1" == "--help" ]]; then
    showHelp
    exit 0
fi

if [ $(id -u) -ne 0 ]; then
  printf "Script must be run as root. Try 'sudo ./picam_setup'\n"
  exit 1
fi

echo -e "====Installing dependencies====\n"
apt-get install -y build-essential subversion libjpeg8-dev imagemagick
echo -e "====Installing mpeg-streamer====\n"
mkdir tmp
cd tmp
svn co https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer mjpg-streamer
cd mjpg-streamer/mjpg-streamer
make
echo -e "====DONE====\n"
