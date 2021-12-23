local tempF=20
local VIDEO = 0


function cb_init(mapargs)
  local sdata = {}
  
  if VIDEO == 0 then
    sdata["hidden"] = 0
  else
    sdata["hidden"] = 1
  end
   gre.set_layer_attrs_global("video_thumbnail_layer",sdata)
end

function cb_nav_animate(mapargs) 
   gre.send_event("nav_animation")
end

local function updateTemp(mapargs)
  local data = {}
  data["clim_in_layer.in_temp_val.text"] = tempF.."º"
    gre.set_data(data)
end

function cb_increase_temp(mapargs)
  tempF=tempF+1
  updateTemp()  
end

function cb_decrease_temp(mapargs)
  tempF=tempF-1
  
  updateTemp()  
end

function cb_load_images(mapargs) 
    local preload = {
    "images/Crank_screen.png",
    "images/climate_bg.png",
    "images/house_icn.png",
    "images/icn_weather.png",
    "images/640x480_downstairs.png",
    "images/chart_bg.png",
    "images/graph_chart.png",
    "images/key_up.png",
    "images/cli_back_arrow.png",
    "images/back_arrow.png",
    "images/shield_03.png",
    "images/shield_02.png",
    "images/shield_01.png",
    "images/house_icon.png",
    "images/disarm_up.png",
    "images/back_arrow1.png",
    "images/back_arrow_crank.png",
    "images/lock_box.png",
    "images/icn_lock.png",
    "images/shield_BG.png",
    }

    for i=1,#preload do
      gre.load_resource("image",preload[i])
    end
end
