local transition_screen_info = {
  digital_clock_screen = {
    layer = "digital_clock_layer",
    beside_screen = "analog_clock_screen",
    beside_layer = "analog_clock_layer"
  },
  analog_clock_screen = {
    layer = "analog_clock_layer",
    beside_screen = "digital_clock_screen",
    beside_layer = "digital_clock_layer"
  },
  music_player_screen = {
    layer = "music_player_layer",
    beside_screen = "volume_screen",
    beside_layer = "volume_layer"
  },
  volume_screen = {
    layer = "volume_layer",
    beside_screen = "music_player_screen",
    beside_layer = "music_player_layer"
  },
  running_screen = {
    layer = "running_layer",
    beside_screen = "step_tracker_screen",
    beside_layer = "step_tracker_layer"
  },
  step_tracker_screen = {
    layer = "step_tracker_layer",
    beside_screen = "running_screen",
    beside_layer = "running_layer"
  }
}
local screen_size = 392
local to_screen

local function transition_to_screen()
  gre.set_value("to_screen", to_screen)
  gre.send_event("go_to_screen")
end

local function screen_path_transition(layer, to_layer, direction)
  local path_animation = gre.animation_create(30,1,transition_to_screen)
  local key_var = direction == "down" and "grd_y" or "grd_x"
  
  -- Step 1, old layer moving out
  local step = {}
  
  step["rate"] = "easeinout"
  step["duration"] = 250
  step["delta"] = direction == "left" and -1 * screen_size or screen_size
  step["key"] = string.format("%s.%s", layer, key_var)
  
  gre.animation_add_step(path_animation,step)
  
  -- Step 2, new layer moving in
  step["key"] = string.format("%s.%s", to_layer, key_var)
  
  gre.animation_add_step(path_animation,step)
  
  gre.animation_trigger(path_animation)
end

function cb_set_up_screen_transition(mapargs) 
  local screen = mapargs.context_screen
  local screen_info = transition_screen_info[screen]
  local data = {}
  
  for _,v in pairs(transition_screen_info) do 
    data[string.format("transition_screen.%s.grd_hidden", v.layer)] = 1
  end
  
  data[string.format("transition_screen.%s.grd_hidden", screen_info.layer)] = 0
  data[string.format("transition_screen.%s.grd_y", screen_info.layer)] = 0
  data[string.format("transition_screen.%s.grd_x", screen_info.layer)] = 0
  data["transition_screen.menu_layer.grd_y"] = -1 * screen_size
  
  gre.set_data(data)
end

function cb_side_screen_transition(mapargs) 
  local screen = mapargs.context_screen
  local screen_info = transition_screen_info[screen]
  local direction = string.gsub(mapargs.context_event,"gre.gesture.","")
  local to_layer = string.format("transition_screen.%s", screen_info.beside_layer)
  to_screen = screen_info.beside_screen
  
  local data = {}
  data[to_layer .. ".grd_x"] = direction == "left" and screen_size or -1 * screen_size
  data[to_layer .. ".grd_hidden"] = 0
  gre.set_data(data)
  
  gre.set_value("to_screen", "transition_screen")
  gre.send_event("go_to_screen")
  screen_path_transition(string.format("transition_screen.%s", screen_info.layer), to_layer, direction)
end

function cb_menu_screen_transition(mapargs) 
  local screen = mapargs.context_screen
  local screen_info = transition_screen_info[screen]
  local to_layer = "transition_screen.menu_layer"
  to_screen = "menu_screen"
  
  local data = {}
  data[to_layer .. ".grd_y"] = -1 * screen_size
  data[to_layer .. ".grd_hidden"] = 0
  gre.set_data(data)
  
  gre.set_value("to_screen", "transition_screen")
  gre.send_event("go_to_screen")
  screen_path_transition(string.format("transition_screen.%s", screen_info.layer), to_layer, "down")
end
