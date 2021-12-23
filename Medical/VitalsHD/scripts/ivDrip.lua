local ivOn = 0
local dripRate = 0.1
local bagAmount = 1000

local remainingAngle = 360
local prevRemainingAngle = 360

local function animateRemainingAmount()
  
  local key = ("IVCetner.outerArc.endAngle")
  local anim_data = {}
  
  local remaingBagAnimation = gre.animation_create(60, 1)
  
  anim_data["key"] = key
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["from"] = prevRemainingAngle
  anim_data["to"] = remainingAngle
  gre.animation_add_step(remaingBagAnimation, anim_data)
  
  
  gre.animation_trigger(remaingBagAnimation)

end

local function dripRateAmount()
  --setup how much is left in the bag
  bagAmount = bagAmount - dripRate
  --setup how many seconds are left in the bag
  local timeRemaining = math.floor(bagAmount/dripRate)
  --setupSecond to minute/second
  
  local data = {}
  
  local min = math.floor(timeRemaining / 60)
  local sec = timeRemaining - (min * 60)
  if(string.len(min) == 1)then
    min = "0"..min
  end
  if(string.len(sec) == 1)then
    sec = "0"..sec
  end
  
  --setup arc animations
  
  
  --
  remainingAngle = (bagAmount/1000) * 360
  animateRemainingAmount()
  prevRemainingAngle = remainingAngle
  
  data["IVCetner.IVInfo.time.text"] = min.."m"..sec.."s"
  gre.set_data(data)
end

local function dripRateSetup()

  local data = {}
  if(string.len(dripRate) == 1)then
    data["IVCetner.IVInfo.rate.text"] = dripRate..".0 mg/s"
  else
    data["IVCetner.IVInfo.rate.text"] = dripRate.." mg/s"
  end
  
  gre.set_data(data)
    
  gre.animation_trigger("IV_dripChange")
end


local dripTimer = {}
function CBivToggle(mapargs)

  if(ivOn == 0)then
    ivOn = 1
    gre.animation_trigger("IV_intervalsStart")
    gre.animation_trigger("IV_constantMovement")
    dripTimer = gre.timer_set_interval(dripRateAmount,1000)
  else
    ivOn = 0
    gre.animation_trigger("IV_intervalsStop")
    gre.animation_stop("IV_constantMovement")
    gre.animation_trigger("IV_constantMovementEnd")
    local timerData
    timerData = gre.timer_clear_timeout(dripTimer)
  end

end

function CBdripBagReplace(mapargs)
  bagAmount = 1000
end

function CBdripRate(mapargs)
  local drip = gre.get_value(mapargs.context_group..".drip")
  if(drip == 1)then
    dripRate = dripRate + 0.1
  elseif(drip == 0)then
    dripRate = dripRate - 0.1
  end
  
  if(dripRate >= 3.00)then
    dripRate = 3.0
  elseif(dripRate <= .1)then
    dripRate = 0.1
  end
  dripRateSetup() 
    
end

