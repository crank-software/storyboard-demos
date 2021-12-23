--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--


-- Call back functions for the BubbleMark benchmark test

-- This controls the runtime behaviour of this test.  The original JS version
-- runs on a fixed timer, but that means that the test is artificially
-- limited in its framerate.  By making the test entirely event driven (draw
-- a frame, trigger next frame) we make the test scale up/down more appropriately.
-- events_instead_of_timers ==> TRUE makes the test purely event driven
-- events_instead_of_timers ==> FALSE makes the test run at the timer rate
local events_instead_of_timers = true
local stop_movement = false; 

require("BallsTest")

-- Our root control object
local gBallsTest

-- Initialize the test with 16 balls
function CBInit(mapargs)
  print("balls started")
	--print("Init Balls Test")
	gBallsTest = BallsTest:init(16)
	gBallsTest:start()
	stop_movement = false 
end

function CBStartFrame(mapargs)
	if(events_instead_of_timers) then
		gre.send_event("next_frame")
	else
		gre.send_event("start_frame_timer")
	end
end

function CBMove(mapargs)
	--print("Move Balls")
	gBallsTest:moveBalls()
	
	if(events_instead_of_timers and not stop_movement) then
		gre.send_event("next_frame")
	end
end

function CBFPSUpdate(mapargs)
	--print("FPS Update")
	gBallsTest:showFPS()
end

function CBStop(mapargs)
  gBallsTest:stop()
  stop_movement = true
end
