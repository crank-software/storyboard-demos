function init_set_time(mapargs)
  
  local data = {}
  
  data["top_status_layer.time.text"] = os.date("%H:%M | %b %d | 25")

  gre.set_data(data)
  
end