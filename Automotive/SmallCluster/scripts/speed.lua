
function updateSpeed(mapargs)
  local angle = gre.get_value("speed_layer.speed_pointer_control.angle")
  angle = math.floor(angle + 0.5)
  local percent = (angle+110)/110
  gre.set_value("speed_layer.value.text",string.format("%d",percent*100))

end

