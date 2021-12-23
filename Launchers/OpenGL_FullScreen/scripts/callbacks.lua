require "config"

local prevSelectedSelector
local previd
local activeApp = nil
--set the amount of demos
--local demoAmount = 8
local boardScreenActive = 0
--if we forcefully stop ambient animation by selecting a new animation then this is set to 0
local loopAnimActive = 1

local idleCall = 0
local idleSelected = nil


local APP_IDLE_TIME = 9000
local idleTimer = {}
local appIdle = 1
--set up the amount of demos we have and the one demo you want to start on in the beginning
local activeDemo = 2
local demoAmount = 3

apps = standard_apps

function selectGroup(mapargs) 

  local selectedSelector
  
  local animData = {}
  if(idleCall == 0)then  
    selectedSelector = mapargs.context_group
  else
    selectedSelector = idleSelected
  end
  
  local id = gre.get_value(selectedSelector..".id")
  local tempApp = gre.get_value(selectedSelector..".app")
  activeDemo = id
  activeApp = tempApp
  if(prevSelectedSelector == selectedSelector)then
    --print("same control")
    return
  end

  --trigger animations for the selected (and if something else is active) unselected buttons
  if(prevSelectedSelector ~= nil)then
    animData["context"]=prevSelectedSelector
    animData["id"]=previd
    gre.animation_trigger("PRESS_AppUnselect", animData)
  end
  
  animData = {}
  animData["context"] = selectedSelector
  animData["id"] = id
  gre.animation_trigger("PRESS_AppSelect", animData)
   
  --store the id and the control
  previd = id
  prevSelectedSelector = selectedSelector
  
  --setup false image for transition and then trigger transitions
  local dataTable = {}
    
  dataTable = gre.get_data(selectedSelector..".thumbOne",selectedSelector..".thumbTwo",selectedSelector..".thumbThree", selectedSelector..".descHolder", selectedSelector..".titleHolder",
              selectedSelector..".blurOne",selectedSelector..".blurTwo",selectedSelector..".blurThree" )
  
    
  local img1 = tostring(dataTable[selectedSelector..".thumbOne"])
  local img2 = tostring(dataTable[selectedSelector..".thumbTwo"])
  local img3 = tostring(dataTable[selectedSelector..".thumbThree"])
  
  local blur1 = tostring(dataTable[selectedSelector..".blurOne"])
  local blur2 = tostring(dataTable[selectedSelector..".blurTwo"])
  local blur3 = tostring(dataTable[selectedSelector..".blurThree"])
  --local newDesc = tostring(dataTable[selectedSelector..".descHolder"])
  local newTitle = tostring(dataTable[selectedSelector..".titleHolder"])
  
  
  local data = {}
  data["circleTransitionOverlay.newImg.transitionImg"] = img1
  
  data["bg.imgOneBlur.newImage"] = blur1
  data["bg.imgTwoBlur.newImage"] = blur2
  data["bg.imgThreeBlur.newImage"] = blur3
  
  --data["bg.imgOneBlur.img"] = blur1
  --data["bg.imgTwoBlur.img"] = blur2
  --data["bg.imgThreeBlur.img"] = blur3
  
  data["centerPoint.img1.newImage"] = img1
  data["centerPoint.img2.newImage"] = img2
  data["centerPoint.img3.newImage"] = img3
  
  data["buttons.aboutApp.title.newTitle"] = newTitle
  --data["aboutApp.description.newDesc"] = newDesc
  data["circleTransitionOverlay.nameOverlay.textPlaceholder"] = "- "..newTitle.." -"
  
  
  --if there is an animation in place for swapping just set the images to clean it all up
  local transitionActive = gre.get_value("circleTransitionActive")
  local ctrl_data = {}
  if(transitionActive == 1)then
    ctrl_data["hidden"] = 0
  else
    ctrl_data["hidden"] = 1
  end
  gre.set_control_attrs("circleTransitionOverlay.blackBG",ctrl_data)
  
  gre.set_data(data)
    
  --gre.animation_trigger("TRANSITION_swapImages")
  --gre.animation_trigger("TRANSITION_swapDesc")
  gre.animation_trigger("DETAILS_TitleRedraw")
  gre.animation_trigger("DETAILS_circleTransition")
  loopAnimActive = 0
  gre.send_event("stopAnimation")
  --print(id, prevSelectedSelector)
  
  
  
end

function loopAnimationCheck()
  --if we have forcefully stopped the animation for selecting a new one do not restart the animation
  if(loopAnimActive == 0)then
    return
  end
  gre.animation_trigger("AMBIENT_rotatesScreenshots")
end

function loopAnimationStart()
  loopAnimActive = 1
  gre.animation_trigger("AMBIENT_rotatesScreenshots")
end

local tendrilSelected
local prevTendrilSelected
local tendrilAnimation

function setupTendrils(mapargs)
  
  
  if(mapargs.context_group == buttonSelected)then
    return
  end

  tendrilSelected = mapargs.context_group  
  local id = gre.get_value(tendrilSelected..".id")
  
  
  if(id == 1)then
    tendrilAnimation = 1
  elseif(id == 2)then
    tendrilAnimation = 2
  elseif(id == 3)then
    tendrilAnimation = 3
  else
  --future
  end
  
  gre.send_event("stopTendrils")
  if(prevTendrilSelected ~= nil)then
    if(prevTendrilSelected == 1)then
      gre.animation_trigger("EFFECTS_TendrilsLeftEnd")
    elseif(prevTendrilSelected == 2)then
      gre.animation_trigger("EFFECTS_TendrilsCenterEnd")
    elseif(prevTendrilSelected == 3)then
      gre.animation_trigger("EFFECTS_TendrilsRightEnd")
    else
    --future
    end
  end
  prevTendrilSelected = id
  
  TendrilAnimationCheck()
