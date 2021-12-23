local g_tumbler_list ={}
local g_current_tumbler = nil

-- This is hard coded for the demo, generally this would come from the model
-- @Return cell height and cell selector offset
function get_cell_data(control)

	-- All cells use 40 and 3
	-- 40 is the height of a cell
	-- 3 is what cell in the visiable area is selected (since there are 5, 3 is the answer)
	
	local v = {}
	v = gre.get_table_attrs(control, "visible_rows", "rows")
	local sel_row = math.ceil(v["visible_rows"] / 2)
	
	local d = {}
	d = gre.get_table_cell_attrs(control, 1, 1,"height")
	--print("height = "..d["height"].." selected = "..sel_row)
	return d["height"], sel_row, v["rows"]
end


-- When the button is pressed then we start recording interesting data
function cb_list_press(mapargs)
	local ev = mapargs["context_event_data"];
	
	-- If we had a tumbler, mark it as unpressed now in case we missed it 
	if g_current_tumbler then
		local info = g_current_tumbler and g_tumbler_list[g_current_tumbler]
		if info ~= nil then
			info.press = 0
		end
	end
	
	-- Initialize the mouse and control tracking
	g_current_tumbler = mapargs.context_control
	
	local info = {}
	info.press = 1
	info.pos = tonumber(ev["y"])
	info.last_pos = info.pos
	info.offset = 0
	info.acceleration = 0
	info.speed = 0;
	
	-- Use this to determine snapping and drag limits
	local height, selector, num_rows = get_cell_data(g_current_tumbler)
	info.cell_height = height				-- The height of the individual cells
	info.cell_selector_offset = selector	-- How many cells down from the origin we use as our selector
	
	--TODO: If the timer isn't already firing, start it 
	local data = gre.get_data(g_current_tumbler..".grd_height", g_current_tumbler..".grd_yoffset", g_current_tumbler..".type")
	info.height = height * num_rows
	info.list_y = data[g_current_tumbler..".grd_yoffset"]
	
	if data[g_current_tumbler..".type"] ~= nil then
		info.type = data[g_current_tumbler..".type"]
	else
		info.type = 0
	end
	
	--print(g_current_tumbler..".type = "..info.type)
	
	if info.type == 1 then	
		local v = {}
		v = gre.get_table_attrs(mapargs.context_control, "rows")
	
		local d = {}
		d = gre.get_table_cell_attrs(mapargs.context_control, 1, 1,"height")
		
		if ((v["rows"] * d["height"]) < 1020) then
			info.y_max = 120
			info.y_min = 120
		else
			info.y_max = 120
			info.y_min = (-1 * v["rows"] * d["height"]) + 1020 + 120
		end	
	end
	
	-- Add the control structure to the master list 	
	g_tumbler_list[g_current_tumbler] = info
	
	gre.send_event("tumbler_timer_start")
end

-- When we drag, we reset the amount we are going to move based on the
-- position delta between the motion events.  The bigger the delta the
-- faster we should be scrolling the list.
function cb_list_motion(mapargs)
	local ev = mapargs["context_event_data"];
	if ev == nil then
		return
	end
	
	-- If we don't have a current tumbler or we haven't pressed, then bail out
	local info = g_current_tumbler and g_tumbler_list[g_current_tumbler]
	if info == nil or info.press ~= 1 then
		return
	end
	
	-- Mouse tracking ...
	info.last_pos = info.pos;
	info.pos = tonumber(ev["y"])
	info.offset = info.last_pos - info.pos
	info.acceleration = info.offset				-- Adjust by some time factor if desired
	
	-- Speed is actually an amount to move ...
	info.speed = -1 * info.acceleration
	
	if info.press == 1 then
		info.list_y = info.list_y - info.offset
		local data = {}
		data[g_current_tumbler..".grd_yoffset"] = info.list_y
		gre.set_data(data)
	end

end

