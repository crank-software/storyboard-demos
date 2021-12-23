	
local drag_control = nil
local start_x = 0
local start_y = 0

local xmin = 0
local ymin = 0
local xmax = 0
local ymax = 0
local range = 0

local temp_start = 15
local temp_range = 13

local xmid
local ymid

function cb_drag_press(mapargs)
	local ev = mapargs["context_event_data"];
	local data = {}

	xmin = tonumber(mapargs.xmin)
	xmax = tonumber(mapargs.xmax)
	ymin = tonumber(mapargs.ymin)
	ymax = tonumber(mapargs.ymax)
	range = ymax - ymin
	
	xmid = (xmax-xmin) + xmin
	ymid = (ymax-ymin) + ymin
	
	drag_control = mapargs.context_control
	start_x = ev["x"]
	start_y = ev["y"]
end

function cb_drag_release(mapargs)
	local ev = mapargs["context_event_data"];
	drag_control = nil
end

function cb_drag_move(mapargs)
	if( drag_control ~= nil) then
		local ev = mapargs["context_event_data"];
		local data = {}
		local sdata = {}
		
		delta_x = ev.x - start_x
		delta_y = ev.y - start_y
		data = gre.get_control_attrs(drag_control, "x", "y") 

		x = tonumber(data["x"]) + delta_x;
		if (x > xmax) then
			x = xmax
		elseif (x < xmin) then
			x = xmin
		end
		sdata["x"] = x

		y = tonumber(data["y"]) + delta_y;
		if (y > ymax) then
			y = ymax
		elseif (y < ymin) then
			y = ymin
		end
		sdata["y"] = y
		
		gre.set_control_attrs(drag_control, sdata)
		start_x = ev["x"]
		start_y = ev["y"]
		
		-- set the value
		offset = ymax - y
		value = (offset/range * temp_range) + temp_start
		
		data = {}
		data[drag_control..".value"] = string.format("%dº", value)
		gre.set_data(data)
	end
end

