local selectedCookMode = ""
local prevSelectedCookMode = ""
local activeSetupToggle = 'cook'
local largeFont = 36
local smallFont = 30
local pressPositionOffset = 100


--these names must match the "ALL COOK MODES" layer control names on the homescreen
cookModes = {
  energy =    {name = "Recipe",           sliderPos = {400, -1200},   quickStartValue = "Quiche", setup = "recipe"},
  warm =      {name = "Warm",             sliderPos = {200, -1400},   quickStartValue = "Moist",  setup = "warm"},
  selfClean = {name = "Self Clean",       sliderPos = {0, -1600},     quickStartValue = "Steam",  setup = "selfClean"},
  smartCook = {name = "Smart Cook",       sliderPos = {-200, -1800},  quickStartValue = 350,      setup = "bake"},
  bake =      {name = "Bake",             sliderPos = {-400, -2000},  quickStartValue = 350,      setup = "bake"},
  broil =     {name = "Broil",            sliderPos = {-600, -2200},  quickStartValue = "High",   setup = "broil"},
  convBake =  {name = "Convection Bake",  sliderPos = {-800, 800},    quickStartValue = 375,      setup = "bake"},
  roast =     {name = "Roast",            sliderPos = {-1000, 600},   quickStartValue = 400,      setup = "bake"}
}

function setupFontSizes(incSize)
  if incSize == smallAppSize then
    largeFont = math.floor(largeFont * smallAppRatio)
    smallFont = math.floor(smallFont * smallAppRatio)
    pressPositionOffset = pressPositionOffset * smallAppRatio
    
  cookModes = {
    energy =    {name = "Recipe",           sliderPos = {400* smallAppRatio,    -1200* smallAppRatio},  quickStartValue = "Quiche", setup = "recipe"},
    warm =      {name = "Warm",             sliderPos = {200* smallAppRatio,    -1400* smallAppRatio},  quickStartValue = "Moist",  setup = "warm"},
    selfClean = {name = "Self Clean",       sliderPos = {0* smallAppRatio,      -1600* smallAppRatio},  quickStartValue = "Steam",  setup = "selfClean"},
    smartCook = {name = "Smart Cook",       sliderPos = {-200* smallAppRatio,   -1800* smallAppRatio},  quickStartValue = 350,      setup = "bake"},
    bake =      {name = "Bake",             sliderPos = {-400* smallAppRatio,   -2000* smallAppRatio},  quickStartValue = 350,      setup = "bake"},
    broil =     {name = "Broil",            sliderPos = {-600* smallAppRatio,   -2200* smallAppRatio},  quickStartValue = "High",   setup = "broil"},
    convBake =  {name = "Convection Bake",  sliderPos = {-800* smallAppRatio,     800* smallAppRatio},  quickStartValue = 375,      setup = "bake"},
    roast =     {name = "Roast",            sliderPos = {-1000* smallAppRatio,    600* smallAppRatio},  quickStartValue = 400,      setup = "bake"}
  }
  end
end

local function setHomeText(incMode)
  
  if(prevSelectedCookMode == selectedCookMode)then
    return
  end
  
  local data = {}
  data["homeSelection.centerText_group.cookMode.text"] = string.upper(cookModes[incMode].name)
  if(string.len(cookModes[incMode].name) > 10)then
    data["homeSelection.centerText_group.cookMode.fontSize"] = smallFont
  else
    data["homeSelection.centerText_group.cookMode.fontSize"] = largeFont
  end
  data["homeSelection.centerText_group.quickStartMode.text"] = string.upper(tostring(cookModes[incMode].quickStartValue))
  gre.set_data(data)
  
  --fade in cook mode selected, fade out unselcted
  anim_cookModesBannerFade(selectedCookMode, prevSelectedCookMode)
  
end

function setSelectedCookMode(incPos)

  --print(incPos)
  local selectedMin, selectedMax
  
  for mode, modeData in pairs(cookModes) do    
  --set all of the groups to be unselected
    
    for i = 1, #modeData.sliderPos do
      --print(mode, modeData.sliderPos[i])
      --since the size of the control+padding is 200, we check for 100 on either side of the control to set the text
      selectedMin = modeData.sliderPos[i] - pressPositionOffset
      selectedMax = modeData.sliderPos[i] + pressPositionOffset
      
      if(incPos > selectedMin and incPos < selectedMax)then
        selectedCookMode = mode
        setHomeText(mode)
        prevSelectedCookMode = selectedCookMode
        --return
      end
    end
        
  end

end



--- @param gre#context mapargs
function CBHomeOpenSetup(mapargs) 
  --selectedCookMode
  local pressedSetup = cookModes[selectedCookMode].setup
  --print(pressedSetup)
  if(pressedSetup == 'recipe')then
    gre.send_event('goToRecipeScreen')
    gre.timer_set_timeout(function()
        local layerData = {}
        layerData['hidden'] = 1
        gre.set_layer_attrs_global("recipeUnavailable",layerData)
      end,
    5000)
    return
  end
  
  if(pressedSetup == 'selfClean')then
    startSelfClean()
    return
  end
  
  cookingRequest.mode = selectedCookMode
  setupToggles(pressedSetup)

  gre.animation_trigger('HOME_pressSetup')
  
  gre.timer_set_timeout(function()
    gre.animation_trigger('POPUP_open')
  end,50)

  gre.timer_set_timeout(function()
    local layerData = {}
    layerData['hidden'] = 0
    --gre.set_layer_attrs('popupBG',layerData)
    gre.set_layer_attrs('setupToggles',layerData)
    
    if(pressedSetup == 'bake')then
      gre.animation_trigger('SETUP_showTemp')      
    elseif(pressedSetup == 'broil')then
      gre.animation_trigger('SETUP_showBroil')
    elseif(pressedSetup == 'warm')then
      gre.animation_trigger('SETUP_showWarm')
    end
  end,550)
  
  --reset the starting timer numbers here to make sure the animations are completed before stopping
  --TODO: SETUP A FUNCTION TO RESET ALL OF THE COOKING THINGS
  setupMorphStartingTimerNumbers(0)
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("timerExpiredOverlay",layerData)
  CBSmartToggleToCook()
  
end

function CBSetupCookToggleActive()
  local pressedSetup = cookModes[selectedCookMode].setup
  
  gre.animation_trigger('SETUP_toggleCooking')
  
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs('setupTimeOverlay',layerData)
  
  layerData['hidden'] = 0
  if(pressedSetup == 'bake')then
    gre.animation_trigger('SETUP_showTemp')
  elseif(pressedSetup == 'broil')then
    gre.set_layer_attrs('setupBroil',layerData)
  elseif(pressedSetup == 'warm')then
    gre.set_layer_attrs('setupWarm',layerData)
  end
end

function CBSetupTimerToggleActive()

  gre.animation_trigger('SETUP_toggleTimer')

  local layerData = {}
  layerData['hidden'] = 0
  gre.animation_trigger('SETUP_showTime')
  --gre.set_layer_attrs('setupTimeOverlay',layerData)
  layerData['hidden'] = 1
  gre.set_layer_attrs('setupWarm',layerData)
  gre.set_layer_attrs('setupBroil',layerData)
  gre.set_layer_attrs('setupTempOverlay',layerData)
end

function getSelectedCookMode()
  return selectedCookMode
end