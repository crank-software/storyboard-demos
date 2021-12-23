function animationCallsTiming()

  gre.timer_set_timeout(loadModels,10)
  gre.timer_set_timeout(startupAnimationCall,500)
  gre.timer_set_timeout(startupSmallTBTCall,2700)
  gre.timer_set_timeout(hideSmallTBTCall,5000)
  gre.timer_set_timeout(showLargeTBTCall,6200)
  gre.timer_set_timeout(hideLargeTBTCall,13000)
  gre.timer_set_timeout(showMaintenance,14400)
  gre.timer_set_timeout(MaintenanceCarBuild, 15000)
  gre.timer_set_timeout(openDoors,29000)
  gre.timer_set_timeout(Cabin,31000)
  gre.timer_set_timeout(Brake,34750)
  gre.timer_set_timeout(hideMaintenance, 40000)
  gre.timer_set_timeout(blinkerLeft, 42000)
  gre.timer_set_timeout(toArrival, 49000)
  gre.timer_set_timeout(shutdown, 53500)

end

function animationCallsTiming_Lite()
  gre.timer_set_timeout(LITE_dialsBack,5000)
  gre.timer_set_timeout(LITE_dialsUp,13500)
  gre.timer_set_timeout(LITE_CarRotation, 6000)
end

function LITE_dialsBack()
  gre.animation_trigger("dialsBack")
  gre.animation_trigger("hideSmallTBT")
end

function LITE_dialsUp()
  gre.animation_trigger("dialsUp")
  gre.animation_trigger("showSmallTBT")
end

function LITE_CarRotation()
  gre.animation_trigger("CAR_rotation")
end

function loadModels()
  gre.animation_trigger("loadModelsAnim")
end

function startupAnimationCall()
  gre.animation_trigger("StartupAnimation")
  gre.animation_trigger("mapReset")
end

function startupSmallTBTCall()
  gre.animation_trigger("speedometer")
  gre.animation_trigger("startupSmallTBT")
end

function hideSmallTBTCall()
  gre.animation_trigger("hideSmallTBT")
end

function showLargeTBTCall()
  gre.animation_trigger("showLargeTBT")
  gre.animation_trigger("dialsBack")
  gre.animation_trigger("mapOpening")
end

function hideLargeTBTCall()
  gre.animation_trigger("largeTBTToMaintenance")
end

function showMaintenance()
  gre.animation_trigger("showMaintenance")
end

function openDoors()
  gre.animation_trigger("CAR_doors")
end

function Cabin()
  gre.animation_trigger("CAR_cabin")
end

function Brake()
  gre.animation_trigger("CAR_brake")
end

function Engine()
  gre.animation_trigger("Engine")
end

function Headlights()
  gre.animation_trigger("Headlights")
end

function Tire()
  gre.animation_trigger("Tire")
end

function MaintenanceCarBuild()
  gre.animation_trigger("maintenanceCarBuild_REDONE")
end

function hideMaintenance()
  gre.animation_trigger("hideMaintenance")
  gre.animation_trigger("dialsUp")
  gre.animation_trigger("showSmallTBT")
end

function blinkerLeft()
  gre.animation_trigger("blinkerLeft")
end

function toArrival()
  gre.animation_trigger("TBTToArrival")
end

function shutdown()
  gre.animation_trigger("ClosingAnimation")
end