require "dataTables"

local keypadString = ""
local keypadLength = 0
local submitOpen = 0

function Settings_ResetKeypad(mapargs)
  keypadString = ""
  keypadLength = 0
  submitOpen = 0
  
  local data ={}
  data["settings_layer.advanced.codeInput.codeText"] = keypadString
  gre.set_data(data)
  
    gre.animation_trigger("Settings_AdvancedReset")
end

function Settings_KeypadPress(mapargs) 

  local data = {}

  if(keypadLength <= 6)then
    keypadString = keypadString.."•"
    keypadLength = keypadLength + 1
    data["settings_layer.advanced.codeInput.codeText"] = keypadString
    
    local animData = {}
    animData["context"] = mapargs.context_control
    gre.animation_trigger("Settings_KeypadPress", animData)
    
  end
  if(keypadLength >= 4)then
    
    if(submitOpen == 0)then
      data["settings_layer.advanced.submit.alpha"] = 255
      submitOpen = 1
    else
    end
    
  end
  gre.set_data(data)
  
end


function Settings_AdvancedPress(mapargs) 
  if(submitOpen == 1)then
    gre.animation_trigger("Settings_Advanced")
  end
  
end


function Settings_IntervalRadial(mapargs) 
  local name = mapargs.context_control
  local activeControl = ""
  local animData = {}
  
  gre.animation_trigger("Settings_IntervalsRadialOff")
  
  if(name == "settings_layer.intervals.statPressArea")then
    animData["context"] = "settings_layer.intervals.radialButton_3"
    gre.animation_trigger("Settings_IntervalsRadialOn", animData)
     
  elseif(name == "settings_layer.intervals.programPressArea")then
    animData["context"] = "settings_layer.intervals.radialButton_2"
    gre.animation_trigger("Settings_IntervalsRadialOn", animData)
    
  elseif(name == "settings_layer.intervals.automaticPressArea")then
    animData["context"] = "settings_layer.intervals.radialButton_1"
    gre.animation_trigger("Settings_IntervalsRadialOn", animData)
  else
  end
  
end

local settings_IntervalCheckToggle = 0
function Settings_IntervalCheck(mapargs) 
  
  if(settings_IntervalCheckToggle == 0)then
    gre.animation_trigger("Settings_IntervalsCheckOn")
    settings_IntervalCheckToggle = 1
  else
    gre.animation_trigger("Settings_IntervalsCheckOff")
   settings_IntervalCheckToggle = 0
  end
  
end

local IntervalAnimActive = 0
function Settings_IntervalAnimationStart(mapargs)
  gre.animation_trigger("Settings_IntervalsAnimation")
  IntervalAnimActive = 1
end

function Settings_IntervalAnimationCheck(mapargs)
  if(IntervalAnimActive == 1)then
    gre.animation_trigger("Settings_IntervalsAnimation")
  end
end

function Settings_IntervalAnimationStop(mapargs)
  IntervalAnimActive = 0
  gre.animation_trigger("Settings_IntervalsAnimationEnd")
end


function Settings_FillTable(mapargs)
  
  local data = {}
  local dk_data = {}
  
  for i=1, table.maxn(CLINICIANS)do
    data["settings_layer.clinician.clinicianList.text."..i..".1"] = CLINICIANS[i].name
    data["settings_layer.clinician.clinicianList.img."..i..".1"] = CLINICIANS[i].imageThumb
    data["settings_layer.clinician.clinicianList.fillAlpha."..i..".1"] = 0
    data["settings_layer.clinician.clinicianList.lineAlpha."..i..".1"] = 100
  end
  gre.set_data(data)
  
  dk_data["rows"] = table.maxn(CLINICIANS)
  gre.set_table_attrs("settings_layer.clinician.clinicianList", dk_data) 
  
end

