--VARIABLES TO CHANGE/WHAT THEY DO
--FORMAT (VARIABLE::COMMENT ON WHAT THEY CHANGE)

--"mapargs.context_group.colour" :: master colour, changes the colour of all of the neccessary circles
--"mapargs.context_group.dimmer" :: vaule of the dimmer in alpha, changes the alpha of the light fill
--"mapargs.context_group.toggle" :: master toggle connected to the light
--"mapargs.context_group.toggle_text" :: the ON OFF text at the bottom of the light
--"mapargs.context_group.light_open_dimmer.rot" :: the location of the finger dot for the dimmer on the top
--"mapargs.context_group.light_open_colour.rotation" :: location of the finger dot for the hue outline
--"mapargs.context_group.light_icon.image" :: small image of the light icon for when its small -use images/light_icon.png for on and images/light_icon_off_1 for off
--"mapargs.context_group.light_open_colour.image" :: cutout image of the light for the large one --use images/light_bg_cutout for on and images/light_bg_cutout for off


--WHAT TO CHANGE FOR STANDARD USE CASES

--TURN LIGHT ON OFF :: REFER TO light_toggle FUNCTION ON LINE 192
--CHANGE COLOUR OF THE LIGHT :: "mapargs.context_group.colour", "mapargs.context_group.light_open_colour.rotation"
--  colour is hex code, you can run your input colour through set_colour(inc_degrees) where inc_degrees is the hue degrees (only works with HSV to Hex)
--CHANGE DIMMER VALUE OF THE LIGHT ::  "mapargs.context_group.light_open_dimmer.rot", "mapargs.context_group.dimmer"
--  dimmer is an alpha value, 255 is full strength, 0 is no strength

  --self.proprties
    -- on=false,
    -- brightness=100,
    -- pulse=false,
    -- hue=223,
    -- saturation=100,
    -- color_temperature=0
    -- }

  --self.controlData
      -- title="Light",
      -- room="bedroom",
      -- controlType="light",
      -- groupName="house_bedroom_controls_layer.light",
      -- did="BULB-fe980ecf80bfbfa7629659b0a5ea8d34"


--{"notif":"property_update","property":{"value":90,"id":{"name":"hue","did":"BULB-fe980ecf80bfbfa7629659b0a5ea8d34"}}}


local ACTIVE_LIGHT = nil
local ACTIVE_LIGHT_COLOUR = nil
local ACTIVE_LIGHT_DIMMER = nil
local ACTIVE_LAYER = nil

local LIGHT_CIRCLE_MODE = 1

local lastDegrees=nil
local lastDim=nil

function updateLightUI(self, name, value)
  local data={}
  local data_table = {}
  local target=self.controlData.groupName
  local save_active=ACTIVE_LIGHT
  ACTIVE_LIGHT=target
  set_colour(self.properties.hue,1)
  set_colour(self.properties.brightness/100*360,2)
  set_colour(self.properties.saturation/100*360,3)

  data_table = gre.get_data(target..".mode", target..".brightness_deg", target..".hue_deg", target..".sat_deg")

  -- if the control is open and property "on" was updated then send events to trigger the animations
  if CURRENT_OPEN == target and name == "on" then
    if (self.properties.on)then
      gre.send_event_target("light_toggle_on",target..".light_status")
    else
      gre.send_event_target("light_toggle_off",target..".light_status")
    end

    --light_to_color_mode(self.controlData.groupName, 1)
    --light_to_temp_mode(self.controlData.groupName, 1)

  else
    if (self.properties.on)then --the light is on
      local curr_mode = data_table[target..".mode"]
      local bright = data_table[target..".brightness_deg"]
      local hue = data_table[target..".hue_deg"]
      local sat = data_table[target..".sat_deg"]
      local colour = {}

      data[target..".button_b.image"] = "images/button_b.png"
      --data[target..".button_h.image"] = "images/button_h.png"
      data[target..".light_status.text"] = "ON"
      data[target..".Hue.image"] = "images/Hue.png"
      data[target..".ColourTemp.image"] = "images/ColourTemp1.png"

      if(curr_mode == 1)then
        data[target..".button_s.image"] = "images/button_s.png"
        colour['r'], colour['g'], colour['b'] = hsvToRgb(1, 0, 1) --(Hue, Sat, brightness), Between 0 and 1
      else
        data[target..".button_s.image"] = "images/button_s_locked.png"
        colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, sat, bright) --(Hue, Sat, brightness), Between 0 and 1
      end

      data[target..".toggle"] = 1

    else -- the light is off
      data[target..".button_b.image"] = "images/button_b_locked.png"
      data[target..".button_h.image"] = "images/button_h_locked.png"
      data[target..".button_s.image"] = "images/button_s_locked.png"
      data[target..".Hue.alpha"] = 255
      data[target..".Hue.image"] = "images/off_circle.png"
      data[target..".ColourTemp.image"] = "images/off_circle.png"
      data[target..".light_status.text"] = "OFF"
      data[target..".toggle"] = 0
      data[target..".colour"] = 13421772
    end

    data[self.controlData.overallDisplay]=string.lower(data[target..".light_status.text"])
    gre.set_data(data)

  end

  set_indicator_pos(LIGHT_CIRCLE_MODE)

  --light_to_color_mode(self.controlData.groupName, 1)
  --light_to_temp_mode(self.controlData.groupName, 1)
  ACTIVE_LIGHT=save_active
