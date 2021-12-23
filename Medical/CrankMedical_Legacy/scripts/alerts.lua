--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]

local g_temp_alert = {
	min = 36.0,
	max = 38.5,
	step = 0.1,
	format = "%0.1f",
	min_var = "body_temp_layer.temp_min.val",
	max_var =  "body_temp_layer.temp_max.val"
}

local g_rr_alert = {
	min = 12,
	max = 20,
	step = 1,
	format = "%d",
	min_var = "alarm_respiration_layer.rr_min.val",
	max_var =  "alarm_respiration_layer.rr_max.val"
}

local g_ecg_alert = {
	min = 65,
	max = 117,
	step = 1,
	format = "%d",
	min_var = "alarm_ecg_layer.ecg_min.val",
	max_var =  "alarm_ecg_layer.ecg_max.val"
}


function update_temp_range()
	local data = {}
	
	data["data_layer.temp_alert_min.grd_y"] = 370 - ((g_temp_alert.min - 33) * 30) 
	data["data_layer.temp_alert_max.grd_y"] = 370 - ((g_temp_alert.max - 33) * 30) 
	gre.set_data(data)
end


function cb_alert_init(mapargs)
	local data = {}

	data[g_temp_alert.min_var] = string.format(g_temp_alert.format,g_temp_alert.min)
	data[g_temp_alert.max_var] = string.format(g_temp_alert.format,g_temp_alert.max)
	
	data[g_ecg_alert.min_var] = string.format(g_ecg_alert.format,g_ecg_alert.min)
	data[g_ecg_alert.max_var] = string.format(g_ecg_alert.format,g_ecg_alert.max)	
	
	data[g_rr_alert.min_var] = string.format(g_rr_alert.format,g_rr_alert.min)
	data[g_rr_alert.max_var] = string.format(g_rr_alert.format,g_rr_alert.max)
	
	update_temp_range()
	gre.set_data(data)
end


function cb_alert_inc(mapargs)
	local data = {}
	local cur
	
	if mapargs.alert == "temp" then
		cur = g_temp_alert
	elseif mapargs.alert == "ecg" then
		cur = g_ecg_alert
	elseif mapargs.alert == "rr" then
		cur = g_rr_alert
	else
		return
	end
	
	if mapargs.val == "min" then
		cur.min = cur.min + cur.step
		data[cur.min_var] = string.format(cur.format,cur.min)
	elseif mapargs.val == "max" then
		cur.max = cur.max + cur.step
		data[cur.max_var] = string.format(cur.format,cur.max)
	else
		return
	end

	update_temp_range()
	gre.set_data(data)
end

function cb_alert_dec(mapargs)
	local data = {}
	local cur
	
	if mapargs.alert == "temp" then
		cur = g_temp_alert
	elseif mapargs.alert == "ecg" then
		cur = g_ecg_alert
	elseif mapargs.alert == "rr" then
		cur = g_rr_alert
	else
		return
	end
	
	if mapargs.val == "min" then
		cur.min = cur.min - cur.step
		data[cur.min_var] = string.format(cur.format,cur.min)
	elseif mapargs.val == "max" then
		cur.max = cur.max - cur.step
		data[cur.max_var] = string.format(cur.format,cur.max)
	else
		return
	end

	update_temp_range()
	gre.set_data(data)
end
