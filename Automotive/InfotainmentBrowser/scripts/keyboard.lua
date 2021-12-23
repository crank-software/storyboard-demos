
local keyboard_data = ""
local shifted = 0

function cb_keyboard_press(mapargs)
	local data = {}
	
	if (shifted == 1) then
		val = string.upper(mapargs.value)
	else 	
		val = mapargs.value
	end

	keyboard_data = keyboard_data..val
	
	data["browser_url"] = keyboard_data
	gre.set_data(data)
end

function cb_keyboard_press_sym(mapargs)
	local data = {}
	
	keyboard_data = keyboard_data..mapargs.value
	
	data["browser_url"] = keyboard_data
	gre.set_data(data)
end

function cb_keyboard_delete(mapargs)
	local data = {}
	
	local len = string.len(keyboard_data)
	len = len - 1
	local new = string.format("%s", string.sub(keyboard_data,1,len))
	keyboard_data = new
	data["browser_url"] = keyboard_data
	gre.set_data(data)
end

function cb_keyboard_clear(mapargs)
	local data = {}
	
	keyboard_data = ""
	data["browser_url"] = keyboard_data
	gre.set_data(data)	
end

function cb_keyboard_shift(mapargs)
	local data = {}
	
	if (shifted == 1) then
		data["KEY_ROW3_layer.ShiftL_OFF.image"] = "images/ShiftL_OFF.png"
		shifted = 0
	else 
		data["KEY_ROW3_layer.ShiftL_OFF.image"] = "images/ShiftL_ON.png"
		shifted = 1
	end
	
	gre.set_data(data)
end
