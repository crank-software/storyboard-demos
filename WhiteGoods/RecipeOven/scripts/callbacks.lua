local cookType = 0
local sliderPressed = nil

--- @param gre#context mapargs
function cb_init(mapargs) 
--init stuff here
end

--- @param gre#context mapargs
function recipeThumb(mapargs) 
  local dataTable = {}
  local data = {}
  local threeD = gre.get_value("applicationType")
  
  dataTable = gre.get_layer_attrs("sideListRecipe","yoffset")
  local layerOffset = dataTable["yoffset"]
  --print("in recipeThumb"..layerOffset)
  
  --setting up a scrollbar
  local scrollY = (380*(math.abs(layerOffset)))/821
  
  if(layerOffset > 0)then
    scrollY = 0
  elseif(layerOffset < -821)then
    scrollY = 380
  end
  
  local scrollData = {}
  scrollData["y"] = scrollY
  gre.set_control_attrs("scrollBar.scrollBar", scrollData)
  data["scrollBar.scrollBar.y"] = -scrollY
  
  --end of setting up a scrollbar
  
  
  local offsets = {}
  for i=1, 10 do
    dataTable = gre.get_control_attrs("sideListRecipe.recipeThumb"..i,"y")
    offsets[i] = dataTable["y"] + layerOffset - 182 --(Half the screen, with the size of the control and shadow taken into account. So the 3D affect looks right (at 0) when in the center)

    
    --neagtive offset, negative spin
    local tempRot = offsets[i]/4 
    local tempX = offsets[i]/5 
    if(tempRot>0)then
      -- if greater then 0, subtract by 5
      tempRot = tempRot - 5
      if(tempRot<0)then
        tempRot = 0
      end
    else
      --if less then 0, add 5
      tempRot = tempRot + 5
      if(tempRot>0)then
        tempRot = 0
      end  
    end
    
    local ctrldata = {}
    ctrldata["x"] = -(math.abs(tempX)) + 12
    gre.set_control_attrs("sideListRecipe.recipeThumb"..i,ctrldata)
    
    if(threeD == 1)then
      data["sideListRecipe.recipeThumb"..i..".yRot"] = tempRot
    end
    --print("rot for "..i.." is "..tempRot)
    
  end
  
  gre.set_data(data)

  
end


function cb_bakeBroilToggle(mapargs)

  --if cookType is 0, then its broil, cookType is 1, is bake
  local incCookType = gre.get_value(mapargs.context_group..".cookType")

  if(incCookType == cookType)then
    return
  end
  
  local animData = {}
  if(incCookType == 0)then
    --trigger animation for both sets of selects
    animData["context"] = "setupOven.broil"
    animData["id"] = 13
    gre.animation_trigger("SETUP_BakeBroilUnselect", animData)
    animData["context"] = "ovenBaking.broil"
    animData["id"] = 23
    gre.animation_trigger("SETUP_BakeBroilUnselect", animData)
    
    animData["context"] = "setupOven.bake"
    animData["id"] = 10
    gre.animation_trigger("SETUP_BakeBroilSelect", animData)
    animData["context"] = "ovenBaking.bake"
    animData["id"] = 20
    gre.animation_trigger("SETUP_BakeBroilSelect", animData)
    
    
  else
    --trigger animation for both sets of selects
    animData["context"] = "setupOven.bake"
    animData["id"] = 12
    gre.animation_trigger("SETUP_BakeBroilUnselect", animData)
    animData["context"] = "ovenBaking.bake"
    animData["id"] = 22
    gre.animation_trigger("SETUP_BakeBroilUnselect", animData)
    
    animData["context"] = "setupOven.broil"
    animData["id"] = 11
    gre.animation_trigger("SETUP_BakeBroilSelect", animData)
    animData["context"] = "ovenBaking.broil"
    animData["id"] = 21
    gre.animation_trigger("SETUP_BakeBroilSelect", animData)
  end
  cookType = incCookType
end

