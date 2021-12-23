--Global Variables Listings

local SPEED = nil
local RPM = nil
local ENGINE_TEMP = nil
local MAX_ENGINE_TEMP = 75
local MIN_ENGINE_TEMP = -50
local FUEL = nil
local MAX_FUEL = 65
local MIN_FUEL = 5
local HEADING = nil
local CUR_HEADING = 1



--This function sets the speed that is shown in the digital display as well as the gauge
--Layers Affected:speed_layer
--Global Variables Used/Defined:SPEED

function setspeed(mapargs)

  local data = {}

  SPEED = math.random(0,140)
  SPEED = math.floor(SPEED + 0.5) 
  animation_speed()

  gre.set_data(data)
  
end



function update_speed_number(mapargs)

  local data = {}
  
  data = gre.get_data("speed_layer.needle.rot", "rpm_layer.needle_rpm.rot")
  
  local val = data["speed_layer.needle.rot"]+123
  local percent = val/246
  local speed = percent * 140
  speed = math.floor(speed + 0.5)
  
  local rval = data["rpm_layer.needle_rpm.rot"]+123
  local rpercent = rval/246
  local rpm = rpercent * 70
  rpm = math.floor(rpm + 0.5)
  
  data = {}
  data["rpm_layer.digital_display_control_rpm.rpm"] = tostring(rpm)
  data["speed_layer.digital_display_control.speed"] = tostring(speed)
  gre.set_data(data)  

end



--This function sets the speed that is shown in the digital display as well as the gauge
--Layers Affected:rpm_layer
--Global Variables Used/Defined: RPM

function setrpm(mapargs)

  local data = {}
  print("setrpm")
  
  RPM = math.random(0,140)
  RPM = math.floor(RPM + 0.5) 
  animation_rpm()

  gre.set_data(data)

end


--function update_rpm_number(mapargs)

 -- local data = {}
  
 -- data = gre.get_data("rpm_layer.needle_rpm.rot")
  
--  local val = data["rpm_layer.needle_rpm.rot"]+123
--  local percent = val/246
--  local rpm = percent * 70
--  rpm = math.floor(rpm + 0.5)
  
--  data["rpm_layer.digital_display_control_rpm.rpm"] = tostring(string.format("%d", rpm))
--  gre.set_data(data)  
--end

--This function sets the compass, and starts the compass animation
--Layers Affected: compass_and_lights_layer
--Global Variables Used/Defined: CUR_COMPASS_POS, NEW_COMPASS_POS, HEADING, CUR_HEADING

local CUR_COMPASS_POS = -323*.66
local NEW_COMPASS_POS = -1

function compass(mapargs)
  local data = {}
  
  HEADING = math.random(0,359) --INPUT OF THE ACTUAL VALUE THAT WE GET FROM THE SYSTEM
  HEADING = math.floor(HEADING + 0.5) 

  NEW_COMPASS_POS = math.floor((-(1000*HEADING) / 360) + 0.5)
  
  if(HEADING > CUR_HEADING)then    
    if(HEADING - CUR_HEADING >180)then
      --Snap to the right side of the image and move left
      CUR_COMPASS_POS = CUR_COMPASS_POS -1000
      animation_compass()
    else
      --Snap to the left side of the image and move right
      animation_compass()
    end
  elseif(HEADING < CUR_HEADING)then   
    if(CUR_HEADING - HEADING <180)then
      --Snaps to the right side of the image and move left
      animation_compass()
    else
      --Snaps to the left side of the image and move right
      animation_compass()
      CUR_COMPASS_POS = CUR_COMPASS_POS -1000
    end
  else
  end
  
  CUR_HEADING = HEADING
  CUR_COMPASS_POS = NEW_COMPASS_POS
end


