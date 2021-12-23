--sizes of apps
smallAppSize = 800
largeAppSize = 1280
smallAppRatio = 0.625

--based on which mode you want to start on you set it here
local startOffsets = 1
--offset of the slider, allowed to set up different modes in which you want to start up in
local offsetDistanceSmall = -200
local offsetDistanceLarge = -300

function CBInit(mapargs)
  
  --done to all of the controls that use const sizes in code
  local size = getAppSize()
  setupHomeSizeOffsets(size)
  setupInteractionSizeOffsets(size)
  setupFontSizes(size)
  
  createForwardAnimations()
  numberSwitchAnimationSetup()
  createTempAnimations()
  tempNumberSwitchAnimSetup()
  
  tempNumberSpecialAnimSetup()
  timeNumberSpecialAnimSetuo()
  
  create_voiceAnim()
  anim_voiceLines()
  anim_voiceDots()
  anim_homeExtras()
  
  recipeVariablesSetup()
  
  --setup the position of the slider
  setupSliderStartPositions()
  setSelectedCookMode(startOffsets*offsetDistanceSmall)
  callExtrasAnimation()
  gre.animation_trigger('APP_jarvisIdle')
end

function setupHomeSizeOffsets(incSize)
  if incSize == smallAppSize then
    offsetDistanceSmall = offsetDistanceSmall * smallAppRatio
    offsetDistanceLarge = offsetDistanceLarge * smallAppRatio
  end
end

function setupSliderStartPositions()
  local layerData = {}
  layerData['xoffset'] = startOffsets*offsetDistanceSmall
  gre.set_layer_attrs_global("homeSliderLeft",layerData)
  gre.set_layer_attrs_global("homeSliderRight",layerData)
  layerData['xoffset'] = startOffsets*offsetDistanceLarge
  gre.set_layer_attrs_global("homeSliderMid",layerData)
end

--- @param gre#context mapargs
function CBHideHomeLayers(mapargs) 
  setupSliderStartPositions()
  setSelectedCookMode(startOffsets*offsetDistanceSmall)
  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs_global('fakeBackgroundOverlay',layerData)
  gre.set_control_attrs("background.backgroundAnimated",layerData)
  layerData['hidden'] = 1
  gre.set_layer_attrs_global('homeAllCookModes', layerData)
  gre.set_layer_attrs_global('homeSelection', layerData)
  gre.set_layer_attrs_global('homeSliderLeft', layerData)
  gre.set_layer_attrs_global('homeSliderRight', layerData)
  gre.set_layer_attrs_global('homeSliderMid', layerData)
  gre.set_layer_attrs_global('homeAllCookModes', layerData)
  gre.set_layer_attrs_global('voiceActivationHeader', layerData)
  gre.set_control_attrs("homeAllCookModes.smartCook.selected",layerData)
  gre.set_control_attrs("homeAllCookModes.smartCook.unselected",layerData)
  gre.set_control_attrs("homeSelection.sliderFadeLeft",layerData)
  gre.set_control_attrs("homeSelection.sliderFadeRight",layerData)
  gre.set_control_attrs("homeSelection.centerCircleOverlay",layerData)
end

function CBHideCookingLayer(mapargs)

  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs_global('voiceActivationHeader',layerData)
  layerData['hidden'] = 1
  gre.set_layer_attrs_global('cooking',layerData)

end

function recipeVariablesSetup()

  local data = {}
  data["recipeSelectionCenter.outsideLines.alpha"] = 0
  data["recipeSelectionCenter.recipeTop_group.recipeText"] = 0
  data["recipeSelectionCenter.recipeTop_group.recipeBG"] = 0
  data["recipeSelectionCenter.cancel_group.cancelLines"] = 0
  data["recipeSelectionCenter.cancel_group.cancelText"] = 0

end