--- @param gre#context mapargs
function ovenSlider_Press(mapargs) 

  local passedControl
  local pressedControl = mapargs.context_group
  if(pressedControl == "setupOven.tempButton")then
    passedControl = 1
  elseif(pressedControl == "setupOven.timeButton")then
    passedControl = 2
  elseif(pressedControl == "ovenBaking.tempButton")then
    passedControl = 3
  elseif(pressedControl == "ovenBaking.timeButton")then
    passedControl = 4
  end
  
  setupContext(passedControl)
  local animData = {}
  animData["context"] = pressedControl
  gre.animation_trigger("SETUP_OpenButton", animData)
end

local openLeftCtrl, openRightCtrl, openButton
local tempOneSliderPos = 0
local tempTwoSliderPos = 0
local timeSliderPos = 0


local direction, amount
local sliderTimer = nil
local sliderPosition = 400
local linePosition = 0

function setupContext(incContext)

  local ctrlData = {}
  --temp On setup
  if(incContext == 1)then
   
    ctrlData["hidden"] = 0
    gre.set_control_attrs("setupOven.tempPosition",ctrlData)
  
    sliderPressed = "setupOven.tempPosition"
    openLeftCtrl = "setupOven.tempOpenLeft"
    openRightCtrl = "setupOven.tempOpenRight"
    openButton = "setupOven.tempButton"
    
    gre.animation_trigger("SETUP_OpenTempSlider")
  --time On Setup
  elseif(incContext == 2)then
  
    ctrlData["hidden"] = 0
    gre.set_control_attrs("setupOven.timePosition",ctrlData)
  
    sliderPressed = "setupOven.timePosition"
    openLeftCtrl = "setupOven.timeOpenLeft"
    openRightCtrl = "setupOven.timeOpenRight"
    openButton = "setupOven.timeButton"
    
    gre.animation_trigger("SETUP_OpenTimeSlider")
    
  --temp on Baking
  elseif(incContext == 3)then
  
    ctrlData["hidden"] = 0
    gre.set_control_attrs("ovenBaking.tempPosition",ctrlData)
  
    sliderPressed = "ovenBaking.tempPosition"
    openLeftCtrl = "ovenBaking.tempOpenLeft"
    openRightCtrl = "ovenBaking.tempOpenRight"
    openButton = "ovenBaking.tempButton"
    
    gre.animation_trigger("SETUP_OpenTempSliderTwo")  
  
  elseif(incContext == 4)then
  
    ctrlData["hidden"] = 0
    gre.set_control_attrs("ovenBaking.timePosition",ctrlData)
  
    sliderPressed = "ovenBaking.timePosition"
    openLeftCtrl = "ovenBaking.timeOpenLeft"
    openRightCtrl = "ovenBaking.timeOpenRight"
    openButton = "ovenBaking.timeButton"
    
    gre.animation_trigger("SETUP_OpenTimeSliderTwo")  
  
  else
  end
  
end

--- @param gre#context mapargs
function ovenSlider_Update(mapargs) 
  if(sliderPressed == nil)then
    return
  end
  
  local locX = mapargs.context_event_data.x
  local control = gre.get_control_attrs(sliderPressed, "x")
  local xOffset = locX - control["x"] - 175
  amount = math.abs(xOffset / 5)
  
  if(xOffset < 0)then
    --print("moving Left")
    direction = 0
  else
    --print("moving Right")
    direction = 1
  end
  
--TODO: Your code goes here...
  if(sliderTimer ~= nil)then
    local data
    data = gre.timer_clear_interval(sliderTimer)
    sliderTimer = nil
    updatePos()
  end
  
  sliderTimer = gre.timer_set_interval(updatePos,25)
  
  local ctrlData = {}
  ctrlData["x"] = 355 + xOffset
  gre.set_control_attrs(openButton,ctrlData)
  ctrlData = {}
  ctrlData["width"] = 384 +xOffset
  gre.set_control_attrs(openLeftCtrl,ctrlData)
  ctrlData = {}
  ctrlData["x"] = 384 + xOffset + 14
  ctrlData["width"] = 384 -xOffset
  gre.set_control_attrs(openRightCtrl,ctrlData)

  
