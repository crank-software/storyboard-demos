function openingtimings(mapargs)

  --gre.timer_set_timeout(opening_anim_bg, 500)
  gre.timer_set_timeout(speed_gauge_openinglines, 2000)
  gre.timer_set_timeout(speed_gauge_opening, 5500)
  gre.timer_set_timeout(rpm_gauge_opening, 10000)
  gre.timer_set_timeout(center_left_lines_opening, 8500)
  gre.timer_set_timeout(small_gauges, 16000)
  gre.timer_set_timeout(center_console, 12000)
  gre.timer_set_timeout(upper_overlay, 14000)
  gre.timer_set_timeout(opening_car, 18000)

end

function opening_anim_bg()
  gre.animation_trigger("opening_anim_bg")
end

function speed_gauge_openinglines()
  gre.animation_trigger("opening_anim_speed_gauge_1")
end

function speed_gauge_opening()
  gre.animation_trigger("opening_anim_speed_gauge_2")
end

function center_left_lines_opening()
  gre.animation_trigger("opening_anim_center_lines")
end

function center_console()
  gre.animation_trigger("opening_anim_center_modules")
end

function upper_overlay()
  gre.animation_trigger("opening_anim_upper_overlay")
end

function small_gauges()
  gre.animation_trigger("opening_anim_small_gauges")
end

function rpm_gauge_opening()
  gre.animation_trigger("opening_anim_rpm_gauge_2")
end

function start_continuous_anims()
  gre.animation_trigger("continuous_anim_center_lines")
end

function opening_car()
  gre.animation_trigger("opening_anim_car_drive_in")
end