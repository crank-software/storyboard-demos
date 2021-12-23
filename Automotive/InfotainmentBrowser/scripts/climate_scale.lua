local myenv = gre.env({ "target_os", "target_cpu" })
package.path = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.lua;" .. package.path


local LEFT = {
	press_y = 0,
	prev_y = 0,
	cur_y = 0,
	pressed = false,
}
	
local RIGHT = {
	press_y = 0,
	prev_y = 0,
	cur_y = 0,
	pressed = false,
}

local IMG_MAX = 1082
local TEMP_MIN = 14
local TEMP_MAX = 30

function cb_scale_R_press(mapargs)
	local ev = mapargs["context_event_data"]
	local gdata = {}
	
	gdata = gre.get_data("temp_scale_layer.temp_scale_offset_R")
	
	RIGHT.press_y = ev["y"]
	RIGHT.prev_y = ev["y"]
	RIGHT.cur_y = gdata["temp_scale_layer.temp_scale_offset_R"]
	RIGHT.pressed = true
end

function cb_scale_R_motion(mapargs)
	local ev = mapargs["context_event_data"]
	local data = {}
	
	if RIGHT.pressed == false then
		return
	end
	
	local delta = RIGHT.prev_y - ev["y"]
	RIGHT.cur_y = RIGHT.cur_y - math.floor(delta /4)
	--print(delta)
	
	if RIGHT.cur_y > 0 then
		RIGHT.cur_y = 0
	elseif RIGHT.cur_y < -IMG_MAX then
		RIGHT.cur_y = -IMG_MAX
	end
	
	data["temp_scale_layer.temp_scale_offset_R"] = RIGHT.cur_y
	local temp = TEMP_MIN +  math.ceil((TEMP_MAX - TEMP_MIN) * (math.abs(RIGHT.cur_y) / IMG_MAX)) 
	data["buttons_layer.temp_r.text"] = temp.."°C"	
	gre.set_data(data)
end

function cb_scale_R_release(mapargs)
	LEFT.pressed = false
end

function cb_scale_L_press(mapargs)
	local ev = mapargs["context_event_data"]
	local gdata = {}
	
	gdata = gre.get_data("temp_scale_layer.temp_scale_offset_L")
	
	LEFT.press_y = ev["y"]
	LEFT.prev_y = ev["y"]
	LEFT.cur_y = gdata["temp_scale_layer.temp_scale_offset_L"]
	LEFT.pressed = true
end

function cb_scale_L_motion(mapargs)
	local ev = mapargs["context_event_data"]
	local data = {}
	
	if LEFT.pressed == false then
		return
	end
	
	local delta = LEFT.prev_y - ev["y"]
	LEFT.cur_y = LEFT.cur_y - math.floor(delta /4)
	--print(delta)
	
	if LEFT.cur_y > 0 then
		LEFT.cur_y = 0
	elseif LEFT.cur_y < -IMG_MAX then
		LEFT.cur_y = -IMG_MAX
	end
	
	data["temp_scale_layer.temp_scale_offset_L"] = LEFT.cur_y
	local temp = TEMP_MIN +  math.ceil((TEMP_MAX - TEMP_MIN) * (math.abs(LEFT.cur_y) / IMG_MAX)) 
	data["buttons_layer.temp_l.text"] = temp.."°C"
	gre.set_data(data)	
end

function cb_scale_L_release(mapargs)
	LEFT.pressed = false
end


function set_temp_L(temp)
	local temp = TEMP_MAX - math.ceil((TEMP_MAX - TEMP_MIN) * (math.abs(LEFT.cur_y) / IMG_MAX)) 
end

function set_temp_R(temp)

end
