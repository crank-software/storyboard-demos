function CBFlipLayer1(mapargs)

  local gdata = {}
  local incPos = gre.get_value("appImages1.position")
  
  gdata = setupLayerData(incPos)
    
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("appImages1",attrs)

  --everything folds at the same time to keep only 1 event going we will be making a function for each movement layer
  flipLayer2()
  flipLayer3()
  falseLayer1()
  falseLayer2()
  falseLayer3()
end

function flipLayer2()
  local gdata = {}
  local incPos = gre.get_value("appImages2.position")
  
  gdata = setupLayerData(incPos)
  
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("appImages2",attrs)

end

function flipLayer3()
  local gdata = {}
  local incPos = gre.get_value("appImages3.position")
 
  gdata = setupLayerData(incPos)
   
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("appImages3",attrs)

end

function falseLayer1()
  --local ev_data = mapargs.context_event_data;
  --setup the mouseX value, and the value to set
  local gdata = {}
  local incPos = gre.get_value("falseAppImages1.position")
  
  gdata = setupLayerData(incPos)
  
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("falseAppImages1",attrs)
end

function falseLayer2()
  local gdata = {}
  local incPos = gre.get_value("falseAppImages2.position")
  
  gdata = setupLayerData(incPos)
  
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("falseAppImages2",attrs)
end

