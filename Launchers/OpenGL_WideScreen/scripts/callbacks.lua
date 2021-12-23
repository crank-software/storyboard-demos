require 'config'

-- Set up the app table you want. Currently the ones included are
-- auto_apps, standard_apps
apps = standard_apps

--this is a variable to not shutdown the launcher after an app is launched.
--If you have no idea what this comment is talking to set the below variable to 0
NO_SHUTDOWN_MODE = 0

MAIN_LASTLAUNCHED = 3

local prevSelectedSelector = "scrollingList.selector01"
local previd = 301
local autoswitch = 0
local forcedStop = 0
local appToLaunch
--set the amount of demos
--local demoAmount = 8

function selectorPress(mapargs) 
  local animData = {}
  local selectedSelector
 
  if(autoswitch == 0)then
    --this happens when we press the control
    local data = {}
    forcedStop = 1
    data["forcedStop"] = forcedStop
    gre.set_data(data)
    
    selectedSelector = mapargs.context_group
  else
    selectedSelector = mapargs
  end
  
  autoswitch = 0
  --print(selectedSelector, prevSelectedSelector)
  
  local id = gre.get_value(selectedSelector..".id")
  local ypos = gre.get_value(selectedSelector..".grd_y") + 40
  
  if(prevSelectedSelector == selectedSelector)then
    local data = {}
    forcedStop = 0
    data["forcedStop"] = forcedStop
    gre.set_data(data)
    return
  end

  --trigger animations for the selected (and if something else is active) unselected buttons
  if(prevSelectedSelector ~= nil)then
    animData = {}
    animData["context"]=prevSelectedSelector
    animData["id"]=previd
    gre.animation_trigger("LIST_unselected", animData)
  end
  
  --store the id and the control
  previd = id
  prevSelectedSelector = selectedSelector
  
  animData = {}
  animData["context"] = selectedSelector
  animData["id"] = id
  gre.animation_trigger("LIST_select", animData)
    
  --setting up rotation for rotIndicator
  local dataTable = gre.get_layer_attrs("scrollingList", "yoffset")
  local yoffset = ypos + dataTable.yoffset
  
  
  local oppSide = (yoffset-400)
  local selectorRot = math.deg(math.atan(oppSide/340)) * -1
  animate_rotIndicator(selectorRot)
  

  
  --setup false image for transition and then trigger transitions
  dataTable = {}
    
  dataTable = gre.get_data(selectedSelector..".thumb1",selectedSelector..".thumb2",selectedSelector..".thumb3", selectedSelector..".descHolder", selectedSelector..".titleHolder", 
                           selectedSelector..".bg01",selectedSelector..".bg02",selectedSelector..".bg03" ,selectedSelector..".app")
  
  local img1 = tostring(dataTable[selectedSelector..".thumb1"])
  local img2 = tostring(dataTable[selectedSelector..".thumb2"])
  local img3 = tostring(dataTable[selectedSelector..".thumb3"])
  local blur1 = tostring(dataTable[selectedSelector..".bg01"])
  local blur2 = tostring(dataTable[selectedSelector..".bg02"])
  local blur3 = tostring(dataTable[selectedSelector..".bg03"])
  local newDesc = tostring(dataTable[selectedSelector..".descHolder"])
  local newTitle = tostring(dataTable[selectedSelector..".titleHolder"])
        appToLaunch = tostring(dataTable[selectedSelector..".app"])
  
  local data = {}
  data["circleTransitionOverlay.newImg.transitionImg"] = img1
  data["centerPoint_Images.1.newImage"] = img1
  data["centerPoint_Images.2.newImage"] = img2
  data["centerPoint_Images.3.newImage"] = img3
  data["bg.newImage1"] = blur1
  data["bg.newImage2"] = blur2
  data["bg.newImage3"] = blur3
  data["aboutApp.aboutApp.title.newTitle"] = newTitle
  data["aboutApp.aboutApp.description.newDesc"] = newDesc
  data["circleTransitionOverlay.nameOverlay.textPlaceholder"] = "-"..newTitle.."-"
  gre.set_data(data)
  
  local ctrl_data = {}
  local transitionInProgress = gre.get_value("circleTransitionActive")
  if(transitionInProgress == 1)then
    ctrl_data["hidden"] = 0
  else
    ctrl_data["hidden"] = 1
  end
  
  gre.set_control_attrs("activeTransitionBG",ctrl_data)
  
  gre.animation_trigger("TRANSITION_swapDesc")
  gre.animation_trigger("DETAILS_circleTransition")
  gre.send_event("stopRotatingScreens")
  
