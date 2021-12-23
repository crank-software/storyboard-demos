--[[
Copyright 2012, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]

local g_months = {"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"}

local g_tumbler_list ={}
local g_current_tumbler = nil

function cb_load_lists(mapargs)
	local data = {}
	local i
	
	for i=1, table.maxn(g_months) do
		data["date_spinner.month.text."..i..".1"] = g_months[i]
		--print("date_spinner.month.text."..i..".1")
		--print(g_months[i])
	end
	
	for i=1, 31 do
		data["date_spinner.day.text."..i..".1"] = tostring(i)
	end
	
	local year = 1960
	for i=1, 111 do
		data["date_spinner.year.text."..i..".1"] = tostring(year)
		year = year + 1
	end	
	gre.set_data(data)
end

-- When the button is pressed then we start recording interesting data
function cb_list_press(mapargs)
	local ev = mapargs["context_event_data"];
	local info = {}
	
	-- Mouse tracking ...
	info.press = 1
	info.pos = tonumber(ev["y"])
	info.last_pos = info.pos
	info.offset = 0
	info.acceleration = 0
	info.cell_height = 43
	-- Carousel ...
	info.speed = 0;
	--TODO: If the timer isn't already firing, start it 
	
	local data = {}
	data = gre.get_data(mapargs.context_control..".grd_height",mapargs.context_control..".grd_y")
	info.height = data[mapargs.context_control..".grd_height"]
	info.list_y = data[mapargs.context_control..".grd_y"]
	
	g_current_tumbler = mapargs.context_control
	
	g_tumbler_list[mapargs.context_control] = info
	
	gre.send_event("tumbler_timer_start")
end

-- When we drag, we reset the amount we are going to move based on the
-- position delta between the motion events.  The bigger the delta the
-- faster we should be scrolling the list.
function cb_list_motion(mapargs)
	local ev = mapargs["context_event_data"];

	if g_current_tumbler == nil or g_tumbler_list[g_current_tumbler].press ~= 1 then
		return
	end

	-- Mouse tracking ...
	g_tumbler_list[g_current_tumbler].last_pos = g_tumbler_list[g_current_tumbler].pos;
	g_tumbler_list[g_current_tumbler].pos = tonumber(ev["y"])
	g_tumbler_list[g_current_tumbler].offset = g_tumbler_list[g_current_tumbler].last_pos - g_tumbler_list[g_current_tumbler].pos
	g_tumbler_list[g_current_tumbler].acceleration = g_tumbler_list[g_current_tumbler].offset		-- Adjust by some time factor if desired
	
	-- Carousel ...
	g_tumbler_list[g_current_tumbler].speed = -1 * g_tumbler_list[g_current_tumbler].acceleration
	
	if g_tumbler_list[g_current_tumbler].press == 1 then
		g_tumbler_list[g_current_tumbler].list_y = g_tumbler_list[g_current_tumbler].list_y - g_tumbler_list[g_current_tumbler].offset
		local data = {}
		data[g_current_tumbler..".grd_y"] = g_tumbler_list[g_current_tumbler].list_y
		gre.set_data(data)
	end
	
end

function cb_list_release(mapargs)
	-- Mouse tracking ...
	if g_current_tumbler ~= nil then
		g_tumbler_list[g_current_tumbler].press = 0	
	end
end

-- The timer is what performs the movement of the list.
-- It may be that the list is moved in response to the mouse being held down
-- or it may be that the movement is due to the deceleration that happens after
-- the mouse hase been released.
function cb_timer(mapargs)	
	-- Decelerate ... speed is actually an 'amount' to drop

	if (g_current_tumbler == nil) then
		return
	end
	
	g_tumbler_list[g_current_tumbler].speed = g_tumbler_list[g_current_tumbler].speed * 0.95
	
	-- Update positions
	local data = {}
	if g_tumbler_list[g_current_tumbler].press == 0 then
		g_tumbler_list[g_current_tumbler].list_y = math.floor(g_tumbler_list[g_current_tumbler].list_y + g_tumbler_list[g_current_tumbler].speed)	
	else
		return
	end
	-- ... artificially limit the content to stay onscreen
	-- 8400 = (90px * 100items) - 600px screen
	if(g_tumbler_list[g_current_tumbler].list_y > (g_tumbler_list[g_current_tumbler].cell_height * 1)) then
		g_tumbler_list[g_current_tumbler].list_y = (g_tumbler_list[g_current_tumbler].cell_height * 1)
	elseif g_tumbler_list[g_current_tumbler].list_y < -((g_tumbler_list[g_current_tumbler].height) - (g_tumbler_list[g_current_tumbler].cell_height * 3)) then
		g_tumbler_list[g_current_tumbler].list_y = -((g_tumbler_list[g_current_tumbler].height) - (g_tumbler_list[g_current_tumbler].cell_height * 3))
	end
		
	data[g_current_tumbler..".grd_y"] = g_tumbler_list[g_current_tumbler].list_y	
		
	-- Turn off timer if threshold reached
	if(g_tumbler_list[g_current_tumbler].speed >= 0 and g_tumbler_list[g_current_tumbler].speed < 0.2) or (g_tumbler_list[g_current_tumbler].speed < 0 and g_tumbler_list[g_current_tumbler].speed > -0.2) then
		gre.send_event("tumbler_timer_stop")
		
		local x = math.floor((g_tumbler_list[g_current_tumbler].list_y) / g_tumbler_list[g_current_tumbler].cell_height) * g_tumbler_list[g_current_tumbler].cell_height
		if (g_tumbler_list[g_current_tumbler].list_y % g_tumbler_list[g_current_tumbler].cell_height) > (g_tumbler_list[g_current_tumbler].cell_height / 2) then
			g_tumbler_list[g_current_tumbler].list_y = x + g_tumbler_list[g_current_tumbler].cell_height
		else
			g_tumbler_list[g_current_tumbler].list_y = x 
		end
		
		data[g_current_tumbler..".grd_y"] = g_tumbler_list[g_current_tumbler].list_y
		gre.set_data(data)
		g_current_tumbler = nil
		gre.send_event("tumbler_timer_stop")
	else
		data[g_current_tumbler..".grd_y"] = g_tumbler_list[g_current_tumbler].list_y
		gre.set_data(data)
	end	

	gre.set_data(data)
end
