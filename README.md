PiCam-Setup
===========

A simple install script for initializing your Raspberry Pi with mpeg-streamer to stream your webcam on a Raspberry PI.
To run the script make sure your repository is up-to-date and Git and dialog is installed. 

```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git
```

After this you can download the script

```
cd
git clone git://github.com/Ploeper/PiCam-Setup.git
```

Execute the script

```
cd PiCam-Setup
sudo chmod +x picam_setup.sh
sudo ./picam_setup.sh
```

After the installation you can run the picam_run.sh script to launch the webcam with some default options.
To launch the webcam streamer with the parameters for your webcam, edit the picam_run.sh script. To launch the webcam on boot with
your parameters, edit the picam_service.sh script and launch the setup script. To stop the webcam streamer run

```
killall mpjg_streamer
```


