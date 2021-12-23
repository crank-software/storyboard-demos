function cb_update_speed(mapargs)
	local data
	data = gre.get_data("speed")
	gre.set_data({["speedometer_content_layer.speed.text"] = tostring(data.speed)})
end

function cb_update_rpm(mapargs)
	local data
	data = gre.get_data("rpm")
	
	text = string.format("%.1f", data.rpm)
	gre.set_data({["tachometer_content_layer.RPM_value.text"] = text})
end
