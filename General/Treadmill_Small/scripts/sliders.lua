local  SMULTI = (272 / 480)

local BUTTON_MIN =  340 - 198
local BUTTON_MAX =  453 - 198
local BUTTON_HEIGHT =  28

local ACTIVE_SLIDER = nil

function cb_reset_sliders(mapargs)

end


function calc_slider_position(mapargs)
	local press_x = mapargs.context_event_data.x
	local v = {}
	local data = {}
	
	control = gre.get_control_attrs(mapargs.context_control, "x")
	local new_x = press_x - control["x"] -  math.floor(10 * SMULTI)
	local fill_new_x = press_x - control["x"] -  math.floor(15 * SMULTI)
	local stroke_new_x = press_x - control["x"] -  0
	
	
	if new_x < BUTTON_MIN then
		new_x = BUTTON_MIN
	elseif new_x > BUTTON_MAX then
		new_x = BUTTON_MAX
	end
	
	local fill_new_x = new_x - math.floor(5 * SMULTI)
	local stroke_new_x = new_x - 130
	
	--Setting Distance String
	local time = (math.floor((((new_x - 113 - 29)/1.75)/5)+.5))*5 + 5
	local intensity = math.floor((new_x -  math.floor(150 * SMULTI))/math.floor(70 * SMULTI))
	local weight = math.floor(new_x -  113- 19 ) * 2
	local age = math.floor(new_x -  113- 19 )
  
	data[mapargs.context_control..".offset_x"] = new_x
	data[mapargs.context_control..".slider_thumb_pos"] = new_x - 140
	data[mapargs.context_control..".fill_offset_x"] = fill_new_x
	data[mapargs.context_control..".stroke_offset_x"] = stroke_new_x
	
	data[mapargs.context_control..".distance"] = time
	data[mapargs.context_control..".intensity"] = intensity
	data[mapargs.context_control..".weight"] = weight
	data[mapargs.context_control..".age"] = age
	

	
	gre.set_data(data)
end

function cb_slider_press(mapargs)
	ACTIVE_SLIDER = mapargs.context_control
	
	calc_slider_position(mapargs)
end


function cb_slider_motion(mapargs)
	
	if ACTIVE_SLIDER == nil then
		return
	end
	
	if ACTIVE_SLIDER == mapargs.context_control then
		calc_slider_position(mapargs)
	end
end


function cb_slider_release(mapargs)

	ACTIVE_SLIDER = nil	
end