end

function autoLoop()
  
  local activeSwitch = gre.get_value("activeSwitch")
  forcedStop = gre.get_value("forcedStop")
  
  if(activeSwitch == 1)then
    return
  end
  
  if(forcedStop == 1)then
    return
  end
  
  autoswitch = 1
  local newid = previd + 1

  --based on the amount of apps, we swap at the last app
  local numApps = #apps
  local maxID = 300 + numApps 

  if(newid>maxID)then
    newid = 301
  end
  
  local selectorid = newid - 300
  local newSelector = "scrollingList.selector0"..selectorid
  selectorPress(newSelector)
  
end


function animate_rotIndicator(selectorRotInc)
  
  local key = ("centerPoint_Overlay.rotIndicator.angle")
  local anim_data = {}
  
  local rotIndicator_rotate = gre.animation_create(60, 1)
  
  anim_data["key"] = key
  anim_data["rate"] = "linear"
  anim_data["duration"] = 100
  anim_data["offset"] = 0
  anim_data["to"] = selectorRotInc
  gre.animation_add_step(rotIndicator_rotate, anim_data)
  
  gre.animation_trigger(rotIndicator_rotate)

end

function INIT_Animations(mapargs)

  gre.animation_trigger("AMBIENT_bgDoppler")
  gre.animation_trigger("AMBIENT_dashedCircles")
  gre.animation_trigger("AMBIENT_Logo")
  gre.animation_trigger("AMBIENT_rotatesScreenshots")

end

-- USED FOR FTF, NEED TO UPDATE LATER
function INIT_App()
    
    --local data = {}
    --data["background"] = 1
    
    gre.load_resource("image", "images/bgImages/3DCluster1.png")
    gre.load_resource("image", "images/bgImages/3DCluster2.png")
    gre.load_resource("image", "images/bgImages/3DCluster3.png")
    gre.load_resource("image", "images/bgImages/Movie1.png")
    gre.load_resource("image", "images/bgImages/Movie2.png")
    gre.load_resource("image", "images/bgImages/Movie3.png")
    gre.load_resource("image", "images/bgImages/3DHouse1.png")
    gre.load_resource("image", "images/bgImages/3DHouse2.png")
    gre.load_resource("image", "images/bgImages/3DHouse3.png")
    gre.load_resource("image", "images/bgImages/Oven1.png")
    gre.load_resource("image", "images/bgImages/Oven2.png")
    gre.load_resource("image", "images/bgImages/Oven3.png")
    
    gre.load_resource("image", "images/bgImages/3DCluster1Blurred.png")
    gre.load_resource("image", "images/bgImages/3DCluster2Blurred.png")
    gre.load_resource("image", "images/bgImages/3DCluster3Blurred.png")
    gre.load_resource("image", "images/bgImages/Movie1Blurred.png")
    gre.load_resource("image", "images/bgImages/Movie2Blurred.png")
    gre.load_resource("image", "images/bgImages/Movie3Blurred.png")
    gre.load_resource("image", "images/bgImages/3DHouse1Blurred.png")
    gre.load_resource("image", "images/bgImages/3DHouse2Blurred.png")
    gre.load_resource("image", "images/bgImages/3DHouse3Blurred.png")
    gre.load_resource("image", "images/bgImages/Oven1Blurred.png")
    gre.load_resource("image", "images/bgImages/Oven2Blurred.png")
    gre.load_resource("image", "images/bgImages/Oven3Blurred.png")

end

local function resetStartup()
  --sets up the images and descriptions for reset after launch
 --reset the selected selector
  autoswitch = 1
  selectorPress("scrollingList.selector01")
    
  local data = {}
  
  data["centerPoint_Images.1.image"] = apps[1].image01
  data["centerPoint_Images.2.image"] = apps[1].image02
  data["centerPoint_Images.3.image"] = apps[1].image03
  data["bg.blurImg1.image"] = apps[1].blur01
  data["bg.blurImg2.image"] = apps[1].blur02
  data["bg.blurImg3.image"] = apps[1].blur03
  data["aboutApp.aboutApp.title.text"] = apps[1].name
  data["aboutApp.aboutApp.description.text"] = apps[1].desc
  appToLaunch = apps[1].gapp_file 


  gre.set_data(data)
  
