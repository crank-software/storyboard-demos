
json=require("dkjson")

-- -----------------------------------------------------------------------------

debugging = 0
is_paused = 1
is_started = 0
video_seconds = 0
elapsed_seconds = 0
progressBarWidth = 488    -- "media_control_layer.progress_bar_control"

-- -----------------------------------------------------------------------------
-- for debugging
-- -----------------------------------------------------------------------------
function dump_table(t)
  for key, value in pairs(t) do
    if (type(value) == "table") then
      --print("table key " .. key)
      dump_table(value)
    else
      --print (tostring(key) .. " => " .. tostring(value))
    end
  end
end

-- -----------------------------------------------------------------------------
-- gra.media.playpause
-- -----------------------------------------------------------------------------
function media_play_pause_video(mapargs)
  if is_started == 1 then
    gre.send_event("ev_play_pause_song")
    return    
  end
  
  -- todo: get stopped event from ffmpeg, restart video on play
  
  gre.send_event("ev_start_video")
  is_started = 1
end

-- -----------------------------------------------------------------------------
-- gra.media.volume
-- -----------------------------------------------------------------------------
function media_vol_up(mapargs)
  local data = {}
  local var = gre.get_data("volume")
  local volume = var["volume"]
  local tick = gre.get_data("volume_height")
  local volume_tick = tick["volume_height"]

  ----print("START VOL: "..volume)

  if volume == 100 then 
    return
  else
    local data = {}
    volume = volume + 10
    volume_tick = volume_tick - 15
    ----print("NEW VOL: "..volume)
    data["volume_height"] = volume_tick
    data["volume"] = volume
    gre.set_data(data)
    gre.send_event("ev_volume_up")
  end
end

-- -----------------------------------------------------------------------------
-- gra.media.volume
-- -----------------------------------------------------------------------------
function media_vol_down(mapargs)
  local data = {}
  local var = gre.get_data("volume")
  local volume = var["volume"]
  local tick = gre.get_data("volume_height")
  local volume_tick = tick["volume_height"]
 
  ----print("START VOL: "..volume)

  if volume == 0 then 
    return
  else
    local data = {}
    volume = volume - 10
    volume_tick = volume_tick + 15
    ----print("NEW VOL: "..volume)
    data["volume_height"] = volume_tick
    data["volume"] = volume
    gre.set_data(data)
    gre.send_event("ev_volume_down")
  end
end

-- -----------------------------------------------------------------------------
-- receive gre.media.videoduration
-- -----------------------------------------------------------------------------
function media_video_total_time(mapargs) 
  local total = json.decode(mapargs.context_event_data.total_time)
  local totaltime = tonumber(total)
  
  video_seconds = totaltime
  local minutes = math.floor(video_seconds / 60)
  local seconds = video_seconds % 60
  
  if (debugging == 1) then
    --print("total time of video: " .. totaltime .. " ms = " .. minutes .. ":" .. seconds .. " (min:sec)")
  end
end

-- -----------------------------------------------------------------------------
-- receive gre.media.timeupdate
-- -----------------------------------------------------------------------------
function media_time_update(mapargs) 
  local total = json.decode(mapargs.context_event_data.total_time)
  local elapsed = json.decode(mapargs.context_event_data.time_elapsed)
  local totaltime = tonumber(total)       -- in seconds
  local elapsedtime = tonumber(elapsed)   -- in seconds
  local progressWidth = 0
  local data = {}
  local progress = (totaltime/elapsedtime)
  
  if(elapsedtime >= (totaltime - 50000)) then
    --print("SENDING RESTART")
    gre.send_event("restart_video")
  end

  if (debugging == 1) then
    --print("Video Total Time: " .. totaltime .. "  Elapsed Time: " .. elapsedtime)
  end

  if (elapsedtime == 0) then
    progressWidth = 0
  elseif (elapsedtime > 0) then
    progressWidth = progressBarWidth / progress

    if (debugging == 1) then
      --print("Progress: " .. progress .. "  Bar Width: " .. progressWidth)
    end
  end

  data["video_progress_width"] = progressWidth
  gre.set_data(data)
end
