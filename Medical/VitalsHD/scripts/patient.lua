local prevSymptom = nil
local heldView = 1

function CBpatientPressView(mapargs)

  local incView = gre.get_value(mapargs.context_group..".view")
  
  local button1X, button2X, button3X
  local button1Y, button2Y, button3Y
  
  local data = {}
  local ctrlData = {}
  
  if(incView == 1)then
    data["patientBody.dropDown.selectedName.heldText"] = "re-occuring"
    button1X = 548
    button1Y = 401    
    button2X = 508
    button2Y = 161    
    --show body
    ctrlData["hidden"] = 1
    gre.set_control_attrs("patientBody.skeleton",ctrlData)
    ctrlData["hidden"] = 0
    gre.set_control_attrs("patientBody.body",ctrlData)
  elseif(incView == 2)then
    data["patientBody.dropDown.selectedName.heldText"] = "skeleton"
    button1X = 398
    button1Y = 311    
    button2X = 508
    button2Y = 301 
    --show skeleton
    ctrlData["hidden"] = 0
    gre.set_control_attrs("patientBody.skeleton",ctrlData)
    ctrlData["hidden"] = 1
    gre.set_control_attrs("patientBody.body",ctrlData)
  elseif(incView == 3)then
    data["patientBody.dropDown.selectedName.heldText"] = "latest reported"
    button1X = 498
    button1Y = 81    
    button2X = 588
    button2Y = 311
    --show body
    ctrlData["hidden"] = 1
    gre.set_control_attrs("patientBody.skeleton",ctrlData)
    ctrlData["hidden"] = 0
    gre.set_control_attrs("patientBody.body",ctrlData)
  else
  end
  
  --set individual locations for animations
  data["patientBody.button1X"] = button1X
  data["patientBody.button1Y"] = button1Y
  data["patientBody.button2X"] = button2X
  data["patientBody.button2Y"] = button2Y
    
  gre.set_data(data)
  gre.animation_trigger("PATIENT_dropMenuTitle")
  gre.animation_trigger("PATIENT_moveButtons")
  
  local animData = {}
  if(prevSymptom ~= nil)then
    animData["context"] = prevSymptom
    animData["id"] = 10
    gre.animation_trigger("PATIENT_symptomUp", animData)
    gre.animation_trigger("PATIENT_closeSymptom")
    prevSymptom = nil
  end
  
  heldView = incView
  --setup the positions of the symptomButtons based on the incView
end

local function symptomOpenAnimation()
  gre.animation_trigger("PATIENT_openSymptoms")
end

local function setupText(mapargs)
  
  local body, title
  if(heldView == 1)then
    if(mapargs.context_group == "patientBody.symptomButton1")then
      body = "images/injurys/injury1.png"
      title = "Leg Injury"
    elseif(mapargs.context_group == "patientBody.symptomButton2")then
      body = "images/injurys/injury2.png"
      title = "Throat Pain"
    end
  elseif(heldView == 2)then
    if(mapargs.context_group == "patientBody.symptomButton1")then
      body = "images/injurys/injury3.png"
      title = "Sprained Wrist (13 yrs)"
    elseif(mapargs.context_group == "patientBody.symptomButton2")then
      body = "images/injurys/injury4.png"
      title = "Car Accident Injury"
    end
  elseif(heldView == 3)then
    if(mapargs.context_group == "patientBody.symptomButton1")then
      body = "images/injurys/injury5.png"
      title = "Whiplash Pains"
    elseif(mapargs.context_group == "patientBody.symptomButton2")then
      body = "images/injurys/injury6.png"
      title = "Physio Recommended"
    end
  end  
  
  local stringData = {}
  stringData = gre.get_string_size("fonts/Roboto-Condensed.ttf", 18, title)
  local titleSize = stringData["width"] + 15
  
  local data = {}
  data["patientBody.heldTitleWidth"] = titleSize
  data["patientBody.heldTitle"] = title
  data["patientBody.heldBody"] = body
  gre.set_data(data)
  
end

function CBpatientPressSymptom(mapargs)

  local newSymptom = mapargs.context_group

  if(prevSymptom == newSymptom)then
    return
  end

  local animData = {}
  animData["context"] = newSymptom
  animData["id"] = 1
  gre.animation_trigger("PATIENT_symptomDown", animData)
  
  if(prevSymptom ~= nil)then
    animData["context"] = prevSymptom
    animData["id"] = 10
    gre.animation_trigger("PATIENT_symptomUp", animData)
    gre.animation_trigger("PATIENT_closeSymptom")
  end
  
  local incData = {}
  incData = gre.get_control_attrs(newSymptom, "x", "y")   
  
  local newX = incData["x"] -79
  local newY = incData["y"] - 8

  local data = {}
  data["patientBody.heldY"] = newY
  data["patientBody.heldX"] = newX
  gre.set_data(data)
  
  gre.timer_set_timeout(symptomOpenAnimation,150)
  
  prevSymptom = newSymptom
  
  setupText(mapargs)
end


local patientSlider = nil

local function modelRotate(mapargs)

  local pressX = mapargs.context_event_data.x
  local control = gre.get_control_attrs(mapargs.context_control, "x")
  local newX = pressX - control["x"] - 25 - 307 + 50
    
  if (newX < 25) then
    newX = 25
  elseif newX > 480 then
    newX = 480
  end
  
  local percentage = math.floor(((newX-50)/404)* 100)

  local data = {}
  data["patientBody.skeleton.var"] = percentage * 3.6
  data["patientBody.body.var"] = percentage * 3.6
  data["patientBody.modelSlider.bg.width"] = newX - 25
  gre.set_data(data)
  
  local ctrlData = {}
  ctrlData["x"] = newX
  gre.set_control_attrs("patientBody.modelSlider.dot",ctrlData)
  

end

function CBpatientSliderPress(mapargs)

  patientSlider = mapargs.context_control
  modelRotate(mapargs)
  gre.animation_trigger("PATIENT_pressSlider")
  
end

function CBpatientSliderMotion(mapargs)
  
  if (patientSlider == nil) then
    return
  end
  
  if (patientSlider == mapargs.context_control) then
    modelRotate(mapargs)
  end

end

function CBpatientSliderRelease(mapargs)
  
  if(patientSlider ~= nil)then
    gre.animation_trigger("PATIENT_releaseSlider")
  end
  
  patientSlider = nil

    
end

function resetScreen()
  
  prevSymptom = nil

end

--- @param gre#context mapargs
function CBpatientScreenShow(mapargs) 

  -- Reset patient slider view to midpoint on each screen show
  local control = gre.get_control_attrs("patientBody.modelSlider", "x")
  local newX = 257 -- midpoint

  local percentage = math.floor(((newX-50)/404)* 100)    

  local data = {}
  data["patientBody.skeleton.var"] = percentage * 3.6
  data["patientBody.body.var"] = percentage * 3.6
  data["patientBody.modelSlider.bg.width"] = newX - 25
  gre.set_data(data)
  
  local ctrlData = {}
  ctrlData["x"] = newX
  gre.set_control_attrs("patientBody.modelSlider.dot",ctrlData)

end
