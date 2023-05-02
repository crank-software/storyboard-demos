local VIDEOS_ROOT = gre.APP_ROOT .. "/videos/"

local timer = 7
local timerID = nil
local mode = "watts"

function CBSetModeTimer()
  timerID = gre.timer_set_interval(CBTick,1000)
end


function CBTick(mapargs)
  if (timer>0) then
    timer = timer - 1
  else
    CBChangeMode()
  end
end

function CBChangeMode(mapargs)
   gre.timer_clear_timeout(timerID)
   CBSetMode()
end

function CBSetMode()
  if mode == "watts" then
    gre.animation_trigger("mode_watts_hide")
    CBNavigation()
  elseif mode == "navigation" then
    gre.animation_trigger("mode_navigation_hide")
    gre.animation_trigger("turn_by_turn_hide")
    gre.animation_trigger("bearing_hide")
    CBMusic()
  elseif mode == "music" then
    gre.animation_trigger("mode_music_hide")
    CBWatts()
  end

  CBReset()

end

function CBReset()
  CBSetModeTimer()
end

function CBNavigation()
  timer = 12
  gre.animation_trigger("mode_navigation_show")
  gre.animation_trigger("bearing_show")
  gre.animation_trigger("turn_by_turn_show")
    
  mode = "navigation"
end

function CBMusic()
  timer = 7
  gre.animation_trigger("mode_music_show")

  mode = "music"
end

function CBWatts()
  timer = 10
  gre.animation_trigger("mode_watts_show")
  gre.animation_trigger("trend_line") -- placeholder
  mode = "watts"
end


--//------ test function to trigger video setting framerate

--function trigger_div()
--  gre.set_value("map_graph.circle_transition.num",30)
--end

function startup(mapargs)  -- using video media complete events as trigger events 

  local video = string.gsub(mapargs.context_event_data.name, VIDEOS_ROOT, "")

for k,v in pairs (mapargs.context_event_data) do 
  end


  if video == "circle_transition.gif" then
    show_watts()
  elseif video == "startup_iv3.mpeg" then
    fade_startup()
  end

end

function fade_startup()
  gre.animation_trigger("fade_startup")
  gre.animation_trigger("speedometer_arc")
  gre.animation_trigger("speed_line")
end

function show_watts()
  gre.set_value("watt_hours.grd_hidden",off)
  gre.animation_trigger("show_watt_hours")
  gre.animation_trigger("trend_line")
end


local RANGE_SPEED = 180 -- 180mph on gauge
local RANGE_DEGREE = 220 -- degrees from -200º to +20º
local MULTIPLIER = RANGE_SPEED/RANGE_DEGREE
local OFFSET_DEGREE = 200
local OFFSET_ARC_LEADER = 89 


function CBUpdateSpeed(mapargs) 
  local data = {}
  data = gre.get_data("speedometer.glow.endAngle")

  local val = data["speedometer.glow.endAngle"] + OFFSET_DEGREE
  local val_leader = data["speedometer.glow.endAngle"] + OFFSET_ARC_LEADER
  local speed_value = val*MULTIPLIER


  
  gre.set_data({["speedometer.speed_readout.text"] = tostring(string.format("%d", speed_value))})
  gre.set_data({["speedometer.arc_leader.angle"] = val_leader}) -- maintain a feathered edge on arc with image "speedometer.arc_leader"
end
