require "media_tables"

media_controls_play = 0

function media_controls_play_toggle(mapargs) 
  local data = {}
  local dk_data
  
  if(media_controls_play == 0)then
    data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_pause.png"
    media_controls_play = 1
    
    media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
    
  else
    data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_play.png"
    media_controls_play = 0
    
    dk_data = gre.timer_clear_timeout(media_elapsed_time_timer)
    
  end
  
  gre.set_data(data)
  
end

function media_controls_stop(mapargs)
  
  local dk_data
  local data = {}
  
  media_controls_play = 0
  dk_data = gre.timer_clear_timeout(media_elapsed_time_timer)
  media_elapsed_time = 0

  data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
  data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_play.png"
  gre.set_data(data)
end

function media_controls_next(mapargs)

  media_controls_stop()
  local data = {}
  
  data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_pause.png"
  
  if(media_active_medium == 1)then
    
    local max = table.maxn(cd_list)
    
    local i = cd_active_song + 1
    
    if(i > max)then
      i = 1
    end
    
    local time = cd_list[i].len
    local min = math.floor(time / 60)
    local sec = time - (min * 60)
    
    data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
    data["media_main_layer.media_main_std_text.text"] = cd_list[i].name
    data["media_main_layer.media_main_std_text.time"] = min..":"..sec
    
    data["media_main_layer.media_main_song_data.album"] = cd_list[i].album
    data["media_main_layer.media_main_song_data.artist"] = cd_list[i].artist
    data["media_main_layer.media_main_song_data.date"] = cd_list[i].date 
    
    gre.set_data(data)
    
    cd_active_song = i
    
    media_controls_play = 1
    media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
    media_active_tracktime = cd_list[i].len
    media_elapsed_time = 0  
    
  elseif(media_active_medium == 2)then
    
    local data = {}
    
    if(radio_fm_active == 1)then
      radio_tuning_fm = radio_tuning_fm + 0.1
      if(radio_tuning_fm > 111.1)then
        radio_tuning_fm = 87.8
      end
      
      if(string.len(radio_tuning_fm) < 4)then
        radio_tuning_fm = radio_tuning_fm..".0"
      end
      
      data["media_main_layer.media_main_radio_text.text"] = radio_tuning_fm
    else
      radio_tuning_am = radio_tuning_am + 10
      if(radio_tuning_am > 1600)then
        radio_tuning_am = 560
      end
      
      data["media_main_layer.media_main_radio_text.text"] = radio_tuning_am
    end
    gre.set_data(data)
    
  else
    
    local max = table.maxn(song_list)
    
    local i = math.random(1, max)
    
    local time = song_list[i].len
    local min = math.floor(time / 60)
    local sec = time - (min * 60)
    
    data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
    data["media_main_layer.media_main_std_text.text"] = song_list[i].name
    data["media_main_layer.media_main_std_text.time"] = min..":"..sec
    
    data["media_main_layer.media_main_song_data.album"] = song_list[i].album
    data["media_main_layer.media_main_song_data.artist"] = song_list[i].artist
    data["media_main_layer.media_main_song_data.date"] = song_list[i].date
    data["media_main_layer.media_main_song_data.image"] = song_list[i].image
    
    gre.set_data(data)
    
    media_controls_play = 1
    media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
    media_active_tracktime = song_list[i].len
    media_elapsed_time = 0  
  end
  
end

function media_controls_prev(mapargs)

  media_controls_stop()
  local data = {}
  data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_pause.png"
  
  if(media_active_medium == 1)then
    
    local max = table.maxn(cd_list)
    
    local i = cd_active_song - 1
    
    if(i < 1)then
      i = max
    end
    
    local time = cd_list[i].len
    local min = math.floor(time / 60)
    local sec = time - (min * 60)
    
    data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
    data["media_main_layer.media_main_std_text.text"] = cd_list[i].name
    data["media_main_layer.media_main_std_text.time"] = min..":"..sec
    
    data["media_main_layer.media_main_song_data.album"] = cd_list[i].album
    data["media_main_layer.media_main_song_data.artist"] = cd_list[i].artist
    data["media_main_layer.media_main_song_data.date"] = cd_list[i].date
    
    gre.set_data(data)
    
    cd_active_song = i
    
    media_controls_play = 1
    media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
    media_active_tracktime = cd_list[i].len
    media_elapsed_time = 0  
    
  elseif(media_active_medium == 2)then  
    local data = {}
    
    if(radio_fm_active == 1)then
      radio_tuning_fm = radio_tuning_fm - 0.1
      if(radio_tuning_fm < 87.8)then
        radio_tuning_fm = 111.1
      end
      
      if(string.len(radio_tuning_fm) < 4)then
        radio_tuning_fm = radio_tuning_fm..".0"
      end
      
      data["media_main_layer.media_main_radio_text.text"] = radio_tuning_fm
    else
      radio_tuning_am = radio_tuning_am - 10
      if(radio_tuning_am < 560)then
        radio_tuning_am = 1600
      end
      
      data["media_main_layer.media_main_radio_text.text"] = radio_tuning_am    
    end
    
    gre.set_data(data)
  else
    
    local max = table.maxn(song_list)
    
    local i = math.random(1, max)
    
    local time = song_list[i].len
    local min = math.floor(time / 60)
    local sec = time - (min * 60)
    
    data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
    data["media_main_layer.media_main_std_text.text"] = song_list[i].name
    data["media_main_layer.media_main_std_text.time"] = min..":"..sec
    
    data["media_main_layer.media_main_song_data.album"] = song_list[i].album
    data["media_main_layer.media_main_song_data.artist"] = song_list[i].artist
    data["media_main_layer.media_main_song_data.date"] = song_list[i].date
    data["media_main_layer.media_main_song_data.image"] = song_list[i].image
    
    gre.set_data(data)
    
    media_controls_play = 1
    media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
    media_active_tracktime = song_list[i].len
    media_elapsed_time = 0  
  end
  
end