require "config"

local prevSelectedKey = "buttons.app1"
local prevSelectedID = 1
local launchingApp = nil

apps = standard_apps

function CB_Init(mapargs)

  local data = {}
  for i=1, 4 do
    data["buttons.app"..i..".app"] = apps[i].gapp_file 
    data["buttons.app"..i..".titleText"] = apps[i].name
    data["buttons.app"..i..".descText"] = string.lower(apps[i].desc_holder)
  
    data["buttons.app"..i..".thumbOne"] = apps[i].image1
    data["buttons.app"..i..".thumbTwo"] = apps[i].image2
    data["buttons.app"..i..".thumbThree"] = apps[i].image3

    data["buttons.app"..i..".blurOne"] = apps[i].blur1
    data["buttons.app"..i..".blurTwo"] = apps[i].blur2
    data["buttons.app"..i..".blurThree"] = apps[i].blur3
    
    gre.load_image(apps[i].image1)
    gre.load_image(apps[i].image2)
    gre.load_image(apps[i].image3)
    
    gre.load_image(apps[i].blur1)
    gre.load_image(apps[i].blur2)
    gre.load_image(apps[i].blur3)
  end
    
  gre.set_data(data)
  
  gre.animation_trigger("AMBIENT_IndicatorLeft")
  gre.animation_trigger("AMBIENT_ImageSlides")
  gre.animation_trigger("AMBIENT_OverlayLines")
  gre.animation_trigger("AMBIENT_LaunchArrows")
  
  --setup the first set of images
  CB_SetupImages()
  get_ip_address()
end

--- @param gre#context mapargs
function CB_PressApp(mapargs) 
  
  local key
  --this will be nil if its coming from the auto loop, wont be if pressed
  if(mapargs.context_group ~= nil)then
    key = mapargs.context_group
  else
    key = mapargs
  end
  
  local id = gre.get_value(key..".id")
  local animData = {}
  local ctrlData = gre.get_control_attrs(key,"y")
  local ypos = ctrlData["y"]
  local xpos = gre.get_value(key..".indX")
  gre.animation_stop("AMBIENT_IndicatorLeft")
  
  
  if(id == prevSelectedID)then
    return
  end
  
  animData["context"] = key
  animData["id"] = id
  gre.animation_trigger("BUTTON_Select", animData)

  animData["context"] = prevSelectedKey
  animData["id"] = prevSelectedID
  gre.animation_trigger("BUTTON_Unselect", animData)
  
  animateIndicatorLeft(key, ypos, xpos)
    
  prevSelectedID = id
  prevSelectedKey = key
  
  
  gre.animation_trigger("TRANSITION_AppImages")
 -- CB_SetupImages()
end

--- @param gre#context mapargs
function CB_SetupImages(mapargs) 
  --get everything from the button variables (taken from the config data tables), fill up all of the images and stuff
  --use prev selected ID because the id is already setup
  local data = {}
  local dataTable = {}
    
  dataTable = gre.get_data(prevSelectedKey..".thumbOne",prevSelectedKey..".thumbTwo",prevSelectedKey..".thumbThree",
              prevSelectedKey..".blurOne",prevSelectedKey..".blurTwo",prevSelectedKey..".blurThree" )
  
    
  local img1 = tostring(dataTable[prevSelectedKey..".thumbOne"])
  local img2 = tostring(dataTable[prevSelectedKey..".thumbTwo"])
  local img3 = tostring(dataTable[prevSelectedKey..".thumbThree"])
  
  local blur1 = tostring(dataTable[prevSelectedKey..".blurOne"])
  local blur2 = tostring(dataTable[prevSelectedKey..".blurTwo"])
  local blur3 = tostring(dataTable[prevSelectedKey..".blurThree"])
  
  data["overlay.blurredImages.image1.image"] = blur1
  data["overlay.blurredImages.image2.image"] = blur2
  data["overlay.blurredImages.image3.image"] = blur3
  
  data["appImages1.image.image"] = img1
  data["appImages2.image.image"] = img2
  data["appImages3.image.image"] = img3
  data["falseAppImages1.image.image"] = img1
  data["falseAppImages2.image.image"] = img2
  data["falseAppImages3.image.image"] = img3
  
  gre.set_data(data)
  
  gre.animation_stop("AMBIENT_ImageSlides")
  gre.animation_trigger("AMBIENT_ImageSlides")
end

--- @param gre#context mapargs
function CB_LaunchAppPressed(mapargs) 
  local dataTable = {}
  dataTable = gre.get_data(prevSelectedKey..".app")
  launchingApp = tostring(dataTable[prevSelectedKey..".app"])
  
  gre.animation_trigger("TRANSITION_Launch")
end

function CB_Launch(mapargs)
  local data = {}
    
  data["model"] = gre.SCRIPT_ROOT..launchingApp
  gre.send_event_data("gre.load_app", "1s0 model", data)
  
  gre.quit()  
end


function CB_AutoLoop(mapargs)
  local tempID = prevSelectedID
  
  tempID = tempID + 1
  if(tempID >4)then
    tempID = 1
  end
  
  local tempSelected = "buttons.app"..tempID
  CB_PressApp(tempSelected)
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
    data["branding.ipaddress.text"] = tostring(ip_addr)
    gre.set_data(data)
    data_table["hidden"] = 0
  end
  
  gre.set_control_attrs("branding.ipaddress", data_table)  
end

function animateIndicatorLeft(incKey, incY, incX)
  
  local key = (incKey)
  local anim_data = {}
  
  local moveIndicator = gre.animation_create(60, 1)
  
  anim_data["key"] = "buttons.indicatorLeft.grd_y"
  anim_data["rate"] = "Swift"
  anim_data["duration"] = 600
  anim_data["offset"] = 0
  anim_data["to"] = incY + 7
  gre.animation_add_step(moveIndicator, anim_data)
  
  anim_data["key"] = "buttons.indicatorRight.grd_y"
  anim_data["rate"] = "Swift"
  anim_data["duration"] = 600
  anim_data["offset"] = 0
  anim_data["to"] = incY -16
  gre.animation_add_step(moveIndicator, anim_data)
  
  anim_data["key"] = "buttons.indicatorRight.grd_x"
  anim_data["rate"] = "Swift"
  anim_data["duration"] = 600
  anim_data["offset"] = 0
  anim_data["to"] = incX
  gre.animation_add_step(moveIndicator, anim_data)
  
  anim_data["key"] = "startAmbient"
  anim_data["rate"] = "Swift"
  anim_data["duration"] = 0
  anim_data["offset"] = 600
  anim_data["from"] = 0
  anim_data["to"] = 1
  gre.animation_add_step(moveIndicator, anim_data)
  
  gre.animation_trigger(moveIndicator)

end




