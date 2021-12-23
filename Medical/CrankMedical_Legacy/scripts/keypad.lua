--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]

-- Layout for different keyboard layouts
local g_keypad_upper = {"Q","W","E","R","T","Y","U","I","O","P","del","A","S","D","F","G","H","J","K","L","shift","Z","X","C","V","B","N","M","?","!","shift","_"}
local g_keypad_lower = {"q","w","e","r","t","y","u","i","o","p","del","a","s","d","f","g","h","j","k","l","shift","z","x","c","v","b","n","m",",",".","shift","-"}

local g_cur_keypad = g_keypad_lower

-- current sex
local g_sex = "female"

-- Used to store the first and last name (1 and 2 respectively)
local g_name = {"",""}
local g_cur = 1

--load current keyboard
function cb_keybad_init(mapargs)
	local i
	local data = {}
	local name
	
	for i=1, table.maxn(g_cur_keypad) do
		name = "keyboard_layer.sm_key"..i..".key"
		data[name] = g_cur_keypad[i]
	end
	gre.set_data(data)
end

-- shift keypress, change keyboard case
function keypad_shift()
	
	if g_cur_keypad == g_keypad_lower then
		g_cur_keypad = g_keypad_upper
	elseif g_cur_keypad == g_keypad_upper then
		g_cur_keypad = g_keypad_lower
	end
	
	cb_keybad_init()
end

-- remove char when del is press on keyboard
function del_key()
	local len = string.len(g_name[g_cur])
	
	len = len - 1
	if len < 0 then
		len = 0
	end
	
	local new = string.format("%s", string.sub( g_name[g_cur], 1, len ))
	g_name[g_cur] = new
	update_text()
end

-- chnage focus when next button is pressed
function cb_text_focus(mapargs)
	if mapargs.text == "first" then
		g_cur = 1
	elseif mapargs.text == "last" then
		g_cur = 2
	end
end

-- update the text displayed on screen
function update_text()
	local data = {}

	data["patient_info.first_name.text"] = g_name[1] 
	data["patient_info.last_name.text"] = g_name[2] 
	gre.set_data(data)
end

-- process all keyboard touches
function cb_key_press(mapargs)
	local data = {}
	local name = mapargs.context_control..".key"
	
	data = gre.get_data(name)
	
	if data[name] == "shift" then
		keypad_shift()
		return
	end
	
	if data[name] == "del" then
		del_key()
		return
	end	
	
	if data[name] == "Next" then
		gre.send_event("focus_next")
		return
	end		
	
	if data[name] == "123" then
		-- still need to make a numeric keyboard
		return
	end
	
	if data[name] == "Special" then
		-- still need to make a special symbol keyboard
		return
	end			
	
	-- add the char pressed to the current string
	g_name[g_cur] = g_name[g_cur] ..data[name]
	update_text()
	
	-- if the current keyboard isn't lower case change it back to lower case
	if g_cur_keypad ~= g_keypad_lower then
		g_cur_keypad = g_keypad_lower
		cb_keybad_init()
	end	
end

-- submit the information
function cb_submit_press(mapargs)
	local data = {}

	-- load the name
	data["patient_info_layer.patient_first_name.text"] = g_name[1]
	data["patient_info_layer.patient_last_name.text"] = g_name[2].."," 
	
	--clear current content 
	g_name = {"",""}
	update_text()	
	
	-- set avatar to corrent sex image
	if g_sex == "female" then
		data["patient_info_layer.patient_avatar_control.image"] = "images/patient_female.png"
	else
		data["patient_info_layer.patient_avatar_control.image"] = "images/patient_male.png"
	end
	
	-- update age and birth day
	
	-- set attending physician
	
	data["green_bar_layer.attending_physician.text"] = 

	gre.set_data(data)
end

-- gender toogle
function slide_LR (mapargs)
	local var = mapargs.context_control .. ".slide"
	local values = gre.get_data(var)
	local slide_x_value = values[var]	
	local data = {}
	
	if slide_x_value == 0 then
		gre.send_event_target("go_right", mapargs.context_control)
		g_sex = "male"
		data["patient_info.gen_avatar_control.image"] = "images/gen_avatar_male.png"
	else
		gre.send_event_target("go_left", mapargs.context_control)
		g_sex = "female"
		data["patient_info.gen_avatar_control.image"] = "images/gen_avatar_female.png"
	end
	gre.set_data(data)
end