function Settings_ClinicianSelect(mapargs) 
  local data = {}
  
  local row = mapargs.context_row
  local name, list, image, number, active, pager
  
  name = CLINICIANS[row].name
  list = CLINICIANS[row].list
  image = CLINICIANS[row].image
  pager = CLINICIANS[row].pager
  number = CLINICIANS[row].number
  active = CLINICIANS[row].active
  
  data["settings_layer.clinician.DoctorName.text"] = name
  data["settings_layer.clinician.pagerData.text"] = pager
  data["settings_layer.clinician.activeData.text"] = active
  data["settings_layer.clinician.fileData.text"] = number
  data["settings_layer.clinician.DoctorPhoto.image"] = image
  --data["settings_layer.clinician.DoctorName"] = CLINICIANS[i].name
  
  gre.set_data(data)
  animationClinician(mapargs)
  
end

function Settings_FillTableProfiles(mapargs)
  
  local data = {}
  local dk_data = {}
  
  for i=1, table.maxn(PROFILES)do
    data["settings_layer.profiles.PatientList.text."..i..".1"] = PROFILES[i].name
    data["settings_layer.profiles.PatientList.img."..i..".1"] = PROFILES[i].imageThumb
    data["settings_layer.profiles.PatientList.fillAlpha."..i..".1"] = 0
    data["settings_layer.profiles.PatientList.lineAlpha."..i..".1"] = 100
  end
  gre.set_data(data)
  
  dk_data["rows"] = table.maxn(CLINICIANS)
  gre.set_table_attrs("settings_layer.profiles.PatientList", dk_data) 
  
end

function Settings_ProfilesSelect(mapargs) 
  local data = {}
  
  local row = mapargs.context_row
  local name, list, image, number, active, pager
  
  name = PROFILES[row].name
  list = PROFILES[row].list
  image = PROFILES[row].image
  pager = PROFILES[row].pager
  number = PROFILES[row].number
  active = PROFILES[row].active
  
  data["settings_layer.profiles.PatientName.text"] = name
  data["settings_layer.profiles.contactData.text"] = pager
  data["settings_layer.profiles.visitData.text"] = active
  data["settings_layer.profiles.fileData.text"] = number
  data["settings_layer.profiles.PatientPhoto.image"] = image
  --data["settings_layer.profiles.DoctorName"] = CLINICIANS[i].name
  
  gre.set_data(data)
  animationClinician(mapargs)
  
end

function animationClinician(mapargs)
  
  local index = mapargs.context_row
  local key = (mapargs.context_control)
  local anim_data = {}
  
  local pressClinician = gre.animation_create(60, 1)
  
  anim_data["key"] = key..".fillAlpha."..index..".1"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 155
  anim_data["offset"] = 0
  anim_data["from"] = 0
  anim_data["to"] = 100
  gre.animation_add_step(pressClinician, anim_data)
  
  anim_data["duration"] = 300
  anim_data["offset"] = 77
  anim_data["from"] = 100
  anim_data["to"] = 0
  gre.animation_add_step(pressClinician, anim_data)
    
  gre.animation_trigger(pressClinician)

end


function Review_SkeletonToggle(mapargs)

  local name = mapargs.context_control
  local animData = {}
  
  gre.animation_trigger("Review_ButtonUp")
  gre.animation_trigger("Review_HideText")

  
  
  if(name == "review_layer.skeletonReview.pressArea1")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_TextShow1")
     
  elseif(name == "review_layer.skeletonReview.pressArea2")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_TextShow2")
    
  elseif(name == "review_layer.skeletonReview.pressArea3")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_TextShow3")
  else
  end
  
end


function Review_CirculatoryToggle(mapargs)

  local name = mapargs.context_control
  local animData = {}
  
  gre.animation_trigger("Review_CirculatoryButtonUp")
  gre.animation_trigger("Review_CirculatoryHideText")

  
  
  if(name == "review_layer.circulatoryReview.pressArea1")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_CirculatoryTextShow1")
     
  elseif(name == "review_layer.circulatoryReview.pressArea2")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_CirculatoryTextShow2")
    
  elseif(name == "review_layer.circulatoryReview.pressArea3")then
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    animData["context"] = name
    gre.animation_trigger("Review_ButtonPress", animData)
    gre.animation_trigger("Review_CirculatoryTextShow3")
  else
  end
  
end

