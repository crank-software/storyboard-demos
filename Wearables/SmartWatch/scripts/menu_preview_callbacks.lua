function cb_change_screen(mapargs)
  
  gre.set_value('screen_target', mapargs.screen_target)
  gre.send_event('screen_navigate')
end