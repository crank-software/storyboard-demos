local STEAM = "off"
local RINSE = "off"
local SIGNAL = "off"
local SANATIZE = "off"

function setupSpin(mapargs) 
    local data = {}
    text = mapargs.text
    data["settings_layer.set_spin.spin_txt"] = text

    if(text == "4")then
        data["settings_layer.set_spin.spin_txt"] = "No Spin"
    elseif(text == "3")then
        data["settings_layer.set_spin.spin_txt"] = "Low"
    elseif(text == "2")then
        data["settings_layer.set_spin.spin_txt"] = "Medium"
    elseif(text == "1")then
        data["settings_layer.set_spin.spin_txt"] = "High"
    end
    
    gre.set_data(data)

end

function setupTemperature(mapargs) 
    local data = {}
    text = mapargs.text
    data["settings_layer.set_temp.temp_txt"] = text

    if(text == "5")then
        data["settings_layer.set_temp.temp_txt"] = "Cold"
        
    elseif(text == "4")then
        data["settings_layer.set_temp.temp_txt"] = "Cool"
    elseif(text == "3")then
        data["settings_layer.set_temp.temp_txt"] = "Warm"
    elseif(text == "2")then
        data["settings_layer.set_temp.temp_txt"] = "Hot / Cold"
    elseif(text == "1")then
        data["settings_layer.set_temp.temp_txt"] = "Hot"
    end
    
    gre.set_data(data)

end

local pressedPos
local threshold  = 5

function CBHomePress(mapargs)
  local evData = mapargs.context_event_data
  pressedPos = evData['x']
end

function setupFabric(mapargs) 
  local evData = mapargs.context_event_data
  
  if(math.abs(evData['x'] - pressedPos) > threshold)then
    return
  end
  
  local data = {}
  local fabric = mapargs.fabric
  
  local controlLoc = gre.get_value(mapargs.context_control..".grd_x")
  local layerData = gre.get_layer_attrs('slidingSelection','xoffset')
  local scrollOffset = layerData['xoffset']
  local newLoc = controlLoc + scrollOffset
  
  data["startLayer.pressedControl.grd_x"] = newLoc
  data["startLayer.pressedCircleOverlay.grd_x"] = newLoc + 7
  data["settings_layer.set_fab.fab_txt"] = fabric
  data["startLayer.pressedControl.text"] = fabric
  data[mapargs.context_control..".grd_hidden"] = 1
  data["startLayer.pressedControl.grd_hidden"] = 0
  
  gre.set_data(data)
  gre.animation_trigger('START_selectFabric')
end

function set_temp(mapargs) 
  local data = {}
  TEMPERATURE = mapargs.temp.txt
  data["settings_layer.set_temp.temp_txt"] = temp.txt
  data["settings_layer.set_temp.temp_txt"] = "Cold"
gre.set_data(data)

end

function toggle_extras(mapargs)
    local data = {}
    local control = mapargs.context_control

    if(control == "setting_options.extras_group.signal")then
      if(SIGNAL == "on")then
        SIGNAL = "off"
        data[control..".text"] = "OFF"
        data[control..".fill_col"] = 0xFFFFFF
        data[control..".txt_col"] = 0x00AEEF
        data["settings_layer.set_options.icn_signal"] = "images/buzzerIcon.png"
      else
        SIGNAL = "on"
        data[control..".text"] = "ON"
        data[control..".fill_col"] = 0x00AEEF
        data[control..".txt_col"] = 0xFFFFFF
        data["settings_layer.set_options.icn_signal"] = "images/buzzerIconGrey.png"
      end
    elseif(control == "setting_options.extras_group.rinse")then

      if(RINSE == "on")then
        RINSE = "off"
        data[control..".text"] = "OFF"
        data[control..".fill_col"] = 0xFFFFFF
        data[control..".txt_col"] = 0x00AEEF
        data["settings_layer.set_options.icn_rinse"] = "images/rinseIcon.png"
      else
        RINSE = "on"
        data[control..".text"] = "ON"
        data[control..".fill_col"] = 0x00AEEF
        data[control..".txt_col"] = 0xFFFFFF
        data["settings_layer.set_options.icn_rinse"] = "images/rinseIconGrey.png"
      end
    elseif(control == "setting_options.extras_group.steam")then
      if(STEAM == "on")then
        STEAM = "off"
        data[control..".text"] = "OFF"
        data[control..".fill_col"] = 0xFFFFFF
        data[control..".txt_col"] = 0x00AEEF
        data["settings_layer.set_options.icn_steam"] = "images/steamIcon.png"
      else
        STEAM = "on"
        data[control..".text"] = "ON"
        data[control..".fill_col"] = 0x00AEEF
        data[control..".txt_col"] = 0xFFFFFF
        data["settings_layer.set_options.icn_steam"] = "images/steamIconGrey.png"
      end
    elseif(control == "setting_options.extras_group.sanatize")then
      if(SANATIZE == "on")then
        SANATIZE = "off"
        data[control..".text"] = "OFF"
        data[control..".fill_col"] = 0xFFFFFF
        data[control..".txt_col"] = 0x00AEEF
        data["settings_layer.set_options.icn_sanatize"] = "images/sanatizeIcon.png"
      else
        SANATIZE = "on"
        data[control..".text"] = "ON"
        data[control..".fill_col"] = 0x00AEEF
        data[control..".txt_col"] = 0xFFFFFF
        data["settings_layer.set_options.icn_sanatize"] = "images/sanatizeIconGrey.png"
      end

  end

  gre.set_data(data)
end


function clear_extras(mapargs)

STEAM = "off"
RINSE = "off"
SIGNAL = "off"
SANATIZE = "off"


  end
--
--signal
--rinse
--steam
--sanitize
 

--    elseif(control == "setting_options.extras_group.steam")then
--      if(STEAM == "on")then
--        STEAM = "off"
--        data[control..".text"] = "OFF"
--        data[control..".fill_col"] = 0xFFFFFF
--        data[control..".txt_col"] = 0x00AEEF
--        data["settings_layer.set_options.icn_steam"] = "images/steamIcon.png"
--      else
--        STEAM = "on"
--        data[control..".text"] = "ON"
--        data[control..".fill_col"] = 0x00AEEF
--        data[control..".txt_col"] = 0xFFFFFF
--        data["settings_layer.set_options.icn_steam"] = "images/steamIconGrey.png"
--      end
--    elseif(control == "setting_options.extras_group.sanatize")then
--      if(SANATIZE == "on")then
--        SANATIZE = "off"
--        data[control..".text"] = "OFF"
--        data[control..".fill_col"] = 0xFFFFFF
--        data[control..".txt_col"] = 0x00AEEF
--        data["settings_layer.set_options.icn_sanatize"] = "images/sanatizeIcon.png"
--      else
--        SANATIZE = "on"
--        data[control..".text"] = "ON"
--        data[control..".fill_col"] = 0x00AEEF
--        data[control..".txt_col"] = 0xFFFFFF
--        data["settings_layer.set_options.icn_sanatize"] = "images/sanatizeIconGrey.png"
--      end
