export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/crank/linux-yocto-armle-fbdev-obj/lib
export SB_PLUGINS=/crank/linux-yocto-armle-fbdev-obj/plugins
FBDEV=/dev/fb1

killall sbengine
/crank/layer-enable

/crank/linux-yocto-armle-fbdev-obj/bin/sbengine -vv -ocapture_playback,mode=playback,file=GRE_CAPTURE,loop=-1 -orender_mgr,fb=$FBDEV /crank/Treadmill/Treadmill.gapp
