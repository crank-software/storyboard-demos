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


---
function cb_start_leaf_video(mapargs)  
  --print("Start home screen video")
  if VIDEO == 1 then
    os.execute(gre.SCRIPT_ROOT.."/run-leaf-video.sh &")
  end
end

function cb_start_rain_video(mapargs)  
  --print("Start home screen video")
  if VIDEO == 1 then
    os.execute(gre.SCRIPT_ROOT.."/run-rain-video.sh &")
  end        
end

function cb_start_cloud_video(mapargs)  
  --print("Start home screen video")
    if VIDEO == 1 then
      os.execute(gre.SCRIPT_ROOT.."/run-cloud-video.sh &")
    end
end

function cb_start_parking_video(mapargs)  
  --print("Start home screen video")
  if VIDEO == 1 then
    os.execute(gre.SCRIPT_ROOT.."/run-parking-video.sh &")
  end
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

