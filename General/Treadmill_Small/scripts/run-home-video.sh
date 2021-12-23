#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/crank/linux-yocto-armle-fbdev-obj/lib
export SB_PLUGINS=/crank/linux-yocto-armle-fbdev-obj/plugins

killall gst-launch-1.0

gst-launch-1.0 uridecodebin expose-all-streams=false uri=file:///crank/Treadmill-480/video/forest_homescreen_480.mp4 caps="video/x-h264" ! queue ! h264parse ! g1h264dec ! video/x-raw,width=480,height=272 ! g1fbdevsink zero-memcpy=true max-lateness=-1 async=false > /dev/null
rc=$?

if [ "$rc" -eq 0 ]; then
	echo "IOGEN"
	/crank/linux-yocto-armle-fbdev-obj/bin/iogen Treadmill-480.gapp no_target gre.media.complete
fi

