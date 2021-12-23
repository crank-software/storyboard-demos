IOGEN=/Applications/Crank_Software_3_2/Storyboard_Engine/3.2.201311151606/macos-x86-opengles_2.0-obj/bin/iogen

while true
do
	sleep 10
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message phone
	sleep 3
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message navigation
	sleep 10
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message gas
	sleep 3
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message navigation
	sleep 10
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message engine
	sleep 3
	${IOGEN} CrankCluster.gapp no_target show_message 1s0:message navigation
done
