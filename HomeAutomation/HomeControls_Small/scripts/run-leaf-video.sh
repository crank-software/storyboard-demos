#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/crank/linux-yocto-armle-fbdev-obj/lib
export SB_PLUGINS=/crank/linux-yocto-armle-fbdev-obj/plugins

killall gst-launch-1.0

gst-launch-1.0 uridecodebin expose-all-streams=false uri=file:///crank/Atmel_Home/video/leaves_loop_800x480.mp4 caps="video/x-h264;audio/x-raw" . ! queue ! h264parse ! queue ! g1h264dec ! video/x-raw,width=800,height=480 ! g1fbdevsink zero-memcpy=true max-lateness=-1 async=false enable-last-sample=false

rc=$?
if [ "$rc" -eq 0 ]; then
	echo "IOGEN"
	/crank/linux-yocto-armle-fbdev-obj/bin/iogen Atmel_Home_Automation.gapp no_target gre.media.complete
fi
