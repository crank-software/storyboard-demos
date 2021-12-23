local hvacModes = {OFF=1, HEATING=2, COOLING=3, ERROR=4}
local fanModes = {ON=1, AUTO=2, ERROR=3}

local ACTIVE_THERMOSTAT="thermo_layer.thermostat"
local lastDegrees=70


--{"notif":"property_update","property":{"value":222,"id":{"name":"setpoint_temp","did":"0001C014F4A7-thermostat"}}}

function updateThermoUI(self)
  local data={}
  local target=self.controlData.groupName
  ACTIVE_THERMOSTAT = target
  local hvacMode=self.properties.hvac_mode
  data[target..".therm_status.text"] = hvacMode
  data[target..".hvac_mode"] = hvacModes[hvacMode]
  local fanMode=self.properties.fan_mode
  data[target..".therm_fanstatus.text"] = "FAN: "..fanMode
  data[target..".fan_mode"] = fanModes[fanMode]
  ACTIVE_THERMOSTAT_CIRCLE = target
  lastDegrees=math.floor(tonumber(self.properties.setpoint_temp))
  thermostat_set_amb_temp(self.properties.ambient_temp)
  thermostat_display_set_temp(self.properties.setpoint_temp)
  gre.set_data(data)
end

function updateThermoData(property,value,group)
  print("\nupdating "..group.." "..tostring(value).." : "..property)
  local device=getObjectByGroup(group)
  if(device)then
    local props=device:get_properties()
    props[property]=value
    --sendSetProperty(property,value,device:get_did())
    --Set the top level label
  else
    print("Could not find the device, No update sent")
  end
end


function thermostat_set_context(mapargs)
  ACTIVE_THERMOSTAT = "home_quicklaunch.thermostat"
end

function thermostat_toggle_heat(mapargs)
  local data_table = {}
  data_table = gre.get_data(mapargs.context_group..".hvac_mode")
  local curr_hvac = tonumber(data_table[mapargs.context_group..".hvac_mode"])

  if(curr_hvac ~= 4)then
    local data = {}
    data[mapargs.context_group..".therm_status.text"] = "HEATING"
    data[mapargs.context_group..".hvac_mode"] = 2

    data[mapargs.context_group..".therm_off.image"] = "images/therm_off.png"
    data[mapargs.context_group..".therm_cool.image"] = "images/therm_cool.png"
    data[mapargs.context_group..".therm_heat.image"] = "images/therm_heat_selected.png"

    updateThermoData("hvac_mode","HEATING",ACTIVE_THERMOSTAT)
    gre.set_data(data)
  end

end

function thermostat_toggle_cool(mapargs)

  local data_table = {}
  data_table = gre.get_data(mapargs.context_group..".hvac_mode")
  local curr_hvac = tonumber(data_table[mapargs.context_group..".hvac_mode"])

  if(curr_hvac ~= 4)then
    local data = {}
    data[mapargs.context_group..".therm_status.text"] = "COOLING"
    data[mapargs.context_group..".hvac_mode"] = 3

    data[mapargs.context_group..".therm_off.image"] = "images/therm_off.png"
    data[mapargs.context_group..".therm_cool.image"] = "images/therm_cool_selected.png"
    data[mapargs.context_group..".therm_heat.image"] = "images/therm_heat.png"

    updateThermoData("hvac_mode","COOLING",ACTIVE_THERMOSTAT)
    gre.set_data(data)
  end
end

function thermostat_toggle_off(mapargs)

  local data_table = {}
  data_table = gre.get_data(mapargs.context_group..".hvac_mode")
  local curr_hvac = tonumber(data_table[mapargs.context_group..".hvac_mode"])

  if(curr_hvac ~= 4)then
    local data = {}
    data[mapargs.context_group..".therm_status.text"] = "OFF"
    data[mapargs.context_group..".hvac_mode"] = 1

    data[mapargs.context_group..".therm_off.image"] = "images/therm_off_selected.png"
    data[mapargs.context_group..".therm_cool.image"] = "images/therm_cool.png"
    data[mapargs.context_group..".therm_heat.image"] = "images/therm_heat.png"

    updateThermoData("hvac_mode","OFF",ACTIVE_THERMOSTAT)

    gre.set_data(data)
  end

end

function thermostat_set_error(mapargs)
    local data = {}
    data[mapargs.context_group..".therm_status.text"] = "ERROR"
    data[mapargs.context_group..".hvac_mode"] = 4
    gre.set_data(data)
 end

