TEMP_UNITS = "F"

--- @param gre#context mapargs
function cb_temperature_update(mapargs)
  local data = {}
  data["Temperature"] = string.format("%4.1f", mapargs.context_event_data.value)
  data["Temperature_Unit"] = string.format("º%c", mapargs.context_event_data.unit)
  if(string.char(mapargs.context_event_data.unit) ~= TEMP_UNITS) then
    TEMP_UNITS = string.char(mapargs.context_event_data.unit)
    gre.animation_trigger("temp_toggle_"..TEMP_UNITS)
  end
  gre.set_data(data)
end