require "media_tables"

cd_toggle = 0
library_toggle = 0
aux_toggle = 0
radio_toggle = 0

media_elapsed_time_timer = {}
media_elapsed_time = 0

media_active_medium = 0
cd_active_song = 0

radio_tuning_am = 780
radio_tuning_fm = 87.8

radio_fm_active = 1

media_active_tracktime = 0

media_toggle_animation_active = 0
local media_animation_timer = {}

function media_cd_toggle()

  if(cd_toggle == 0)then
  
    if(media_toggle_animation_active == 0)then
       
      media_fill_cd()
      if(library_toggle == 1)then
        gre.animation_trigger("media_library_close")
        library_toggle = 0
      end
      
      gre.animation_trigger("media_cd_open")  
      cd_toggle = 1
      
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
          
    end
    
  else
    if(media_toggle_animation_active == 0)then
      gre.animation_trigger("media_cd_close") 
      cd_toggle = 0
      
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
    end
  end
end

function media_library_toggle()

  if(library_toggle == 0)then
      
    if(media_toggle_animation_active == 0)then
         
      if(cd_toggle == 1)then
        gre.animation_trigger("media_cd_close")
        cd_toggle = 0
      end
      
      if(settings_menu_toggle == 1)then
        gre.animation_trigger("app_settings_close")
        settings_menu_toggle = 0
      end
      
      gre.animation_trigger("media_library_open") 
      library_toggle = 1
      
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
    
    end
    
  else
    if(media_toggle_animation_active == 0)then
      gre.animation_trigger("media_library_close")
      library_toggle = 0
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
    end
  end
end

function media_aux_toggle(mapargs)

  
  if(media_toggle_animation_active == 0)then    
  
    if(cd_toggle == 1)then
      gre.animation_trigger("media_cd_close")
      cd_toggle = 0
    end
    
    if(library_toggle == 1)then
      gre.animation_trigger("media_library_close")
      library_toggle = 0
    end
    
    if(settings_menu_toggle == 1)then
      gre.animation_trigger("app_settings_close")
      settings_menu_toggle = 0
    end
    
    if(aux_toggle == 0)then
      gre.animation_trigger("media_aux_screen")
      media_controls_stop()
      aux_toggle = 1
      radio_toggle = 0
      
      gre.animation_trigger("media_no_song_data") 
      
    end
      
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
  
  end
  
end

function media_radio_toggle(mapargs)
   
  if(media_toggle_animation_active == 0)then
      
    if(cd_toggle == 1)then
      gre.animation_trigger("media_cd_close")
      cd_toggle = 0
    end
    
    if(library_toggle == 1)then
      gre.animation_trigger("media_library_close")
      library_toggle = 0
    end
    
    if(settings_menu_toggle == 1)then
      gre.animation_trigger("app_settings_close")
      settings_menu_toggle = 0
    end
    
    if(radio_toggle == 0)then
      gre.animation_trigger("media_radio_screen")
      aux_toggle = 0
      radio_toggle = 1
      
      media_controls_stop()
      media_active_medium = 2
      
      gre.animation_trigger("media_no_song_data") 
      
    end
      
      media_toggle_animation_active = 1
      media_animation_timer = gre.timer_set_timeout(media_toggle_anim_complete, 400)
  
  end
end

function media_toggle_anim_complete(mapargs)
  media_toggle_animation_active = 0
end

function media_main_toggle(mapargs)
 
  if(cd_toggle == 1)then
    gre.animation_trigger("media_cd_close")
    cd_toggle = 0
  end
  
  if(library_toggle == 1)then
    gre.animation_trigger("media_library_close")
    library_toggle = 0
  end
  
  if(settings_menu_toggle == 1)then
    gre.animation_trigger("app_settings_close")
    settings_menu_toggle = 0
  end
  
  gre.animation_trigger("media_main_screen")
  aux_toggle = 0
  radio_toggle = 0

end

function media_fill_cd(mapargs)
  local data = {}
  local time
  
  for i=1, table.maxn(cd_list) do
    data["media_cd_drawer_layer.cd_drawer_tracklist.name."..i..".1"] = cd_list[i].name
    data["media_cd_drawer_layer.cd_drawer_tracklist.num."..i..".1"] = i
    
    time = cd_list[i].len
    local min = math.floor(time / 60)
    local sec = time - (min * 60)
    
    data["media_cd_drawer_layer.cd_drawer_tracklist.time."..i..".1"] = min..":"..sec
    
  end
  
  gre.set_data(data)
  
  data = {}
  data["rows"] = table.maxn(cd_list) 
  gre.set_table_attrs("media_cd_drawer_layer.cd_drawer_tracklist", data)
