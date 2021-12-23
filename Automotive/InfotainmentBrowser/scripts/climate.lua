local myenv = gre.env({ "target_os", "target_cpu" })

package.path = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.lua;" .. package.path

-- global table that will keep track of the toggle button states
local CLIMATE_STATE = {}
 
local fill_x = -247


--
--
--
--initial state for Air Conditioning button
function cb_climate_AC(mapargs)
	local data = {}

	if CLIMATE_STATE[mapargs.context_control] == nil then
		CLIMATE_STATE[mapargs.context_control] = 0
	end

--get the variable for the control
	vs = mapargs.context_control..".vshader"
	fs = mapargs.context_control..".fshader"

--toggle the image and switch the value in the state table	
	if 	CLIMATE_STATE[mapargs.context_control] == 0	then
		data[vs] = "shaders/glowc.vs"
		data[fs] = "shaders/glowc.fs"
		CLIMATE_STATE[mapargs.context_control] = 1
	else
		data[vs] = ""
		data[fs] = ""
		CLIMATE_STATE[mapargs.context_control] = 0
	end	 

	gre.set_data(data)
end
--
--
--
--initial state for Rear button
function cb_climate_rear(mapargs)
	local data = {}

	if CLIMATE_STATE[mapargs.context_control] == nil then
		CLIMATE_STATE[mapargs.context_control] = 0
	end

--get the variable for the control
	vs = mapargs.context_control..".vshader"
	fs = mapargs.context_control..".fshader"

--toggle the image and switch the value in the state table	
	if 	CLIMATE_STATE[mapargs.context_control] == 0	then
		data[vs] = "shaders/glowc.vs"
		data[fs] = "shaders/glowc.fs"
		CLIMATE_STATE[mapargs.context_control] = 1
	else
		data[vs] = ""
		data[fs] = ""
		CLIMATE_STATE[mapargs.context_control] = 0
	end	 

	gre.set_data(data)
end
--
--
--
--initial state for driver button
function cb_climate_front(mapargs)
	local data = {}

	if CLIMATE_STATE[mapargs.context_control] == nil then
		CLIMATE_STATE[mapargs.context_control] = 0
	end

	vs = mapargs.context_control..".vshader"
	fs = mapargs.context_control..".fshader"

--toggle the image and switch the value in the state table	
	if 	CLIMATE_STATE[mapargs.context_control] == 0	then
		data[vs] = "shaders/glowc.vs"
		data[fs] = "shaders/glowc.fs"
		CLIMATE_STATE[mapargs.context_control] = 1
	else
		data[vs] = ""
		data[fs] = ""
		CLIMATE_STATE[mapargs.context_control] = 0
	end	 

	gre.set_data(data)
end
--
--
--
function set_shader_disable(data, control)
	vs = control..".vshader"
	fs = control..".fshader"

	data[vs] = ""
	data[fs] = ""
end

function set_shader_enable(data, control)
	vs = control..".vshader"
	fs = control..".fshader"

	data[vs] = "shaders/glowc.vs"
	data[fs] = "shaders/glowc.fs"
end

--initial state for arrow button
function cb_climate_M_fan(mapargs)
	local image_var
	local dk_image = {}

	set_shader_enable(dk_image,"buttons_layer.face")
	set_shader_disable(dk_image,"buttons_layer.both")
	set_shader_disable(dk_image,"buttons_layer.feet")
	set_shader_disable(dk_image,"buttons_layer.feet_shield")

	gre.set_data(dk_image)
end
--
--
--
--initial state for arrow button
function cb_climate_ML_fan(mapargs)
	local dk_image = {}

	set_shader_disable(dk_image, "buttons_layer.face")
	set_shader_enable(dk_image, "buttons_layer.both")
	set_shader_disable(dk_image, "buttons_layer.feet")
	set_shader_disable(dk_image, "buttons_layer.feet_shield")

	gre.set_data(dk_image)
end
--
--
--

--initial state for arrow button
function cb_climate_L_fan(mapargs)
	local dk_image = {}

	set_shader_disable(dk_image, "buttons_layer.face")
	set_shader_disable(dk_image, "buttons_layer.both")
	set_shader_enable(dk_image, "buttons_layer.feet")
	set_shader_disable(dk_image, "buttons_layer.feet_shield")
	gre.set_data(dk_image)
end
--
--
--
--initial state for arrow button
function cb_climate_U_fan(mapargs)
	local dk_image = {}

	set_shader_disable(dk_image, "buttons_layer.face")
	set_shader_disable(dk_image, "buttons_layer.both")
	set_shader_disable(dk_image, "buttons_layer.feet")
	set_shader_enable(dk_image, "buttons_layer.feet_shield")

	gre.set_data(dk_image)
end

--
--
--
--initial state for arrow button
function cb_climate_circulation(mapargs)
	local data = {}

	if CLIMATE_STATE[mapargs.context_control] == nil then
		CLIMATE_STATE[mapargs.context_control] = 0
	end

--get the variable for the control
	vs = mapargs.context_control..".vshader"
	fs = mapargs.context_control..".fshader"

--toggle the image and switch the value in the state table	
	if 	CLIMATE_STATE[mapargs.context_control] == 0	then
		data[vs] = "shaders/glowc.vs"
		data[fs] = "shaders/glowc.fs"
		CLIMATE_STATE[mapargs.context_control] = 1
	else
		data[vs] = ""
		data[fs] = ""
		CLIMATE_STATE[mapargs.context_control] = 0
	end	 

	gre.set_data(data)
end


g_fill_base= -247 -- starting value of the fan is -247. it can be increased/decreased by increments of 31 until the value is 1 or -247 (max and min)
g_fan_speed = 0
g_fan_max = 8
g_fan_dir = nil

function cb_fanSpeed_update(mapargs)	
	g_fan_speed = lqnx_pps.get("/pps/services/can/status", "fan_speed_l")
	set_fan_display(g_fan_speed)
end

function set_fan_display(speed)
	local data = {}
	
	local fill_x =(speed * 20)
	data["buttons_layer.fan_speed.grd_width"] = fill_x
	gre.set_data(data)	

	--set pps 
	lqnx_pps.set("/pps/services/can/status", "fan_speed_l", speed)
	lqnx_pps.set("/pps/services/can/status", "fan_speed_r", speed)
end

function cb_climate_fanbar(mapargs)
	local ev = mapargs.context_event_data
	local gdata = {}

	if myenv.target_os  == "macos" then
		if ev["button"] == 0 then
			return
		end
	end
	gdata = gre.get_control_attrs(mapargs.context_control, "x")
	local x_pos = ev["x"] - gdata["x"]
	local speed = math.ceil(x_pos / 20)

	set_fan_display(speed)
end

local SEAT_L = 1
local SEAT_R = 1
local fill_image = {"seat_off.png", "seat_yellow.png", "seat_orange.png", "seat_red.png"}

function cb_climate_seat_L(mapargs)
	local data = {}
	
	SEAT_L = SEAT_L + 1
	if SEAT_L > 4 then
		SEAT_L = 1
	end
	
	data["temp_scale2_layer.seat_driver_control.image"] = "images/"..fill_image[SEAT_L]
	gre.set_data(data)
end


function cb_climate_seat_R(mapargs)
	local data = {}
	
	SEAT_R = SEAT_R + 1
	if SEAT_R > 4 then
		SEAT_R = 1
	end
	
	data["temp_scale2_layer.seat_passenger_control.image"] = "images/"..fill_image[SEAT_R]
	gre.set_data(data)
end