end

function updatePos()

  if(sliderPressed == "setupOven.tempPosition")then
    sliderPosition = tempOneSliderPos
  elseif(sliderPressed == "ovenBaking.tempPosition")then
    sliderPosition = tempOneSliderPos
  elseif(sliderPressed == "setupOven.timePosition")then
    sliderPosition = timeSliderPos
  elseif(sliderPressed == "ovenBaking.timePosition")then
    sliderPosition = timeSliderPos
  end
  --pull sliderPosition from the saved slider pos based on pressed slider
 
  --print(direction, amount)
  
  local newAmount, lineAmount
  
  if(direction == 1)then
    newAmount = -math.floor(amount)
  else
    newAmount = math.floor(amount)
  end
  --sets up our number
  sliderPosition = sliderPosition - newAmount
  
  if(sliderPosition <0)then
    sliderPosition = 0
  elseif(sliderPosition >3963)then
    sliderPosition = 3963
  else
  end
    
  local data = {}
  --setup the first line
  data[openLeftCtrl..".xPos"] = -sliderPosition +382 --offset the width of the control to "center up"
  data[openLeftCtrl..".xPosTwo"] = -sliderPosition + 1963 +382 --offset thje width of the control and first image
  data[openRightCtrl..".xPos"] = -sliderPosition
  data[openRightCtrl..".xPosTwo"]  = -sliderPosition + 1963
  
  --round to nearest 5
  
  --setup temp number
  local tempNumber = math.floor(((sliderPosition * 400) / 3963)+150)
  local timeNumber = math.floor(((sliderPosition * 300) / 3963)) --puts it between 0 and 600 minutes (10 hrs)
  local hour = math.floor(timeNumber / 60)
  local min = timeNumber - (hour * 60)
  if(string.len(min) == 1)then
    min = "0"..min
  end
  
  --sliderTimer = nil
  
  --set the slide pos based on the open slider
  if(sliderPressed == "setupOven.tempPosition")then
    tempOneSliderPos = sliderPosition
    data[openButton..".text.text"] = tempNumber.."°F"
    --set the oven baking on to keep it the same
    data["ovenBaking.tempButton.text.text"]  = tempNumber.."°F"
    data["ovenBaking.time.temp.f"] = tempNumber
  
  elseif(sliderPressed == "ovenBaking.tempPosition")then
    tempOneSliderPos = sliderPosition
    data[openButton..".text.text"] = tempNumber.."°F"
    data["setupOven.tempButton.text.text"] = tempNumber.."°F"
    data["ovenBaking.time.temp.f"] = tempNumber
    
  elseif(sliderPressed == "setupOven.timePosition" or sliderPressed == "ovenBaking.timePosition")then
    timeSliderPos = sliderPosition
    --data[openButton..".text.text"] = hour.."h"..min.."m"
    data["ovenBaking.timeButton.text.text"] = hour.."h"..min.."m"
    data["setupOven.timeButton.text.text"] = hour.."h"..min.."m"
    data["ovenBaking.time.time.h"] = hour
    data["ovenBaking.time.time.m"] = min
   
  end
  
  gre.set_data(data)
end

