require "playback" 
local swipePress = 0 
local app = ""
local playbackFile = ""
require "config/config"
local screenSize
local AUTOMATED = 0

--this function is called on startup, when done the opening animation will spawn. Right now it is just a black box hiding
function startup()
  screenSize = gre.get_value("screenSize")
  --depending on the size of the screen we will require a different config file (screen size relates to board
  
  local fontSize
  local table
  if(screenSize == 272)then
    table =  apps_480x272
    fontSize = 14
  elseif(screenSize == 273)then
    table =  apps_480x272_V2
    fontSize = 14
  elseif(screenSize == 480)then
    table =  apps_800x480
    fontSize = 18
  elseif(screenSize == 481)then
    table =  apps_800x480_V2
    fontSize = 18
  elseif(screenSize == 482)then
    table =  apps_800x480_V3
    fontSize = 18
  elseif(screenSize == 600)then
    table =  apps_800x600
    fontSize = 18
  else
    print("Startup Script, cannot find table to fill fields")  
  end
  
  local automated_value = os.getenv("SB_AUTO")
  if automated_value ~= nil or AUTOMATED == 1 then
      if automated_value == "1" or AUTOMATED == 1 then
          local next = getNextPlayback()
          if next == nil or next == "" then
              next = table[1].next
          end
          gre.set_value("next", string.format("%s/../%s", gre.SCRIPT_ROOT, next))
          gre.send_event("startPlayback")
      end
  end
  
  --filling up the 3 areas
  local data = {}
  for i=1, 3 do
    local group = i+1
    data["block_layer.group"..group..".app"] = table[i].gapp_file 
    data["block_layer.group"..group..".next"] = table[i].next
    data["block_layer.group"..group..".text.text"] = table[i].name
    data["block_layer.group"..group..".textBG.width"] = getFontSize(table[i].name, fontSize)
    
    data["block_layer.group"..group..".desc"] = table[i].desc
    data["block_layer.group"..group..".icon"] = table[i].icon
    data["block_layer.group"..group..".image"] = table[i].thumb
  
    data["block_layer.group"..group..".img1"] = table[i].image01
    data["block_layer.group"..group..".img2"] = table[i].image02
    data["block_layer.group"..group..".img3"] = table[i].image03
  end

  gre.set_data(data)
--require "available_apps"
end

function startupLayer()
  local layerPrefs = {}
  if(MAINTOGGLE_bgAnimationOn == 0)then
    layerPrefs["hidden"] = 1
  else
    layerPrefs["hidden"] = 0
    gre.animation_trigger("bgAnimation")
    gre.animation_trigger("bgLines")
  end
  gre.set_layer_attrs("bgAdditions", layerPrefs)
end

--finds the size of the font string, and returns it + 10 for padding. Used for the background of the text for the blocks
function getFontSize(incString, incSize)
  local data = {}
  local width
  local size = tonumber(incSize)
  data = gre.get_string_size("fonts/Roboto-Medium.ttf", size, incString)
  width = data["width"]
  return(width + size)
end



function autoSelect()

end


function setupTransition(mapargs) 
  if automated_value ~= nil or AUTOMATED == 1 then
    setNextPlayback(gre.get_value(mapargs.context_group..".next"))
  end
  
  local xPos = gre.get_value(mapargs.context_group..".grd_x")
  local yPos = gre.get_value(mapargs.context_group..".grd_y")
  local width = gre.get_value(mapargs.context_group..".bg.grd_width")
  
  local data_table={}
  data_table["x"] = xPos
  data_table["y"] = yPos
  data_table["width"] = width  
  gre.set_control_attrs("block_layer.transitionOverlayBot",data_table)
  
  --print(width)
  swipePress = 0
  
  data_table = {}
  data_table["x"] = 0
  data_table["y"] = 0
  data_table["width"] = 743
  data_table["hidden"] = 0
  gre.set_control_attrs("open_layer.imgBG_group.img1", data_table)
  data_table["hidden"] = 1
  gre.set_control_attrs("open_layer.imgBG_group.img2", data_table)
  gre.set_control_attrs("open_layer.imgBG_group.img3", data_table)
  
  data_table ={}
  data_table = gre.get_data(mapargs.context_group..".img1", mapargs.context_group..".img2", mapargs.context_group..".img3", mapargs.context_group..".app",
                mapargs.context_group..".text.text",mapargs.context_group..".desc", mapargs.context_group..".nextPlayback" )
  local img1 = data_table[mapargs.context_group..".img1"]
  local img2 = data_table[mapargs.context_group..".img2"]
  local img3 = data_table[mapargs.context_group..".img3"]
  local appName = data_table[mapargs.context_group..".text.text"]
  local desc = data_table[mapargs.context_group..".desc"]
  app = gre.SCRIPT_ROOT..data_table[mapargs.context_group..".app"]
  
  local data = {}
  
  
  if(screenSize == 272)then
  elseif(screenSize == 480)then
    data["open_layer.desc.text"] = desc
  elseif(screenSize == 600)then
    data["open_layer.desc.text"] = desc
  else
  end  
  
  data["open_layer.imgBG_group.img1.img"]= img1
  data["open_layer.imgBG_group.img2.img"]= img2
  data["open_layer.imgBG_group.img3.img"]= img3
  data["open_layer.title.text"] = appName
    
  local light, med, dark
    
  light = gre.get_value(mapargs.context_group..".colLight")
  med = gre.get_value(mapargs.context_group..".colMed")
  dark = gre.get_value(mapargs.context_group..".colDark")

  data["block_layer.transitionOverlayBot.colourDark"] = dark
  data["block_layer.transitionOverlayBot.colourMed"] = med
  data["block_layer.transitionOverlayBot.colourLight"] = light
  
  gre.set_data(data)
end

  
function setupAbout(mapargs)

  local newWidth = gre.get_value(mapargs.context_group..".bg.grd_width")
  local data_table = {}
  data_table["width"] = newWidth
  gre.set_control_attrs("block_layer.aboutOpen.fillOverlay", data_table)

  gre.animation_trigger("aboutOpen")
end
--TIMER TO SET UP IF THE SCREEN IS IDLE
local idleTimer = {}
local appIdle = 1

function idle(mapargs)
  local animActive = gre.get_value("animActive")
  appIdle = 1
  local screen =  tonumber(gre.get_value("launcherLowEndImport2.screenOpen"))
  
  if(screen == 1)then
    gre.send_event("startIdleAnim")
  elseif(screen == 2)then
    stopSwipeAnim()
    gre.send_event("idleAnimBack")
  elseif(screen == 3)then
    if(animActive == 1)then
      return
    end
    gre.send_event("aboutToMain")
  end
  
--  appIdle = 1
--  print("app is now Idle")
--  gre.send_event("startIdleAnim")
end

function resetIdle(mapargs)
  local animActive = gre.get_value("animActive")    
  local idleTime = gre.get_value("idleTime")
  
  if(appIdle == 0)then
    cb_clear_timeout()  
  end

  if(appIdle == 1)then
    gre.send_event("stopIdleAnim")
  end
  
  if(animActive == 0)then
    idleTimer = gre.timer_set_timeout(idle,idleTime)
  end
  
  appIdle = 0
end

function checkAnim(mapargs)
  if(appIdle == 1)then
    gre.animation_trigger("animatedMovement")    
  end
end

function cb_clear_timeout()
  local data
  data = gre.timer_clear_timeout(idleTimer)
end

function swipeAnimCheck(mapargs) 
  
  if(swipePress==0)then
  gre.animation_trigger("screenshotsSwipe")
  end
  
end

function stopSwipeAnim(mapargs)
  swipePress=1
  gre.send_event("stopSwipeAnim")
end

function launchApp(mapargs) 

  local data = {}
  data["model"] = app
  gre.send_event_data("gre.load_app", "1s0 model", data)
  
  print(data["model"])
  gre.quit()  
      
end

function get_ip_address()
  local data = {}
  local ip_addr = get_ip()
  
  if ip_addr == nil then
    gre.timer_set_timeout(get_ip_address,10000)
  else
    data["logo_layer.ipaddress.text"] = tostring(ip_addr)
    gre.set_data(data)
  end
end


--- @param gre#context mapargs
function test(mapargs) 
  print(gre.get_value("playback"))
end
