-- --------------------------------------------------------------------------------------
-- --------------------CROSS SCREEN NAVIGATION SCRIPTS ----------------------------------
-- --------------------------------------------------------------------------------------
--everything until the end of this block has to do with the the cross screen navigation and controls



local open_timer = {} 
local pos = {} 

local navi_open = nil
local navi_open_animation_complete = nil
                  
function open_navi_timer() --this is the press function that is working and stuff
  navi_open = 0 

  local dk_data = {}
  dk_data["hidden"] = 0
  gre.set_control_attrs("top_navi_bg", dk_data)  
  
  
  open_timer = gre.timer_set_timeout(open_navi, 110)  
end

function open_navi(mapargs)
  
  navi_open = 1
  navi_open_animation_complete = 0
  
  gre.animation_trigger("app_navigation_open")   
  
end

function home_release()
  
  if(navi_open == 0)then
    gre.animation_trigger("app_navigation_close")    
    gre.send_event("app_to_home")
    
    local data
    data = gre.timer_clear_timeout(open_timer)

    local control_data = {}
    control_data["hidden"] = 1
    gre.set_control_attrs("top_navi_bg", control_data)
     
  elseif(navi_open == 1)then
    gre.animation_trigger("app_navigation_close")
    
    local control_data={}
    control_data["hidden"] = 1
    gre.set_control_attrs("top_navi_bg", control_data)
    
  else
    gre.animation_trigger("app_navigation_close")
  end
  
end

function release(mapargs) --this is getting called twice for some reason
  local screen = mapargs.context_control
  
  if(navi_open_animation_complete == 0)then
  
  else
    print("closed the correct navigation")   
    
    if(screen == "top_navigation_layer.top_navi_vm")then
      gre.send_event("app_to_vm")
      gre.animation_trigger("app_navigation_close")
    elseif(screen == "top_navigation_layer.top_navi_navigation")then
      gre.send_event("app_to_navigation")
      gre.animation_trigger("app_navigation_close")
    elseif(screen == "top_navigation_layer.top_navi_phone")then
      gre.send_event("app_to_phone")
      gre.animation_trigger("app_navigation_close")
    elseif(screen == "top_navigation_layer.top_navi_climate")then
      gre.send_event("app_to_climate")
      gre.animation_trigger("app_navigation_close")      
    elseif(screen == "top_navigation_layer.top_navi_music")then
      gre.send_event("app_to_media")
      gre.animation_trigger("app_navigation_close")
    else
      print("released_nothing")
      navi_overlay_release()
    end
    
  end
  
  

  
  
end

function navi_overlay_release(mapargs) 

  print("animation to hide it again")
  gre.animation_trigger("app_navigation_close")
  
  gre.send_event("app_stop_open_animation")
  
  local data
  data = gre.timer_clear_timeout(open_timer)

    
end

function open_animation_complete(mapargs)
  navi_open_animation_complete = 1
  print("animation_complete")
end

function navi_overlay_hover(mapargs)
  
  local adj = mapargs.context_event_data.x - 400
  local opp = mapargs.context_event_data.y - 26
  local data = {}
  
  local deg = math.deg(math.atan2(opp,adj)) + 180
  
  data["top_navigation_layer.top_navi_pointer.angle"] = deg + 90
  gre.set_data(data)
end