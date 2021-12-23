local lights={
  kitchen1={state=0,control="floorplan1_touch_layer.lig_kit1"},
  kitchen2={state=0,control="floorplan1_touch_layer.lig_kit2"},
  dining={state=0,control="floorplan1_touch_layer.lig_din"},
  stairs1={state=0,control="floorplan1_touch_layer.sta1"},
  living={state=0, control="floorplan1_touch_layer.lig_liv"},
  lounge={state=0, control="floorplan1_touch_layer.lig_lou"},
  study={state=0, control="floorplan1_touch_layer.lig_stu"},

  yard={state=0, control="lig_extra_layer.lig_yard_control"},
  garage={state=0, control="lig_extra_layer.lig_garage_control"},
  energy={state=0, control="lig_extra_layer.energy_control"},



  bed1={state=0, control="floorplan2_touch_layer.lig_bed1"},
  bed2={state=0, control="floorplan2_touch_layer.lig_bed2"},
  bed3={state=0, control="floorplan2_touch_layer.lig_bed3"},
  stairs2={state=0, control="floorplan2_touch_layer.sta2"},
  office={state=0, control="floorplan2_touch_layer.lig_off"},
}

function updateLights(mapargs)
  local dk_data={}
  for k,v in pairs(lights) do   --go through each of the lights
    if(v.state==1)then --check the lights state
      dk_data[v.control..".alpha"]=255
      else
      dk_data[v.control..".alpha"]=0
    end
  end

  gre.set_data(dk_data)
end

function cb_toggleLight(mapargs)
  local name=mapargs.name
  print(lights[name].state)

  if(lights[name].state==1)then
    lights[name].state=0
  else
    lights[name].state=1
  end

  updateLights(mapargs) --send it over to update all the lights
end

function cb_toggleAllOff(mapargs)
  for k,v in pairs(lights) do
    v.state=0
  end
  updateLights(mapargs)
 end