function falseLayer3()
  local gdata = {}
  local incPos = gre.get_value("falseAppImages3.position")

  gdata = setupLayerData(incPos)
  
  local attrs = {}
  attrs["geometry"] = {
      width = 800,
      height = 480,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("falseAppImages3",attrs)
end

function setupLayerData(pos)

  local data = {}
  
  if(pos<150)then
  
    data = {
    
      --Triangle 1
      {x = 526,               y=0,            z=0,        u=(526/800),  v=0},
      {x = 139,               y=480,          z=0,        u=(139/800),  v=1},
      {x = 650-pos*1.2,       y=480,          z=pos/2.5,        u=(650/800),  v=1},
      
      {x = 526,               y=0,            z=0,        u=(526/800),  v=0},
      {x = 800-pos*.6575,     y=0,            z=pos/2,        u=1,          v=0},
      {x = 650-pos*1.2,       y=480,          z=pos/2.5,        u=(650/800),  v=1},   
      
      
      --Triangle 2
      {x = 650-pos*1.2,       y=480,          z=pos/2.5,        u=(650/800),  v=1},
      {x = 800-pos*.6575,     y=0,            z=pos/2,        u=1,          v=0},
      {x = 800-pos*1.2,       y=480,          z=pos/2,        u=1,          v=1},
                      
    }
  
  else
  
      data = {
    
      --Triangle 1
      {x = 526,                         y=0,                    z=0,        u=(526/800),  v=0},
      {x = 139,                         y=480,                  z=0,        u=(139/800),  v=1},
      {x = 650-pos*1.2+((pos-150)/3),   y=480-((pos-150)/2.5),  z=pos/2.5,  u=(650/800),  v=1},
      
      {x = 526,                         y=0,                    z=0,        u=(526/800),  v=0},
      {x = 800-pos*.6575-((pos-150)/2.5),   y=0-((pos-150)/2),    z=pos/2,    u=1,          v=0},
      {x = 650-pos*1.2+((pos-150)/3),   y=480-((pos-150)/2.5),  z=pos/2.5,  u=(650/800),  v=1},   
      
      
      --Triangle 2
      {x = 650-pos*1.2+((pos-150)/3),   y=480-((pos-150)/2.5),  z=pos/2.5,  u=(650/800),  v=1},
      {x = 800-pos*.6575-((pos-150)/2.5),   y=0-((pos-150)/2),    z=pos/2,    u=1,          v=0},
      {x = 800-pos*1.2-((pos-150)*1.3), y=480-((pos-150)*2),    z=pos/2,    u=1,          v=1},
                      
    }
    
    
--    data = {
--  
--      --Triangle 1
--      {x = 526,               y=0,                      z=0,        u=(526/800),  v=0},
--      {x = 139,               y=480,                    z=0,        u=(139/800),  v=1},
--      {x = 650-pos*1.2,       y=480-((pos-150)/2.5),      z=pos/1.5,    u=(650/800),          v=1},
--      
--      --triangle 2.5
--      
--      {x = 526,                         y=0,                  z=0,        u=(526/800),  v=0},
--      {x = 800-pos*.6575-((pos-150)),   y=0-((pos-150)/1.5),  z=0,        u=1,          v=0},
--      {x = 650-pos*1.2,                 y=480-((pos-150)/2.5),  z=pos/1.5,    u=(650/800),  v=1},     
--      
--      --Triangle 2
--      {x = 650-pos*1.2,                 y=480-((pos-150)/2.5),  z=pos/1.5,    u=(650/800),  v=1},  
--      {x = 800-pos*.6575-((pos-150)),   y=0-((pos-150)/1.5),  z=0,        u=1,          v=0},
--      {x = 800-pos*1.2,                 y=480-((pos-150)/2),  z=pos/2,    u=1,          v=1},
--                    
--    } 
    
  end
  
  return data
end

--function setupLayerData(pos)
--  
--  local data = {}
--  
--  --top and bottom move at different rates
--  
--  local topMovement = pos * .8
--  local botMovement = pos 
--  local Zmovement = (pos -150)
--  
--  if(Zmovement<0)then
--     Zmovement = 0
--  end
--  
--  Zmovement = Zmovement / 5
--  
--  data = {
--  
--    --Triangle -1
--    {x = 0,                     y=0,    z=0,            u=0,          v=0},
--    {x = 0,                     y=480,  z=0,            u=0,          v=1},
--    {x = 350 -topMovement/2,    y=0,    z=-Zmovement,   u=(350/800),  v=0},
--    
--    --Triangle -2
--    {x = 350-topMovement/2,     y=0,    z=-Zmovement,   u=(350/800),  v=0},
--    {x = 0,                     y=480,  z=0,            u=0,          v=1},
--    {x = 350-botMovement/2,     y=480,  z=-Zmovement,   u=(350/800),  v=1},
--
--        --Triangle 1
--    {x = 350-topMovement/2,     y=0,    z=-Zmovement,   u=(350/800),  v=0},
--    {x = 350-botMovement/2,     y=480,  z=-Zmovement,   u=(350/800),  v=1},
--    {x = 500-botMovement/1.5,   y=480,  z=Zmovement,    u=(500/800),  v=1},
--    
--            --Triangle 2
--    {x = 350-topMovement/2,     y=0,    z=-Zmovement,   u=(350/800),  v=0},
--    {x = 500-topMovement/1.5,   y=0,    z=Zmovement,    u=(500/800),  v=0},
--    {x = 500-botMovement/1.5,   y=480,  z=Zmovement,    u=(500/800),  v=1},
--    
--            --Triangle 3
--    {x = 650-topMovement/1.25,  y=0,    z=-Zmovement,   u=(650/800),  v=0},
--    {x = 500-topMovement/1.5,   y=0,    z=Zmovement,    u=(500/800),  v=0},
--    {x = 500-botMovement/1.5,   y=480,  z=Zmovement,    u=(500/800),  v=1},
--    
--            --Triangle 4
--    {x = 650-topMovement/1.25,  y=0,    z=-Zmovement,   u=(650/800),  v=0},
--    {x = 650-botMovement/1.25,  y=480,  z=-Zmovement,   u=(650/800),  v=1},
--    {x = 500-botMovement/1.5,   y=480,  z=Zmovement,    u=(500/800),  v=1},
--    
--            --Triangle 5
--    {x = 650-topMovement/1.25,  y=0,    z=-Zmovement,   u=(650/800),  v=0},
--    {x = 650-botMovement/1.25,  y=480,  z=-Zmovement,   u=(650/800),  v=1},
--    {x = 800-botMovement,       y=480,  z=Zmovement,    u=1,          v=1},
--    
--            --Triangle 6
--    {x = 650-topMovement/1.25,  y=0,    z=-Zmovement,   u=(650/800),  v=0},
--    {x = 800-topMovement,       y=0,    z=Zmovement,    u=1,          v=0},
--    {x = 800-botMovement,       y=480,  z=Zmovement,    u=1,          v=1},
--  }
--  
--  return data
--end