local time, secTime = 0
local elapsedSecTime = 0
local washingOn = 0
local washingTimer = nil

local stage

secTime = 400

function resetWashSettings()
  
  time = 0
  secTime = 400
  elapsedSecTime = 0
  washingOn = 0
  stage = ""
  
  if(washingTimer ~= nil)then
    local dk_data
    dk_data = gre.timer_clear_timeout(washingTimer)
  end
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
    --print("in 1")
    if(stage ~= "prewash")then
      stage = "prewash"
      gre.animation_trigger("WashingAnims_PreWashStart")
    end
  elseif(remainingTime < 300 and remainingTime > 200)then
    --print("in 2")
    if(stage ~= "wash")then
      stage = "wash"
      gre.animation_trigger("WashingAnims_WashStart")
    end
  elseif(remainingTime < 200 and remainingTime > 125)then
    --print("in 3")
    if(stage ~= "rinse")then
      stage = "rinse"
      gre.animation_trigger("WashingAnims_RinseStart")
    end
  elseif(remainingTime < 125 and remainingTime > 0)then
    --print("in 4")
    if(stage ~= "spin")then
      stage = "spin"
      gre.animation_trigger("WashingAnims_SpinStart")
    end
  end
  
  local min = math.floor(remainingTime / 60)
  local sec = remainingTime - (min * 60)
  local pos = ((800 * elapsedSecTime) / secTime) - 800
  local frompos = ((800 *(elapsedSecTime - 1)) / secTime) - 800
  
  washingAnimation(pos,frompos)
  
  local data = {}
  
  if(min == 0)then
    min = "0"
  end
  
  if(string.len(sec) == 1)then
    sec = "0"..sec  
  end
    
  data["washingData.remainingTime.text"] = min..":"..sec
  gre.set_data(data)
  
end

function washingAnimation(pos,frompos)

  local anim_data = {}
  
  local washingSecond = gre.animation_create(60, 1)
  
  anim_data["key"] = "washingProgress.progressOverlay.xpos"
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
  local dk_data
    
  if(washingOn == 0)then
  
    data["washingData.pauseButton.pause.text"] = "PAUSE"
    washingOn = 1
  
    washingTimer = gre.timer_set_interval(updateTime, 50)
    
    if(stage=="prewash")then
      gre.animation_trigger("WashingAnims_PreWashFill")
    elseif(stage=="wash")then
      gre.animation_trigger("WashingAnims_WashCycle")
    elseif(stage=="spin")then
      gre.animation_trigger("WashingAnims_SpinCycle")
    elseif(stage=="rinse")then
      gre.animation_trigger("WashingAnims_RinseCycle")
    end
  else
    washingOn = 0  
    dk_data = gre.timer_clear_timeout(washingTimer)
    data["washingData.pauseButton.pause.text"] = "RESUME"
  end
  
  gre.set_data(data)
  
end

function washComplete()
  
  local dk_data
  local data = {}
  
  washingOn = 0  
  dk_data = gre.timer_clear_timeout(washingTimer)
  washingTimer = nil
  
  gre.animation_trigger("WashingAnims_SpinComplete")
  gre.animation_trigger("WashingAnims_Complete")
  
  data["washingData.remainingTime.text"] = "Done!"
  gre.set_data(data)
end

function prewashAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "prewash")then
    gre.animation_trigger("WashingAnims_PreWashFill")
  else
    gre.animation_trigger("WashingAnims_PreWashComplete")
  end
end

function washAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "wash")then
    gre.animation_trigger("WashingAnims_WashCycle")
  else
    gre.animation_trigger("WashingAnims_WashComplete")
  end
end

function rinseAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "rinse")then
    gre.animation_trigger("WashingAnims_RinseCycle")
  else
    gre.animation_trigger("WashingAnims_RinseComplete")
  end
end

function spinAnimCheck()
  if(washingOn == 0)then
    return
  end
  if(stage == "spin")then
    gre.animation_trigger("WashingAnims_SpinCycle")
  else
    gre.animation_trigger("WashingAnims_SpinComplete")
  end
end