end

function TendrilAnimationCheck()
  if(tendrilAnimation == 1)then
    gre.animation_trigger("EFFECTS_LeftTendrils")
  elseif(tendrilAnimation == 2)then
    gre.animation_trigger("EFFECTS_CenterTendrils")
  elseif(tendrilAnimation == 3)then
    gre.animation_trigger("EFFECTS_RightTendrils")
  else
  end
end

function cb_func()
--  print("APP_IS_IDLE")
  --stuff that happens when the app is idle
  appIdle = 1   
  activeDemo = activeDemo + 1

  if(activeDemo > demoAmount)then
    activeDemo = 1
  end
  
  if(activeDemo==1)then
    idleSelected = "bottomButtons.button1"
  elseif(activeDemo==2)then
    idleSelected = "bottomButtons.button2"
  elseif(activeDemo == 3)then
    idleSelected = "bottomButtons.button3"
  end
  
  idleCall = 1
  selectGroup()
  idleCall = 0
  
 -- print("App is idle, looping "..activeDemo)
  idleTimer = gre.timer_set_timeout(cb_func, APP_IDLE_TIME)
  
end

--Call cb_func after x seconds
function APP_idleApp()
  
  appIdle = 0
  cb_clear_timeout()
  idleTimer = gre.timer_set_timeout(cb_func, APP_IDLE_TIME)
  
end

function cb_clear_timeout()
  local data
  data = gre.timer_clear_timeout(idleTimer)
end

function APP_init()
  
  activeDemo = 1
  cb_func()
end

function LAUNCH()


  local data = {}
  print(gre.SCRIPT_ROOT)
  print(activeApp)
  data["model"] = gre.SCRIPT_ROOT..activeApp
  gre.send_event_data("gre.load_app", "1s0 model", data)
  
  --print(data["model"])
  gre.quit()  
      
end

local infoToggle = 1
function INFO_toggle(mapargs) 
  if(infoToggle == 1)then
    infoToggle = 0
    gre.animation_trigger("PRESS_closeInfo")
  else
    infoToggle = 1
    gre.animation_trigger("PRESS_info")
  end  
end

--0 is dark, 1 is light
local schemeToggle = 1

function toggleScheme(mapargs) 
  local newLang
  --currently dark, switching to light
  if(schemeToggle == 0)then
    schemeToggle = 1
    newLang = "light.csv"
    gre.animation_trigger("PRESS_toggleLight")
  --currently light, swithing to dark
  else
    schemeToggle = 0
    newLang = "dark.csv"
    gre.animation_trigger("PRESS_toggleDark")
  end 
  
  cb_load_language(newLang)
  
end


function get_ip_address()
  local data = {}
  local data_table = {}
  local ip_addr = get_ip()
  --print(ip_addr)
  --print("inGetIP")
  if ip_addr == nil then
    gre.timer_set_timeout(get_ip_address,10000)
    data_table["hidden"] = 1
  else
    data["buttons.ipAddressData.text"] = tostring(ip_addr)
    gre.set_data(data)
    data_table["hidden"] = 0
  end
  
  gre.set_control_attrs("buttons.ipAddressData", data_table)
  gre.set_control_attrs("buttons.infoTitle", data_table)
  gre.set_control_attrs("buttons.ipTitle", data_table)
  gre.set_control_attrs("buttons.infoBG", data_table)
  gre.set_control_attrs("buttons.info", data_table)
  
end


function startup()

  local data = {}
  for i=1, 3 do
    data["bottomButtons.button"..i..".app"] = apps[i].gapp_file 
    data["bottomButtons.button"..i..".titleText"] = apps[i].name
    data["bottomButtons.button"..i..".titleHolder"] = apps[i].name
    data["bottomButtons.button"..i..".descHolder"] = string.lower(apps[i].desc_holder)
  
    data["bottomButtons.button"..i..".thumbOne"] = apps[i].image01
    data["bottomButtons.button"..i..".thumbTwo"] = apps[i].image02
    data["bottomButtons.button"..i..".thumbThree"] = apps[i].image03
    
    data["bottomButtons.button"..i..".blurOne"] = apps[i].blur01
    data["bottomButtons.button"..i..".blurTwo"] = apps[i].blur02
    data["bottomButtons.button"..i..".blurThree"] = apps[i].blur03
    
  end

  
  data["centerPoint.img1.newImage"] = apps[2].image01
  data["centerPoint.img2.newImage"] = apps[2].image02
  data["centerPoint.img3.newImage"] = apps[2].image03
  
  data["bg.imgOneBlur.newImage"] = apps[2].blur01
  data["bg.imgTwoBlur.newImage"] = apps[2].blur02
  data["bg.imgThreeBlur.newImage"] = apps[2].blur03
  
  data["circleTransitionOverlay.newImg.transitionImg"] = apps[2].image01
  
  activeApp = apps[2].gapp_file
  
  gre.set_data(data)
--require "available_apps"
end