local function blockAction()
    local data = {}
    data["hidden"] = 0
    gre.set_control_attrs("blocker_layer.blocker",data)  
end

function unblockAction()
    local data = {}
    data["hidden"] = 1
    gre.set_control_attrs("blocker_layer.blocker",data)  
end

local goToScreen
function navigatePress(mapargs)
    local currentScreen = mapargs.context_screen
    goToScreen = gre.get_value(mapargs.context_group..".screen")
    
    if currentScreen == goToScreen then
        return
    end
    
    blockAction()
    
    local hideEvent = currentScreen.."Hide"
    gre.send_event(hideEvent) -- hide current screen
    gre.animation_trigger("App_bottomNavClear")
    
    local data = {}
    data.context = mapargs.context_group
    gre.animation_trigger("App_bottomNav", data)
end

function navigateToScreen(mapargs)
    gre.send_event(goToScreen.."Show")
end

function updatePulseNumber(mapargs) 
  local data = {}  
  local pulse = gre.get_value("home_layer.2_group.number")
  data["home_layer.2_group.value.text"] = pulse
  gre.set_data(data)
end


function updateTempNumber(mapargs) 
  local data = {}  
  local temp = gre.get_value("home_layer.4_group.number")
  temp = string.sub(temp,1,4)
  data["home_layer.4_group.value.text"] = temp.."°"
  gre.set_data(data)
end


function updateSpNumber(mapargs) 
  local data = {}  
  local sp = gre.get_value("home_layer.3_group.number")
  data["home_layer.3_group.value.text"] = sp
  gre.set_data(data)
end


function updateBpNumber(mapargs) 
  local data = {}  
  local bp1 = gre.get_value("home_layer.1_group.number")
  local bp2 = gre.get_value("home_layer.1_group.numberTwo")
  data["home_layer.1_group.value.text"] = bp1.."/"..bp2
  gre.set_data(data)
end

local function updateColoursLight()
    local data = {}
    data["green"] = 0x58A85C
    data["text_colour"] = 0x5B5B5B
    data["label_colour"] = 0x333333
    data["home_layer.data_bg_colour"] = 0xAAAAAA
    data["home_layer.data_bg_alpha"] = 63
    data["homeScreen.temp_colour"] = 0xB1B1B1
    data["settings_layer.intervals.ring_bg_colour"] = 0xD4D4D4
    data["settingsScreen.wipe_colour"] = 0xE4E4E4
    for i=1,3 do
        if gre.get_value(string.format("settings_layer.intervals.radialButton_%s.alpha",i)) == 255 then
            data[string.format("settings_layer.intervals.radialButton_%s.ringColour",i)] = 0x58A85C
        end
    end
    gre.set_data(data)
end

local function updateColoursDark()
    local data = {}
    data["green"] = 0x8DC53F
    data["text_colour"] = 0xFFFFFF
    data["label_colour"] = 0xCCCCCC 
    data["home_layer.data_bg_colour"] = 0x111111
    data["home_layer.data_bg_alpha"] = 255
    data["homeScreen.temp_colour"] = 0xFFFFFF
    data["settings_layer.intervals.ring_bg_colour"] = 0x333333
    data["settingsScreen.wipe_colour"] = 0x1B1B1B
    for i=1,3 do
        if gre.get_value(string.format("settings_layer.intervals.radialButton_%s.alpha",i)) == 255 then
            data[string.format("settings_layer.intervals.radialButton_%s.ringColour",i)] = 0x8DC53F
        end
    end
    gre.set_data(data)
end

