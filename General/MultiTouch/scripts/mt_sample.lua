function box_rotate(mapargs)
	local data = gre.get_data("Layer1.rotate.theta", "Layer1.rotate_title.title")
	local title = tostring(mapargs.points) .. " POINT ROTATION"
	data["Layer1.rotate_title.title"] = title
	local shift = tonumber(mapargs.context_event_data.value)
	local angle = tonumber(data["Layer1.rotate.theta"])
	local newangle = angle + shift
	data["Layer1.rotate.theta"] = newangle
	gre.set_data(data);
end

pinch = 250;
function box_pinch(mapargs)
	local data = gre.get_data("Layer1.scale.pinch", "Layer1.pinch_title.title")
	local title = tostring(mapargs.points) .. " POINT ZOOM"
	data["Layer1.pinch_title.title"] = title
	local shift = tonumber(mapargs.context_event_data.value)
	pinch = pinch * shift
	if pinch < 0.5 then
		pinch = 0.5
	elseif pinch > 500 then
		pinch = 500
	end
	data["Layer1.scale.pinch"] = pinch
	gre.set_data(data);
end