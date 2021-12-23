local brakes_toggle = 1
local engine_toggle = 0
local fluid_toggle = 0
local tyres_toggle = 0

function vm_brakes_toggle()
  if(brakes_toggle == 0)then
    gre.animation_trigger("vm_brakes_show")
    brakes_toggle = 1
  end
 
  if(engine_toggle == 1)then
    gre.animation_trigger("vm_engine_hide")
    engine_toggle = 0
  end
  
  if(fluid_toggle == 1)then
    gre.animation_trigger("vm_fluid_hide")
    fluid_toggle = 0
  end
  
  if(tyres_toggle == 1)then
    gre.animation_trigger("vm_tyres_hide")
    tyres_toggle = 0
  end    


end

function vm_engine_toggle()
  if(engine_toggle == 0)then
    gre.animation_trigger("vm_engine_show")
    engine_toggle = 1
  end
  
  if(brakes_toggle == 1)then
    gre.animation_trigger("vm_brakes_hide")
    brakes_toggle = 0
  end
  
  if(fluid_toggle == 1)then
    gre.animation_trigger("vm_fluid_hide")
    fluid_toggle = 0
  end
  
  if(tyres_toggle == 1)then
    gre.animation_trigger("vm_tyres_hide")
    tyres_toggle = 0
  end  

end

function vm_fluid_toggle()
  if(fluid_toggle == 0)then
    gre.animation_trigger("vm_fluid_show")
    fluid_toggle = 1
  end
  
  if(engine_toggle == 1)then
    gre.animation_trigger("vm_engine_hide")
    engine_toggle = 0
  end
  
  if(brakes_toggle == 1)then
    gre.animation_trigger("vm_brakes_hide")
    brakes_toggle = 0
  end
  
  if(tyres_toggle == 1)then
    gre.animation_trigger("vm_tyres_hide")
    tyres_toggle = 0
  end  

end

function vm_tyres_toggle()
  if(tyres_toggle == 0)then
    gre.animation_trigger("vm_tyres_show")
    tyres_toggle = 1
  end
  
  if(engine_toggle == 1)then
    gre.animation_trigger("vm_engine_hide")
    engine_toggle = 0
  end
  
  if(fluid_toggle == 1)then
    gre.animation_trigger("vm_fluid_hide")
    fluid_toggle = 0
  end
  
  if(brakes_toggle == 1)then
    gre.animation_trigger("vm_brakes_hide")
    brakes_toggle = 0
  end  

end