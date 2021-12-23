local TOUCH_THRESHOLD = 20 -- number of pixels to move less then to count as a touch
local FLICK_MS = 1200 --number of ms for scroll flick to last
local DEGRADE_VALUE = 0.95  -- this value is used to degrade speed 
local SPEED_MIN = 1.5  -- stop when speed goes below this number
local NO_DEGRADE = 10 -- number of events to ignore before degrading
local NO_MOTION_TIME = 150 -- num ms to wait for a mtion event before we fake a release event
local FACTOR_MULT = 0.7
local DEBUG = 0

local g_tumbler_list ={}
local g_current_tumbler = nil
local g_last_x = 0


function cb_list_init(mapargs)
	local data = {}
	data = gre.get_data("album.photos.grd_xoffset", "album.albums.grd_xoffset")
	
	local info = {}
	info.list_x = data["album.photos.grd_xoffset"]
	info.last_motion = -1
	info.speed = 0
	g_tumbler_list["album.photos"] = info

	local info = {}
	info.list_x = data["album.albums.grd_xoffset"]
	info.last_motion = -1
	info.speed = 0
	g_tumbler_list["album.albums"] = info
end

function cb_screen_show(mapargs)
	gre.send_event("tumbler_timer_start")
end

function cb_screen_hide(mapargs)
	g_tumbler_list["album.albums"].press = 0	
	g_tumbler_list["album.photos"].press = 0
	g_tumbler_list["album.albums"].last_motion = -1
	g_tumbler_list["album.photos"].last_motion = -1
	gre.send_event("tumbler_timer_stop")
end

-- When the button is pressed then we start recording interesting data
function cb_list_press(mapargs)
	local ev = mapargs["context_event_data"];
	local info = {}
	
	-- Mouse tracking ...
	info.press = 1
	info.pos = tonumber(ev["x"])
	info.start = info.pos
	info.start_time = ev["timestamp"]
	info.last_time = info.start_time
	info.time = info.start_time
	info.release_time = 0
	info.last_pos = info.pos
	info.offset = 0
	info.acceleration = 0
	info.last_motion = -1
	-- Carousel ...
	info.speed = 0
	info.no_degrade = NO_DEGRADE
	
	local data = {} 
	data = gre.get_data(mapargs.context_control..".grd_xoffset")
	info.list_x = data[mapargs.context_control..".grd_xoffset"]

	g_current_tumbler = mapargs.context_control
	
	g_tumbler_list[mapargs.context_control] = info
	
	g_scrolling = 1
end


function update_position(list, offset)
	local data = {}
	
	if list == "album.albums" then
		g_tumbler_list["album.albums"].list_x = math.ceil(g_tumbler_list["album.albums"].list_x + offset)
		g_tumbler_list["album.photos"].list_x = math.ceil(g_tumbler_list["album.photos"].list_x + (offset * 2))
	else
		g_tumbler_list["album.albums"].list_x = math.ceil(g_tumbler_list["album.albums"].list_x + (offset * 0.5))
		g_tumbler_list["album.photos"].list_x = math.ceil(g_tumbler_list["album.photos"].list_x + offset)
	end
	

	if(g_tumbler_list["album.photos"].list_x > -700) then
		g_tumbler_list["album.photos"].list_x = g_tumbler_list["album.photos"].list_x - 1512
	elseif(g_tumbler_list["album.photos"].list_x < -3700) then 
		g_tumbler_list["album.photos"].list_x = g_tumbler_list["album.photos"].list_x + 1512
	end	

	if(g_tumbler_list["album.albums"].list_x > -700) then
		g_tumbler_list["album.albums"].list_x = g_tumbler_list["album.albums"].list_x - 1440
	elseif(g_tumbler_list["album.albums"].list_x < -3700) then 
		g_tumbler_list["album.albums"].list_x = g_tumbler_list["album.albums"].list_x + 1440
	end	
	
	data["album.albums.grd_xoffset"] = g_tumbler_list["album.albums"].list_x
	data["album.photos.grd_xoffset"] = g_tumbler_list["album.photos"].list_x	
	gre.set_data(data)
end