end

function LAUNCH(mapargs)

  local data = {}
  
  data["model"] = gre.SCRIPT_ROOT..appToLaunch
  gre.send_event_data("gre.load_app", "1s0 model", data)
  
  print(appToLaunch)
  
  if(NO_SHUTDOWN_MODE == 1)then
    --reset the animation points of the long loading transition
    gre.animation_trigger('TRANSITION_launchCirclesReset')
    gre.animation_trigger('TRANSITION_launchReset')
    gre.animation_trigger('PRESS_launchAnimReset')
    --restart the startup and itnit the animations again
    resetStartup()
    INIT_Animations()
  else
    gre.quit()  
  end
end


function startup()

  get_ip_address()
  local data = {}
  --print("instartup")
  --hide all of the selectors
  for i = 1, 4 do
    data["scrollingList.selector0"..i..".grd_hidden"] = 1
  end
  --unhide based on how many there are to fill
  --filling up the 3 areas
  
  for i=1, #apps do
    data["scrollingList.selector0"..i..".grd_hidden"] = 0
    data["scrollingList.selector0"..i..".app"] = apps[i].gapp_file 
    data["scrollingList.selector0"..i..".titleHolder"] = apps[i].name
    data["scrollingList.selector0"..i..".tagline"] = string.upper(apps[i].tagline)
    data["scrollingList.selector0"..i..".descHolder"] = apps[i].desc
    
    data["scrollingList.selector0"..i..".thumb1"] = apps[i].image01
    data["scrollingList.selector0"..i..".thumb2"] = apps[i].image02
    data["scrollingList.selector0"..i..".thumb3"] = apps[i].image03
 
    data["scrollingList.selector0"..i..".bg01"] = apps[i].blur01
    data["scrollingList.selector0"..i..".bg02"] = apps[i].blur02
    data["scrollingList.selector0"..i..".bg03"] = apps[i].blur03    
    
  end

  --sets up the images and descriptions for cold launch

  data["centerPoint_Images.1.image"] = apps[1].image01
  data["centerPoint_Images.2.image"] = apps[1].image02
  data["centerPoint_Images.3.image"] = apps[1].image03
  data["bg.blurImg1.image"] = apps[1].blur01
  data["bg.blurImg2.image"] = apps[1].blur02
  data["bg.blurImg3.image"] = apps[1].blur03
  data["aboutApp.aboutApp.title.text"] = apps[1].name
  data["aboutApp.aboutApp.description.text"] = apps[1].desc
  appToLaunch = apps[1].gapp_file 
  
  
  gre.set_data(data)

  --if it is automated we count down a timer, select a group and then launch it.
  --needs to make the launch script call teh animations 
  
  if(MAINTOGGLE_AUTOMATED == 1)then
      --figure out the last selected selector
      --set a timer before selecting
      --select selector and call the launch function
      print("automated selection timer started")
      gre.timer_set_timeout(automatedSelection,12000)
  end
  
end

function automatedSelection()
  print("in automated selection")
  local selection
  if(MAIN_LASTLAUNCHED == 1)then
    selection = 2
  elseif(MAIN_LASTLAUNCHED == 2)then
    selection = 3
  elseif(MAIN_LASTLAUNCHED == 3)then
    selection = 1
  else
  end
  
  autoswitch = 1
  local newSelector = "scrollingList.selector0"..selection
  selectorPress(newSelector)
  
  MAIN_LASTLAUNCHED = selection
  gre.timer_set_timeout(launchButtonPress,2000)
end

function get_ip_address()
  local data = {}
  local ip_addr = get_ip()
  
  if ip_addr == nil then
    gre.timer_set_timeout(get_ip_address,10000)
    data["aboutApp.boardDetails.description.text"] = "Network Disconnected"
  else
    data["aboutApp.boardDetails.description.text"] = tostring(ip_addr)
  end
  gre.set_data(data)
end

function loadingText(mapargs) 
  local loadNum = gre.get_value("launchAnimation.launchloadingBar.loading")
  local data = {}
  data["launchAnimation.launchloadingBar.text"] = loadNum
  gre.set_data(data)
end


function launchButtonPress(mapargs) 
  gre.animation_trigger("TRANSITION_launchCirclers")
  gre.animation_trigger("TRANSITION_launch")
  gre.animation_trigger("PRESS_launchAnim")
end