local function updateImages(folder)
  local data = {}
  data["bg_top"] = folder.."bg_top.png"
  data["box_background"] = folder.. "1_box_control.9.png"
  data["crank_logo"] = folder.."logo.png" 
  data["top_bar"] = folder.."bar3.9.png"
  
  data["homeScreen.icon_alarm"] = folder.."alarm.png"
  data["homeScreen.trend_green_bottom"] = folder.."trendGreenBotOverlay.png"
  data["homeScreen.trend_green_fill"] = folder.."trendGreenLineFill.png"
  data["homeScreen.trend_green_line"] = folder.."trendGreenLine.png"
  data["homeScreen.trend_grid"] = folder.."trendGrid.png"
  data["homeScreen.trend_white_bottom"] = folder.."trendWhiteBotOverlay.png"
  data["homeScreen.trend_white_fill"] = folder.."trendWhiteLineFill.png"
  data["homeScreen.trend_white_line"] = folder.."trendWhiteLine.png"
  
  data["navigation_layer.green_bar"] = folder.."green_bar.9.png"
  data["navigation_layer.bg_bottom"] = folder.."bg_bottom.png"
  data["navigation_layer.bottom_buttons"] = folder .. "BottomButtons.png"
  data["navigation_layer.bottom_buttons_stroke"] = folder.."BottomButtonsStroke.png"
  
  data["patientScreen.body_back"] = folder.."body_back.png"
  data["patientScreen.body_front"] = folder.."body_front.png"
  data["patientScreen.pain_btn"] = folder.."pain_btn.png"
  data["patientScreen.pain_slider"] = folder.."pain_slider.9.png"
  data["patientScreen.toggle_no"] = folder.."tog_no.png"
  data["patientScreen.toggle_yes"] = folder.."tog_yes.png"
  for i=1,3 do
    data[string.format("patient_layer.switch%d.bgOff", i)] = folder.."bgOff.png"
    data[string.format("patient_layer.switch%d.bgOn", i)] = folder.."bgOn.png"
    data[string.format("patient_layer.switch%d.bgDot", i)] = folder.."bgDot.png"
    data[string.format("patient_layer.switch%d.fgDot", i)] = folder.."fgDot.png"
  end
  data["patient_layer.slider.dot"] = folder.."standardDot.png"
  data["patient_layer.slider.pressedOverlay"] = folder.."pressedOverlay.png"
  
  data["settings_layer.icon_confirm"] = folder.."greenArrowConfirm.png"
  data["settings_layer.intervals.intervalsActive.stroke"] = folder.."interval_stroke.png"
  
  data["crank_layer.3D_txt"] = folder .."model_support.png"
  data["crank_layer.collaboration"] = folder .."collaboration.png"
  data["crank_layer.collaboration_txt"] = folder .."Collaboration_Tools.png"
  data["crank_layer.div"] = folder .."div.png"
  data["crank_layer.preview_txt"] = folder .."Animation_Preview__Timeline.png"
  data["crank_layer.psd_txt"] = folder .."psd_txt.png"
  data["crank_layer.title1"] = folder .."Crank_Software.png"
  data["crank_layer.title2"] = folder .."Storyboard_Suite.png"
  data["crank_layer.website_txt"] = folder .."wwwcranksoftwarecom.png"
  
  gre.set_data(data)
end

local function updateUI(skin)
    local darkFolder = "images/dark_skin/"
    local lightFolder = "images/light_skin/"
    local folder = ""
    
    if skin == "light" then
      updateColoursLight()
      folder = lightFolder
    elseif skin == "dark" then 
      updateColoursDark()
      folder = darkFolder
    end
    updateImages(folder)
end

function ToggleSkin(mapargs)
    local skin = gre.get_value("navigation_layer.skinSwitch.skin")
    if skin == "light" then
        local data = {}
        data["navigation_layer.skinSwitch.skin"] = "dark"
        data["navigation_layer.skinSwitch.image"] = "images/light_btn.png"
        gre.set_data(data)
        skin = "dark"
    elseif skin == "dark" then
        local data = {}
        data["navigation_layer.skinSwitch.skin"] = "light"
        data["navigation_layer.skinSwitch.image"] = "images/dark_btn.png"
        gre.set_data(data)
        skin = "light"
    end
    updateUI(skin)
end

local trends_timer
function startTimer()
    if not trends_timer then
    trends_timer = gre.timer_set_interval(update_small_graphs,50)
    end
end

function checkTrendsStatus(mapargs) 
    if gre.get_value("home_layer.animateTrends") == 1 then  
        gre.animation_trigger("Home_Trends")
    else
       if trends_timer then
          gre.timer_clear_interval(trends_timer)
          trends_timer = nil
       end
    end
end

