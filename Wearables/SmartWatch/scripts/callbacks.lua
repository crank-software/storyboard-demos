require("menu_list_content")
local time = require "date_time"

-- Source the content 
local function build_content(mapargs)
  local tableName = mapargs.context_control

  local data = {}
  if (tableName == CURVED_MENU_CONTROLS.MAIN_MENU) then
    for r=1,#SCREEN_MENU_CONTENT do 
      local item = SCREEN_MENU_CONTENT[r]
      data[string.format("%s.text.%d.1", tableName, r)] = item.label
      data[string.format("%s.image.%d.1", tableName, r)] = "images/" .. item.image
    end
    gre.set_data(data)
    
    local attrs = {}
    attrs.rows = #SCREEN_MENU_CONTENT
    gre.set_table_attrs(tableName, attrs)
  elseif (tableName == CURVED_MENU_CONTROLS.SONG_MENU) then
    local music_list = get_music_list()
    for r=1,#music_list do 
      local item = music_list[r]
      data[string.format("%s.text.%d.1", tableName, r)] = string.format('%s', item.title)
      data[string.format("%s.num.%d.1", tableName, r)] = string.format('%d.', r)  
    end
    gre.set_data(data)
    
    local attrs = {}
    attrs.rows = #music_list
    gre.set_table_attrs(tableName, attrs)
    
  end
  
end

--- @param gre#context mapargs
function cb_init(mapargs)
  time.init()
end


function cb_screen_menu_touch(mapargs)
  local data = {}
  local screen = gre.get_value(string.format('%s.screen.%d.1', mapargs.context_control, mapargs.context_row))
  local highlight_height = gre.get_value("main_menu_layer.select_highlight.grd_height")
  local dk_data = gre.get_table_cell_attrs(mapargs.context_control, mapargs.context_row, 1, 'x', 'y', 'height')
  data["main_menu_layer.select_highlight.grd_y"] = dk_data['y'] + ((dk_data['height'] / 2) - (highlight_height / 2))
  data["main_menu_layer.select_highlight.grd_x"] = dk_data['x']
  data['screen_target'] = screen
  gre.set_data(data)
  
  gre.animation_trigger('screen_menu_select')
end

function cb_screen_menu_motion(mapargs)
  gre.set_value("main_menu_layer.select_highlight.alpha", 0)
end

function cb_menu_screen_selected()  
  gre.send_event('screen_navigate')
end

function cb_setup_song_list(mapargs)
  local control_context = {context_control = CURVED_MENU_CONTROLS.SONG_MENU}
  build_content(control_context)
  cb_sync_position(control_context)
end