end


function updateLightData(property,value,group)
  print("\nupdating "..group.." "..tostring(value).." "..property)

  if(group=="global_light_layer.light")then
    print("Got all light property update")
    local sendTable={req="set_property",details= {group_id= {group= "lights",name= property},value= value}}
    --sendUDPDatagram(sendTable)
    return
  end

  local device=getObjectByGroup(group)
  if(device)then
    local props=device:get_properties()
    props[property]=value
    --device:update()
    --sendSetProperty(property,value,device:get_did())

    --Set the top level label
    if(property=="on")then
      local data={}
      local topLabel=device:get_controlData().overallDisplay
      if(value)then
        data[topLabel]="on"
      else
        data[topLabel]="off"
      end
      gre.set_data(data)
    end
  else
    print("Could not find the device, No update sent")
  end

end

--On off use case for opening the global light and setting the active light to the global screen light
function light_global_open()
  ACTIVE_LIGHT = "global_light_layer.light"
  local data_table = {}
  local light_mode, light_status

  data_table = gre.get_data(ACTIVE_LIGHT..".mode",ACTIVE_LIGHT..".toggle")
  light_mode = data_table[ACTIVE_LIGHT..".mode"]
  light_status = data_table[ACTIVE_LIGHT..".toggle"]

  if(light_mode == 1)then
    LIGHT_CIRCLE_MODE = 1
  else
    LIGHT_CIRCLE_MODE = 4
  end

end

--sets the active light to the group of the small light you just pressed.
--This gives us context in the following scripts
function light_small_open(mapargs)
  ACTIVE_LIGHT = mapargs.context_group

  if(CURRENT_OPEN~=nil)then
    gre.send_event_target("close_control",CURRENT_OPEN..".auto_close")
  end
  CURRENT_OPEN=mapargs.context_group

  local data_table = {}
  local light_mode = nil
  local light_status = nil

  --checks to see if the light is in colour mode or temp mode
  data_table = gre.get_data(ACTIVE_LIGHT..".mode",ACTIVE_LIGHT..".toggle")
  light_mode = data_table[ACTIVE_LIGHT..".mode"]
  light_status = data_table[ACTIVE_LIGHT..".toggle"]

  if(light_status == 1)then
    if(light_mode == 1)then
     -- print("open to hue")
      LIGHT_CIRCLE_MODE = 1
      gre.send_event_target("light_open",mapargs.context_control)
      set_indicator_pos(1)
      data_table[ACTIVE_LIGHT..".mode_control.text"] = "COLOUR"

    else
      --print("open to temp")
      LIGHT_CIRCLE_MODE = 4
      gre.send_event_target("light_open2",mapargs.context_control)
      set_indicator_pos(4)
      data_table[ACTIVE_LIGHT..".mode_control.text"] = "TEMPERATURE"
    end
    gre.set_data(data_table)
  else
    --print("open to off")
    gre.send_event_target("light_open3",mapargs.context_control)
  end


  --gre.animation_trigger("light_open")
  --gre.send_event_target("light_open",mapargs.context_group)
end