--- @param gre#context mapargs
function ovenSlider_Release(mapargs) 
  if(sliderPressed == nil)then
    return
  end
  
  if(sliderTimer ~= nil)then
    local data
    data = gre.timer_clear_interval(sliderTimer)
    sliderTimer = nil
  end
  
  
  local ctrlData = {}
  ctrlData["hidden"] = 1
  gre.set_control_attrs(sliderPressed,ctrlData)
  
  local animData = {}
  animData["context"] = openButton
  gre.animation_stop("SETUP_OpenButton", animData)
  gre.animation_trigger("SETUP_CloseButton", animData)
  
  
  --due to the fact of the way the sliders work (doubled up) we have to call seperate animations
  if(openButton == "setupOven.tempButton")then
    gre.animation_stop("SETUP_OpenTempSlider")
    gre.animation_trigger("SETUP_CloseTempSlider")
  
  elseif(openButton == "setupOven.timeButton")then
    gre.animation_stop("SETUP_OpenTimeSlider")
    gre.animation_trigger("SETUP_CloseTimeSlider")
  
  elseif(openButton == "ovenBaking.tempButton")then
    gre.animation_stop("SETUP_OpenTempSliderTwo")
    gre.animation_trigger("SETUP_CloseTempSliderTwo")
    
  elseif(openButton == "ovenBaking.timeButton")then
    gre.animation_stop("SETUP_OpenTimeSliderTwo")
    gre.animation_trigger("SETUP_CloseTimeSliderTwo")
  end
  --call animation to snap it to center, animate closed
  
  sliderPressed = nil
end

local pressedRecipe, prevPressedRecipe
local recipeBG, recipeBGBlurred, recipeTitle, recipeTitleWidth

