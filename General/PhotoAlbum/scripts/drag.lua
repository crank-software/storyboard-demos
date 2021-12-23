--[[
Copyright 2013, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

require("albums")

local prev_x = 0
local press  = 0;

-- this function is called on motion events
function cb_drag(mapargs)
	local ev_data = mapargs.context_event_data;
	local gdata = {}
	local sdata = {}
	local x_off = "photo.photo_large.grd_x"
	local alpha1 = "photo.photo_next.alpha"
	local alpha2 = "photo.photo_prev.alpha"
	
	if press == 0 then
	 return
	end
	
	gdata = gre.get_data(x_off)
	
	local new_x = gdata[x_off] - (prev_x - ev_data.x)
	prev_x = ev_data.x
  
	if gdata[x_off] == 0 and new_x < 0 then
	   sdata["photo.photo_prev.grd_hidden"] = 1
	   sdata["photo.photo_next.grd_hidden"] = 0
	elseif gdata[x_off] == 0 and new_x > 0 then
	   sdata["photo.photo_prev.grd_hidden"] = 0
	   sdata["photo.photo_next.grd_hidden"] = 1
	end
	
	--set postion to touch co-ord (-34 to make it center on image)
	sdata[x_off] = new_x
	local new_alpha =  math.floor(255 * (math.abs(gdata[x_off]) / 480))
	sdata[alpha1] = new_alpha
	sdata[alpha2] = new_alpha
	
	-- set the control to the new position
	gre.set_data(sdata)
end



-- When a control is pressed on, save the name of the control
function cb_drag_press(mapargs)
  local ev_data = mapargs.context_event_data;
  press = 1
  prev_x = ev_data.x
end

-- When a release happens, clear the saved control name
function cb_drag_release(mapargs)
  local x_off = "photo.photo_large.grd_x"
  
  gdata = gre.get_data(x_off)
  
  if gdata[x_off] <= -120 then  
    gre.animation_trigger("photo_snap_left")
  elseif gdata[x_off] >= 120 then 
    gre.animation_trigger("photo_snap_right")
  else
    gre.animation_trigger("photo_snap_home")
  end
  
  press = 0
end


function cb_snap_right_complete(mapargs) 
  g_current_col = g_current_col - 1
  cb_set_images()
end

function cb_snap_left_complete(mapargs) 
  g_current_col = g_current_col + 1
  cb_set_images()
end