function light_small_close(mapargs)
  if(CURRENT_OPEN==mapargs.context_group)then
    CURRENT_OPEN=nil
  end
end

function light_press(mapargs)

  ACTIVE_LIGHT = mapargs.context_group
  ACTIVE_LIGHT_COLOUR = mapargs.context_group

  local toggle = nil
  local dk_data = {}

  dk_data = gre.get_data(ACTIVE_LIGHT..".toggle")
  toggle = dk_data[ACTIVE_LIGHT..".toggle"]

  if(toggle == 1)then
    light_degrees_setup(mapargs)
  end

end

function light_motion(mapargs)
  if (ACTIVE_LIGHT_COLOUR == nil) then
    return
  end

  local toggle = nil
  local dk_data = {}

  dk_data = gre.get_data(ACTIVE_LIGHT..".toggle")
  toggle = dk_data[ACTIVE_LIGHT..".toggle"]

  if(toggle == 1)then
    if (ACTIVE_LIGHT == mapargs.context_group) then
      light_degrees_setup(mapargs)
    end
  end
end

local setDegrees=180 -- This gets set on motion depending on mode and is used to set once released

function light_release(mapargs)
--  if (ACTIVE_LIGHT == mapargs.context_group and lastDegrees ~= nil) then
--    updateLightData("hue",lastDegrees,mapargs.context_group)
--    lastDegrees=nil
--  end
  ACTIVE_LIGHT = mapargs.context_group
  local type = LIGHT_CIRCLE_MODE
  if(type == 1)then
    updateLightData("hue",math.floor(setDegrees),ACTIVE_LIGHT)
  elseif(type == 2)then
    updateLightData("brightness",setDegrees*100,ACTIVE_LIGHT)
  elseif(type == 3)then
    updateLightData("saturation",setDegrees*100,ACTIVE_LIGHT)
  elseif(type == 4)then
    updateLightData("color_temperature",math.floor(2500+(setDegrees*400)),ACTIVE_LIGHT)
  end
  ACTIVE_LIGHT_COLOUR = nil

end

--LIGHT MODES (HUE, BRIGHTNESS/DIMMER, SATURATION, COLOUR TEMP)
-- 1: HUE
-- 2: BRIGHTNESS
-- 3: SATURATION
-- 4: COLOUR TEMP

function light_set_mode(mapargs)
  ACTIVE_LIGHT = mapargs.context_group
  local data_table = {}
  local data = {}
  local light_mode = nil
  local control_pressed = mapargs.context_control

  --checks to see if the light is in colour mode or temp mode
  data_table = gre.get_data(ACTIVE_LIGHT..".toggle", ACTIVE_LIGHT..".mode")
  local toggle = data_table[ACTIVE_LIGHT..".toggle"]
  light_mode = data_table[ACTIVE_LIGHT..".mode"]

  --print(toggle)

  if(toggle == 0)then
  return
  end

  if(mapargs.context_control == ACTIVE_LIGHT..".button_h")then

    if(light_mode == 1)then
        --print("pressed Hue")
        --gre.animation_trigger("light_to_hue")
        gre.send_event_target("light_to_hue", mapargs.context_control)
        LIGHT_CIRCLE_MODE = 1
        data[ACTIVE_LIGHT..".mode_control.text"] = "COLOUR"
    else
        --print("pressed Temp")
        --gre.animation_trigger("light_to_hue")
        gre.send_event_target("light_to_hue2", mapargs.context_control)
        LIGHT_CIRCLE_MODE = 4
        data[ACTIVE_LIGHT..".mode_control.text"] = "TEMPERATURE"
    end
  elseif(mapargs.context_control == ACTIVE_LIGHT..".light_fill")then
    if(light_mode == 1)then
      --print("pressed Hue")
      --gre.animation_trigger("light_to_hue")
      gre.send_event_target("light_to_hue", mapargs.context_control)
      LIGHT_CIRCLE_MODE = 1
      data[ACTIVE_LIGHT..".mode_control.text"] = "COLOUR"
    end
  elseif(mapargs.context_control == ACTIVE_LIGHT..".button_b")then
    --print("pressed Brightness")
    --gre.animation_trigger("light_to_brightness")
    if(light_mode == 1)then
      gre.send_event_target("light_to_brightness", mapargs.context_control)
    else
      gre.send_event_target("light_to_brightness2", mapargs.context_control)
    end

    LIGHT_CIRCLE_MODE = 2
    data[ACTIVE_LIGHT..".mode_control.text"] = "DIMMER"

  elseif(mapargs.context_control == ACTIVE_LIGHT..".button_s")then
    if(light_mode==0)then
    return
    end
    --print("pressed saturation")
    --gre.animation_trigger("light_to_saturation")
    gre.send_event_target("light_to_saturation", mapargs.context_control)
    LIGHT_CIRCLE_MODE = 3
    data[ACTIVE_LIGHT..".mode_control.text"] = "SATURATION"
  end

  set_indicator_pos(LIGHT_CIRCLE_MODE)
  gre.set_data(data)
