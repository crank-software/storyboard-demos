local trends_timer
function startTimer()
    if not trends_timer then
    trends_timer = gre.timer_set_interval(update_small_graphs,50)
    end
end

function checkTrendsStatus(mapargs) 
  if trends_timer then
    gre.timer_clear_interval(trends_timer)
    trends_timer = nil
  end
end