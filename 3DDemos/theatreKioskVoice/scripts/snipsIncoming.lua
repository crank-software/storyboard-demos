function trailer_voice(mapargs) 
  local evData = mapargs.context_event_data
  
  if (evData.movie ~= nil) then
    local movie = 0
    if (evData.movie == "El Dorado") then movie = 1
    elseif (evData.movie == "Moment of Intensity") then movie = 2
    elseif (evData.movie == "Indoor soccer") then movie = 3
    elseif (evData.movie == "Seconds that Count") then movie = 4
    elseif (evData.movie == "Lifting Off") then movie = 5
    elseif (evData.movie == "Unspoken Friend") then movie = 6
    elseif (evData.movie == "Storyboard connector") then movie = 7
    elseif (evData.movie == "Storyboard suite") then movie = 8
    elseif (evData.movie == "Photoshop reimport") then movie = 9 end
    
    MOVIESCREEN_SetMovie(movie)
    
    if (mapargs.context_screen == "viewtrailerScreen") then
      gre.animation_trigger("TRANSITION_showTrailer")
    else
       gre.animation_trigger("TRANSITION_postersToTrailer")
    end
    
  elseif (mapargs.context_screen == "selectMovieScreen") then
    gre.set_value("logo.Repeat.grd_hidden", 0)
  else
    gre.send_event("TrailerScreen")
  end
end

function tickets_voice(mapargs) 
  local evData = mapargs.context_event_data
  
  if(evData.movie ~= nil) then
    local movie = 0
    if (evData.movie == "El Dorado") then movie = 1
    elseif (evData.movie == "Moment of Intensity") then movie = 2
    elseif (evData.movie == "Indoor soccer") then movie = 3
    elseif (evData.movie == "Seconds that Count") then movie = 4
    elseif (evData.movie == "Lifting Off") then movie = 5
    elseif (evData.movie == "Unspoken Friend") then movie = 6
    elseif (evData.movie == "Storyboard connector") then movie = 7
    elseif (evData.movie == "Storyboard suite") then movie = 8
    elseif (evData.movie == "Photoshop reimport") then movie = 9 end
    
    MOVIESCREEN_SetMovie(movie)
    gre.animation_trigger("TRANSITION_postersToTime")
    
  elseif (mapargs.context_screen == "selectMovieScreen") then
    gre.set_value("logo.Repeat.grd_hidden", 0)
    
  elseif (mapargs.context_screen == "viewtrailerScreen") then
    gre.animation_trigger("TRANSITION_hideTrailer")
  end
  
  if(evData.number ~= nil) then
    adultTickets = evData.number
    TIMESSCREEN_updateTickets()
  end
  
end
