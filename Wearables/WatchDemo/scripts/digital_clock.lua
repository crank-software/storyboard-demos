local date_time = require "date_time"

function set_digital_clock() 
  local time = date_time.get_current_time()
  local date = date_time.get_current_date()
  
  local data = {}
  data["digital_clock_layer.hour_control.text"] = string.format("%02d", time.hour)
  data["digital_clock_layer.minute_control.text"] = string.format("%02d", time.minute)
  data["digital_clock_layer.date_control.text"] = string.format("%s %s %02d", date.weekday, date.month, date.day )
  
  gre.set_data(data)
end
