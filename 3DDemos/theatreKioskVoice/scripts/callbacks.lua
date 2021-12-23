--Used on the main screen to blur the movie poster for the other information to pop up
function moviePosterBlur(mapargs) 

  --commented out until the fix is in (HI BRIAN)
--  local effect = {}
--  local sdata = {}
--  
--  effect["name"] = "blur"
--  effect["passes"] = 2
--  effect["radius"] = 2
--  effect["composite"] = true
--
--  sdata["effect"] = effect
--  gre.set_control_attrs(mapargs.context_group..".blur",sdata)
  
end

function flipLayer(mapargs)
  local gdata = {}
  
  local ev_data = mapargs.context_event_data;

  local gdata = {}
  
  local mouseY = ev_data.x
  
  --print(mouseY)
  
  gdata = {
  
    --Triangle 1
    {x = 0, y=0, z=0, u=0, v=0},
    {x = 426, y=0, z=-mouseY, u=0.33, v=0},
    {x = 0, y=720, z=0, u=0, v=1.0},
    --Triangle 2
    {x = 426, y=720, z=-mouseY, u=0.33, v=1.0},
    {x = 426, y=0, z=-mouseY, u=0.33, v=0},
    {x = 0, y=720, z=0, u=0, v=1.0},
    --Triangle 3
    {x = 426, y=720, z=-mouseY, u=0.33, v=1.0},
    {x = 426, y=0, z=-mouseY, u=0.33, v=0},
    {x = 850, y=720, z=mouseY, u=0.66, v=1.0},
    --Triangle 4
    {x = 850, y=0, z=mouseY, u=0.66, v=0.0},
    {x = 426, y=0, z=-mouseY, u=0.33, v=0},
    {x = 850, y=720, z=mouseY, u=0.66, v=1.0},
     --Triangle 5
    {x = 850, y=0, z=mouseY, u=0.66, v=0.0},
    {x = 1280, y=0, z=0, u=1.0, v=0},
    {x = 850, y=720, z=mouseY, u=0.66, v=1.0},
     --Triangle 6
    {x = 1280, y=720, z=0, u=1.0, v=1.0},
    {x = 1280, y=0, z=0, u=1.0, v=0},
    {x = 850, y=720, z=mouseY, u=0.66, v=1.0},
                        
  }
    
  local attrs = {}
  attrs["geometry"] = {
      width = 1280,
      height = 720,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("moviesLayer1",attrs)

end

--set to one if the card has video support (viewing trailers), set to 0 if not
--DEFAULT = 1
--local videoSupportAvailable = 0 
--now uses gVideoSupport declared in demo_close file

local pressX, releaseX, changeX, changeDirection, layerNumber, layerPressed
local activeMovieLayer = "moviesLayer1"
local layerNumber = 1
local movementPercentage
--did the screen move left or right, used for the finishing animation at the end since no more context is given during that time
local moveDirection
local animationRunning = false


--SETTINGS FOR USAGE

local layerCheckMovementThreshold = 20 --Checks to make sure the finger has move a little bit before it even attemps to make motion
--local APP_IDLE_TIME = 5000 -- App is called idle after 15 sec
local noMovement = 20 --makes sure the app has moved this much to update a release
local movementThreshold = 150 -- this is how much the app has to move before it registers as a swipe left or right. Otherwise snaps back
local seatAmount = 12 --amount of seats 
local prevSelectedMovie, selectedMovie, movieName, movieRuntime, movieTrailer

local function animationEnded()
  animationRunning = false
end

function APP_INIT()
  local data = {}
  local dk_data = {}
  
  
  if(gVideoSupport == 1)then
    data["postHomeAnim"] = "TRANSITION_postersToTrailer"
    local trailerText = "VIEW TRAILER"

    for i=1, 3 do
      local j = i + 3
      local k = i + 6
      data["moviesLayer1.moviePoster"..i..".buyTicketsAnimated.text"] = trailerText
      data["moviesLayer1.moviePoster"..i..".buyTickets.text"] = trailerText
      data["moviesLayer2.moviePoster"..j..".buyTicketsAnimated.text"] = trailerText
      data["moviesLayer2.moviePoster"..j..".buyTickets.text"] = trailerText
      data["moviesLayer3.moviePoster"..k..".buyTicketsAnimated.text"] = trailerText
      data["moviesLayer3.moviePoster"..k..".buyTickets.text"] = trailerText    
    end

    
  else
    data["postHomeAnim"] = "TRANSITION_postersToTime"
    local buyText = "BUY TICKETS"

    for i=1, 3 do
      local j = i + 3
      local k = i + 6
      data["moviesLayer1.moviePoster"..i..".buyTicketsAnimated.text"] = buyText
      data["moviesLayer1.moviePoster"..i..".buyTickets.text"] = buyText
      data["moviesLayer2.moviePoster"..j..".buyTicketsAnimated.text"] = buyText
      data["moviesLayer2.moviePoster"..j..".buyTickets.text"] = buyText
      data["moviesLayer3.moviePoster"..k..".buyTicketsAnimated.text"] = buyText
      data["moviesLayer3.moviePoster"..k..".buyTickets.text"] = buyText
    end
  end

  gre.set_data(data)

end

function resetLayers(mapargs)
  --print("in reset Layers")
  activeMovieLayer = "moviesLayer1"
  layerNumber = 1
  
  local data = {}
  local dataTable = {}
  
  dataTable["hidden"]=1
  gre.set_layer_attrs("selectMovieScreen.moviesLayer2",dataTable)
  gre.set_layer_attrs("selectMovieScreen.moviesLayer3",dataTable)
  dataTable["hidden"]=0
  dataTable["x"] = 0
  gre.set_layer_attrs("selectMovieScreen.moviesLayer1",dataTable)
    
  data["dragLayer.navigationCircles.screenCircle01.alpha"] = 255
  data["dragLayer.navigationCircles.screenCircle02.alpha"] = 100
  data["dragLayer.navigationCircles.screenCircle03.alpha"] = 100
  
  gre.set_data(data) 
  ResetGLTriangle()
end

-- When a control is pressed on, save the name of the control
function dragPress(mapargs)
  if(animationRunning == true) then
    return
  end
  
  local ev_data = mapargs.context_event_data;
  pressX = ev_data.x
  layerPressed = 1
  --print(pressX)
  --clear off all animated things?
  gre.animation_trigger("HOME_clearAnimations")
end

function ResetGLTriangle(mapargs)
   
  local attrs = {}
  attrs["geometry"] = ""
  
  gre.set_layer_attrs("selectMovieScreen.moviesLayer1",attrs)
  gre.set_layer_attrs("selectMovieScreen.moviesLayer2",attrs)
  gre.set_layer_attrs("selectMovieScreen.moviesLayer3",attrs)
 
end


function dragMotion(mapargs)

  if(layerPressed == 1)then
    
    
    local gdata = {}
    local ev_data = mapargs.context_event_data;  
    local currX = ev_data.x

    local layerTranslate = -(pressX - currX)
    --print(layerTranslate)
    local layerCheck = math.abs(layerTranslate)
    --print(layerCheck)
    
    if(layerCheck<layerCheckMovementThreshold)then
      --print("Too little Movement")
      return
    end
    
    local moveZ = -(pressX - currX)
    if(moveZ>0)then
      moveZ = moveZ - 20
    else
      moveZ = moveZ + 20
    end
    local X0, X1, X2, X3, Z1, Z2
    movementPercentage = moveZ/1280
    if(moveZ>0)then
      --print("rightSideStuck")  
      X0 = movementPercentage * 1280
      X1 = (movementPercentage * 854) + 426
      X2 = (movementPercentage * 430) + 850
      X3 = (movementPercentage * 0) + 1280
      moveDirection= 0
      Z1 = 0
      Z2 = moveZ/2
    else
      movementPercentage = movementPercentage * -1
      --print("leftSideStuck")
      X0 = 0
      X1 = 426 - (movementPercentage * 426)
      X2 = 850 - (movementPercentage * 850)
      X3 = 1280 - (movementPercentage * 1280)
      moveDirection= 1
      Z1 = -(moveZ/2)
      Z2 = 0
    end
    
    --moveZ= moveZ/2
    
    --print(movementPercentage)
    --print(mouseY)
    
    gdata = {
    
      --Triangle 1
      {x = X0, y=0, z=0, u=0, v=0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X0, y=720, z=0, u=0, v=1.0},
      --Triangle 2
      {x = X1, y=720, z=Z1, u=0.33, v=1.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X0, y=720, z=0, u=0, v=1.0},
      --Triangle 3
      {x = X1, y=720, z=Z1, u=0.33, v=1.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X2, y=720, z=Z2, u=0.66, v=1.0},
      --Triangle 4
      {x = X2, y=0, z=Z2, u=0.66, v=0.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X2, y=720, z=Z2, u=0.66, v=1.0},
       --Triangle 5
      {x = X2, y=0, z=Z2, u=0.66, v=0.0},
      {x = X3, y=0, z=0, u=1.0, v=0},
      {x = X2, y=720, z=Z2, u=0.66, v=1.0},
       --Triangle 6
      {x = X3, y=720, z=0, u=1.0, v=1.0},
      {x = X3, y=0, z=0, u=1.0, v=0},
      {x = X2, y=720, z=Z2, u=0.66, v=1.0},
                          
    }
      
    local attrs = {}
    attrs["geometry"] = {
        width = 1280,
        height = 720,
        type = "triangle",
        nvert = 3, --(X Y or Z - 2 or 3)
        nuv = 2,--(ON or OFF 0 or 2
        data = gdata
    }
    gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)    
    
    
    
    
    local layerTable = {}
    
    if(layerNumber == 1)then

      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      
    elseif(layerNumber == 2)then
    
      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
    
    elseif(layerNumber == 3)then
      
      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
    
    else
    end
    
    local dataTable = {}
    dataTable["hidden"] = 0
    gre.set_control_attrs("dragLayerBlocker.dragLayerBlocker", dataTable)
    
  end
 
end


function finishMovement(mapargs)

  local gdata = {}
  local X0, X1, X2, X3,moveZ, Z1, Z2
  local finishMovementPercentage = gre.get_value("menuMovementPercentage")
    
  if(moveDirection==0)then
    --print("rightSideStuck")  
    X0 = finishMovementPercentage * 1280
    X1 = (finishMovementPercentage * 854) + 426
    X2 = (finishMovementPercentage * 430) + 850
    X3 = (finishMovementPercentage * 0) + 1280
    
    moveZ = finishMovementPercentage*1280
    
    Z1 = 0
    Z2 = moveZ/2
      
    --posmoveZ
  else
    movementPercentage = movementPercentage * -1
    --print("leftSideStuck")
    X0 = 0
    X1 = 426 - (finishMovementPercentage * 426)
    X2 = 850 - (finishMovementPercentage * 850)
    X3 = 1280 - (finishMovementPercentage * 1280)
    
    moveZ = -finishMovementPercentage*1280
    
    Z1 = -(moveZ/2)
    Z2 = 0
    --negMoveZ
  end
    
  moveZ= moveZ/2
   
  gdata = {
    
    --Triangle 1
    {x = X0, y=0, z=0, u=0, v=0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=720, z=0, u=0, v=1.0},
    --Triangle 2
    {x = X1, y=720, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=720, z=0, u=0, v=1.0},
    --Triangle 3
    {x = X1, y=720, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
    --Triangle 4
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
     --Triangle 5
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
     --Triangle 6
    {x = X3, y=720, z=0, u=1.0, v=1.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
                        
  }
      
  local attrs = {}
  attrs["geometry"] = {
      width = 1280,
      height = 720,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)
 
end


function dragMotionSmall(mapargs)

  if(layerPressed == 1)then
    
    
    local gdata = {}
    local ev_data = mapargs.context_event_data;  
    local currX = ev_data.x

    local layerTranslate = -(pressX - currX)
    --print(layerTranslate)
    local layerCheck = math.abs(layerTranslate)
    --print(layerCheck)
    
    if(layerCheck<layerCheckMovementThreshold)then
      --print("Too little Movement")
      return
    end
    
    local moveZ = -(pressX - currX)
    if(moveZ>0)then
      moveZ = moveZ - 20
    else
      moveZ = moveZ + 20
    end
    local X0, X1, X2, X3, Z1, Z2
    movementPercentage = moveZ/800
    if(moveZ>0)then
      --print("rightSideStuck")  
      X0 = movementPercentage * 800
      X1 = (movementPercentage * 534) + 266
      X2 = (movementPercentage * 269) + 531
      X3 = (movementPercentage * 0) + 800
      moveDirection= 0
      Z1 = 0
      Z2 = moveZ/2
    else
      movementPercentage = movementPercentage * -1
      --print("leftSideStuck")
      X0 = 0
      X1 = 266 - (movementPercentage * 266)
      X2 = 531 - (movementPercentage * 531)
      X3 = 800 - (movementPercentage * 800)
      moveDirection= 1
      Z1 = -(moveZ/2)
      Z2 = 0
    end
    
    --moveZ= moveZ/2
    
    --print(movementPercentage)
    --print(mouseY)
    
    gdata = {
    
      --Triangle 1
      {x = X0, y=0, z=0, u=0, v=0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X0, y=480, z=0, u=0, v=1.0},
      --Triangle 2
      {x = X1, y=480, z=Z1, u=0.33, v=1.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X0, y=480, z=0, u=0, v=1.0},
      --Triangle 3
      {x = X1, y=480, z=Z1, u=0.33, v=1.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X2, y=480, z=Z2, u=0.66, v=1.0},
      --Triangle 4
      {x = X2, y=0, z=Z2, u=0.66, v=0.0},
      {x = X1, y=0, z=Z1, u=0.33, v=0},
      {x = X2, y=480, z=Z2, u=0.66, v=1.0},
       --Triangle 5
      {x = X2, y=0, z=Z2, u=0.66, v=0.0},
      {x = X3, y=0, z=0, u=1.0, v=0},
      {x = X2, y=480, z=Z2, u=0.66, v=1.0},
       --Triangle 6
      {x = X3, y=480, z=0, u=1.0, v=1.0},
      {x = X3, y=0, z=0, u=1.0, v=0},
      {x = X2, y=480, z=Z2, u=0.66, v=1.0},
                          
    }
      
    local attrs = {}
    attrs["geometry"] = {
        width = 800,
        height = 480,
        type = "triangle",
        nvert = 3, --(X Y or Z - 2 or 3)
        nuv = 2,--(ON or OFF 0 or 2
        data = gdata
    }
    gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)    
    
    
    
    
    local layerTable = {}
    
    if(layerNumber == 1)then

      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      
    elseif(layerNumber == 2)then
    
      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
    
    elseif(layerNumber == 3)then
      
      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
    
    else
    end
    
    local dataTable = {}
    dataTable["hidden"] = 0
    gre.set_control_attrs("dragLayerBlocker.dragLayerBlocker", dataTable)
    
  end
 
end


function finishMovementSmall(mapargs)

  local gdata = {}
  local X0, X1, X2, X3,moveZ, Z1, Z2
  local finishMovementPercentage = gre.get_value("menuMovementPercentage")
    
  if(moveDirection==0)then
    --print("rightSideStuck")  
    X0 = finishMovementPercentage * 800
    X1 = (finishMovementPercentage * 534) + 266
    X2 = (finishMovementPercentage * 269) + 531
    X3 = (finishMovementPercentage * 0) + 800
    
    moveZ = finishMovementPercentage*1280
    
    Z1 = 0
    Z2 = moveZ/2
      
    --posmoveZ
  else
    movementPercentage = movementPercentage * -1
    --print("leftSideStuck")
    X0 = 0
    X1 = 266 - (finishMovementPercentage * 266)
    X2 = 531 - (finishMovementPercentage * 531)
    X3 = 800 - (finishMovementPercentage * 800)
    
    moveZ = -finishMovementPercentage*1280
    
    Z1 = -(moveZ/2)
    Z2 = 0
    --negMoveZ
  end
    
  moveZ= moveZ/2
   
  gdata = {
    
    --Triangle 1
    {x = X0, y=0, z=0, u=0, v=0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=480, z=0, u=0, v=1.0},
    --Triangle 2
    {x = X1, y=480, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=480, z=0, u=0, v=1.0},
    --Triangle 3
    {x = X1, y=480, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
    --Triangle 4
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
     --Triangle 5
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
     --Triangle 6
    {x = X3, y=480, z=0, u=1.0, v=1.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
                        
  }
      
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)
 
end

function dragRelease(mapargs)
 
  if(layerPressed == 1 and animationRunning == false)then  
    local ev_data = mapargs.context_event_data;
    releaseX = ev_data.x
    layerPressed = 0
    --print(releaseX)
    checkMovement()
    local dataTable = {}
    dataTable["hidden"] = 1
    gre.set_control_attrs("dragLayerBlocker.dragLayerBlocker", dataTable)
  end
end

function checkMovement()

  changeX = math.abs(pressX-releaseX)
  
  --if the user just clicks and has no motion just stops any animation, this stops any wonky animations coming about, and th difference in 5 px is negligable
  if(changeX < noMovement)then
    --print("no movement detected")
    return
  end
  
  if(changeX < movementThreshold and changeX > noMovement)then
    local data = {}
    data["menuMovementPercentage"] = movementPercentage
    gre.set_data(data)
    gre.animation_trigger("MENU_resetAnimation")
    
    if(layerNumber == 1)then
      gre.animation_trigger("HOME_resetLayer1")
    elseif(layerNumber == 2)then
      gre.animation_trigger("HOME_resetLayer2")
    elseif(layerNumber == 3)then
      gre.animation_trigger("HOME_resetLayer3")
    end
    animationRunning = true
    gre.timer_set_timeout(animationEnded, 650)
    return
  end
 
  local data = {}
  data["menuMovementPercentage"] = movementPercentage
  gre.set_data(data)
  --calls the animation to finish off the 
  gre.animation_trigger("MENU_finishAnimation")
  
  if((pressX-releaseX) < 0)then 
    if(layerNumber == 1)then
      gre.animation_trigger("HOME_finishLayer1_DOWN")
    elseif(layerNumber == 2)then
      gre.animation_trigger("HOME_finishLayer2_DOWN")
    elseif(layerNumber ==3 )then
      gre.animation_trigger("HOME_finishLayer3_DOWN")
    end
  else
    if(layerNumber == 1)then
      gre.animation_trigger("HOME_finishLayer1_UP")
    elseif(layerNumber == 2)then
      gre.animation_trigger("HOME_finishLayer2_UP")
    elseif(layerNumber ==3 )then
      gre.animation_trigger("HOME_finishLayer3_UP")
    end
  end
  animationRunning = true
  --set this timer to 50ms more then the animation length
  gre.timer_set_timeout(movementSuccess, 550)

end


function movementSuccess()
  animationEnded()
  if((pressX-releaseX) < 0)then 
    layerNumber = layerNumber - 1
    if(layerNumber < 1)then
      layerNumber = 3
    end
  else
    layerNumber = layerNumber + 1
    if(layerNumber > 3)then
      layerNumber = 1
    end
  end
  
  --print(layerNumber)
  --print(changeX)
  
    --close the movies that are opened when a new layer shows up
  if(prevSelectedMovie~=nil)then
    local animData = {}
    local animID = prevSelectedMovie..".animID"
    animData["context"] = prevSelectedMovie
    animData["id"] = animID
    gre.animation_trigger("HOME_moviePosterClose", animData)
    prevSelectedMovie = nil
  end
    
  setupLayers()
  ResetGLTriangle()
  --print(layerNumber)
end

function setupLayers()

  local dataTable = {}
  local data = {}
  dataTable["alpha"]=255
      
  if(layerNumber == 1)then
    
    dataTable["hidden"]=1
    dataTable["zindex"] = 101
    gre.set_layer_attrs("moviesLayer3",dataTable)
    dataTable["zindex"] = 102
    gre.set_layer_attrs("moviesLayer2",dataTable)
    dataTable["hidden"]=0
    dataTable["zindex"] = 100
    gre.set_layer_attrs("moviesLayer1",dataTable)
    
    data["dragLayer.navigationCircles.screenCircle01.alpha"] = 255
    data["dragLayer.navigationCircles.screenCircle02.alpha"] = 100
    data["dragLayer.navigationCircles.screenCircle03.alpha"] = 100
    
  elseif(layerNumber == 2)then
    dataTable["hidden"]=1
    dataTable["zindex"] = 101
    gre.set_layer_attrs("moviesLayer3",dataTable)
    dataTable["zindex"] = 102
    gre.set_layer_attrs("moviesLayer1",dataTable)
    dataTable["hidden"]=0
    dataTable["zindex"] = 100
    gre.set_layer_attrs("moviesLayer2",dataTable)
    
    data["dragLayer.navigationCircles.screenCircle01.alpha"] = 100
    data["dragLayer.navigationCircles.screenCircle02.alpha"] = 255
    data["dragLayer.navigationCircles.screenCircle03.alpha"] = 100
  elseif(layerNumber == 3)then
    dataTable["zindex"] = 101
    gre.set_layer_attrs("moviesLayer1",dataTable)
    dataTable["zindex"] = 102
    gre.set_layer_attrs("moviesLayer2",dataTable)
    dataTable["hidden"]=0
    dataTable["zindex"] = 100
    gre.set_layer_attrs("moviesLayer3",dataTable)
    
    data["dragLayer.navigationCircles.screenCircle01.alpha"] = 100
    data["dragLayer.navigationCircles.screenCircle02.alpha"] = 100
    data["dragLayer.navigationCircles.screenCircle03.alpha"] = 255
  end
  
  dataTable = {}
  dataTable["hidden"] = 1
  gre.set_control_attrs("blockerLayer.blocker", dataTable)
  gre.set_data(data)
  
  --gre.animation_trigger("MENU_showMovies")
end



function MOVIESCREEN_SelectMovie(mapargs)
  --This was causing a gitter bug when a movie poster was touched 
  --because we were performing ResetGLTriangle twice.
  --ResetGLTriangle()

  local movie = tonumber(mapargs.movie)
  local selectedMovie = mapargs.context_group
  local groupX = gre.get_value(mapargs.context_group..".grd_x")
  --number the movie poster is always at in the Y position
  local groupY = 68
  
  if(prevSelectedMovie~=nil)then
    
    local animData = {}
    local animID = prevSelectedMovie..".animID"
    animData["context"] = prevSelectedMovie
    animData["id"] = animID
    gre.animation_trigger("HOME_moviePosterClose", animData)
   
    --print("previousMovieSelected")
    if(prevSelectedMovie == selectedMovie)then
      prevSelectedMovie = nil
      return
    end
    
  end
  
  --setup the animations to expand out
  local animData = {}
  local animID = selectedMovie..".animID"
  animData["context"] = selectedMovie
  animData["id"] = animID
  gre.animation_trigger("HOME_moviePosterSelect", animData)
  
  prevSelectedMovie = selectedMovie
    
  --check which movie it is and set the false movie layer to the proper poster and position
  --Also resets the image before the animation is called
  local data = {}
  data["falseMovieLayer.moviePoster.alpha"]=255
  data["falseMovieLayer.moviePoster.grd_x"]=groupX
  data["falseMovieLayer.moviePoster.grd_y"]=groupY
  gre.set_data(data)
  
  MOVIESCREEN_SetMovie(movie)
  
end

function MOVIESCREEN_SetMovie(movie)
  gre.set_value("logo.Repeat.grd_hidden", 1)
  
  local data = {}
  
  if(movie==1)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster01.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster01.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster01.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster01.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/pacificRim.png"
    movieName = "El Dorado"
    movieRuntime = "132 min"
    movieTrailer = "trailers/Eldorado.mp4"
  elseif(movie==2)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster02.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster02.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster02.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster02.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/tronLegacy.png"
    movieName = "Moment of Intensity"
    movieRuntime = "102 min"
    movieTrailer = "trailers/Moment_of_Intensity.mp4"
  elseif(movie==3)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster03.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster03.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster03.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster03.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/starWars.png"
    movieName = "Indoor Soccer"
    movieRuntime = "108 min"
    movieTrailer = "trailers/Indoor_Soccer.mp4"
  elseif(movie==4)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster04.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster04.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster04.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster04.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/insideOut.png"
    movieName = "Seconds that Count"
    movieRuntime = "120 min"
    movieTrailer = "trailers/Seconds_That_Count.mp4"    
  elseif(movie==5)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster05.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster05.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster05.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster05.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/madMax.png"
    movieName = "Lifting Off"
    movieRuntime = "136 min"
    movieTrailer = "trailers/Lifting_Off.mp4"
  elseif(movie==6)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster06.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster06.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster06.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster06.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/furious7.png"
    movieName = "Unspoken Friend"
    movieRuntime = "140 min"
    movieTrailer = "trailers/Unspoken_Friend.mp4"
  elseif(movie==7)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster07.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster07.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster07.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster07.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/MI.png"
    movieName = "Storyboard Connector"
    movieRuntime = "93 min"
    movieTrailer = "trailers/Storyboard_Connector.mp4"
  elseif(movie==8)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster08.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster08.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster08.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster08.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/bvS.png"
    movieName = "Storyboard Suite 5.0"
    movieRuntime = "118 min"
    movieTrailer = "trailers/Storyboard_5_0.mp4"
  elseif(movie==9)then
    data["falseMovieLayer.moviePoster.image"]="images/MoviePosters/poster09.jpg"
    data["confirm.moviePoster.image"] = "images/MoviePosters/poster09.jpg"
    data["selectTimes.moviePoster.image"] = "images/MoviePosters/poster09.jpg"
    data["trailer.poster.image"] = "images/MoviePosters/poster09.jpg"
    data["trailer.endThumb.image"] = "images/trailerScreen/zootopia.png"
    movieName = "Photoshop Reimport"
    movieRuntime = "108 min"
    movieTrailer = "trailers/Storyboard_PSD_Reimport.mp4"
  end
  
  data["selectTimes.aboutMovie.movieTitle.text"] = movieName
  data["selectTimes.aboutMovie.runningTime"] = movieRuntime
  data["confirm.confirm.showData.text"] = movieName
  data["confirm.confirm.runtimeData.text"] = movieRuntime
  data["trailer.movieData.movieTitle.text"] = movieName
  data["trailer.movieData.runTime.runtime"] = movieRuntime
  data["trailer_name"] = movieTrailer


  gre.set_data(data)
end

function MOVIESCREEN_clearSelection()
  prevSelectedMovie = nil
end

adultTickets = 0
local childTickets = 0
local seniorTickets = 0

function resetTickets()
  adultTickets=0
  childTickets=0
  seniorTickets=0
end

function TIMESSCREEN_addTicket(mapargs)

  local type = mapargs.ticket
  if(type == "adult")then
    adultTickets = adultTickets +1
  elseif(type == "child")then
    childTickets = childTickets +1
  elseif(type == "senior")then
    seniorTickets = seniorTickets +1
  end

  TIMESSCREEN_updateTickets()
end

function TIMESSCREEN_subTicket(mapargs)

  local type = mapargs.ticket
  if(type == "adult")then
    adultTickets = adultTickets -1
  elseif(type == "child")then
    childTickets = childTickets -1
  elseif(type == "senior")then
    seniorTickets = seniorTickets -1
  end
  
  TIMESSCREEN_updateTickets()
end

function TIMESSCREEN_updateTickets()
  local data = {}
  local dataTable = {}
  
  if(adultTickets == 0)then
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedAdult", dataTable)
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountAdult", dataTable) 
  else
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedAdult", dataTable)
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountAdult", dataTable) 
  end
 
  if(childTickets == 0)then
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedChild", dataTable)
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountChild", dataTable) 
  else
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedChild", dataTable)
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountChild", dataTable) 
  end
  
  if(seniorTickets == 0)then
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedSenior", dataTable)
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountSenior", dataTable) 
  else
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountLockedSenior", dataTable)
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectTimes.buyTickets.decreaseCountSenior", dataTable) 
  end

  
  data["selectTimes.buyTickets.adultTickets.text"] = adultTickets
  data["selectTimes.buyTickets.childTickets.text"] = childTickets
  data["selectTimes.buyTickets.seniorTickets.text"] = seniorTickets
  local totalTickets = seniorTickets + childTickets + adultTickets
  data["selectTimes.buyTickets.totalTickets.text"] = totalTickets
  
  local price
  local adultPrice = adultTickets * 13
  local childPrice = childTickets * 10
  local seniorPrice = seniorTickets * 8
  
  data["confirm.confirm.ticketAmount1.text"] = adultTickets
  data["confirm.confirm.ticketAmount2.text"] = childTickets
  data["confirm.confirm.ticketAmount3.text"] = seniorTickets
  
  data["confirm.confirm.ticketSubtotal1.text"] = adultPrice..".00"
  data["confirm.confirm.ticketSubtotal2.text"] = childPrice..".00"
  data["confirm.confirm.ticketSubtotal3.text"] = seniorPrice..".00"
  
  data["selectTimes.buyTickets.totalTickets.text"] = totalTickets
   
  price = adultPrice + childPrice + seniorPrice
  
  data["selectTimes.buyTickets.totalPrice.text"] = price..".00"
  
  data["confirm.confirm.ticketTotal.text"] = price..".00"
  
  gre.set_data(data)
end


function SEATS_seatPopup(mapargs) 
  
  local toggle = gre.get_value(mapargs.context_group..".toggle")
  local id = gre.get_value(mapargs.context_group..".id")
  local data = {}
  local dataTable = {}
  
  dataTable["context"] = mapargs.context_group
  dataTable["id"] = id
  
  if(toggle == 1)then
    gre.animation_trigger("_NEW_seatUnselect", dataTable)
    toggle = 0
  else
    gre.animation_trigger("_NEW_seatSelect", dataTable)
    toggle = 1
  end

  data[mapargs.context_group..".toggle"] = toggle
  gre.set_data(data)
   
end



function SEATS_resetSeats(mapargs)
  
  local data = {}
  
  for i=1, seatAmount do
  
    local dataTable = {}
    data["selectSeats.seatSelection"..i..".whiteSeat.alpha"] = 100
    data["selectSeats.seatSelection"..i..".whiteSeat.alpha2"] = 255
    data["selectSeats.seatSelection"..i..".whiteSeat.textAlpha"] = 255
    data["selectSeats.seatSelection"..i..".toggle"] = 0
    
    dataTable["hidden"] = 0
    gre.set_control_attrs("selectSeats.seatSelection"..i..".whiteSeat", dataTable)
    dataTable["hidden"] = 1
    gre.set_control_attrs("selectSeats.seatSelection"..i..".greenSeat", dataTable)

  end

  gre.set_data(data)
end

local prevTimeSelected, timeSelected

function TIMESSCREEN_resetShowtimes(mapargs)

  prevTimeSelected = "selectTimes.ticket01"
  local dataTable = {}
  local data = {}

  data["selectTimes.ticket01.ampm.AMColour"] = 0xC7E5C9
  data["selectTimes.ticket01.modifierColour"] = 0xC7E5C9
  data["selectTimes.ticket01.ticketSelectedBG.alpha"] = 275
  data["selectTimes.ticket01.ticketSelectedBGCopy.alpha"] = 0
  
  data["selectTimes.ticket02.ampm.AMColour"] = 0xffffff
  data["selectTimes.ticket02.modifierColour"] = 0x999999
  data["selectTimes.ticket02.ticketSelectedBG.alpha"] = 275
  data["selectTimes.ticket02.ticketSelectedBGCopy.alpha"] = 0
  
  data["selectTimes.ticket03.ampm.AMColour"] = 0xffffff
  data["selectTimes.ticket03.modifierColour"] = 0x999999
  data["selectTimes.ticket03.ticketSelectedBG.alpha"] = 0
  data["selectTimes.ticket03.ticketSelectedBGCopy.alpha"] = 0
  --data["selectTimes.ticket01.ticketSelectedBG.grd_width"] = 153
  
  --data["selectTimes.ticket01.ticketSelectedBG.grd_width"] = 0xC7E5C9
  --data["selectTimes.ticket01.ampm.AMColour"] = 0xC7E5C9
  
  dataTable["width"] = 153
  gre.set_control_attrs("selectTimes.ticket01.ticketSelectedBG",dataTable)
  gre.set_control_attrs("selectTimes.ticket02.ticketSelectedBGCopy",dataTable)
  gre.set_control_attrs("selectTimes.ticket03.ticketSelectedBGCopy",dataTable)
  dataTable["width"] = 0
  gre.set_control_attrs("selectTimes.ticket02.ticketSelectedBG",dataTable)
  gre.set_control_attrs("selectTimes.ticket03.ticketSelectedBG",dataTable)
  gre.set_control_attrs("selectTimes.ticket01.ticketSelectedBGCopy",dataTable)
  
  dataTable = {}
  dataTable["hidden"] = 0
  gre.set_control_attrs("selectTimes.ticket01.ticketSelectedBG",dataTable) 
  dataTable["hidden"] = 1 
  gre.set_control_attrs("selectTimes.ticket02.ticketSelectedBG",dataTable)
  gre.set_control_attrs("selectTimes.ticket03.ticketSelectedBG",dataTable)
  gre.set_control_attrs("selectTimes.viewTrailer",dataTable)
  
  
  gre.set_data(data) 
  
end

function TIMESSCREEN_selectShowtime(mapargs) 
  
  timeSelected = mapargs.context_group  
  --print(timeSelected, prevTimeSelected)
  
  local animData = {}
  animData["context"] = timeSelected
  gre.animation_trigger("TIMES_selectShowtime", animData)
  
  if(prevTimeSelected ~= nil)then
    animData["context"] = prevTimeSelected
    gre.animation_trigger("TIMES_unselectShowtime", animData) 
  end
  prevTimeSelected = timeSelected
  
end

local BGPaused = 0
function setBGPaused(mapargs)

  if(mapargs.context_control == "selectTimes.buyTickets.selectSeats")then
    BGPaused = 1
    --print("movieIsPaused")
  else
    BGPaused = 0
    --print("movieIsPlaying")
  end
  
end

function APP_resetApp(mapargs)
  if(prevSelectedMovie == nil)then
    return
  end
  --resetLayers()
  --ResetGLTriangle()
  --print(prevSelectedMovie)
  --Use the prev selected movie to make sure we have the mocie that was just selected.
  --use this to close up said movie screen and reset it
  local data = {}
  --
  local dataTable = {}
  local layerData = {}
  dataTable["hidden"] = 1
  
  gre.set_control_attrs(prevSelectedMovie..".buyTicketsAnimated",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".buyTickets",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".viewTrailer",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".hide",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".rating",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".runtime",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier1",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier2",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier3",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openTimes",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openSynopsis",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openGenre",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openTitle",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openBottomOverlay",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".blur",dataTable)
  dataTable["hidden"] = 0
  gre.set_control_attrs("dragLayer.dragControl", dataTable)
  gre.set_control_attrs(prevSelectedMovie..".stroke",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".ImaxText",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".closedImaxRectangle",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".closedMovieTime",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".bottomOverlay",dataTable)
  dataTable["y"] = 553
  gre.set_control_attrs(prevSelectedMovie..".movieTitle",dataTable)
  
  dataTable["width"]= 373
  dataTable["height"] = 620
  
  layerData["hidden"] = 1
  gre.set_control_attrs("falseMovieLayer.moviePoster", dataTable)
  gre.set_layer_attrs("selectMovieScreen.falseMovieLayer", layerData)
  gre.set_layer_attrs("selectTimesScreen.2DTo3DTransition", layerData)
  
  data["selectTimes.buyTickets.adultTickets.text"] = "0"
  data["selectTimes.buyTickets.childTickets.text"] = "0"
  data["selectTimes.buyTickets.seniorTickets.text"] = "0"
  data["selectTimes.buyTickets.totalTickets.text"] = "0"
  data["selectTimes.buyTickets.totalPrice.text"] = "0.00"
  
  dataTable = {}
  data["selectTimes.moviePoster.alpha"] = 255
  dataTable["hidden"] = 1
  gre.set_control_attrs("falseMovieLayer.moviePoster", dataTable)
  
  local ctrl_data = {}
  ctrl_data["hidden"] = 1
  gre.set_control_attrs("trailer.endReplay",ctrl_data)
  gre.set_control_attrs("trailer.endBuy",ctrl_data)
  gre.set_control_attrs("trailer.endThumb",ctrl_data)
  
  layerPressed = 0
  resetTickets()
  TIMESSCREEN_resetShowtimes()
  SEATS_resetSeats()
  
  if(BGPaused == 1)then
    gre.send_event("APP_resetBG")
    --print("toggledMovieStart")
  end
   
  gre.set_data(data)
  prevSelectedMovie = nil
  selectedMovie = nil
  --pressX = 0
  --releaseX = 0
  --changeX = 0


end

function APP_resetAppSmall(mapargs)
  if(prevSelectedMovie == nil)then
    return
  end
  --resetLayers()
  --ResetGLTriangle()
  --print(prevSelectedMovie)
  --Use the prev selected movie to make sure we have the mocie that was just selected.
  --use this to close up said movie screen and reset it
  local data = {}
  --
  local dataTable = {}
  local layerData = {}
  dataTable["hidden"] = 1
  
  gre.set_control_attrs(prevSelectedMovie..".buyTicketsAnimated",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".buyTickets",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".viewTrailer",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".hide",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".rating",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".runtime",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier1",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier2",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".modifier3",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openTimes",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openSynopsis",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openGenre",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openTitle",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".openBottomOverlay",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".blur",dataTable)
  dataTable["hidden"] = 0
  gre.set_control_attrs("dragLayer.dragControl", dataTable)
  gre.set_control_attrs(prevSelectedMovie..".stroke",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".ImaxText",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".closedImaxRectangle",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".closedMovieTime",dataTable)
  gre.set_control_attrs(prevSelectedMovie..".bottomOverlay",dataTable)
  dataTable["y"] = (553/1.6)
  gre.set_control_attrs(prevSelectedMovie..".movieTitle",dataTable)
  
  dataTable["width"]= 373/1.6
  dataTable["height"] = 620/1.6
  
  layerData["hidden"] = 1
  gre.set_control_attrs("falseMovieLayer.moviePoster", dataTable)
  gre.set_layer_attrs("selectMovieScreen.falseMovieLayer", layerData)
  gre.set_layer_attrs("selectTimesScreen.2DTo3DTransition", layerData)
  
  data["selectTimes.buyTickets.adultTickets.text"] = "0"
  data["selectTimes.buyTickets.childTickets.text"] = "0"
  data["selectTimes.buyTickets.seniorTickets.text"] = "0"
  data["selectTimes.buyTickets.totalTickets.text"] = "0"
  data["selectTimes.buyTickets.totalPrice.text"] = "0.00"
  
  dataTable = {}
  data["selectTimes.moviePoster.alpha"] = 255
  dataTable["hidden"] = 1
  gre.set_control_attrs("falseMovieLayer.moviePoster", dataTable)
  
  local ctrl_data = {}
  ctrl_data["hidden"] = 1
  gre.set_control_attrs("trailer.endReplay",ctrl_data)
  gre.set_control_attrs("trailer.endBuy",ctrl_data)
  gre.set_control_attrs("trailer.endThumb",ctrl_data)
  
  layerPressed = 0
  resetTickets()
  TIMESSCREEN_resetShowtimes()
  SEATS_resetSeats()
  
  if(BGPaused == 1)then
    gre.send_event("APP_resetBG")
    --print("toggledMovieStart")
  end
   
  gre.set_data(data)
  prevSelectedMovie = nil
  selectedMovie = nil
  --pressX = 0
  --releaseX = 0
  --changeX = 0


end
--TIMER TO SET UP IF THE SCREEN IS IDLE


local idleTimer = {}
local appIdle = 1

function cb_func()
--  print("APP_IS_IDLE")
  gre.send_event("APP_idleReset")
  appIdle = 1
end

--Call cb_func after app idle time
function APP_idleApp()
  
  local idleTime = gre.get_value("appIdleTime")
  --print(idleTime)
  
  print(idleTime)
  if(appIdle == 0)then
    cb_clear_timeout()
  end
  
  if(appIdle == 1)then
    gre.send_event("APP_CarouselEnd")
  end
  
  idleTimer = gre.timer_set_timeout(cb_func, idleTime)
  appIdle = 0
end


function cb_clear_timeout()
  local data
  data = gre.timer_clear_timeout(idleTimer)
end


function HOME_carouselUpdate()

  if(prevSelectedMovie ~= nil)then
    --print("closing selected movie "..prevSelectedMovie)
    
    local animData = {}
    animData["context"] = prevSelectedMovie
    
    gre.animation_trigger("HOME_moviePosterImmediateClose", animData)
    prevSelectedMovie = nil
  end
  
  

  local movement = gre.get_value("appCarousel")
  --print(movement,layerNumber )
  
   
  local gdata = {}
  local X0, X1, X2, X3,moveZ, Z1, Z2

  X0 = 0
  X1 = 426 - (movement * 426)
  X2 = 850 - (movement * 850)
  X3 = 1280 - (movement * 1280)
    
  moveZ = -movement*1280
  
  Z1 = -(moveZ/2)
  Z2 = 0
      
  moveZ= moveZ/2
   
  gdata = {
    
    --Triangle 1
    {x = X0, y=0, z=0, u=0, v=0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=720, z=0, u=0, v=1.0},
    --Triangle 2
    {x = X1, y=720, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=720, z=0, u=0, v=1.0},
    --Triangle 3
    {x = X1, y=720, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
    --Triangle 4
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
     --Triangle 5
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
     --Triangle 6
    {x = X3, y=720, z=0, u=1.0, v=1.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=720, z=Z2, u=0.66, v=1.0},
                        
  }
      
  local attrs = {}
  attrs["geometry"] = {
      width = 1280,
      height = 720,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)
  
  
  local layerTranslate = -(1280*movement)
  local layerTable = {}
    
    if(layerNumber == 1)then

      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      
    elseif(layerNumber == 2)then
    
      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
    
    elseif(layerNumber == 3)then
      
      layerTable["x"] = layerTranslate - 1280
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      layerTable["x"] = 1280-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
    
    else
    end
    
    local dataTable = {}
    dataTable["hidden"] = 0
    gre.set_control_attrs("dragLayerBlocker.dragLayerBlocker", dataTable)
 
end

function HOME_carouselUpdateSmall()

  if(prevSelectedMovie ~= nil)then
    --print("closing selected movie "..prevSelectedMovie)
    
    local animData = {}
    animData["context"] = prevSelectedMovie
    
    gre.animation_trigger("HOME_moviePosterImmediateClose", animData)
    prevSelectedMovie = nil
  end
  
  

  local movement = gre.get_value("appCarousel")
  --print(movement,layerNumber )
  
   
  local gdata = {}
  local X0, X1, X2, X3,moveZ, Z1, Z2

  X0 = 0
  X1 = 266 - (movement * 266)
  X2 = 531 - (movement * 531)
  X3 = 800 - (movement * 800)
    
  moveZ = -movement*800
  
  Z1 = -(moveZ/2)
  Z2 = 0
      
  moveZ= moveZ/2
   
  gdata = {
    
    --Triangle 1
    {x = X0, y=0, z=0, u=0, v=0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=480, z=0, u=0, v=1.0},
    --Triangle 2
    {x = X1, y=480, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X0, y=480, z=0, u=0, v=1.0},
    --Triangle 3
    {x = X1, y=480, z=Z1, u=0.33, v=1.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
    --Triangle 4
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X1, y=0, z=Z1, u=0.33, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
     --Triangle 5
    {x = X2, y=0, z=Z2, u=0.66, v=0.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
     --Triangle 6
    {x = X3, y=480, z=0, u=1.0, v=1.0},
    {x = X3, y=0, z=0, u=1.0, v=0},
    {x = X2, y=480, z=Z2, u=0.66, v=1.0},
                        
  }
      
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("moviesLayer"..layerNumber,attrs)
  
  
  local layerTranslate = -(800*movement)
  local layerTable = {}
    
    if(layerNumber == 1)then

      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      
    elseif(layerNumber == 2)then
    
      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer3",layerTable)
    
    elseif(layerNumber == 3)then
      
      layerTable["x"] = layerTranslate - 800
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer2",layerTable)
      layerTable["x"] = 800-(-layerTranslate)
      layerTable["hidden"] = 0
      gre.set_layer_attrs_global("moviesLayer1",layerTable)
    
    else
    end
    
    local dataTable = {}
    dataTable["hidden"] = 0
    gre.set_control_attrs("dragLayerBlocker.dragLayerBlocker", dataTable)
 
end


function HOME_carouselReset()
 
  local data = {}
  data["appCarousel"] = 0.0
  gre.set_data(data)

  local endingActive = gre.get_value("carouselEnd")

  if(endingActive == 1)then
    layerNumber = layerNumber + 1
    if(layerNumber > 3)then
      layerNumber = 1
    end
    
    ResetGLTriangle()
      
    local dataTable = {}
    
    dataTable["alpha"]=255
    
    --print(layerNumber)
    
    if(layerNumber == 1)then
      
      dataTable["hidden"]=1
      dataTable["zindex"] = 101
      gre.set_layer_attrs("moviesLayer3",dataTable)
      dataTable["zindex"] = 102
      gre.set_layer_attrs("moviesLayer2",dataTable)
      dataTable["hidden"]=0
      dataTable["zindex"] = 100
      gre.set_layer_attrs("moviesLayer1",dataTable)
      
      data["dragLayer.navigationCircles.screenCircle01.alpha"] = 255
      data["dragLayer.navigationCircles.screenCircle02.alpha"] = 100
      data["dragLayer.navigationCircles.screenCircle03.alpha"] = 100
      
    elseif(layerNumber == 2)then
      dataTable["hidden"]=1
      dataTable["zindex"] = 101
      gre.set_layer_attrs("moviesLayer3",dataTable)
      dataTable["zindex"] = 102
      gre.set_layer_attrs("moviesLayer1",dataTable)
      dataTable["hidden"]=0
      dataTable["zindex"] = 100
      gre.set_layer_attrs("moviesLayer2",dataTable)
      
      data["dragLayer.navigationCircles.screenCircle01.alpha"] = 100
      data["dragLayer.navigationCircles.screenCircle02.alpha"] = 255
      data["dragLayer.navigationCircles.screenCircle03.alpha"] = 100
    elseif(layerNumber == 3)then
      dataTable["zindex"] = 101
      gre.set_layer_attrs("moviesLayer1",dataTable)
      dataTable["zindex"] = 102
      gre.set_layer_attrs("moviesLayer2",dataTable)
      dataTable["hidden"]=0
      dataTable["zindex"] = 100
      gre.set_layer_attrs("moviesLayer3",dataTable)
      
      data["dragLayer.navigationCircles.screenCircle01.alpha"] = 100
      data["dragLayer.navigationCircles.screenCircle02.alpha"] = 100
      data["dragLayer.navigationCircles.screenCircle03.alpha"] = 255
    end
    
    gre.set_data(data)
    
    if(appIdle ==1)then
      gre.animation_trigger("HOME_carousel")
    end
  end
end

function APP_cancel(mapargs) 
  APP_resetApp()
  if(mapargs.context_screen == "selectMovieScreen")then
    return
  end
  
  gre.send_event("APP_toHomeScreen")
end


function trailerEnd() 
  
  local data = {}
  data["appIdleTime"] = 30000
  gre.set_data(data)
  
  local ctrl_data = {}
  ctrl_data["hidden"] = 0
  gre.set_control_attrs("trailer.endReplay",ctrl_data)
  gre.set_control_attrs("trailer.endBuy",ctrl_data)
  gre.set_control_attrs("trailer.endThumb",ctrl_data)
  --local idleTime = gre.get_value("appIdleTime")

  --hide the trailer
  --show the two controls (replay and buy)
    --buy Tickets goes to next screen, same as the green button at the bottom
    --replay goes to a replay funtion

  APP_idleApp()
end

function trailerReplay() 

  local ctrl_data = {}
  ctrl_data["hidden"] = 1
  gre.set_control_attrs("trailer.endReplay",ctrl_data)
  gre.set_control_attrs("trailer.endBuy",ctrl_data)
  gre.set_control_attrs("trailer.endThumb",ctrl_data)
  
  local data = {}
  data["appIdleTime"] = 240000
  gre.set_data(data)
  
  gre.send_event("restartTrailerEvent")
  --local idleTime = gre.get_value("appIdleTime")

  --reset the idle time and replay the trailer

  APP_idleApp()
end

function APP_loadImages(mapargs) 
  gre.load_resource("image", "images/MoviePosters/04Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster04.jpg")
  gre.load_resource("image", "images/MoviePosters/05Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster05.jpg")
  gre.load_resource("image", "images/MoviePosters/06Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster06.jpg")
  gre.load_resource("image", "images/MoviePosters/07Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster07.jpg")
  gre.load_resource("image", "images/MoviePosters/08Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster08.jpg")
  gre.load_resource("image", "images/MoviePosters/09Alt.jpg")
  gre.load_resource("image", "images/MoviePosters/poster09.jpg")
end

local coldLoad = 0

function APP_firstLoadAnims()
  --if (coldLoad == 0)then
    --coldLoad = 1
    gre.animation_trigger("APP_LoadingHides")
  --end
end

function start_trailer() 

  print("====gplay stop==== ")
  os.execute('pkill gplay-1.0')
  
  os.execute('gplay-1.0 /home/root/'..movieTrailer..' &')
  print("====gplay==== ")
  
end


--- @param gre#context mapargs
function stop_trailer(mapargs) 
--TODO: Your code goes here...
 print("====gplay stop==== ")
  os.execute('pkill gplay-1.0')
end



--- @param gre#context mapargs
function cb_timeoutVoice(mapargs) 
  gre.timer_set_timeout(function()
    gre.set_value("logo.voiceOverlay.grd_hidden",1)
  end,30000)
end