end

function media_select_cd(mapargs)
  local data = {}
  local i = mapargs.context_row
  
  local time = cd_list[i].len
  local min = math.floor(time / 60)
  local sec = time - (min * 60)
  
  data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
  data["media_main_layer.media_main_std_text.text"] = cd_list[i].name
  data["media_main_layer.media_main_std_text.time"] = min..":"..sec
  
  data["media_main_layer.media_main_song_data.album"] = cd_list[i].album
  data["media_main_layer.media_main_song_data.artist"] = cd_list[i].artist
  data["media_main_layer.media_main_song_data.date"] = cd_list[i].date
  data["media_main_layer.media_main_song_data.image"] = cd_list[i].image  
  
  
  cd_active_song = i
  media_active_medium = 1
  
  media_cd_toggle()
  media_main_toggle()
  media_controls_stop()
  
  media_controls_play = 1
  media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
  media_active_tracktime = cd_list[i].len
  media_elapsed_time = 0
  
  data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_pause.png"
  gre.animation_trigger("media_show_song_data")
  gre.animation_trigger("media_song_data") 
  gre.set_data(data)
  
  local dk_data = {}
  dk_data["hidden"] = 0
  gre.set_control_attrs("media_main_layer.media_main_std_play", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_std_back", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_std_forward", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_song_data", dk_data) 
  
end

function media_fill_songs(type, filter)
  --TYPE ARE
  --SONG    1
  --MOVIE   2
  --ARTIST  3
  --ALBUM   4
  
  --FILTERS ARE
  --ARTIST
  --ALBUM
  local data = {}
  local time
  local index = 0
  
  local id = filter
  local category = type
  
  -- ---------------------
  --IF CLICKED FROM SONGS
  if(category == 1)then
    for i=1, table.maxn(song_list) do
        
      data["media_library_drawer_layer.library_drawer_listtwo_table.name."..i..".2"] = song_list[i].name
      data["media_library_drawer_layer.library_drawer_listtwo_table.image."..i..".1"] = song_list[i].thumb_image
        
      time = song_list[i].len
      local min = math.floor(time / 60)
      local sec = time - (min * 60)
        
      data["media_library_drawer_layer.library_drawer_listtwo_table.time."..i..".2"] = min..":"..sec
    end
    
    gre.set_data(data)
    
    data = {}
    data["rows"] = table.maxn(song_list) 
    gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", data)

  -- -----------------------
  --IF CLICKED FROM MOVIES
  
  elseif(category == 2)then
    for i=1, table.maxn(movie_list) do
        
      data["media_library_drawer_layer.library_drawer_listtwo_table.name."..i..".2"] = movie_list[i].name
      data["media_library_drawer_layer.library_drawer_listtwo_table.image."..i..".1"] = movie_list[i].image
        
      time = movie_list[i].len
      local min = math.floor(time / 60)
      local sec = time - (min * 60)
        
      data["media_library_drawer_layer.library_drawer_listtwo_table.time."..i..".2"] = min..":"..sec..":00"
    end
    
    gre.set_data(data)
    
    data = {}
    data["rows"] = table.maxn(movie_list) 
    gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", data)

  -- ------------------------
  --IF CLICKED FROM ARTIST
  elseif(category == 3)then
    for i=1, table.maxn(song_list) do
      if(song_list[i].artist == id)then
        
        index = index + 1
        data["media_library_drawer_layer.library_drawer_listtwo_table.name."..index..".2"] = song_list[i].name
        data["media_library_drawer_layer.library_drawer_listtwo_table.image."..index..".1"] = song_list[i].thumb_image
        
        time = song_list[i].len
        local min = math.floor(time / 60)
        local sec = time - (min * 60)
        
        data["media_library_drawer_layer.library_drawer_listtwo_table.time."..index..".2"] = min..":"..sec
      end
    end
    
    gre.set_data(data)
    
    data = {}
    data["rows"] = index 
    gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", data)

  -- ----------------------
  --IF CLICKED FROM ALBUM
  elseif(category == 4)then
    for i=1, table.maxn(song_list) do
      if(song_list[i].album == id)then
        
        index = index + 1
        data["media_library_drawer_layer.library_drawer_listtwo_table.name."..index..".2"] = song_list[i].name
        data["media_library_drawer_layer.library_drawer_listtwo_table.image."..index..".1"] = song_list[i].thumb_image
        
        time = song_list[i].len
        local min = math.floor(time / 60)
        local sec = time - (min * 60)
        
        data["media_library_drawer_layer.library_drawer_listtwo_table.time."..index..".2"] = min..":"..sec
      end
    end
    
    gre.set_data(data)
    
    data = {}
    data["rows"] = index 
    gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", data)
    
  else
    print("did not send a song type")
  end
  
  local dk_data = {}
  dk_data["hidden"] = 0
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", dk_data) 

end

local listoneselection

function media_fill_artists(mapargs)

  --SHOW THE FIRST TABLE
  --HIDE THE SECOND TABLE
  listoneselection = 3
  local data = {}
  local active_letter = ""
  
  for i=1, table.maxn(artist_list)do
    local short_string = artist_list[i]
    
    data["media_library_drawer_layer.library_drawer_listone_table.name."..i..".2"] = artist_list[i]
    short_string = string.sub(artist_list[i],0,1)
    
    if(active_letter ~= short_string)then
      data["media_library_drawer_layer.library_drawer_listone_table.letter."..i..".1"] = short_string
      active_letter = short_string
    else
      data["media_library_drawer_layer.library_drawer_listone_table.letter."..i..".1"] = ""
    end
      
  end
  
  gre.set_data(data)
  
  local dk_data = {}
  dk_data["hidden"] = 0
  dk_data["rows"] = table.maxn(artist_list)
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listone_table", dk_data) 
  dk_data["hidden"] = 1
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", dk_data)
    
  gre.set_control_attrs("media_library_drawer_layer.library_drawer_prompt", dk_data)    

end

function media_fill_album(mapargs)
  
  print("album is filled")
  --SHOW THE FIRST TABLE
  --HIDE THE SECOND TABLE
  listoneselection = 4
  local data = {}
  local active_letter = ""
  
  for i=1, table.maxn(album_list)do
    local short_string = album_list[i]
    
    data["media_library_drawer_layer.library_drawer_listone_table.name."..i..".2"] = album_list[i]
    short_string = string.sub(album_list[i],0,1)
    
    if(active_letter ~= short_string)then
      data["media_library_drawer_layer.library_drawer_listone_table.letter."..i..".1"] = short_string
      active_letter = short_string
    else
      data["media_library_drawer_layer.library_drawer_listone_table.letter."..i..".1"] = ""
    end
      
  end
  
  gre.set_data(data)
  
  local dk_data = {}
  dk_data["hidden"] = 0
  dk_data["rows"] = table.maxn(album_list)
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listone_table", dk_data) 
  dk_data["hidden"] = 1
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listtwo_table", dk_data)
  gre.set_control_attrs("media_library_drawer_layer.library_drawer_prompt", dk_data)   
  
end

function media_select_song(mapargs)

  local name = "media_library_drawer_layer.library_drawer_listtwo_table.name." .. mapargs.context_row .. '.2'
  local len = "media_library_drawer_layer.library_drawer_listtwo_table.time." .. mapargs.context_row .. '.2'
  local time = gre.get_data(len)
  local song = gre.get_data(name)
  local data = {} 
  
  data["media_main_layer.media_main_std_text.elapsed"] = "0:00 |"
  data["media_main_layer.media_main_std_text.text"] = song[name]
  data["media_main_layer.media_main_std_text.time"] = time[len]
  
  for i=1, table.maxn(song_list) do 
    if(song_list[i].name == song[name])then
    
      data["media_main_layer.media_main_song_data.album"] = song_list[i].album
      data["media_main_layer.media_main_song_data.artist"] = song_list[i].artist
      data["media_main_layer.media_main_song_data.date"] = song_list[i].date
      data["media_main_layer.media_main_song_data.image"] = song_list[i].image
      media_active_tracktime = song_list[i].len
      
    end
  end
  
  media_active_medium = 3
  
  media_library_toggle()
  media_main_toggle()
  media_controls_stop()
  
  media_controls_play = 1
  media_elapsed_time_timer = gre.timer_set_interval(media_timer_counter, 1000)
  media_elapsed_time = 0
  
  data["media_main_layer.media_main_std_play.image"] = "images/media_main_std_pause.png"
  gre.set_data(data)
  
  gre.animation_trigger("media_show_song_data")
  gre.animation_trigger("media_song_data") 
  
  local dk_data = {}
  dk_data["hidden"] = 0
  gre.set_control_attrs("media_main_layer.media_main_std_play", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_std_back", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_std_forward", dk_data)
  gre.set_control_attrs("media_main_layer.media_main_song_data", dk_data) 
  
end

function media_select_listone(mapargs)

  local key = "media_library_drawer_layer.library_drawer_listone_table.name." .. mapargs.context_row .. '.2'
  local album_id = gre.get_data(key)

  media_fill_songs(listoneselection, album_id[key])
  animation_library_select(mapargs)

end

function media_select_allsongs(mapargs)
  local dk_data = {}
  dk_data["hidden"] = 1
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listone_table", dk_data)     
  gre.set_control_attrs("media_library_drawer_layer.library_drawer_prompt", dk_data)    

--HIDE THE FIRST TABLE
  listoneselection = 1
  media_fill_songs(listoneselection)  
end

function media_select_allmovies(mapargs)
  --HIDE THE FIRST TABLE
  local dk_data = {}
  dk_data["hidden"] = 1
  gre.set_table_attrs("media_library_drawer_layer.library_drawer_listone_table", dk_data)
  gre.set_control_attrs("media_library_drawer_layer.library_drawer_prompt", dk_data)    
  
  listoneselection = 2
  media_fill_songs(listoneselection)  
end

function media_radio_fm_am_toggle(mapargs)
  
  local dk_data = {}
  local data = {}
  
  if(radio_fm_active == 0)then
    dk_data["hidden"] = 1
    gre.set_control_attrs("media_main_layer.media_main_radio_AM",dk_data)
    dk_data["hidden"] = 0
    gre.set_control_attrs("media_main_layer.media_main_radio_FM",dk_data)
    radio_fm_active = 1
    data["media_main_layer.media_main_radio_text.text"] = radio_tuning_fm
  else
    dk_data["hidden"] = 0
    gre.set_control_attrs("media_main_layer.media_main_radio_AM",dk_data)
    dk_data["hidden"] = 1
    gre.set_control_attrs("media_main_layer.media_main_radio_FM",dk_data)
    radio_fm_active = 0
    data["media_main_layer.media_main_radio_text.text"] = radio_tuning_am
  end
  
  gre.set_data(data)

end

function media_timer_counter(mapargs)  
    
  if(media_active_tracktime <= media_elapsed_time)then
    media_controls_next()
  end
  
  media_elapsed_time = media_elapsed_time + 1
  
  local min = math.floor(media_elapsed_time / 60)
  local sec = media_elapsed_time - (min * 60)
  local angle = (360 * media_elapsed_time) / media_active_tracktime
  local from_angle = (360 *(media_elapsed_time - 1)) / media_active_tracktime
  
  media_outer_second_animation(angle, from_angle)
  
  local data = {}
  
  if(min == 0)then
    min = "0"
  end
  
  if(string.len(sec) == 1)then
    sec = "0"..sec  
  end
  
  
--  data["media_main_layer.media_main_outer_ring.angle"] = angle
  data["media_main_layer.media_main_std_text.elapsed"] = min..":"..sec.." |"
  gre.set_data(data)
  
end

function media_library_category_select(mapargs)

  local dk_data = {}
  local data = {}
    
  dk_data = gre.get_control_attrs(mapargs.context_control, "y")
  data["y"] = dk_data["y"]  
  gre.set_control_attrs("media_library_drawer_layer.library_drawer_category_selection", dk_data) 
  
  gre.animation_trigger("media_library_category_select")
  
  data["media_library_drawer_layer.library_drawer_artists.colour"] = 0xffffff
  data["media_library_drawer_layer.library_drawer_albums.colour"] = 0xffffff
  data["media_library_drawer_layer.library_drawer_movies.colour"] = 0xffffff
  data["media_library_drawer_layer.library_drawer_songs.colour"] = 0xffffff
  
  data[mapargs.context_control..".colour"] = 0xff0055
  
  gre.set_data(data)
   
end

function media_outer_second_animation(angle, from_angle)

  local anim_data = {}
  
  local media_second = gre.animation_create(60, 1)
  
  anim_data["key"] = "media_main_layer.media_main_outer_ring.angle"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["from"] = from_angle
  anim_data["to"] = angle
  gre.animation_add_step(media_second, anim_data)
 
  
  gre.animation_trigger(media_second)
    

end