function cb_PressedRecipe(mapargs)

  local data = {}
  local oldThumb
  if(prevPressedRecipe ~= nil)then
    --set the last thumb to the green one
    local oldThumb = gre.get_value(prevPressedRecipe..".thumb")
    data[prevPressedRecipe..".image"] = "images/recipes/"..oldThumb..".png"
  end  

  pressedRecipe = mapargs.context_control
  recipeTitle = gre.get_value(pressedRecipe..".name")
  recipeBGBlurred = gre.get_value(pressedRecipe..".bgBlur")
  recipeBG = gre.get_value(pressedRecipe..".bg")
  
  --set the new thumb to the orange one
  local pressedThumb = gre.get_value(pressedRecipe..".thumb")
  data[pressedRecipe..".image"] = "images/recipes/"..pressedThumb.."Pressed.png"

  

  local titleWidthTable = gre.get_string_size("fonts/Roboto-Bold.ttf", 30, recipeTitle)
  recipeTitleWidth = titleWidthTable["width"] + 25
  
  prevPressedRecipe = pressedRecipe
  
  
  --setup instruction screen so its not all the same (cupcakes dont have beef)
  

  local incType = gre.get_value(pressedRecipe..".type")

  if(incType == 1)then
    --print("baking")
    
    data["instruction.largeInstruction.text.measure"] = "2 cups"
    data["instruction.largeInstruction.text.type"] = "flour"
    data["instruction.largeInstruction.foodImage.image"] = "images/instruction/flour.png"
    
    data["instruction.largeInstruction1.text.measure"] = "½ cup"
    data["instruction.largeInstruction1.text.type"] = "sugar"
    data["instruction.largeInstruction1.foodImage.image"] = "images/instruction/sugar.png"
    
    data["instruction.smallInstruction.text.measure"] = "1 tbsp"
    data["instruction.smallInstruction.text.type"] = "baking soda"
    data["instruction.smallInstruction.foodImage.image"] = "images/instruction/bakingSoda.png"
    
    data["instruction.smallInstruction1.text.measure"] = "1 tsp"
    data["instruction.smallInstruction1.text.type"] = "baking powder"
    data["instruction.smallInstruction1.foodImage.image"] = "images/instruction/bakingPowder.png"
    
    data["instruction.smallInstruction2.text.measure"] = "1 tbsp"
    data["instruction.smallInstruction2.text.type"] = "butter"
    data["instruction.smallInstruction2.foodImage.image"] = "images/instruction/butter.png"
    
    data["sideListInstruction.instructionButton1.desc.text"] = "Mix Dry Ingredients"
    data["sideListInstruction.instructionButton2.desc.text"] = "Mix Wet Ingredients"
    data["sideListInstruction.instructionButton3.desc.text"] = "Whisk Egg Whites"
    data["sideListInstruction.instructionButton4.desc.text"] = "Combine Dry/Wet"
    
  elseif(incType == 2)then
    --print("beef")
  
    data["instruction.largeInstruction.text.measure"] = "1 lbs"
    data["instruction.largeInstruction.text.type"] = "beef"
    data["instruction.largeInstruction.foodImage.image"] = "images/instruction/beef.png"
    
    data["instruction.largeInstruction1.text.measure"] = "½ cup"
    data["instruction.largeInstruction1.text.type"] = "onion"
    data["instruction.largeInstruction1.foodImage.image"] = "images/instruction/onion.png"
    
    data["instruction.smallInstruction.text.measure"] = "1 tbsp"
    data["instruction.smallInstruction.text.type"] = "flour"
    data["instruction.smallInstruction.foodImage.image"] = "images/instruction/flour.png"
    
    data["instruction.smallInstruction1.text.measure"] = "½ tsp"
    data["instruction.smallInstruction1.text.type"] = "salt"
    data["instruction.smallInstruction1.foodImage.image"] = "images/instruction/salt.png"
    
    data["instruction.smallInstruction2.text.measure"] = "1 clove"
    data["instruction.smallInstruction2.text.type"] = "garlic "
    data["instruction.smallInstruction2.foodImage.image"] = "images/instruction/garlic.png"
    
    data["sideListInstruction.instructionButton1.desc.text"] = "Brown Meat / Drain"
    data["sideListInstruction.instructionButton2.desc.text"] = "Sautee Vegtables"
    data["sideListInstruction.instructionButton3.desc.text"] = "Combine"
    data["sideListInstruction.instructionButton4.desc.text"] = "Add Sauce"
    
  elseif(incType == 3)then
    --print("chicken")
  
    data["instruction.largeInstruction.text.measure"] = "1 lbs"
    data["instruction.largeInstruction.text.type"] = "chicken"
    data["instruction.largeInstruction.foodImage.image"] = "images/instruction/chicken.png"
    
    data["instruction.largeInstruction1.text.measure"] = "½ cup"
    data["instruction.largeInstruction1.text.type"] = "onion"
    data["instruction.largeInstruction1.foodImage.image"] = "images/instruction/onion.png"
    
    data["instruction.smallInstruction.text.measure"] = "2 sprigs"
    data["instruction.smallInstruction.text.type"] = "thyme"
    data["instruction.smallInstruction.foodImage.image"] = "images/instruction/thyme.png"
    
    data["instruction.smallInstruction1.text.measure"] = "1 tsp"
    data["instruction.smallInstruction1.text.type"] = "salt"
    data["instruction.smallInstruction1.foodImage.image"] = "images/instruction/salt.png"
    
    data["instruction.smallInstruction2.text.measure"] = "1 tsp"
    data["instruction.smallInstruction2.text.type"] = "pepper"
    data["instruction.smallInstruction2.foodImage.image"] = "images/instruction/pepper.png"

    data["sideListInstruction.instructionButton1.desc.text"] = "Salt Chicken"
    data["sideListInstruction.instructionButton2.desc.text"] = "Butterfly Breast"
    data["sideListInstruction.instructionButton3.desc.text"] = "Sautee Onions"
    data["sideListInstruction.instructionButton4.desc.text"] = "Add Thyme"
      
  else
  end
    
  gre.set_data(data)
    
end

--- @param gre#context mapargs
function cb_SetupRecipe() 
  local data = {}
  data["aboutRecipe.blurred.image"] = "images/recipes/"..recipeBGBlurred
  data["aboutRecipe.thumbnail.image"] = "images/recipes/"..recipeBG
  data["aboutRecipe.title.title.text"] = recipeTitle
  local ctrlData = {}
  ctrlData["width"] = recipeTitleWidth + 83
  ctrlData["x"] =  800-recipeTitleWidth + 83
  gre.set_control_attrs("aboutRecipe.title.titleBG", ctrlData)
  gre.set_data(data)
  
end

