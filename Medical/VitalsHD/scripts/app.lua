APP_IDLE_TIME = 15000

local currentScreen = "menu.vitalsButton"

local function closeMenu()
  CBnaviToggleMenu()
end

local function newScreen()
  --switch to the screen and trigger the screen show animation
  if(currentScreen == "menu.vitalsButton")then
    gre.send_event("APP_toVitals")
    gre.animation_trigger("APP_showVitals")
  elseif(currentScreen == "menu.patientButton")then
    gre.send_event("APP_toPatient")
    gre.animation_trigger("APP_showPatient")
  elseif(currentScreen == "menu.IVButton")then
    gre.send_event("APP_toIV")
    gre.animation_trigger("APP_showIV")
  elseif(currentScreen == "menu.systemButton")then
    gre.send_event("APP_toSystem")
    gre.animation_trigger("APP_showSystem")
  end
  
end

function CBPressMenu(mapargs)

  local pressedButton = mapargs.context_group
  
  if(currentScreen == pressedButton)then
    return
  end
  
  --trigger the menu animation and the screen hide animation when pressed
  if(currentScreen == "menu.vitalsButton")then
    gre.animation_trigger("APP_hideVitals")
  elseif(currentScreen == "menu.patientButton")then
    gre.animation_trigger("APP_hidePatient")
    gre.animation_trigger("PATIENT_closeSymptom")
    resetScreen()
    
  elseif(currentScreen == "menu.IVButton")then
    gre.animation_trigger("APP_hideIV")
  elseif(currentScreen == "menu.systemButton")then
    gre.animation_trigger("APP_hideSystem")
    resetSystemArea()
    --hide and reset the screen
  end
  
  if(pressedButton == "menu.vitalsButton")then
    gre.animation_trigger("MENU_pressVitals")
  elseif(pressedButton == "menu.patientButton")then
    gre.animation_trigger("MENU_pressPatient")
  elseif(pressedButton == "menu.IVButton")then
    gre.animation_trigger("MENU_pressIV")
  elseif(pressedButton == "menu.systemButton")then
    gre.animation_trigger("MENU_pressSystem")
  end
  
  currentScreen = pressedButton
  gre.timer_set_timeout(closeMenu,1140)
  gre.timer_set_timeout(newScreen,1000)
  --startScreenTransition

end

function CBnaviToggleMenu()
  local toggle = gre.get_value("menu.menuButton.open")
  
  if(toggle == 0)then
    toggle = 1
    gre.animation_trigger("APP_MenuOpen")
  else
    toggle = 0
    gre.animation_trigger("APP_MenuClose")
  end
  local data = {}
  data["menu.menuButton.open"] = toggle
  gre.set_data(data)
end

local idleTimer = nil

local function homeScreenReset()

  idleTimer = nil
    
  if(currentScreen == "menu.vitalsButton")then
    return
  end
  
  if(currentScreen == "menu.patientButton")then
    gre.animation_trigger("APP_hidePatient")
    gre.animation_trigger("PATIENT_closeSymptom")
    resetScreen()
  elseif(currentScreen == "menu.IVButton")then
    gre.animation_trigger("APP_hideIV")
  elseif(currentScreen == "menu.systemButton")then
    gre.animation_trigger("APP_hideSystem")
  end

  currentScreen = "menu.vitalsButton"
  
  local data = {}
  data["menu.vitalsButton.vitals.image"] = "images/VitalsBlue.png"
  data["menu.systemButton.system.image"] = "images/system.png"
  data["menu.patientButton.patient.image"] = "images/patient1.png"
  data["menu.IVButton.IVSetup.image"] = "images/IV_setup1.png"
  gre.set_data(data)
  
  gre.timer_set_timeout(newScreen,1000)

end


function CBIdle()
  if(idleTimer ~= nil)then
    gre.timer_clear_timeout(idleTimer)
  end
  
  idleTimer = gre.timer_set_timeout(homeScreenReset,APP_IDLE_TIME)
end

function CBPreloadImages()
  gre.load_image("images/Ellipsebg_2.png")
  gre.load_image("images/outerDots.png")
  gre.load_image("images/outerBG.png")
  gre.load_image("images/outerArc.png")
  gre.load_image("images/outerDots1.png")
  gre.load_image("images/outerLine.png")
end


--ip adress stuff
local myenv = gre.env({ "target_os", "target_cpu" })

function get_ip_linux()
  local ip_addr = nil
  local f = assert( io.popen("/sbin/ifconfig"))

  for line in f:lines() do
    if line:match("%sinet addr:") ~= nil then
      ip_addr=line:match("%d+.%d+.%d+.%d+")      
      print(ip_addr)
      break   -- lets take the first IP address which should be eth0
    end
    -- debian ifconfig displays differently
    if line:match("%sinet") ~= nil then
      ip_addr=line:match("%d+.%d+.%d+.%d+")      
      print(ip_addr)
      break   -- lets take the first IP address which should be eth0
    end
  end 

  f:close()
  return(ip_addr)
end

function get_ip_win32()
  local ip_addr = nil
  local f = assert( io.popen("ipconfig"))
  
  for line in f:lines() do
    if line:match("%sIPv4 Address") ~= nil then
      ip_addr=line:match("%d+.%d+.%d+.%d+")
      print(ip_addr)
    end
  end 

  f:close()
  return(ip_addr)
end

function get_ip_qnx()
  local ip_addr = nil
  local f = assert( io.popen("cat /pps/services/networking/interfaces/wm0"))
  
  for line in f:lines() do
    if string.find(line, "ip_addresses", 1) == 1 then 
      ip_addr=line:match("%d+.%d+.%d+.%d+")
      print(ip_addr)
    end
  end -- for loop
     
  f:close()
  return(ip_addr)
end


function get_ip_address()
  local data = {}
  print('ip address:')
  
  local ip_addr = get_ip()
  if ip_addr == nil then
    data["settingsDevice.software.ipData.text"] = '--'
    data["bg.ipAddress.text"] = '--'
    gre.set_data(data)
    gre.timer_set_timeout(get_ip_address,10000)
  else
    --data["logo_layer.ipaddress.text"] = tostring(ip_addr)
    data["settingsDevice.software.ipData.text"] = tostring(ip_addr)
    data["bg.ipAddress.text"] = tostring(ip_addr)
    gre.set_data(data)
  end

end

function get_ip()
  local ip_addr = nil
  if myenv["target_os"] == "qnx" then
    ip_addr = get_ip_qnx()   
  elseif myenv["target_os"] == "win32" then
    ip_addr = get_ip_win32()      
  elseif myenv["target_os"] == "linux" then
    ip_addr = get_ip_linux()
  else
    print("Can't get IP, unsupported OS : " ..  myenv["target_os"] )
  end
  
  return(ip_addr)
end