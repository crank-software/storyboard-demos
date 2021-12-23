function animStep1()
  gre.animation_trigger('APP_dialsData')
  gre.animation_trigger('SMALL_showEco')
  gre.animation_trigger('TRANSITION_MenuShow')
  manageParticleAnimation('resume')
end

local function animStep2()
  gre.animation_trigger('SMALL_hideEco')
  gre.animation_trigger('MENU_ToMedia')
  songStart()
end

local function animStep3()
  gre.animation_trigger('SMALL_showMedia')
end

local function animStep4()
  gre.animation_trigger('3D_DialsOut')
  gre.animation_trigger('SMALL_hideMedia')
  gre.animation_trigger('TRANSITION_MenuHide')
  songClearTimer()
end

local function animStep5()
  gre.animation_trigger('TRANSITION_AdasShow')
  manageParticleAnimation('pause')
end

local function animStep5_1()
  gre.animation_trigger('ADAS_backWarning')
  autoSwapMode()
end

local function animStep5_2()
  gre.animation_trigger('ADAS_leftWarning')
end

local function animStep6()
  gre.animation_trigger('TRANSITION_AdasHide')
end

local function animStep7()
--add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('TRANSITION_MapShow2D')
  else
    gre.animation_trigger('TRANSITION_MapShow1')
  end
end

local function animStep8()
--add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('2D_Map1')
  else
    gre.animation_trigger('3D_Map1')
  end
end

local function animStep9()
--add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('TRANSITION_MapHide2D')
  else
    gre.animation_trigger('TRANSITION_MapHide')
  end
  gre.animation_trigger('3D_DialsIn')
  gre.animation_trigger('MENU_ToMedia')
  songStart()
  manageParticleAnimation('resume')
end

local function animStep10()
  gre.animation_trigger('TRANSITION_MenuShow')
  gre.animation_trigger('SMALL_showMedia')
end

local function animStep11()
  gre.animation_trigger('SMALL_hideMedia')
  gre.animation_trigger('MENU_ToEco')
  songClearTimer()
end

local function animStep12()
  gre.animation_trigger('SMALL_showEco')
end

local function animStep13()
  gre.animation_trigger('3D_DialsOut')
  gre.animation_trigger('SMALL_hideEco')
  gre.animation_trigger('TRANSITION_MenuHide')
end

local function animStep14()
  --add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('TRANSITION_MapShow2D')
  else
    gre.animation_trigger('TRANSITION_MapShow2')
  end
  manageParticleAnimation('pause')
end

local function animStep15()
--add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('2D_Map2')
  else
    gre.animation_trigger('3D_Map2')
  end
end

local function animStep15_2()
  autoSwapMode()
end

local function animStep16()
--add something in for simple maps
  if(configTable.simpleMap == 'on')then
    gre.animation_trigger('TRANSITION_MapHide2D')
  else
    gre.animation_trigger('TRANSITION_MapHide')
  end  
  gre.animation_trigger('3D_DialsIn')
  gre.animation_trigger('MENU_ToEco')
  manageParticleAnimation('resume')
end

local function animStep17()
  gre.animation_trigger('TRANSITION_MenuShow')
  gre.animation_trigger('SMALL_showEco')
end

local function loopAnims()
  animTimings()
  gre.animation_trigger('APP_dialsData')
end

function animTimings()

  --first step is triggered by init, not by the animation steps
  --animStep1()
  --gre.timer_set_timeout(animStep1,1000)
  gre.timer_set_timeout(animStep2,5000)
  gre.timer_set_timeout(animStep3,5400)
  gre.timer_set_timeout(animStep4,7500)
  gre.timer_set_timeout(animStep5,8500)
  gre.timer_set_timeout(animStep5_1,9500)
  gre.timer_set_timeout(animStep5_2,11000)
  gre.timer_set_timeout(animStep6,12000)
  gre.timer_set_timeout(animStep7,12500)
  gre.timer_set_timeout(animStep8,13500)
  gre.timer_set_timeout(animStep9,28500)
  gre.timer_set_timeout(animStep10,29500)
  gre.timer_set_timeout(animStep11,32000)
  gre.timer_set_timeout(animStep12,32400)
  gre.timer_set_timeout(animStep13,35000)
  gre.timer_set_timeout(animStep14,36000)
  gre.timer_set_timeout(animStep15,37000)
  gre.timer_set_timeout(animStep15_2,44000)
  gre.timer_set_timeout(animStep16,50000)
  gre.timer_set_timeout(animStep17,51000) 
  gre.timer_set_timeout(loopAnims,55000)