end

function light_degrees_setup(mapargs)
  local dk_data = {}
  local data = {}
  local ev_data = {}
  local press_pos = {}
  local mid_x, mid_y
  local ctrl_x, ctrl_y
  local grp_x, grp_y
  local click
  local tri_x, tri_y
  local radians, degrees

  ev_data = mapargs.context_event_data
  dk_data = gre.get_data(ACTIVE_LIGHT..".indicator.grd_width",ACTIVE_LIGHT..".indicator.grd_height",ACTIVE_LIGHT..".indicator.grd_x",ACTIVE_LIGHT..".indicator.grd_y",ACTIVE_LIGHT..".grd_x",ACTIVE_LIGHT..".grd_y")

  --"controls_layer.light_open_colour"
  mid_x = dk_data[ACTIVE_LIGHT..".indicator.grd_width"] / 2
  mid_y = dk_data[ACTIVE_LIGHT..".indicator.grd_height"] / 2
  ctrl_x = dk_data[ACTIVE_LIGHT..".indicator.grd_x"]
  ctrl_y = dk_data[ACTIVE_LIGHT..".indicator.grd_y"]
  grp_x = dk_data[ACTIVE_LIGHT..".grd_x"]
  grp_y = dk_data[ACTIVE_LIGHT..".grd_y"]

  press_pos["x"] = ev_data.x - ctrl_x - grp_x
  press_pos["y"] = ev_data.y - ctrl_y - grp_y

  tri_x = press_pos["x"] - mid_x
  tri_y = mid_y - press_pos["y"]

  radians = math.atan2(press_pos["y"] - mid_y,  press_pos["x"] - mid_x)
  degrees = math.deg(radians)

  if(degrees < 0)then
    --on the top portion of the circle
    degrees = 360 - math.abs(degrees)
  else
  --on the bottom portion of the circle
  end

  if(degrees > 54 and degrees < 90)then
    degrees = 54
  elseif(degrees > 90 and degrees < 126)then
    degrees = 126
  end

  data[ACTIVE_LIGHT..".indicator.rot"] = degrees + 90
  gre.set_data(data)

  --setting up the degrees to be between 0 and 360
  if(degrees > 0 and degrees < 55)then
    degrees = degrees + 360
  end

  degrees = degrees - 126
  degrees = (360*degrees)/288

  set_colour(degrees, LIGHT_CIRCLE_MODE)
end

function setRGB(control, r,g,b)
  local data = {}
  data[control..".r"] = r/255
  data[control..".g"] = g/255
  data[control..".b"] = b/255
  gre.set_data(data) 
end