-- Once the list is released, then mark the control structure as being 
function cb_list_release(mapargs)
	local info = g_current_tumbler and g_tumbler_list[g_current_tumbler]
	if info == nil then
		return
	end
	--cb_list_motion(mapargs)
	info.press = 0
end

-- The timer is what performs the movement of the list.
-- It may be that the list is moved in response to the mouse being held down
-- or it may be that the movement is due to the deceleration that happens after
-- the mouse hase been released.
function cb_timer(mapargs)	
	-- If we don't have a current tumbler then bail out
	local info = g_current_tumbler and g_tumbler_list[g_current_tumbler]
	if (info == nil) then
		return
	end
	
	-- Decelerate the automatic scroll (reset if the mouse moves)
	info.speed = info.speed * 0.97
	
	-- Update the position, unless we are still tracking a press
	if info.press ~= 0 then
		return
	end
	info.list_y = math.floor(info.list_y + info.speed)	

	-- Don't allow the list to scroll beyond the cell selector threshold in either direction
	local selector_cell_y = info.cell_height * (info.cell_selector_offset - 1)
	if(info.list_y > selector_cell_y) then
		info.list_y = selector_cell_y
	elseif (info.list_y + info.height) < (selector_cell_y + info.cell_height) then
		info.list_y = selector_cell_y + info.cell_height - info.height
	end
		
	local data = {}
	data[g_current_tumbler..".grd_yoffset"] = info.list_y	
		
	-- Once we get to a small enough speed threshold then stop the timer .. and snap 
	if(info.speed >= 0 and info.speed < 0.5) or (info.speed < 0 and info.speed > -0.5) then
		gre.send_event("tumbler_timer_stop")
		
		if(info.type == 0) then
			--print("Type 0")
			local newy= math.floor((info.list_y) / info.cell_height) * info.cell_height
			if (info.list_y % info.cell_height) > (info.cell_height / 2) then
				info.list_y = newy + info.cell_height
			else
				info.list_y = newy 
			end
		else
			--print("Type 1")
			
			if info.list_y < g_tumbler_list[g_current_tumbler].y_min then
				info.list_y = g_tumbler_list[g_current_tumbler].y_min
			elseif info.list_y> g_tumbler_list[g_current_tumbler].y_max then
				info.list_y = g_tumbler_list[g_current_tumbler].y_max
			end		
		
		end
		
		data[g_current_tumbler..".grd_yoffset"] = info.list_y
		gre.set_data(data)


-- Grab the values
		row = info.list_y/info.cell_height
		if (row < 0) then
			row = row * -1 +3
		else
			row = (row - 3) *-1
		end
		data = gre.get_data(tostring(g_current_tumbler)..".var_temp."..row..".1")
		-- this is the value
		if(g_current_tumbler=="Timer_layer.timer_hr")then
			data["hrs"]=data[tostring(g_current_tumbler)..".var_temp."..row..".1"].."h"
		elseif(g_current_tumbler=="Temperature_layer.temperature_F")then
			data["temp"]=data[tostring(g_current_tumbler)..".var_temp."..row..".1"].."º F"
		elseif(g_current_tumbler=="Timer_layer.timer_min")then
			data["mins"]=data[tostring(g_current_tumbler)..".var_temp."..row..".1"].."min"
		end
		gre.set_data(data)
		--print(">> "..data[tostring(g_current_tumbler)..".var_temp."..row..".1"])
		g_current_tumbler = nil

		gre.send_event("tumbler_timer_stop")
	else
		data[g_current_tumbler..".grd_yoffset"] = info.list_y
		gre.set_data(data)
	end	
end

function cb_set_activity(mapargs)
	local row = mapargs.context_row
	local ev = mapargs["context_event_data"];
	local data = {}
	
	local info = g_current_tumbler and g_tumbler_list[g_current_tumbler]
	if (info == nil) then
		return
	end	
	
	if math.abs(info.pos - ev["y"]) > 5 then
		return
	end
	
	data["tumbler_layer.activity.new_y"] = (row * (-40)) + 120
	gre.set_data(data)
	
	gre.send_event("set_activity")
end