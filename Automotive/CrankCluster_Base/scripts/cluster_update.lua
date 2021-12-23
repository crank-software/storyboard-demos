function cb_update_speed(mapargs)
	local data = {}
	data = gre.get_data("speed_layer.speed_pointer_control.angle")
	
	val = data["speed_layer.speed_pointer_control.angle"]+110
	percent = val/220
	speed = percent*200
	
	gre.set_data({["speed"] = tostring(string.format("%d", speed))})
end

function cb_update_rpm(mapargs)
	local data = {}
	data = gre.get_data("tach_layer.tach_pointer_control.angle")

	val = data["tach_layer.tach_pointer_control.angle"]+110
	percent = val/220
	speed = percent*10
	
	gre.set_data({["rpm"] = tostring(string.format("%.1f", speed))})
end

function cb_update_time(mapargs)
	local data = {}
	data["time"] = os.date("%I:%M %p")
	gre.set_data(data)
end