local time, secTime = 0
local elapsedSecTime = 0
local washingOn = 0
local washingTimer = nil

local stage

secTime = 400


function cancelWashingTimer()
  if(washingTimer == nil) then
    return
  end
  
  gre.timer_clear_timeout(washingTimer)
  washingTimer = nil
end

function resetWashSettings()
  
  time = 0
  secTime = 400
  elapsedSecTime = 0
  washingOn = 0
  stage = ""
  cancelWashingTimer()

end

function updateTime()

  local remainingTime  
    
  if(secTime <= elapsedSecTime)then
    washComplete()
  end
  
  elapsedSecTime = elapsedSecTime + 1
  remainingTime = secTime - elapsedSecTime

  if(remainingTime < 0)then
    washComplete()
    return
  elseif(remainingTime < 400 and remainingTime > 300)then
    if(stage ~= "prewash")then
      stage = "prewash"
      gre.animation_trigger("prewash_start")
    end
  elseif(remainingTime < 300 and remainingTime > 200)then
    if(stage ~= "wash")then
      stage = "wash"
      gre.animation_trigger("washing_start")
    end
  elseif(remainingTime < 200 and remainingTime > 100)then
    if(stage ~= "rinse")then
      stage = "rinse"
      gre.animation_trigger("rinse_start")
    end
  elseif(remainingTime < 100 and remainingTime > 0)then
    if(stage ~= "spin")then
      stage = "spin"
      gre.animation_trigger("spin_start")
    end
  end
  
  local min = math.floor(remainingTime / 60)
  local sec = remainingTime - (min * 60)
  local pos = ((480 * elapsedSecTime) / secTime) - 480
  local frompos = ((480 *(elapsedSecTime - 1)) / secTime) - 480
  
  washingAnimation(pos,frompos)
  
  local data = {}
  
  if(min == 0)then
    min = "0"
  end
  
  if(string.len(sec) == 1)then
    sec = "0"..sec  
  end

  data["washing_layer.remainingTime.text"] = min..":"..sec
  gre.set_data(data)
  
end

function washingAnimation(pos,frompos)

--  print(gre.get_value("washing_animations.progress_overlay.x_pos"))

  local anim_data = {}
  
  local washingSecond = gre.animation_create(60, 1)

  anim_data["key"] = "washing_animations.progress_overlay.x_pos"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 50
  anim_data["offset"] = 0
  anim_data["from"] = frompos
  anim_data["to"] = pos
  gre.animation_add_step(washingSecond, anim_data)
  
  gre.animation_trigger(washingSecond)
end

function startStopWashing(mapargs) 
  local data = {}
    
  if(washingOn == 0)then
  
    data["washing_layer.pause_btn.text"] = "PAUSE"
    washingOn = 1
  
    washingTimer = gre.timer_set_interval(updateTime, 50)
    
    if(stage=="prewash")then
      gre.animation_trigger("prewash_start")
    elseif(stage=="wash")then
      gre.animation_trigger("washing_start")
    elseif(stage=="spin")then
      gre.animation_trigger("spin_start")
    elseif(stage=="rinse")then
      gre.animation_trigger("rinse_start")
    end
  else
    washingOn = 0  
    cancelWashingTimer()
    data["washing_layer.pause_btn.text"] = "RESUME"
  end
  
  gre.set_data(data)
  
end

function washComplete()
  
  local data = {}
  
  washingOn = 0  
  cancelWashingTimer()

  gre.animation_trigger("prewash_complete")
  gre.animation_trigger("washing_complete")
  gre.animation_trigger("rinse_complete")
  gre.animation_trigger("spin_complete")
  
  data["washing_layer.countdown.time"] = "Done!"
  gre.set_data(data)
end

function prewashAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "prewash")then
    gre.animation_trigger("prewash")
  else
    gre.animation_trigger("prewash_complete")
  end
end

function washAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "wash")then
    gre.animation_trigger("washing2")
  else
    gre.animation_trigger("washing_complete")
  end
end

function rinseAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "rinse")then
    gre.animation_trigger("rinse")
  else
    gre.animation_trigger("rinse_complete")
  end
end

function spinAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "spin")then
    gre.animation_trigger("spin")
  else
    gre.animation_trigger("spin_complete")
  end
end