--function to get degrees setup for the colours
--Pass in the value and the type, all values have to be between 0 and 360, function will then set it up to be between 1 and 0 and setup the hsv to hex conversion
function set_colour(inc_degrees, inc_type)
   --TYPE LEGENED BELOW

  -- 1: HUE
  -- 2: BRIGHTNESS
  -- 3: SATURATION
  -- 4: COLOUR TEMP

  --GET THE HSV from the variables attached to the light
  local data_table = {}
  local hue, sat, bright, temp, mode

  data_table = gre.get_data(ACTIVE_LIGHT..".mode", ACTIVE_LIGHT..".hue_deg",ACTIVE_LIGHT..".brightness_deg",ACTIVE_LIGHT..".sat_deg",ACTIVE_LIGHT..".temp_deg")
  bright = data_table[ACTIVE_LIGHT..".brightness_deg"]
  hue = data_table[ACTIVE_LIGHT..".hue_deg"]
  sat = data_table[ACTIVE_LIGHT..".sat_deg"]
  temp = data_table[ACTIVE_LIGHT..".temp_deg"]
  mode = data_table[ACTIVE_LIGHT..".mode"]

  --start to setup the HSV into the correct positions
  local data = {}
  local colour = {}
  local hue_colour = {}
  local degrees = inc_degrees/360

  degrees = round(degrees, 2)
  --print("colour_degrees: "..degrees )

  lastDegrees=math.floor(inc_degrees)
  local type = inc_type

  if(type == 1)then
    colour['r'], colour['g'], colour['b'] = hsvToRgb(degrees, sat, bright) --(Hue, Sat, brightness), Between 0 and 1
    hue_colour['r'], hue_colour['g'], hue_colour['b'] = hsvToRgb(degrees, 1, 1) --(Hue, Sat, brightness), Between 0 and 1
    data[ACTIVE_LIGHT..".hue_deg"] = degrees
    local huehex = rgbToHex(hue_colour)
    data[ACTIVE_LIGHT..".hue_colour"] = huehex
    setDegrees=inc_degrees
    setRGB(ACTIVE_LIGHT..".SatColour",colour['r'], colour['g'], colour['b'])
  elseif(type == 2)then
    if(mode == 1)then
      colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, sat, degrees) --(Hue, Sat, brightness), Between 0 and 1
      setRGB(ACTIVE_LIGHT..".SatColour",colour['r'], colour['g'], colour['b'])
    else
      if(temp <= 0.5)then
        local orange_half = temp*2 -- Sets the degrees between 0 and 1 for math
        local orange_sat = (1- orange_half) / 3
        colour['r'], colour['g'], colour['b'] = hsvToRgb(0.07, orange_sat, degrees) --(Hue, Sat, brightness), Between 0 and 1
        --set the colour to orange, change up the saturation
      else
        local blue_half = (temp - 0.5)*2 -- Sets the degrees between 0 and 1 for math
        local blue_sat = blue_half / 3
        colour['r'], colour['g'], colour['b'] = hsvToRgb(0.625, blue_sat, degrees) --(Hue, Sat, brightness), Between 0 and 1
        --set the colour to orange, change up the saturation
      end
    end
    data[ACTIVE_LIGHT..".brightness_deg"] = degrees
    setDegrees=degrees
  elseif(type == 3)then
    colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, degrees, bright) --(Hue, Sat, brightness), Between 0 and 1
    data[ACTIVE_LIGHT..".sat_deg"] = degrees
    setDegrees=degrees
    setRGB(ACTIVE_LIGHT..".SatColour",colour['r'], colour['g'], colour['b'])
  elseif(type == 4)then
    local temp_sat_deg
    if(degrees <= 0.5)then
      local orange_half = degrees*2 -- Sets the degrees between 0 and 1 for math
      local orange_sat = (1- orange_half) / 3
      colour['r'], colour['g'], colour['b'] = hsvToRgb(0.07, orange_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
      --set the colour to orange, change up the saturation
    else
      local blue_half = (degrees - 0.5)*2 -- Sets the degrees between 0 and 1 for math
      local blue_sat = blue_half / 3
      colour['r'], colour['g'], colour['b'] = hsvToRgb(0.625, blue_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
      --set the colour to orange, change up the saturation
    end
    --colour['r'], colour['g'], colour['b'] = hsvToRgb(1, 0, bright) --(Hue, Sat, brightness), Between 0 and 1
    data[ACTIVE_LIGHT..".temp_deg"] = degrees
    setDegrees=degrees
  end

  local hexcolor = rgbToHex(colour)


  data[ACTIVE_LIGHT..".colour"] = hexcolor
  data[ACTIVE_LIGHT..".light_colour"] = hexcolor


  gre.set_data(data)
end

--sets the indicator position, pass in the type
-- 1: HUE
-- 2: BRIGHTNESS
-- 3: SATURATION
-- 4: COLOUR TEMP

--sets the indicator position, due to the way data is stored the number passed in must be between 1 and 0
function set_indicator_pos(inc_type)

  local type = inc_type
  local data_table = {}
  local data = {}

  data_table = gre.get_data(ACTIVE_LIGHT..".brightness_deg", ACTIVE_LIGHT..".hue_deg", ACTIVE_LIGHT..".sat_deg", ACTIVE_LIGHT..".temp_deg")
  --pull in data, they are stored between 1 and 0, so multiply by 288 to get it to be in our deg space
  local hue_deg = data_table[ACTIVE_LIGHT..".hue_deg"] * 288
  local sat_deg = data_table[ACTIVE_LIGHT..".sat_deg"] * 288
  local bright_deg = data_table[ACTIVE_LIGHT..".brightness_deg"] * 288
  local temp_deg = data_table[ACTIVE_LIGHT..".temp_deg"] * 288

  if(type == 1)then

    hue_deg = hue_deg + 126
    if(hue_deg > 415)then
      hue_deg = hue_deg - 360
    end

    data[ACTIVE_LIGHT..".indicator.rot"] = hue_deg + 90
    --print(hue_deg)
  --set hue pos
  elseif(type == 2)then

    bright_deg = bright_deg + 126
    if(bright_deg > 415)then
      bright_deg = bright_deg - 360
    end

    data[ACTIVE_LIGHT..".indicator.rot"] = bright_deg + 90
    --print(bright_deg)
  --set bright pos
  elseif(type == 3)then

    sat_deg = sat_deg + 126
    if(sat_deg > 415)then
      sat_deg = sat_deg - 360
    end

    data[ACTIVE_LIGHT..".indicator.rot"] = sat_deg + 90
    --print(sat_deg)
  --set sat pos

  elseif(type == 4)then

    temp_deg = temp_deg + 126
    if(temp_deg > 415)then
      temp_deg = temp_deg - 360
    end

    data[ACTIVE_LIGHT..".indicator.rot"] = temp_deg + 90
    --print(hue_deg)
  --set hue pos
  end

  gre.set_data(data)

end


--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]

function hsvToRgb(h, s, v)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if (i == 0) then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255
end


--Converts the RGB codes to hex to allow us to input it
--https://gist.github.com/marceloCodget/3862929

function rgbToHex(rgb)
  local hexadecimal = '0X'

  for key, value in pairs(rgb) do
    local hex = ''

    while(value > 0)do
      local index = math.fmod(value, 16) + 1
      value = math.floor(value / 16)
      hex = string.sub('0123456789ABCDEF', index, index) .. hex
    end

    if(string.len(hex) == 0)then
      hex = '00'

    elseif(string.len(hex) == 1)then
      hex = '0' .. hex
    end

    hexadecimal = hexadecimal .. hex
  end

  return hexadecimal
end

local mode = 1

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--toggles the light mode (colour or temp)
--1 = colour
--0 = temp
function light_toggle_mode(mapargs)

  local colour = {}
  local data_table = gre.get_data(ACTIVE_LIGHT..".temp_deg", ACTIVE_LIGHT..".toggle", ACTIVE_LIGHT..".hue_deg",ACTIVE_LIGHT..".brightness_deg",ACTIVE_LIGHT..".sat_deg")
  local toggle = data_table[ACTIVE_LIGHT..".toggle"]

  if(toggle == 0)then
    return
  end

  local data = {}

  if(mapargs.context_control == ACTIVE_LIGHT..".temp_mode")then
    data[ACTIVE_LIGHT..".mode"] = 0
    mode = 0
    --gre.animation_trigger("light_to_temp")

    if(mapargs.context_group ~= "global_light_layer.light")then
      local saturationObject = getObjectByGroup(mapargs.context_group)---SET SAT TO 0 WHEN SET TO White
      local thisDID = saturationObject.controlData.did
      saturationObject.properties.savedSat=saturationObject.properties.saturation

      --sendSetProperty("saturation",0,thisDID)
    else
      local sendTable={req="set_property",details= {group_id= {group= "lights",name= "saturation"},value= 0}}

      --sendUDPDatagram(sendTable)
    end

    local temp = data_table[ACTIVE_LIGHT..".temp_deg"]
    local bright = data_table[ACTIVE_LIGHT..".brightness_deg"]

    if(temp <= 0.5)then
      local orange_half = temp*2 -- Sets the degrees between 0 and 1 for math
      local orange_sat = (1- orange_half) / 3
      colour['r'], colour['g'], colour['b'] = hsvToRgb(0.07, orange_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
      --set the colour to orange, change up the saturation
    else
      local blue_half = (temp - 0.5)*2 -- Sets the degrees between 0 and 1 for math
      local blue_sat = blue_half / 3
      colour['r'], colour['g'], colour['b'] = hsvToRgb(0.625, blue_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
      --set the colour to orange, change up the saturation
    end

    data[ACTIVE_LIGHT..".temp_mode.image"] = "images/mode_white_selected_button.png"
    data[ACTIVE_LIGHT..".colour_mode.image"] = "images/mode_colour_button.png"

    gre.send_event_target("light_to_temp", mapargs.context_control)
    LIGHT_CIRCLE_MODE = 4
    set_indicator_pos(LIGHT_CIRCLE_MODE)

  elseif(mapargs.context_control == ACTIVE_LIGHT..".colour_mode")then
    data[ACTIVE_LIGHT..".mode"] = 1
    mode = 1
    --gre.animation_trigger("light_from_temp")

    if(mapargs.context_group ~= "global_light_layer.light")then ---SET SAT BACK TO SAVED WHEN SET TO COLOR
      local saturationObject = getObjectByGroup(mapargs.context_group)
      local resetSaturation = saturationObject.properties.savedSat
      data[ACTIVE_LIGHT..".sat_deg"]=saturationObject.properties.savedSat/100
      updateLightData("saturation",resetSaturation,mapargs.context_group)
    else
      local sendTable={req="set_property",details= {group_id= {group= "lights",name= "saturation"},value= 100}}
      data[ACTIVE_LIGHT..".sat_deg"]=1.0
      --sendUDPDatagram(sendTable)
    end

    local bright = data_table[ACTIVE_LIGHT..".brightness_deg"]
    local hue = data_table[ACTIVE_LIGHT..".hue_deg"]
    local sat = data_table[ACTIVE_LIGHT..".sat_deg"]

    colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, sat, bright) --(Hue, Sat, brightness), Between 0 and 1
    --set the colour of the controls (THIS IS A PLACEHOLDER FOR A REAL ANIMATION)

    data[ACTIVE_LIGHT..".temp_mode.image"] = "images/mode_white_button.png"
    data[ACTIVE_LIGHT..".colour_mode.image"] = "images/mode_colour_selected_button.png"

    gre.send_event_target("light_from_temp", mapargs.context_control)
    LIGHT_CIRCLE_MODE = 1
    set_indicator_pos(LIGHT_CIRCLE_MODE)

  end

  local hexcolor = rgbToHex(colour)

  data[ACTIVE_LIGHT..".colour"] = hexcolor
  data[ACTIVE_LIGHT..".light_colour"] = hexcolor

  gre.set_data(data)

end

--Turns light on and off
--Sets toggle state to keep track of
--1 = ON
--0 = OFF
function light_toggle_state(mapargs)

  local toggle, mode
  local dk_data = {}
  local data = {}
  local colour = {}

  dk_data = gre.get_data(ACTIVE_LIGHT..".temp_deg", ACTIVE_LIGHT..".toggle", ACTIVE_LIGHT..".mode", ACTIVE_LIGHT..".hue_deg",ACTIVE_LIGHT..".brightness_deg",ACTIVE_LIGHT..".sat_deg")
  toggle = dk_data[ACTIVE_LIGHT..".toggle"]
  mode = dk_data[ACTIVE_LIGHT..".mode"]

  if(toggle == 0)then
    data[ACTIVE_LIGHT..".toggle"] = 1
    --gre.animation_trigger("light_toggle_on")
    if(mode == 1)then
      gre.send_event_target("light_toggle_on",mapargs.context_control)
      local bright = dk_data[ACTIVE_LIGHT..".brightness_deg"]
      local hue = dk_data[ACTIVE_LIGHT..".hue_deg"]
      local sat = dk_data[ACTIVE_LIGHT..".sat_deg"]

      colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, sat, bright) --(Hue, Sat, brightness), Between 0 and 1
    else
      local temp = dk_data[ACTIVE_LIGHT..".temp_deg"]
      local bright = dk_data[ACTIVE_LIGHT..".brightness_deg"]

      if(temp <= 0.5)then
        local orange_half = temp*2 -- Sets the degrees between 0 and 1 for math
        local orange_sat = (1- orange_half) / 3
        colour['r'], colour['g'], colour['b'] = hsvToRgb(0.07, orange_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
        --set the colour to orange, change up the saturation
      else
        local blue_half = (temp - 0.5)*2 -- Sets the degrees between 0 and 1 for math
        local blue_sat = blue_half / 3
        colour['r'], colour['g'], colour['b'] = hsvToRgb(0.625, blue_sat, bright) --(Hue, Sat, brightness), Between 0 and 1
        --set the colour to orange, change up the saturation
      end
      gre.send_event_target("light_toggle_on2",mapargs.context_control)
    end

    local hexcolor = rgbToHex(colour)

    data[ACTIVE_LIGHT..".colour"] = hexcolor
    data[ACTIVE_LIGHT..".light_colour"] = hexcolor

    updateLightData("on",true,ACTIVE_LIGHT)

  else
    data[ACTIVE_LIGHT..".toggle"] = 0
    --gre.animation_trigger("light_toggle_off")
    gre.send_event_target("light_toggle_off",mapargs.context_control)
    updateLightData("on",false,ACTIVE_LIGHT)
  end

  gre.set_data(data)
end


function light_to_color_mode(groupName, groupOpen)

  local incoming_light
  local open

  local colour = {}
  local data_table = gre.get_data(incoming_light..".toggle", incoming_light..".hue_deg",incoming_light..".brightness_deg",incoming_light..".sat_deg")
  local toggle = data_table[incoming_light..".toggle"]
  local data = {}

  data[incoming_light..".mode"] = 1

  local bright = data_table[incoming_light..".brightness_deg"]
  local hue = data_table[incoming_light..".hue_deg"]
  local sat = data_table[incoming_light..".sat_deg"]

  colour['r'], colour['g'], colour['b'] = hsvToRgb(hue, sat, bright) --(Hue, Sat, brightness), Between 0 and 1
  --set the colour of the controls (THIS IS A PLACEHOLDER FOR A REAL ANIMATION)

  data[incoming_light..".temp_mode.fill_colour"] = 0xFFFFFF
  data[incoming_light..".temp_mode.text_colour"] = 0xF2511A
  data[incoming_light..".colour_mode.fill_colour"] = 0xF2511A
  data[incoming_light..".colour_mode.text_colour"] = 0xFFFFFF

  local hexcolor = rgbToHex(colour)

  data[incoming_light..".colour"] = hexcolor
  data[incoming_light..".light_colour"] = hexcolor

  gre.set_data(data)

  if(open == 1)then
    gre.send_event_target("light_from_temp", incoming_light.context_control)
    LIGHT_CIRCLE_MODE = 1
  end

end

function light_to_temp_mode(groupName, groupOpen)

  local incoming_light = groupName
  local open = groupOpen

  local colour = {}
  local data_table = gre.get_data(incoming_light..".toggle", incoming_light..".hue_deg",incoming_light..".brightness_deg",incoming_light..".sat_deg")
  local toggle = data_table[incoming_light..".toggle"]
  local data = {}

  data[incoming_light..".mode"] = 0

  colour['r'], colour['g'], colour['b'] = hsvToRgb(1, 0, 1) --(Hue, Sat, brightness), Between 0 and 1
  --set the colour of the controls (THIS IS A PLACEHOLDER FOR A REAL ANIMATION)

  data[ACTIVE_LIGHT..".temp_mode.fill_colour"] = 0xF2511A
  data[ACTIVE_LIGHT..".temp_mode.text_colour"] = 0xFFFFFF
  data[ACTIVE_LIGHT..".colour_mode.fill_colour"] = 0xFFFFFF
  data[ACTIVE_LIGHT..".colour_mode.text_colour"] = 0xF2511A

  local hexcolor = rgbToHex(colour)

  data[incoming_light..".colour"] = hexcolor
  data[incoming_light..".light_colour"] = hexcolor

  gre.set_data(data)

  if(open == 1)then
    gre.send_event_target("light_to_temp", mapargs.context_control)
    LIGHT_CIRCLE_MODE = 4
  end

end

function setup_global_saturation(mapargs) 
  ACTIVE_LIGHT = "global_light_layer.light"
  set_colour(180,1)
end
