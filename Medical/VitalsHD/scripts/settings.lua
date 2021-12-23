local prevScreen = "settingNavigation.group1"

--1, 2, 3, reports, advanced, device

local function screenSwap()
  if(prevScreen == "settingNavigation.group1")then
    gre.animation_trigger("SYSTEM_toReports")
  elseif(prevScreen == "settingNavigation.group2")then
    gre.animation_trigger("SYSTEM_toAdvanced")
  elseif(prevScreen == "settingNavigation.group3")then
    gre.animation_trigger("SYSTEM_toDevice")
  end 
end

function CBselectSubScreen(mapargs)
  local incScreen = mapargs.context_group
  if(incScreen == prevScreen)then
    return
  end
  
  local animData = {}
  animData["context"] = prevScreen
  gre.animation_trigger("SYSTEM_releaseNav", animData)
  animData["context"] = incScreen
  gre.animation_trigger("SYSTEM_pressNav", animData)
  
  if(prevScreen == "settingNavigation.group1")then
    gre.animation_trigger("SYSTEM_fromReports")
  elseif(prevScreen == "settingNavigation.group2")then
    gre.animation_trigger("SYSTEM_fromAdvanced")
  elseif(prevScreen == "settingNavigation.group3")then
    gre.animation_trigger("SYSTEM_fromDevice")
  end
  
  prevScreen = incScreen
  gre.timer_set_timeout(screenSwap,300)

end

function resetSystemArea()
    local animData = {}
    animData['id'] = 1
    animData['context'] = "settingNavigation.group2"
    gre.animation_trigger('SYSTEM_releaseNav', animData)
    animData['id'] = 2
    animData['context'] = "settingNavigation.group3"
    gre.animation_trigger('SYSTEM_releaseNav', animData)
    animData['id'] = 3
    animData['context'] = "settingNavigation.group1"
    gre.animation_trigger('SYSTEM_pressNav', animData)
    prevScreen = "settingNavigation.group1"
end

local inputNum = ""
local inputTimer
local coldStartAdvanced = 1

local function hidePass()
  
  local length = string.len(inputNum)
  inputNum = ""
  for i = 1, length do
    inputNum = inputNum.."*" 
  end
  inputTimer = nil
  
  local data = {}
  data["settingsAdvanced.input.time.text"] = inputNum
  gre.set_data(data)
    
end

local function clearTimeout()
  local data
  data = gre.timer_clear_timeout(inputTimer)
end

function CBinputAdvancedNumber(mapargs)

  if(inputTimer ~= nil)then
    clearTimeout()
  end
  
  --change the input into asterixes if there is another incoming number or a timer times out
  if(string.len(inputNum) > 0)then
    local length = string.len(inputNum)
    inputNum = ""
    for i = 1, length do
      inputNum = inputNum.."*" 
    end
  end
  
  if(string.len(inputNum) > 5)then
    if(coldStartAdvanced == 1)then
      gre.animation_trigger("SYSTEM_showUnlock")
      coldStartAdvanced = 0
    end
  end

  local incNum = gre.get_value(mapargs.context_group..".num")
  inputNum = inputNum..incNum

  local data = {}
  data["settingsAdvanced.input.time.text"] = inputNum
  gre.set_data(data)
  
  inputTimer = gre.timer_set_timeout(hidePass,750)

end


local prevReport = "settingsReportsList.report1"
local prevID = 1

function CBPressReport(mapargs)
  local incReport = mapargs.context_group
  if (incReport == prevReport)then
    return
  end
  
  local doctor = gre.get_value(mapargs.context_group..".doctor.text")
  local patient = gre.get_value(mapargs.context_group..".patient.text")
  local date = gre.get_value(mapargs.context_group..".date.text")
  
  local data = {}
  data["settingReports.doc"] = doctor
  data["settingReports.patient"] = patient
  data["settingReports.date"] = "last visit: "..date
  
  gre.set_data(data)
  
  gre.animation_trigger("SYSTEM_reportTransition")
  
  local id = gre.get_value(mapargs.context_group..".id")
  local animData = {}
  animData["context"] = incReport
  animData["id"] = id
  gre.animation_trigger("SYSTEM_pressReport", animData)
  animData["context"] = prevReport
  animData["id"] = prevID
  gre.animation_trigger("SYSTEM_releaseReport", animData)
  
  prevReport = incReport
  prevID = id
end