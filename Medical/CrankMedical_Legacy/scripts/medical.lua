--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]

function clock_update(mapargs)
	local data = {}

	local hour = tonumber(os.date("%I"))
	
	data["green_bar_layer.placeholder_time.clock"] = hour..":"..os.date("%M")..string.lower(os.date("%p"))
	gre.set_data(data)

end

function date_update(mapargs)
	local data = {}

	data["green_bar_layer.placeholder_date1.date"] = string.format("%s\n%s",os.date("%A"),os.date("%B %d, %Y"))
	gre.set_data(data)

end


function cb_move_numbers(mapargs)
	local data = {}
	
	local num = math.random(1,6)
	
	if num == 1 then
		data["temp"] = math.random(222,282)
		gre.send_event("update_temp")
	elseif num == 2 then
		data["data_layer.mmHG.value_mmHG"]  = tostring(math.random(110,114))
	elseif num == 3 then
		data["data_layer.mmol.value_mmol_L"] = "4."..tostring(math.random(7,9))
	elseif num == 4 then
		data["data_layer.SP02.value_sp02"] = tostring(math.random(95,97))
	elseif num == 5 then
		data["data_layer.BPM.value_bpm"] = tostring(math.random(84,89))
	elseif num == 6 then
		data["data_layer.RPM.value_rpm"] = tostring(math.random(14,16))
	end
	
	gre.set_data(data)
end

