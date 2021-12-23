-- This module contains functions that help with creating polygon arcs

--gets the final point of the circle
function get_xy_on_rect(width, height, angle)
	local g_x = width/2
	local g_y = height/2
	local radius=width/2 +5

	radian= angle * (math.pi/ 180)
	dx = g_x + radius*math.cos(radian)
	dy = g_y + radius*math.sin(radian)
	return dx, dy

	end


-- Draw an centered arc from start angle (degrees) with the specified
-- sweep angle 0 - 360 assuming a bounding box of width/height size. 
-- The angles are measured using standard cartesian planes.
--@param startdeg The starting degree point (0 degree == 3 o'clock)
--@param sweepangle The angle to run to (0 - 360)
--@param width The width of the bounding area
--@param height The height of the bounding area
--@param invert An optional parameter indicating that we want a polygon extruding
 function get_arc_points(startdeg, sweepangle, width, height, invert)
	local hwidth = math.floor(width / 2)
	local hheight = math.floor(height / 2)
	
	if(invert ~= nil) then
		sweepangle = 360 - sweepangle
	end

	--Cover the 0 sweep or > 360 sweep cases immediately
	if(sweepangle == 0) then
		return ""
	elseif(sweepangle >= 360) then
		return string.format("0:0 0:%d %d:%d %d:0", height, width, height, width) 
	end
	
	enddeg = startdeg + sweepangle
	
	local dx, dy, rad
	
	-- Start at the center point
	local pts = string.format("%d:%d ", math.floor(hwidth), math.floor(hheight))
	
	-- Determine the first point on the rectangle
	dx, dy = get_xy_on_rect(width, height, startdeg)
	pts = pts .. string.format("%d:%d ", dx, dy)

	for i = startdeg + 45, enddeg, 45 do
		local segment = math.floor(i / 45)
		if(segment == 0) then
			pts = pts .. string.format("%d:%d ", width, hheight)
		elseif(segment == 7) then
			pts = pts .. string.format("%d:%d ", width, 0)
		elseif(segment == 6) then
			pts = pts .. string.format("%d:%d ", hwidth, 0)
		elseif(segment == 5) then 
			pts = pts .. string.format("%d:%d ", 0, 0)
		elseif(segment == 4) then 
			pts = pts .. string.format("%d:%d ", 0, hheight)
		elseif(segment == 3) then 
			pts = pts .. string.format("%d:%d ", 0, height)
		elseif(segment == 2) then 
			pts = pts .. string.format("%d:%d ", hwidth, height)
		elseif(segment == 1) then 
			pts = pts .. string.format("%d:%d ", width, height)
		end 
	end
	
	-- Determine the last point on the rectangle
	dx, dy = get_xy_on_rect(width, height, enddeg)
	pts = pts .. string.format("%d:%d ", dx, dy)	

	return pts
end



local oxy_counter = 0
local upto=94
function cb_show_oxy(mapargs)
	local percent=oxy_counter/100
	local data={}
	data["blood_oxy_right_layer.chart_fill.points"]=get_arc_points(0,360*percent,145,145)
	data["blood_oxy_right_layer.blood_ox_value1.text"]=oxy_counter+1
	data["blood_oxy_right_layer.time1.text"]="NOW"
	gre.set_data(data)
	oxy_counter=oxy_counter+3

	if (oxy_counter < upto+1) then
		gre.timer_set_timeout(cb_show_oxy, 20)
	else
		oxy_counter=0

	end
end

local RAND_MAX = 32767
local ecgSmall = {}
local ecgBig = {}
local plethSmall = {}

local startx = 0
local starty = 120
local amplitude = 30
local freq = 20
local incx = 0
local incy = 0
local max_idx = 376
local cur_w_idx = 1
local wrapped = 1 
local cur_rad = 0
local x = {}
local y = {}

local g_scale_rpm = 0.7
local g_scale_bpm = 0.7


function update_small_graphs ( mapargs )
	local ecgPoints = ""
	local oxiPoints = ""
	local v = {}
	local iter
	local radinc
	local theta
	
	-- print("Updating small graphs")
	
	max_idx = table.getn(ecgSmall)

	-- Use a circular buffer to keep points in a sin wave, adhusting position in screen
	-- and then change points into a polygon string  
	if cur_w_idx > max_idx then
		cur_w_idx = 1
		wrapped = 1
	end		
	
	iter = cur_w_idx
	
	while (iter > 0) do
		newstr = string.format("%d:%d", (max_idx - (cur_w_idx-iter) - 1)*3, ecgSmall[iter]*1.5)
		ecgPoints = ecgPoints..newstr
		newstr = string.format("%d:%d", (max_idx - (cur_w_idx-iter) - 1)*3, plethSmall[iter]*1.5)
		oxiPoints = oxiPoints..newstr		
		if iter > 1 then
			ecgPoints = ecgPoints.." "
			oxiPoints = oxiPoints.." "
		end
		iter = iter -1
	end
	
	-- Gone around once so now fill in the old point data
	if (wrapped == 1) then
		if (max_idx > cur_w_idx) then
			ecgPoints = ecgPoints.." "
			oxiPoints = oxiPoints.." "
		end
		iter = max_idx		
		
		while (iter > cur_w_idx) do		
			newstr = string.format("%d:%d", (iter - cur_w_idx - 1)*3, ecgSmall[iter]*1.5)
			ecgPoints = ecgPoints..newstr
			newstr = string.format("%d:%d", (iter - cur_w_idx - 1)*3, plethSmall[iter]*1.5)
			oxiPoints = oxiPoints..newstr
			if iter > cur_w_idx+1 then
				ecgPoints = ecgPoints.." "
				oxiPoints = oxiPoints.." "
			end		
			iter = iter -1
		end
	else
		-- extend to start of trend window for a flat line 
		if (cur_w_idx < max_idx) then 
			newstr = string.format(" %d:%d",startx,starty)		
			ecgPoints = ecgPoints..newstr
			oxiPoints = oxiPoints..newstr
		end
	end

	cur_w_idx = cur_w_idx + 1
	
	v["ecg_points"] = ecgPoints
	v["oxi_points"] = oxiPoints
	
	--print(v["ecg_points"])
	
	gre.set_data(v)
end




function plot(mapargs)
	local data = {}
	local ecgData = {79 ,79 ,79 ,78 ,78 ,77 ,77 ,77 ,77 ,77 ,76 ,76 ,76 ,76 ,76 ,75 ,75 ,75 ,75 ,74 ,73 ,71 ,68 ,66 ,63 ,60 ,59 ,59 ,60 ,62 ,65 ,68 ,71 ,73 ,75 ,75 ,76 ,78 ,82 ,78 ,56 ,27 ,13 ,17 ,38 ,70 ,88 ,83 ,78 ,76 ,76 ,75 ,75 ,74 ,72 ,71 ,69 ,66 ,64 ,61 ,58 ,55 ,53 ,52 ,51 ,52 ,53 ,55 ,57 ,60 ,63 ,66 ,69 ,72 ,75 ,76 ,77 ,78 ,78 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,67 ,64 ,63 ,63 ,65 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,83 ,87 ,80 ,56 ,29 ,17 ,25 ,50 ,80 ,92 ,86 ,82 ,81 ,80 ,80 ,80 ,79 ,77 ,75 ,73 ,71 ,68 ,65 ,62 ,59 ,58 ,57 ,57 ,57 ,59 ,61 ,63 ,66 ,69 ,72 ,75 ,78 ,80 ,81 ,82 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,83 ,82 ,82 ,82 ,82 ,82 ,81 ,80 ,78 ,76 ,74 ,71 ,68 ,67 ,66 ,67 ,69 ,71 ,74 ,77 ,80 ,81 ,81 ,82 ,84 ,88 ,85 ,64 ,35 ,21 ,25 ,45 ,76 ,95 ,90 ,85 ,83 ,82 ,82 ,81 ,80 ,78 ,77 ,75 ,72 ,69 ,66 ,63 ,60 ,58 ,57 ,56 ,56 ,57 ,59 ,61 ,64 ,67 ,70 ,73 ,76 ,78 ,79 ,80 ,81 ,81 ,82 ,82 ,81 ,81 ,81 ,81 ,81 ,81 ,81 ,80 ,80 ,80 ,80 ,80 ,80 ,79 ,79 ,79 ,79 ,78 ,78 ,76 ,74 ,72 ,69 ,66 ,63 ,62 ,62 ,63 ,65 ,67 ,70 ,73 ,75 ,77 ,77 ,78 ,80 ,83 ,80 ,60 ,31 ,16 ,19 ,17 ,28 ,56 ,84 ,93 ,87 ,83 ,82 ,81 ,81 ,80 ,79 ,77 ,75 ,73 ,70 ,68 ,65 ,62 ,59 ,57 ,56 ,55 ,56 ,57 ,59 ,62 ,64 ,67 ,70 ,73 ,76 ,77 ,78 ,78 ,79 ,79}
	local plethData = {88 ,88 ,89 ,90 ,90 ,91 ,92 ,92 ,93 ,93 ,94 ,94 ,95 ,96 ,97 ,98 ,99 ,99 ,100 ,100 ,101 ,101 ,101 ,101 ,101 ,100 ,100 ,99 ,98 ,96 ,94 ,92 ,90 ,86 ,82 ,78 ,72 ,66 ,61 ,55 ,50 ,45 ,40 ,36 ,32 ,31 ,30 ,31 ,33 ,36 ,40 ,44 ,48 ,52 ,57 ,62 ,67 ,71 ,74 ,77 ,80 ,81 ,82 ,82 ,82 ,81 ,80 ,79 ,78 ,77 ,76 ,75 ,75 ,75 ,76 ,76 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,96 ,97 ,97 ,98 ,98 ,98 ,98 ,98 ,97 ,97 ,96 ,95 ,94 ,93 ,91 ,89 ,86 ,82 ,78 ,74 ,69 ,63 ,57 ,51 ,46 ,41 ,36 ,33 ,30 ,28 ,28 ,29 ,31 ,34 ,38 ,42 ,46 ,51 ,56 ,60 ,65 ,69 ,73 ,76 ,78 ,79 ,80 ,80 ,80 ,79 ,78 ,77 ,76 ,75 ,74 ,74 ,73 ,73 ,74 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,86 ,87 ,89 ,90 ,91 ,92 ,93 ,94 ,95 ,95 ,96 ,96 ,96 ,95 ,95 ,95 ,95 ,94 ,94 ,93 ,92 ,91 ,89 ,87 ,84 ,80 ,76 ,72 ,66 ,60 ,54 ,49 ,43 ,38 ,33 ,30 ,27 ,25 ,25 ,26 ,28 ,30 ,34 ,38 ,42 ,47 ,51 ,56 ,61 ,66 ,69 ,72 ,74 ,75 ,76 ,77 ,76 ,76 ,75 ,74 ,73 ,72 ,71 ,70 ,70 ,70 ,71 ,71 ,72 ,73 ,74 ,75 ,77 ,78 ,80 ,81 ,83 ,84 ,85 ,86 ,88 ,89 ,89 ,90 ,91 ,91 ,92 ,92 ,92 ,92 ,92 ,92 ,92 ,91 ,90 ,89 ,87 ,85 ,83 ,80 ,76 ,72 ,67 ,61 ,55 ,49 ,43 ,37 ,32 ,28 ,24 ,21 ,19 ,19 ,20 ,22 ,25 ,29 ,33 ,37 ,42 ,47 ,52 ,57 ,62 ,66 ,69 ,71 ,73 ,74 ,74 ,74 ,73 ,72 ,71 ,70 ,69 ,69 ,68 ,68 ,69 ,70 ,71 ,72 ,73 ,75 ,76 ,78 ,80 ,81 ,82 ,83 ,84 ,85 ,85 ,86 ,86 ,87 ,87 ,87 ,87 ,87}
	local n = 0
	local i = 0
	local nn = 0
	local v
	local rand = 0
	local ecgPoints = ""
	local ecgPointsBig = ""
	local oxiPoints = ""
	
	--print("Plotting")
	
	-- scale data 
	n = table.getn(ecgData)
	for i = 1, n, 1 do
		ecgData[i] = (ecgData[i] * g_scale_bpm) 
		plethData[i] = (plethData[i] * g_scale_rpm)
	end
	


	for i = 1, n/2, 1 do
		--if (i > n/4 and 0 == (math.fmod(i,10))) then
		--	rand = math.random(-6, 9)
		--end
		ecgSmall[i] = ecgData[i*2] -- rand
		plethSmall[i] = plethData[i*2]
	end

	
	n = table.getn(ecgSmall)
	for i = 1, n, 1 do
		oxiPoints = oxiPoints.." "..string.format("%.0f",i*3)..":"..string.format("%.0f", plethSmall[i]*1.5)
		ecgPoints = ecgPoints.." "..string.format("%.0f",i*3)..":"..string.format("%.0f", ecgSmall[i]*1.5)
	end
	
	data["ecg_points"] = ecgPoints
	data["oxi_points"] = oxiPoints
	

	gre.set_data(data)
end