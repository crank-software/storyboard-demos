local song_duration
local song_progress = 0
local idval = nil
local song_index 
local song_play_pause = 1
local arc_start_angle = -157
local DEFAULT_VOLUME_BTN_POSITION = 258
local volume_btn_slider_position
local volume_percent = 0.17
local track_pressed = false
local loop_status = false

function cb_song_selection(mapargs)
  if (idval ~= nil) then
    clear_progress_timer()
  end
  song_index = mapargs.context_row
  
  setup_song_info()
  play_song()
end

function setup_song_info()
  local music_list = get_music_list()
  song_duration = music_list[song_index].duration
  song_progress = 0
  
  local data = {}
  data["music_layer.progress_bar.endAngle"] = arc_start_angle 
  data["music_layer.song_artwork_control.text"] = music_list[song_index].title
  data["music_layer.song_artwork_control.image"] = music_list[song_index].art
  data["music_layer.duration_control.song_progress_mss"] = milliseconds_to_mss(song_progress)
  data["music_layer.duration_control.song_duration_mss"] = milliseconds_to_mss(song_duration)
  gre.set_data(data)
  
  update_volume_arc(volume_percent)
  update_heart_icon()
end

function cb_play_music(mapargs)
  play_song()
end

function cb_pause_music(mapargs)
  pause_song()
end

function play_song()
  song_play_pause = 1
  local data = {} 
  data["now_playing.song_duration"] = song_duration
  data["playing_layer.btn_pause.grd_hidden"] = 0
  data["playing_layer.btn_play.grd_hidden"] = 1
  gre.set_data(data)
  gre.animation_trigger('song_progress')
  idval = gre.timer_set_interval(update_song_progress, 1000)
end

function pause_song()
  local data = {}
  data["playing_layer.btn_pause.grd_hidden"] = 1
  data["playing_layer.btn_play.grd_hidden"] = 0
  gre.set_data(data)
  gre.animation_pause('song_progress')
  clear_progress_timer()
end

function update_song_progress()
  local data = {}
  song_progress = song_progress + 1000

  if (song_progress >= song_duration) then
    if (loop_status == true) then
      clear_progress_timer()
      setup_song_info()
      play_song()
    else
      -- song is over, play next one
      play_next_song()
    end
  else    
    data["music_layer.duration_control.song_progress_mss"] = milliseconds_to_mss(song_progress)
  end
  
  
  gre.set_data(data)
end

function clear_progress_timer()
  gre.timer_clear_interval(idval)
end

function cb_next()
  play_next_song()
end

function cb_previous()
  play_previous_song()
end

function play_next_song()
  if (song_index == get_music_list_size()) then
    song_index = 1
  else
    song_index = song_index + 1
  end
  clear_progress_timer()
  setup_song_info()
  play_song()
end

function play_previous_song()
  if (song_index == 1) then
    song_index = get_music_list_size()
  else
    song_index = song_index - 1
  end
  clear_progress_timer()
  setup_song_info()
  play_song()
end

function cb_volume_press(mapargs)
  -- show the volume slider control
  if (gre.get_value("volume_layer.volume_overlay.grd_hidden") == 1) then
    show_volume_slider()
  end
end


function cb_volume_overlay_press(mapargs)
  hide_volume_slider()
  track_pressed = false
end

function cb_volume_track_press(mapargs)
  update_volume_btn_pos(mapargs)
  track_pressed = true
end

function cb_volume_track_motion(mapargs)
  if (track_pressed) then
    update_volume_btn_pos(mapargs)
  end
end

function cb_volume_track_release(mapargs)
  track_pressed = false
end

function cb_volume_track_outbound(mapargs)
  track_pressed = false
end

function update_volume_btn_pos(mapargs)
  local dk_data = gre.get_data("volume_layer.volume_track_control.grd_y", "volume_layer.volume_track_control.grd_height", "volume_layer.btn_volume_control.grd_height")
  local press_y = mapargs.context_event_data.y
  local track_y = dk_data["volume_layer.volume_track_control.grd_y"]
  local track_height = dk_data["volume_layer.volume_track_control.grd_height"]
  local new_y = press_y - track_y
  volume_percent = 1 - new_y / track_height
  local volume_btn_height = dk_data["volume_layer.btn_volume_control.grd_height"]
  
  volume_btn_slider_position = press_y - (volume_btn_height / 2)
  
  local data = {}
  data["volume_layer.btn_volume_control.grd_y"] = volume_btn_slider_position
  gre.set_data(data)  
  
  update_volume_arc(volume_percent)
end

function show_volume_slider()
  local data = {}
  data["volume_layer.volume_overlay.grd_hidden"] = 0
  data["volume_layer.volume_track_control.grd_hidden"] = 0
  data["volume_layer.btn_volume_control.grd_y"] = volume_btn_slider_position
  gre.set_data(data)
  gre.send_event('disable_screen_drag')
end

function hide_volume_slider()
  local data = {}
  data["volume_layer.volume_overlay.grd_hidden"] = 1
  data["volume_layer.volume_track_control.grd_hidden"] = 1
  data["volume_layer.btn_volume_control.grd_y"] = DEFAULT_VOLUME_BTN_POSITION
  gre.set_data(data)
  gre.send_event('enable_screen_drag')
end

function cb_now_playing_screenhide(mapargs)
  hide_volume_slider()
end

function cb_heart_icn_press(mapargs)
  toggle_liked_status(song_index)
  update_heart_icon()
end

function update_heart_icon()
  local liked_status = get_liked_status(song_index)
  
  if (liked_status == true) then
    gre.set_value("music_layer.icn_heart_btn.image", "images/icn_heart_music_down.png")
  else
    gre.set_value("music_layer.icn_heart_btn.image", "images/icn_heart_music.png")    
  end  
end

function cb_loop_icn_press(mapargs)
  toggle_loop_status()
end


function toggle_loop_status()
  if (loop_status == true) then
    loop_status = false
    gre.set_value("music_layer.icn_loop_btn.image", "images/icn_loop_music.png")
  else
    loop_status = true
    gre.set_value("music_layer.icn_loop_btn.image", "images/icn_loop_music_down.png")
  end
end

function update_volume_arc(percentage)
  local angle
  angle = 360 * percentage
  angle = math.fmod(angle, 360)

  local data ={}
  data["volume_layer.btn_volume_control.endAngle"] = angle
  gre.set_data(data)
end