--This function sets engine temp, with no animation
--Layers Affected: gauges_layer
--Global Variables Used/Defined: MAX_ENGINE_TEMP, MIN_ENGINE_TEMP, ENGINE_TEMP
function engine_temp(mapargs)

  local data = {}
  local engine_range = nil
  local control_range = nil
  local percentage = nil
  local min_control_width = 46*.66
  local max_control_width = 323*.66
  local final_control_width = nil
  
  
  --finds the range of the engine temperature (used for finding the percentage of how cold the engine is)
  engine_range = MAX_ENGINE_TEMP - MIN_ENGINE_TEMP
  control_range = max_control_width - min_control_width
  ENGINE_TEMP = math.random(MIN_ENGINE_TEMP, MAX_ENGINE_TEMP) --INPUT OF THE ACTUAL VALUE THAT WE GET FROM THE SYSTEM
  --the percentage of how cold the engine is, match it to the percentage width of the control (between 0-1)
  percentage = ((ENGINE_TEMP + (-MIN_ENGINE_TEMP)) / engine_range)
  
  final_control_width = control_range * percentage + min_control_width
  
  data["gauges_layer.engine_temperature_fill.grd_width"] = final_control_width

  gre.set_data(data)
  
end

--This function sets fuel amount, with no animation
--Layers Affected: gauges_layer
--Global Variables Used/Defined: MAX_FUEL, MIN_FUEL, FUEL
function fuel_amount(mapargs)

  local data = {}
  local fuel_range = nil
  local control_range = nil
  local percentage = nil
  local min_control_width = 66*.66
  local max_control_width = 342*.66
  local final_control_width = nil
  
  
  --finds the range of the engine temperature (used for finding the percentage of how cold the engine is)
  fuel_range = MAX_FUEL - MIN_FUEL
  control_range = max_control_width - min_control_width
  FUEL = math.random(MIN_FUEL,MAX_FUEL) --INPUT OF THE ACTUAL VALUE THAT WE GET FROM THE SYSTEM
  --the percentage of how cold the engine is, match it to the percentage width of the control (between 0-1)
  percentage = ((FUEL + (-MIN_FUEL)) / fuel_range)
  
  final_control_width = control_range * percentage + min_control_width
  
  data["gauges_layer.fuel_amount_fill.grd_width"] = final_control_width

  gre.set_data(data)
  
end



-- ---------------------------------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------ANIMATION BLOCK FOR GAUGES-------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------------------------------------------


--COMPASS ANIMATION------
--This animates the compass from its current position to the new position over the span of one second
function animation_compass(mapargs)
 
  local anim_data = {}
  
  local compass_movement = gre.animation_create(60, 1)
  
  anim_data["key"] = "compass_and_lights_layer.compass.position"
  anim_data["rate"] = "easeinout"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["from"] = CUR_COMPASS_POS
  anim_data["to"] = NEW_COMPASS_POS
  
  gre.animation_add_step(compass_movement, anim_data)
  
  
  gre.animation_trigger(compass_movement)  

end

--SPEED GAUGE ANIMATION--
--This animates the speed from its current speed to the new speed over the course of 1 second
function animation_speed(mapargs)
   
  --
  local needle_rotation = nil
  local speed_rotation = nil
  needle_rotation = (((245 * SPEED)/140)-122)
  speed_rotation = (((250 * SPEED)/140)-215)
  --
   
  local anim_data = {}
  
  local speed_movement = gre.animation_create(60, 1)
  
  anim_data["key"] = "speed_layer.needle.rot"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["to"] = needle_rotation
  
  gre.animation_add_step(speed_movement, anim_data)

  anim_data["key"] = "speed_layer.outer_ring_control.end_angle"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["to"] = speed_rotation
  
  gre.animation_add_step(speed_movement, anim_data)  
  
  gre.animation_trigger(speed_movement)  

end

--RPM GAUGE ANIMATION--
--This animates the speed from its current rpm to the new rpm over the course of 1 second
function animation_rpm(mapargs)
   print("animrpm")
  --
  local needle_rotation = nil
  local rpm_rotation = nil
  needle_rotation = (((245 * RPM)/140)-122)
  rpm_rotation = (((250 * RPM)/140)-215)
  --
   
  local anim_data = {}
  
  local rpm_movement = gre.animation_create(60, 1)
  
  anim_data["key"] = "rpm_layer.needle_rpm.rot"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["to"] = needle_rotation
  
  gre.animation_add_step(rpm_movement, anim_data)

  anim_data["key"] = "rpm_layer.outer_ring_control_rpm.end_angle"
  anim_data["rate"] = "linear"
  anim_data["duration"] = 1000
  anim_data["offset"] = 0
  anim_data["to"] = rpm_rotation
  
  gre.animation_add_step(rpm_movement, anim_data)  
  
  gre.animation_trigger(rpm_movement)  

end
