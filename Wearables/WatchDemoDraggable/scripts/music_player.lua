local song_list = {
  {
    title = "Vienna", 
    artist = "Billy Joel", 
    length = 220000,
  },
  {
    title = "Buddy Holly", 
    artist = "Weezer", 
    length = 159000,
  },
  {
    title = "Respect", 
    artist = "Aretha Franklin", 
    length = 143000,
  },
}

local current_song = 1
local current_time = 0
local playing = false
local song_timer

local function convert_ms_to_min(time)
  local mins = math.floor(time / 60000)
  local secs = (time % 60000) / 1000
  
  return string.format("%s:%02d", mins, secs)
end

function cb_play_pause_pressed()
  playing = not playing
  update_play_pause()
end

function update_play_pause()
  local data = {}
  data["music_player_layer.play_pause.image"] = playing and "images/pause.png" or "images/play.png"
  data["music_playing"] = playing
  gre.set_data(data)
  
  update_song_arc_animation()
  update_song_timer()
end

local function update_current_time()
  current_time = current_time + 1000
  gre.set_value("music_player_layer.current_time_control.text", convert_ms_to_min(current_time))
  if current_time == song_list[current_song].length then
    gre.timer_clear_interval(song_timer)
    song_timer = nil
  end
end

function update_song_timer()
  if playing then
    song_timer = gre.timer_set_interval(update_current_time,1000)
  else
    gre.timer_clear_interval(song_timer)
    song_timer = nil
  end
end

function update_song_arc_animation()
  if playing then
    if current_time == 0 then
      gre.set_value("music_player_layer.song_arc_control.anim_duration", song_list[current_song].length)
      gre.animation_trigger("song_progress_arc")
    else
      gre.animation_resume("song_progress_arc")
    end
  else
    gre.animation_pause("song_progress_arc")
  end
end

function cb_back_song(mapargs) 
  playing = false
  update_play_pause()
  
  if current_time <= 5000 then
    current_song = current_song == 1 and #song_list or current_song - 1
  end
  
  set_current_song()
end

function cb_next_song(mapargs) 
  playing = false
  update_play_pause()
  
  current_song = current_song == #song_list and 1 or current_song + 1
  
  set_current_song()
end

function set_current_song()
  current_time = 0
  
  local data = {}
  data["music_player_layer.song_length_control.text"] = convert_ms_to_min(song_list[current_song].length)
  data["music_player_layer.current_time_control.text"] = "0:00"
  data["music_player_layer.artist_control.text"] = song_list[current_song].artist
  data["music_player_layer.song_title_control.text"] = song_list[current_song].title
  data["music_player_layer.song_arc_control.endAngle"] = 0
  gre.set_data(data)
  
  gre.animation_stop("song_progress_arc")
end