end

function animStep1Single()
  gre.animation_trigger('APP_dialsData')
  gre.animation_trigger('SMALL_showEco')
  gre.animation_trigger('TRANSITION_MenuShow')
  manageParticleAnimation('resume')
end

local function animStep2Single()
  gre.animation_trigger('SMALL_hideEco')
  gre.animation_trigger('MENU_ToMedia')
  songStart()
end

local function animStep3Single()
  gre.animation_trigger('SMALL_showMedia')
end

local function animStep4Single()
  gre.animation_trigger('SMALL_hideMedia')
  gre.animation_trigger('MENU_ToEco')
  songClearTimer()
end

local function animStep5Single()
  gre.animation_trigger('SMALL_showEco')
end

local function animStep6Single()
  gre.animation_trigger('SMALL_hideEco')
  gre.animation_trigger('MENU_ToPhone')
end

local function animStep7Single()
  gre.animation_trigger('SMALL_showPhone')
end

local function animStep8Single()
  gre.animation_trigger('SMALL_hidePhone')
  gre.animation_trigger('MENU_ToMedia')
  songStart()
end

local function animStep9Single()
  gre.animation_trigger('SMALL_showMedia')
end

local function animStep10Single()
  gre.animation_trigger('SMALL_hideMedia')
  gre.animation_trigger('MENU_ToEco')
  songClearTimer()
end

local function animStep11Single()
  gre.animation_trigger('SMALL_showEco')
end

local function animStep12Single()
  gre.animation_trigger('SMALL_hideEco')
  gre.animation_trigger('MENU_ToPhone')
end

local function animStep13Single()
  gre.animation_trigger('SMALL_showPhone')
end

local function animStep14Single()
  gre.animation_trigger('SMALL_hidePhone')
  gre.animation_trigger('MENU_ToMedia')
  songStart()
end

local function animStep15Single()
  gre.animation_trigger('SMALL_showMedia')
end

local function animStep16Single()
  gre.animation_trigger('SMALL_hideMedia')
  gre.animation_trigger('MENU_ToEco')
  songClearTimer()
end

local function animStep17Single()
  gre.animation_trigger('SMALL_showEco')
end


local function loopAnimsSingle()
  animTimingsSingle()
  gre.animation_trigger('APP_dialsData')
end


function animTimingsSingle()
  gre.timer_set_timeout(loopAnimsSingle,55000)
  gre.timer_set_timeout(animStep2Single,5000)
  gre.timer_set_timeout(animStep3Single,5400)
  gre.timer_set_timeout(animStep4Single,12000)
  gre.timer_set_timeout(animStep5Single,12400)
  gre.timer_set_timeout(animStep6Single,19000)
  gre.timer_set_timeout(animStep7Single,19400)
  gre.timer_set_timeout(animStep8Single,26000)
  gre.timer_set_timeout(animStep9Single,26400)
  gre.timer_set_timeout(animStep10Single,36000)
  gre.timer_set_timeout(animStep11Single,36400)
  gre.timer_set_timeout(animStep12Single,43000)
  gre.timer_set_timeout(animStep13Single,43400)
  gre.timer_set_timeout(animStep14Single,48000)
  gre.timer_set_timeout(animStep15Single,48400)
  gre.timer_set_timeout(animStep16Single,53000)
  gre.timer_set_timeout(animStep17Single,53500)
end