-- When we drag, we reset the amount we are going to move based on the
-- position delta between the motion events.  The bigger the delta the
-- faster we should be scrolling the list.
function cb_list_motion(mapargs)
	local ev = mapargs["context_event_data"];

	if g_current_tumbler == nil or g_tumbler_list[g_current_tumbler].press ~= 1 then
		return
	end
	
	g_tumbler_list[g_current_tumbler].last_motion = gre.mstime()

	if (g_last_x ~= ev["x"]) then
		g_last_x = ev["x"]
		
		-- Mouse tracking ...
		g_tumbler_list[g_current_tumbler].last_time = g_tumbler_list[g_current_tumbler].time 
		g_tumbler_list[g_current_tumbler].time = ev["timestamp"]
		g_tumbler_list[g_current_tumbler].last_pos = g_tumbler_list[g_current_tumbler].pos;
		g_tumbler_list[g_current_tumbler].pos = tonumber(ev["x"])
		g_tumbler_list[g_current_tumbler].offset = g_tumbler_list[g_current_tumbler].last_pos - g_tumbler_list[g_current_tumbler].pos
		g_tumbler_list[g_current_tumbler].acceleration = g_tumbler_list[g_current_tumbler].offset		-- Adjust by some time factor if desired
		
		-- Carousel ...
		local delta = g_tumbler_list[g_current_tumbler].time - g_tumbler_list[g_current_tumbler].last_time
		local factor = 0.1
		if	delta ~= 0 then
			factor = 16 / delta
		end
		
		local speed = 0
		speed = -1 * g_tumbler_list[g_current_tumbler].acceleration * (factor * FACTOR_MULT)

		g_tumbler_list[g_current_tumbler].speed = speed
		
		if DEBUG ==1 then
			print("MOTION EVENT   x = "..ev["x"].."  TS = "..ev["timestamp"].." O = "..g_tumbler_list[g_current_tumbler].offset.." S = "..g_tumbler_list[g_current_tumbler].speed)
		end
		
		update_position(g_current_tumbler, -1 * g_tumbler_list[g_current_tumbler].offset)
	end
end

--
-- Stop list from scrolling
--
function scrolling_fini()
		-- turn off the timer
		--gre.send_event("tumbler_timer_stop")
		g_current_tumbler = nil
		g_scrolling = 0
		--speed_count = 0
end

--
-- Called when user releases finger from list
--
function cb_list_release(mapargs)
	local ev = mapargs["context_event_data"]

	if g_current_tumbler == nil or g_tumbler_list[g_current_tumbler].press ~= 1 then
		return
	end	
	
	if DEBUG ==1 then
		print("REAL RELEASE")
	end	
	
	g_tumbler_list[g_current_tumbler].release_time = gre.mstime()
	g_tumbler_list[g_current_tumbler].last_motion = -1

	-- if since release there has been movement of lease than 10 pixels count it as a touch
	if math.abs(g_tumbler_list[g_current_tumbler].start - ev["x"]) < TOUCH_THRESHOLD then
		scrolling_fini() 
		gre.send_event_target("cell_touch", mapargs.context_control)
	end 
	
	-- Mouse tracking ...
	if g_current_tumbler ~= nil then
		g_tumbler_list[g_current_tumbler].press = 0	
	end
end

function release_fake()
	if DEBUG ==1 then
		print("FAKE RELEASE")
	end
	g_tumbler_list[g_current_tumbler].release_time = gre.mstime()
	g_tumbler_list[g_current_tumbler].press = 0	
	g_tumbler_list[g_current_tumbler].last_motion = -1
end

-- The timer is what performs the movement of the list.
-- It may be that the list is moved in response to the mouse being held down
-- or it may be that the movement is due to the deceleration that happens after
-- the mouse hase been released.
local speed_count = 0
function cb_list_timer(mapargs)	

	if g_current_tumbler == nil then
		g_current_tumbler = "album.photos"
	end
	
	-- if statement to deal with no release event case
	if g_tumbler_list[g_current_tumbler].last_motion ~= -1 then
		local motion_delta = gre.mstime() - g_tumbler_list[g_current_tumbler].last_motion
		-- if there hasn't been a motion event then fake a release
		if motion_delta > NO_MOTION_TIME then
			release_fake()
		end
	end
	
	if g_tumbler_list[g_current_tumbler].press == 1 then
		return
	end	
	
	-- only start degrading the sppend at a so many event
	if g_tumbler_list[g_current_tumbler].press == 0 then
		if g_tumbler_list[g_current_tumbler].no_degrade <= 0 then
			g_tumbler_list[g_current_tumbler].speed = g_tumbler_list[g_current_tumbler].speed * DEGRADE_VALUE
		else
			g_tumbler_list[g_current_tumbler].no_degrade = g_tumbler_list[g_current_tumbler].no_degrade - 1
		end	
	end
	
	
	if DEBUG == 1 then
		speed_count = speed_count + 1
		print("SPEED2 "..speed_count.." = "..g_tumbler_list[g_current_tumbler].speed)
	end
		
		
	-- Once we reach the MIN just leave it there so the list is always in motion
	if(g_tumbler_list[g_current_tumbler].speed >= 0 and g_tumbler_list[g_current_tumbler].speed < SPEED_MIN) or  (g_tumbler_list[g_current_tumbler].speed < 0 and g_tumbler_list[g_current_tumbler].speed > -(SPEED_MIN)) then
		g_tumbler_list[g_current_tumbler].speed = SPEED_MIN
	end

	-- Update positions
	update_position(g_current_tumbler, g_tumbler_list[g_current_tumbler].speed)
end
