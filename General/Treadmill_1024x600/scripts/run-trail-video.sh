#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/crank/linux-yocto-armle-fbdev-obj/lib
export SB_PLUGINS=/crank/linux-yocto-armle-fbdev-obj/plugins

killall gst-launch-1.0

gst-launch-1.0 uridecodebin expose-all-streams=false uri=file:///crank/testApps/video/forest_run_m.mp4 caps="video/x-h264;audio/x-raw" . ! queue ! h264parse ! queue ! g1h264dec ! video/x-raw,width=1024,height=600 ! g1fbdevsink device=/dev/fb0
rc=$?
if [ "$rc" -eq 0 ]; then
	echo "IOGEN"
	/crank/linux-yocto-armle-fbdev-obj/bin/iogen Treadmill.gapp no_target gre.media.complete
fi

