#GCS-CLI-Pilot
A simple python based UAV control interface and live video player for GCS over cellular data networks like 3G/4G. Feel free to fork and modify.

##Motivation
To fly UAV over cellular network using a GCS and get rid of traditional low range RC remote controlled piloting mechanisms and telemetry radios. In this package, script apm_bridge_tcp.py provides a command line interface to pilot UAV over TCP while script mjpegReceiver_adaptive.py provides a client media player at GCS for low delay live video feed from the smartphone camera installed on the UAV.

##Dependencies
Requires python3 with pip3, pillow3 etc. 

##Instructions

1] To use this control mechanism, use UserCode.pde file from this repo and replace default UserCode.pde in ArduCoptor directory of https://github.com/diydrones/ardupilot.git project's source tree. Flash this modified firmware in APM2.5+ board.  

2] Fork https://github.com/AdiKulkarni/QuadFlyer.git project. Install apk on android device and connect this device to APM through USB. Make sure that you have working 3G/4G connection on the device. 

3] Script apm_bridge_tcp.py is used as a bridge between GCS software i.e. Mission Planner from https://github.com/diydrones/MissionPlanner.git and UAV on-board firmware i.e. ardupilot from https://github.com/diydrones/ardupilot.git. As you run this script on GCS, it establishes a TCP connection to transmit mavlink command messages between GCS to APM. 

4] Currently only few flight mode change commands are implemented as in UserCode.pde. You are free to write and encode own definitions of commands to be used for control. You can write those commands to the TCP connection socket (IP:port) provided by apm_bridge_tcp.py from GCS and parse them in UserCode.pde at APM.

For e.g. few commands encoded in ASCII in UserCode.pde are
    1. mmm2 (set mode to ALT_HOLD)
    2. mmm5 (set mode to LOITER) and so on.
So after following all steps in README here, when you write string "mmm5" to socket provided by apm_bridge_tcp.py, UAV will receive command to change its current mode to LOITER.

5] Alternatively, one can also use Mission Planner GCS software and establish a TCP connection to APM using the socket provided by apm_bridge_tcp.py.

6] Script mjpegReceiver_adaptive.py starts a client video streaming player to receive live video feed from the camera of the device attached to the APM. In order to use this, first enable MJPEG streaming from the QuadFlyer application that you have installed already. 

##Developer Contact
Website: http://www.comp.nus.edu.sg/~adityak
Email: adityak@comp.nus.edu.sg

