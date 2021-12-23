
weight = 175
local ball_home = 291
local start_pos = 0
local count = 0
local offset = 0
local mod = 0
local x_off = 0

-- Weight ball is pressed
function cb_ball_press(mapargs)
	local ev = mapargs["context_event_data"];

	-- save name of control pressed
	start_pos = ev["x"]
	count = 0
	g_control = mapargs[mapargs.context_target]
	gre.send_event("start_weight_timer")
end

-- Motion event while Weight ball is pressed
function cb_ball_motion(mapargs)
	local ev = mapargs["context_event_data"];
	local pos = {}
	
	-- if no control selected just return
	if g_control == nil then
		return
	end

	-- cap the ball moving to limits +/- 82 pixels
	offset = ev["x"] - start_pos
	if offset > 82 then
		offset = 82
	elseif offset < -82 then
		offset = -82
	end
	
	-- set the new position
	pos["x"] = ball_home + offset
	
	-- the further from center we go the lower the mod value becomes
	-- this value is used by the timer callback for the frequency of the update
	mod = math.ceil(((83 - math.abs(offset)) / 82) * 10)
	
	-- set the control to the new position
	gre.set_control_attrs(g_control, pos)
end

-- Release of Weight ball
function cb_ball_release(mapargs)
	g_control = nil
	gre.send_event("stop_weight_timer")
	gre.send_event("ball_return")
end


function cb_weight_timer(mapargs)
	local data = {}
	
	count = count + 1
	
	-- Ignore some timers depending on ball postion
	-- the Further from center = more responses since mod decreases
	if (count % mod) == 0 then
		if offset > 1 then
			weight = weight + 1
			x_off = x_off - 3
		elseif offset < -1 then
			weight = weight - 1
			x_off = x_off + 3
		end
		
		-- cap weight values
		if weight < 0 then
			weight = 0
		elseif weight > 500 then
			weight = 500
		end
		-- move scale in bacground everytime weight increases
		data["weight_layer.scale.scale_x"] = -100 + (x_off % 40)
		-- update new weight value
		data["weight_layer.slider.text"] = tostring(weight)
		gre.set_data(data)
	end
end
