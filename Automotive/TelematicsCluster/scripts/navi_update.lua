

-- set up package paths
local myenv = gre.env({ "target_os", "target_cpu" })


package.cpath = gre.SCRIPT_ROOT .. "/" .. myenv.target_os .. "-" .. myenv.target_cpu .."/?.so;" .. package.cpath

local override_env = os.getenv("GRE_LUA_MODULES")
if (override_env) then
  package.cpath = override_env .."/?.so;" .. package.cpath
end

--pps = require 'lqnx_pps'
--jparse = require 'json'

local NAV_STATUS = "/pps/qnxcar/navigation/status"

function cb_nav_init()
--print(">> STATUS")
  NAV_STATUS = lqnx_pps.monitor_register_event(NAV_STATUS, "navigation.status", "msg")
end


-- just got some data so fill the poi main table
function cb_navigation_update_event(mapargs)
    local res = {}
    local data = {}
    local control = "poi_results_layer.poi_results"
  local i
--        print("UPDATE EVENT !!");
  res = navigation.get_poi_result()
  
    for a, b in pairs(res) do
        print(a, b)
    end
  
  if (res.msg == nil or res.msg ~= "getPOIs") then
    return 0
  end
--print("get locations\n");
  res = navigation.get_locations()
    local count = res and #res
  
  lat = {}
  long = {}
  
    i = 1
    if count > 0 then
        while (i <= count) do
        for a, b in pairs(res[i]) do
--        print(">> "..a.." "..b)
        end
          data[control .. '.name.' .. i .. '.1'] = res[i].name
          data[control .. '.address.' .. i .. '.1'] = res[i].city
        data[control .. '.color.' .. i .. '.1'] = 16777215
        data[control .. '.icon.' .. i .. '.1'] = "images/FAV_BTN_up4.png"
        data[control .. ".vshader."..i..".1"] = ""
      data[control .. ".fshader."..i..".1"] = ""
        lat[i] = res[i].latitude
        long[i] = res[i].longitude
        i = i + 1
        end
    -- show the poi_results
    data["poi_results_layer.poi_results.grd_hidden"] = 0
    data["poi_results_layer.poi_status.grd_hidden"] = 1
    data["poi_results_layer.poi_results.rows"] = i
    gre.set_data(data);
    gre.send_event("poi_results_table_resize")
    else
    data["poi_results_layer.poi_results.grd_hidden"] = 1
    data["poi_results_layer.poi_status.grd_hidden"] = 0
    data["poi_results_layer.poi_status.poi_status_text"] = "No results"
    gre.set_data(data);   
    end 

end

local on_navigation = false;
local received_data = false;  

function cb_navigation_status(mapargs)
  local data = {}
  local attrs = {"msg","dat"}
  local nav_data = {}

  --print("IN NAVIGATION STATUS") 
  data = lqnx_pps.get(NAV_STATUS, attrs)

  --print("PRINTING THE DATA FROM PPS")
  --print("--------------------------")

  for a, b in pairs(data) do
    --print(a,b)
    if(a == "maneuvers") then
      
      if(b == "null" and received_data == false and on_navigation == false) then
        return
      end
      
      if(on_navigation == false) then
        print("Sending switch to navi event")
        gre.send_event("switch_to_navi") 
        nav_data["module_navi_cluster.navi_turnby_bot.grd_hidden"] = 1
        nav_data["module_navi_cluster.navi_turnby_top.grd_hidden"] = 1
        gre.set_data(nav_data)
        on_navigation = true;
        received_data = false;  
        return
      end
           
      if(b == "null" and received_data == true and on_navigation == true) then
        --print("Navigation over, switching to maintenance")
        gre.send_event("switch_to_maintenance")
        on_navigation = false
        received_data = false
        return
      end 
      
      if(b == "null") then
        return
      end
      
      received_data = true 

      decoded_attr = json.decode(b)
      
      num_tables = #decoded_attr
      if(num_tables >= 2) then
        first = decoded_attr[1]
        second = decoded_attr[2]
        nav_data["module_navi_cluster.navi_turnby_bot.grd_hidden"] = 0
        nav_data["module_navi_cluster.navi_turnby_top.grd_hidden"] = 0
        nav_data["module_navi_cluster.navi_turnby_top.street_text"] = getStreet(first["street"])
        nav_data["module_navi_cluster.navi_turnby_bot.street_text"] = getStreet(second["street"])
        nav_data["module_navi_cluster.navi_turnby_top.distance"] = getDistance(first["distance"])
        nav_data["module_navi_cluster.navi_turnby_bot.distance"] = getDistance(second["distance"])
        nav_data["module_navi_cluster.navi_turnby_top.turn_direction"] = getImage(first["command"])
        nav_data["module_navi_cluster.navi_turnby_bot.turn_direction"] = getImage(second["command"])  
      else
        first = decoded_attr[1]
        nav_data["module_navi_cluster.navi_turnby_bot.grd_hidden"] = 1
        nav_data["module_navi_cluster.navi_turnby_top.grd_hidden"] = 0
        nav_data["module_navi_cluster.navi_turnby_top.street_text"] = getStreet(first["street"])
        nav_data["module_navi_cluster.navi_turnby_top.distance"] = getDistance(first["distance"])
        nav_data["module_navi_cluster.navi_turnby_top.turn_direction"] = getImage(first["command"])  
      end
      gre.set_data(nav_data)
    end
  end
  --print("--------------------------")
end

function getStreet(street)
  if(street == "") then
    return "Unknown Street"
  end
  return street
end

function getDistance(distance)
  dist = tonumber(distance)
  if(dist < 0) then
    dist = 0
  end
  
  if(dist > 1000) then
    dist = dist / 1000
    return tostring(dist) .. " km" 
  end
  return tostring(dist) .. " m"
end

function getImage(command)
  if(command == "dt") then
    return "images/navi_destination.png"
  elseif(command == "dt-l") then
    return "images/navi_destination_left.png"
  elseif(command == "dt-r") then
    return "images/navi_destination_right.png"
  elseif(command == "lht-rx") then
    return "images/navi_roundabout_left.png"
  elseif(command == "lht-ut") then
    return "images/navi_uturn_right.png"
  elseif(command == "nc") then
    return "images/navi_straight.png"
  elseif(command == "rx") then
    return "images/navi_roundabout_right.png"
  elseif(command == "tr-l") then
    return "images/navi_left.png"
  elseif(command == "tr-r") then
    return "images/navi_right.png"
  elseif(command == "ut") then
    return "images/navi_uturn.png"
  else
    return " "
  end
end