local prevInstruction = "sideListInstruction.instructionButton1"
--- @param gre#context mapargs
function cb_PressedInstruction(mapargs) 

  local pressedInstruction = mapargs.context_group

  if(pressedInstruction == prevInstruction)then
    return
  end

  local animData = {}
  animData ["context"] = pressedInstruction
  
  gre.animation_trigger("INSTRUCTION_PressInstructionThumb", animData)
  
  
  if(prevInstruction ~= nil)then
    animData ["context"] = prevInstruction
    gre.animation_trigger("INSTRUCTION_DeselectInstructionThumb", animData)
  end
  prevInstruction = pressedInstruction
  
  gre.animation_trigger("INSTRUCTION_RevealSteps")
    
end

function resetInstructions()

  local data = {}
  data["instruction.smallInstruction.pressed"] =0
  data["instruction.smallInstruction1.pressed"] =0
  data["instruction.smallInstruction2.pressed"] =0
  data["instruction.largeInstruction.pressed"] =0
  data["instruction.largeInstruction1.pressed"] =0
  gre.set_data(data)
  
  local animData = {}
  animData["context"] = "instruction.largeInstruction"
  animData["id"] = 1
  gre.animation_trigger("INSTRUCTION_resetLarge", animData)
  animData["context"] = "instruction.largeInstruction1"
  animData["id"] = 2
  gre.animation_trigger("INSTRUCTION_resetLarge", animData)
  
  animData["context"] = "instruction.smallInstruction"
  animData["id"] = 11
  gre.animation_trigger("INSTRUCTION_resetSmall", animData)
  animData["context"] = "instruction.smallInstruction1"
  animData["id"] = 12
  gre.animation_trigger("INSTRUCTION_resetSmall", animData)
  animData["context"] = "instruction.smallInstruction2"
  animData["id"] = 13
  gre.animation_trigger("INSTRUCTION_resetSmall", animData)
  
end

function cb_pressLargeInstruction(mapargs)
  
  local key = mapargs.context_group
  
  local check = gre.get_value(key..".pressed")
  
  if(check == 1)then
    return
  end
  
  local animData = {}
  animData["context"] = key
  gre.animation_trigger("INSTRUCTION_PressLarge", animData)
  
  local data = {}
  data[key..".pressed"] = 1
  gre.set_data(data)

end

function cb_pressSmallInstruction(mapargs)
  
  local key = mapargs.context_group
  
  local check = gre.get_value(key..".pressed")
  
  if(check == 1)then
    return
  end
  
  local animData = {}
  animData["context"] = key
  gre.animation_trigger("INSTRUCTION_PressSmall", animData)
  
  local data = {}
  data[key..".pressed"] = 1
  gre.set_data(data)

end

--- @param gre#context mapargs
function cb_resetSliders(mapargs) 

  --print("in Reset Sliders")
  tempOneSliderPos = 0
  tempTwoSliderPos = 0
  timeSliderPos = 0

end



function cb_digitalSyncTime(mapargs)
  local time = gre.mstime() / 1000
  local data = {}
  
  data["clock.time.text"] = os.date("%I:%M %p", math.floor(time))
  gre.set_data(data)
end



--- @param gre#context mapargs
function cb_InstructionOffset(mapargs) 
  local dataTable = {}
  local data = {}
  
  dataTable = gre.get_layer_attrs("sideListInstruction","yoffset")
  local layerOffset = dataTable["yoffset"]
  --print(layerOffset)
  
  --setting up a scrollbar
  local scrollY = (380*(math.abs(layerOffset)))/155
  
  if(layerOffset > 0)then
    scrollY = 0
  elseif(layerOffset < -155)then
    scrollY = 380
  end
  
  local scrollData = {}
  scrollData["y"] = scrollY
  gre.set_control_attrs("instructionScrollBar.scrollBar", scrollData)
  data["instructionScrollBar.scrollBar.y"] = -scrollY
  gre.set_data(data)
  --end of setting up a scrollbar
end


--- @param gre#context mapargs
function cb_PressIdleScreen(mapargs) 
  gre.animation_stop("AMBIENT_IdleScreen")
  gre.animation_trigger("TRANSITION_IdleToRecipe")
end