function thermostat_fan_set_error(mapargs)
    local data = {}
    data[mapargs.context_group..".therm_status.text"] = "ERROR"
    data[mapargs.context_group..".fan_mode"] = 3
    gre.set_data(data)
 end

function thermostat_toggle_fan(mapargs)
  --1 on
  --2 auto
  --3 off
  --4 error

  local data_table = {}
  local data = {}

  data_table = gre.get_data(mapargs.context_group..".fan_mode")
  local curr_fan = data_table[mapargs.context_group..".fan_mode"]

  if(curr_fan == 4)then
    return
  end

  curr_fan = curr_fan + 1
  if(curr_fan > 2)then
    curr_fan = 1
  end

  if(curr_fan == 1)then
    data[mapargs.context_group..".therm_fanstatus.text"] = "FAN: ON"
    updateThermoData("fan_mode","ON",ACTIVE_THERMOSTAT)
  elseif(curr_fan == 2)then
    data[mapargs.context_group..".therm_fanstatus.text"] = "FAN: AUTO"
    updateThermoData("fan_mode","AUTO",ACTIVE_THERMOSTAT)
  end

  data[mapargs.context_group..".fan_mode"] = curr_fan
  gre.set_data(data)

end

function thermostat_set_amb_temp(inc_temp)

  local data = {}
  local amb_temp = math.floor(inc_temp + 0.49)

  data[ACTIVE_THERMOSTAT..".therm_amb_temp.text"] = "current: "..amb_temp.."°"
  data[ACTIVE_THERMOSTAT..".curr_temp"] = amb_temp

  gre.set_data(data)
end

local ACTIVE_THERMOSTAT_CIRCLE

function thermostat_press(mapargs)
  ACTIVE_THERMOSTAT_CIRCLE = mapargs.context_group

  local dk_data = {}

  dk_data = gre.get_data(ACTIVE_THERMOSTAT_CIRCLE..".hvac_mode")
  local hvac_mode = tonumber(dk_data[ACTIVE_THERMOSTAT_CIRCLE..".hvac_mode"])

  if(hvac_mode == 4)then
    return
  else
    thermostat_set_temp(mapargs)
  end
  thermostat_motion(mapargs)
end

function thermostat_motion(mapargs)
  if (ACTIVE_THERMOSTAT_CIRCLE == nil) then
    return
  end

  local dk_data = {}

  dk_data = gre.get_data(ACTIVE_THERMOSTAT_CIRCLE..".hvac_mode")
  local hvac_mode = tonumber(dk_data[ACTIVE_THERMOSTAT_CIRCLE..".hvac_mode"])

  if(hvac_mode == 4)then
    return
  else
    thermostat_set_temp(mapargs)
  end

end

function thermostat_release(mapargs)
  updateThermoData("setpoint_temp",lastDegrees,ACTIVE_THERMOSTAT)
  ACTIVE_THERMOSTAT_CIRCLE = nil

end

function thermostat_set_temp(mapargs)
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
  dk_data = gre.get_data(ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_width",ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_height",ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_x",ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_y",ACTIVE_THERMOSTAT_CIRCLE..".grd_x",ACTIVE_THERMOSTAT_CIRCLE..".grd_y")

  --"controls_layer.light_open_colour"
  mid_x = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_width"] / 2
  mid_y = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_height"] / 2
  ctrl_x = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_x"]
  ctrl_y = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.grd_y"]
  grp_x = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".grd_x"]
  grp_y = dk_data[ACTIVE_THERMOSTAT_CIRCLE..".grd_y"]

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

  if(degrees > 49 and degrees < 90)then
    degrees = 49
  elseif(degrees > 90 and degrees < 130)then
    degrees = 130
  end

  data[ACTIVE_THERMOSTAT_CIRCLE..".therm_indicator.rot"] = degrees + 90
  gre.set_data(data)

  --setting up the degrees to be between  and 360
  if(degrees > 0 and degrees < 50)then
    degrees = degrees + 360
  end

  degrees = degrees - 130
  degrees = math.floor(((degrees * 60) / 276) + 40)

  thermostat_display_set_temp(degrees)
  lastDegrees=degrees
end

function thermostat_display_set_temp(inc_degrees)
  local data = {}
  local degrees = tonumber(inc_degrees)
  data["thermo_layer.thermostat.therm_temp.text"] = lastDegrees.."°"
  print(ACTIVE_THERMOSTAT..".therm_temp.text "..lastDegrees.."°")
  if(degrees<40)then
    degrees=40
  elseif(degrees>100)then
    degrees=100
  end
  data[ACTIVE_THERMOSTAT..".therm_indicator.rot"] = (degrees-40)/(100-40)*288-144
  gre.set_data(data)
end
