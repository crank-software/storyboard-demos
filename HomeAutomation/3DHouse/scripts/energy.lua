local ENERGY_OPEN = 0

function energy_open()
  --gre.animation_trigger("utility_moving_graph")
  ENERGY_OPEN = 1
end

function energy_check_if_open()
  if(ENERGY_OPEN == 1)then
   -- gre.animation_trigger("utility_moving_graph")    
  end
end

function energy_close()
  ENERGY_OPEN = 0
end

function update_energy_number(mapargs)

  local data_table = {}
  local data = {}
  local consume,produce

  data_table= gre.get_data("eco_layer.energy.energy_moving_graph_red.energy","eco_layer.energy.energy_moving_graph_green.energy")
  consume = data_table["eco_layer.energy.energy_moving_graph_red.energy"]
  produce = data_table["eco_layer.energy.energy_moving_graph_green.energy"]

  local overall = produce - consume
  
  data["eco_layer.energy.energy_stat.text"] = overall.." kWh"
  data["eco_layer.energy.energy_produced.text"] = produce.." kWh"
  data["eco_layer.energy.energy_consumed.text"] = consume.." kWh"
  
  gre.set_data(data)
  
  --print(overall)
  
end