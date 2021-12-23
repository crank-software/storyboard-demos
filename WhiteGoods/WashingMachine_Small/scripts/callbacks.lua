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

function setupFabric(mapargs) 
    local data = {}
    FABRIC = mapargs.fabric
    data["background_layer.bg_image.bg_image"] = fabric
    data["settings_layer.settings1.fab_txt"] = fabric
    if(FABRIC == "bedding")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/beddingBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Bedding"
    elseif(FABRIC == "cotton")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/cottonBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Cotton"
    elseif(FABRIC == "delicates")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/delicates2BG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Delicates"
    elseif(FABRIC == "eco")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/ecoBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Eco"
    elseif(FABRIC == "heavy")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/heavyBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Heavy"
    elseif(FABRIC == "press")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/permBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "P. Press"
    elseif(FABRIC == "quick")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/quickBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Quick Wash"
    elseif(FABRIC == "wool")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/woolBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Wool"
    elseif(FABRIC == "normal")then
      data["background_layer.bg_image.bg_image"] = "images/Backgrounds/normalBG.png"    
      data["settings_layer.set_fab.fab_txt"] = "Normal"
    end

gre.set_data(data)
       
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