local fitness_selection_anim
function fitness_method_selection(mapargs)
  local context_control = mapargs.context_control
  
  -- set the correct labels and image based on the exercise selected
  local exercise_data = {}
  exercise_data["start_workout_overlay.btn_start_workout_control.image"] = mapargs.selected_image
  exercise_data["workout_details.btn_start_workout_control.image"] = mapargs.selected_image
  exercise_data["fitness.start_workout_overlay.grd_hidden"] = 0  
  gre.set_data(exercise_data)
  
  update_workout_labels(mapargs.selected_exercise)
  
  local data = {}
  fitness_selection_anim = gre.animation_create(60, 1, fitness_selection_anim_complete)
  
  for i = 1, #FITNESS_MENU_CONTROLS do
    if (FITNESS_MENU_CONTROLS[i] ~= context_control) then
      data["rate"] = "easeout"
      data["duration"] = 1000
      data["to"] = 392 + math.abs(gre.get_value("fitness.fitness1.grd_yoffset"))
      data["key"] = string.format("%s.grd_y", FITNESS_MENU_CONTROLS[i])
      gre.animation_add_step(fitness_selection_anim, data)
      gre.set_value(string.format("%s.grd_zindex", FITNESS_MENU_CONTROLS[i]), math.abs(i - 1))
    end
  end
  
  gre.set_value(string.format("%s.grd_zindex", context_control), #FITNESS_MENU_CONTROLS - 1)
  
  data["rate"] = "easeout"
  data["duration"] = 1000
  data["to"] = 76
  data["key"] = string.format("%s.grd_x", context_control)
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "easeout"
  data["duration"] = 1000
  data["to"] = 254 + math.abs(gre.get_value("fitness.fitness1.grd_yoffset"))
  data["key"] = string.format("%s.grd_y", context_control)
  gre.animation_add_step(fitness_selection_anim, data)

  data["rate"] = "easeout"
  data["duration"] = 1000
  data["to"] = 79
  data["key"] = string.format("%s.grd_height", context_control)
  gre.animation_add_step(fitness_selection_anim, data)

  data["rate"] = "easeout"
  data["duration"] = 1000
  data["to"] = 238
  data["key"] = string.format("%s.grd_width", context_control)
  gre.animation_add_step(fitness_selection_anim, data)

  data["rate"] = "easeout"
  data["duration"] = 1000
  data["from"] = 0
  data["to"] = 255
  data["key"] = string.format("%s.green_alpha", context_control)
  gre.animation_add_step(fitness_selection_anim, data)
  
  
  -- start workout overlay  
  data["rate"] = "easeout"
  data["duration"] = 750
  data["from"] = gre.get_value(string.format("%s.icn_x", context_control))
  data["to"] = 39
  data["key"] = string.format("%s.icn_x", context_control)
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "easein"
  data["duration"] = 750
  data["offset"] = 250
  data["from"] = 0
  data["to"] = 255
  data["key"] = "start_workout_overlay.btn_start_workout_control.alpha"
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "easein"
  data["duration"] = 750
  data["offset"] = 250
  data["from"] = 255
  data["to"] = 0
  data["key"] = string.format("%s.alpha", context_control)
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "easeout"
  data["duration"] = 400
  data["offset"] = 600
  data["from"] = 62
  data["to"] = 82
  data["key"] = "start_workout_overlay.workout.grd_y"
  gre.animation_add_step(fitness_selection_anim, data)

  data["rate"] = "easeout"
  data["duration"] = 450
  data["offset"] = 550
  data["from"] = 87
  data["to"] = 107
  data["key"] = "start_workout_overlay.exercise.grd_y"
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "easeout"
  data["duration"] = 500
  data["offset"] = 500
  data["from"] = 147
  data["to"] = 167
  data["key"] = "start_workout_overlay.last_run.grd_y"
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "linear"
  data["duration"] = 500
  data["offset"] = 500
  data["from"] = 0
  data["to"] = 255
  data["key"] = "start_workout_overlay.last_run.alpha"
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "linear"
  data["duration"] = 450
  data["offset"] = 550
  data["from"] = 0
  data["to"] = 255
  data["key"] = "start_workout_overlay.exercise.alpha"
  gre.animation_add_step(fitness_selection_anim, data)
  
  data["rate"] = "linear"
  data["duration"] = 400
  data["offset"] = 600
  data["from"] = 0
  data["to"] = 255
  data["key"] = "start_workout_overlay.workout.alpha"
  gre.animation_add_step(fitness_selection_anim, data)
  
  gre.animation_trigger(fitness_selection_anim)
end

function fitness_selection_anim_complete()
  gre.set_value("screen_target", 'start_workout')
  gre.send_event('screen_navigate')
end

function update_workout_labels(exercise)
  exercise = string.lower(exercise)
  local date = "11-14-2020"
  local data = {}
  data["start_workout_overlay.exercise.text"] = EXERCISE_LABEL_LIST[exercise].title  
  data["workout_details.exercise.text"] = EXERCISE_LABEL_LIST[exercise].title
  data["start_workout_overlay.last_run.text"] = string.format('Last %s %s', EXERCISE_LABEL_LIST[exercise].last_label, date)
  data["workout_details.last_run.text"] = string.format('Last %s %s', EXERCISE_LABEL_LIST[exercise].last_label, date)
  gre.set_data(data)
end

local weather_id
function cb_three_day_press(mapargs)
  local highlight_x
  local highlight_width = gre.get_value("weather_3day_layer.day_highlight.grd_width")
  local context_control_x = string.format('%s.grd_x', mapargs.context_control)
  local context_control_width = string.format('%s.grd_width', mapargs.context_control)
  
  local dk_data = gre.get_data(context_control_x, context_control_width)
  
  highlight_x = (dk_data[context_control_x] + (dk_data[context_control_width] / 2)) - (highlight_width / 2)
  gre.set_value("weather_3day_layer.day_highlight.grd_x", highlight_x)

  -- populate the weather screen with data of the selected day's weather
  weather_id = mapargs.weather_id
  setup_weather_details()
end

function cb_weather_screenshow_pre(mapargs)
  if (weather_id == nil) then
    weather_id = 3
  end
  setup_weather_details()
  
  local data = {}
  data["weather1.dots_control.x_white"] = 0
  data["weather1.dots_control.x_grey"] = 21
  gre.set_data(data)
end

function cb_weather_forecast_screenshow_pre(mapargs)
  local data = {}
  data["weather1.dots_control.x_white"] = 21
  data["weather1.dots_control.x_grey"] = 0
  gre.set_data(data)
end

function setup_weather_details()  
  local weather_data = WEATHER_LIST[weather_id]
  local animation_name = ''

  weather_data = WEATHER_LIST[weather_id]
  
  
  local data = {}
  data["weather1.weather_description.text"] = weather_data.type
  data["weather1.temperature_value.text"] = string.format('%dºC', weather_data.temp)
  data["weather1.weather_icn.image"] = string.format('images/%s', weather_data.image)
  data["weather1.weather_icn.angle"] = 0
  data["weather1.weather_icn.x"] = 0
  data["weather1.weather_icn.grd_hidden"] = false
  data["weather1.partly_cloudy.grd_hidden"] = true
  gre.animation_stop('rain_drops_copy')
  gre.animation_stop('sunny_animation')
  gre.animation_stop('partly_cloudy_animation')
  
  if (weather_data.type == 'Sunny') then
    data["weather1.weather_icn.x"] = 13
    animation_name = 'sunny_animation'
    data["weather1.rain_drops.grd_hidden"] = true
    data["weather1.rain_drops_2.grd_hidden"] = true
  elseif (weather_data.type == 'Raining') then
    animation_name = 'rain_drops_copy'
    gre.animation_stop('sunny_animation')
    data["weather1.rain_drops.grd_hidden"] = false
    data["weather1.rain_drops_2.grd_hidden"] = false
  elseif (weather_data.type == 'Partly Cloudy') then
    animation_name = 'partly_cloudy_animation'
    data["weather1.partly_cloudy.grd_hidden"] = false
    data["weather1.rain_drops.grd_hidden"] = true
    data["weather1.rain_drops_2.grd_hidden"] = true
    data["weather1.weather_icn.grd_hidden"] = true
  end
  
  gre.set_data(data)
  gre.animation_trigger(animation_name)
end
