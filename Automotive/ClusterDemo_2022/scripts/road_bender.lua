bend = 1
frame_num = 25 -- 51 road frames from 0 » 50  
frameCount = 25

function road_bend(mapargs)
  local data = {}
  
  animate_road = gre.animation_create(30,1)
  data ["key"] = "road.road_bender.image"
  
  if bend == 1 then
    for i = 1, frameCount do
      frame_num = frame_num + 1
      data["offset"] = i*33
      data["to"] = string.format('images/frames/road_%02d.png',frame_num)
      gre.animation_add_step(animate_road,data)
    end
    bend = 2
    frameCount = 50

  elseif bend == 2 then
    for i = 1, frameCount do
      frame_num = frame_num - 1
      data["offset"] = i*25
      data["to"] = string.format('images/frames/road_%02d.png',frame_num)
      gre.animation_add_step(animate_road,data)
    end
    bend = 3
    frameCount = 25
    
    
  elseif bend == 3 then
    for i = 1, frameCount do
      frame_num = frame_num + 1
      data["offset"] = i*40
      data["to"] = string.format('images/frames/road_%02d.png',frame_num)
      gre.animation_add_step(animate_road,data)
    end
    bend = 1
    frameCount = 25
  
  end 


  gre.animation_trigger(animate_road)
  
end


local road_timer = 5
local timerID2 = nil


function CBRoadTimer()
  timerID2 = gre.timer_set_interval(CBTick2,1000)
end


function CBTick2(mapargs)
  if (road_timer>0) then
    road_timer = road_timer - 1
  else
    CBBender()
  end
end

function CBBender(mapargs)
   gre.timer_clear_timeout(timerID2)
   road_bend()
   CBReset2()
end


function CBReset2()
  road_timer = 5
  timerID2 = nil
  CBRoadTimer()
end