#!/bin/bash
#  PiCam install script for initializing Raspberry Pi, credits to RetroPie-Setup for the fancy bash-functions

# fancy print function
function printMsg()
{
    echo -e "\n= = = = = = = = = = = = = = = = = = = = =\n$1\n= = = = = = = = = = = = = = = = = = = = =\n"
}

# shows information about how to use this script
function showHelp()
{
    echo ""
    echo "PiCam Setup script"
    echo "====================="
    echo ""
    echo "This script will install the mjpg-streamer to use it as webcam streamer on you RaspBerry Pi."
    echo "Root priviliges is needed because some APT packages are installed."
    echo "Usage:"
    echo "sudo ./picam_setup.sh: That's everyting."
    echo ""
}

# checks if git is installed
function checkNeededPackages()
{
    doexit=0
    type -P git &>/dev/null && echo "Found git command." || { echo "Did not find git. Try 'sudo apt-get install -y git' first."; doexit=1; }
    type -P dialog &>/dev/null && echo "Found dialog command." || { echo "Did not find dialog. Try 'sudo apt-get install -y dialog' first."; doexit=1; }
    if [[ doexit -eq 1 ]]; then
        exit 1
    fi
}

# start PiCam on boot
function enablePiCamAtStart()
{
    clear
    printMsg "Enabling PiCam on boot."
    cp picam_service.sh /etc/init.d/
    chmod +x /etc/init.d/picam_service.sh
    update-rc.d picam_service.sh defaults
}

# disable PiCam on boot
function disablePiCamAtStart()
{
    clear
    printMsg "Disabling PiCam on boot."

    # This command stops the daemon now so no need for a reboot
    service picam_service.sh stop

    # This command installs the init.d script so it automatically starts on boot
    update-rc.d -f picam_service.sh remove
}


# show dialog for enabling/disabling picam on boot or not
function enableDisablePiCamStart()
{
    dialog --title "Boot options" --clear \
    --yesno "Do you want to start the webcam streamer on startup?" 22 76
    case $? in
        0)
	enablePiCamAtStart
	;;
	*)
	disablePiCamAtStart
        ;;
    esac
}

function mainSetup()
{
    sudo chmod +x /picam_run.sh
    printMsg "Installing dependencies"
    apt-get install -y build-essential subversion libv4l-dev libjpeg8-dev imagemagick
    echo -e "Installing mpeg-streamer"
    svn co https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer /etc/mjpg-streamer
    rootdir=/etc/mjpg-streamer/mjpg-streamer
    cd "$rootdir"
    sudo make USE_LIB4VL=true clean all
    sudo make DESTDIR=/usr install 
    dialog --backtitle "PiCam Setup script. Installation folder: $rootdir for user $user" --msgbox "Done! You can now setup the boot behaviour of the streamer." 22 76    
}

#== MAIN LOOP ==#
checkNeededPackages

if [[ "$1" == "--help" ]]; then
    showHelp
    exit 0
fi

if [ $(id -u) -ne 0 ]; then
  printf "Script must be run as root. Try 'sudo ./picam_setup'\n"
  exit 1
fi

user=$(whoami)

while true; do
    cmd=(dialog --backtitle "PiCam Setup script. Installation folder: $rootdir for user $user" --menu "Choose install or boot behaviour" 22 76 16)
    # options=(1 "Binaries-based installation (faster, (probably) not the newest)"
    options=(1 "Install"
             2 "Setup boot behaviour"
	     3 "Exit")
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)    
    if [ "$choices" != "" ]; then
        case $choices in
            1) mainSetup ;;
            2) enableDisablePiCamStart ;;
	    3) exit 0
        esac
    else
        break
    fi
done
