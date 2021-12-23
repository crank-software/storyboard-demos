
local phone_number = ""
local ndigits = 0

function cb_dialpad_press(mapargs)
	local data = {}
	
	ndigits = ndigits + 1
	if (ndigits == 4) then
		phone_number = phone_number.."."..mapargs.number
	elseif (ndigits == 7) then
		phone_number = phone_number.."."..mapargs.number
	else
		phone_number = phone_number..mapargs.number
	end
	data["keypad_layer.number.text"] = phone_number
	gre.set_data(data)
end

function cb_dialpad_delete(mapargs)
	local data = {}
	
	if (ndigits == 0) then
		return 0
	end
	
	ndigits = ndigits - 1
	local len = string.len(phone_number)
	if (len == 5) then
		len = len - 2
	elseif (len == 9) then
		len = len - 2
	else
		len = len - 1
	end
	local new = string.format("%s", string.sub(phone_number,1,len))
	phone_number = new
	data["keypad_layer.number.text"] = phone_number
	gre.set_data(data)
end

function cb_dialpad_clear(mapargs)
	local data = {}
	
	phone_number = ""
	ndigits = 0
	data["keypad_layer.number.text"] = phone_number
	gre.set_data(data)	
end

