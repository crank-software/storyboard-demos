local points = {}

function addPoint(mapargs)
	local id = tonumber(mapargs.context_event_data.id)
	id = addNumber(id)
	if id == -1 then
		return
	end
	local name = "Layer1.TP" .. tostring(id)
	local X = tonumber(mapargs.context_event_data.x)
	local Y = tonumber(mapargs.context_event_data.y)
	local v = {}
	v = gre.get_control_attrs(name, "x", "y")
	v["x"] = X-50
	v["y"] = Y-50
	gre.set_control_attrs(name, v)
end

function movePoint(mapargs)
	local id = tonumber(mapargs.context_event_data.id)
	id = getNumber(id)
	if id == -1 then
		return
	end
	local name = "Layer1.TP" .. tostring(id)
	local X = tonumber(mapargs.context_event_data.x)
	local Y = tonumber(mapargs.context_event_data.y)
	local v = {}
	v = gre.get_control_attrs(name, "x", "y")
	v["x"] = X-50
	v["y"] = Y-50
	gre.set_control_attrs(name, v)
end

function remPoint(mapargs)
	local id = tonumber(mapargs.context_event_data.id)
	remNumber(id)
end

function addNumber(num)
	for i=1, 5 do
		if points[i] == -1 then
			points[i] = num
			return i
		end
	end
	return -1
end

function getNumber(num)
	for i=1, 5 do
		if points[i] == num then
			return i
		end
	end
	return -1
end

function remNumber(num)
	for i=1, 5 do
		if points[i] == num then
			points[i] = -1
			return
		end
	end
end

function setup()
		for i=1, 5 do
		if points[i] == num then
			points[i] = -1
		end
	end
end
