

function shatterEffect(mapargs) 
  local gdata = {}
  local ev_data = mapargs.context_event_data;
  local gdata = {}
  local mouseY = ev_data.x
  --print(mouseY)
  
  local w = 1280
  local h = 720
  
  local mouseX = tonumber(gre.get_value("shatterPoint"))
  
  
  gdata = {
  
    --INNER CIRCLE--
    --Triangle 1
    {x = (3/8)*w + mouseX/7, y=(3/8)*h- mouseX/20, z=0, u=(3/8), v=(3/8)},
    {x = (4/8)*w - mouseX/7, y=(4/8)*h- mouseX/7, z=0, u=(4/8), v=(4/8)},
    {x = (4/8)*w - mouseX/12, y=(3/8)*h+ mouseX/14, z=0, u=(4/8), v=(3/8)},
    
    --Triangle 2
    {x = (4/8)*w + mouseX/7,  y=(3/8)*h - mouseX/15, z=0 + mouseX/10, u=(4/8), v=(3/8)},
    {x = (4/8)*w + mouseX/10, y=(4/8)*h - mouseX/10, z=0 + mouseX/10, u=(4/8), v=(4/8)},
    {x = (5/8)*w - mouseX/10, y=(3/8)*h, z=0 , u=(5/8), v=(3/8)},
    
        --Triangle 3
    {x = (5/8)*w - mouseX/7, y=(3/8)*h + mouseX/15, z=0 + mouseX/7, u=(5/8), v=(3/8)},
    {x = (4/8)*w + mouseX/7, y=(4/8)*h + mouseX/20, z=0 + mouseX/7, u=(4/8), v=(4/8)},
    {x = (5/8)*w + mouseX/7, y=(4/8)*h, z=0 + mouseX/7, u=(5/8), v=(4/8)},
        
        --Triangle 4
    {x = (5/8)*w - mouseX/7, y=(4/8)*h + mouseX/7, z=0, u=(5/8), v=(4/8)},
    {x = (4/8)*w + mouseX/7, y=(4/8)*h + mouseX/7, z=0, u=(4/8), v=(4/8)},
    {x = (5/8)*w + mouseX/7, y=(5/8)*h - mouseX/7, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 5
    {x = (4/8)*w + mouseX/15, y=(5/8)*h + mouseX/15, z=0, u=(4/8), v=(5/8)},
    {x = (4/8)*w + mouseX/15, y=(4/8)*h + mouseX/15, z=0, u=(4/8), v=(4/8)},
    {x = (5/8)*w - mouseX/15, y=(5/8)*h - mouseX/15, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 6
    {x = (3/8)*w + mouseX/7, y=(5/8)*h + mouseX/15, z=0, u=(3/8), v=(5/8)},
    {x = (4/8)*w - mouseX/7, y=(4/8)*h + mouseX/7, z=0, u=(4/8), v=(4/8)},
    {x = (4/8)*w + mouseX/15, y=(5/8)*h - mouseX/15, z=0, u=(4/8), v=(5/8)},
    
        --Triangle 7
    {x = (3/8)*w + mouseX/15, y=(4/8)*h + mouseX/15, z=0, u=(3/8), v=(4/8)},
    {x = (4/8)*w - mouseX/7, y=(4/8)*h + mouseX/15, z=0, u=(4/8), v=(4/8)},
    {x = (3/8)*w + mouseX/7, y=(5/8)*h - mouseX/10, z=0, u=(3/8), v=(5/8)},
        
        --Triangle 8
    {x = (3/8)*w + mouseX/7, y=(4/8)*h - mouseX/5, z=0, u=(3/8), v=(4/8)},
    {x = (4/8)*w - mouseX/15, y=(4/8)*h - mouseX/20, z=0, u=(4/8), v=(4/8)},
    {x = (3/8)*w + mouseX/15, y=(3/8)*h + mouseX/15, z=0, u=(3/8), v=(3/8)},
    
    
    --OUTER CIRCLE
        --Triangle 9
    {x = (3/8)*w + mouseX/7, y=(3/8)*h - mouseX/15, z=0, u=(3/8), v=(3/8)},
    {x = (4/8)*w + mouseX/15, y=(3/8)*h - mouseX/7, z=0, u=(4/8), v=(3/8)},
    {x = (4/8)*w - mouseX/7, y=(2/8)*h + mouseX/15, z=0, u=(4/8), v=(2/8)},
    
    --Triangle 10
    {x = (4/8)*w + mouseX/7, y=(2/8)*h + mouseX/7, z=0, u=(4/8), v=(2/8)},
    {x = (4/8)*w + mouseX/7, y=(3/8)*h - mouseX/7, z=0, u=(4/8), v=(3/8)},
    {x = (5/8)*w - mouseX/7, y=(3/8)*h - mouseX/15, z=0, u=(5/8), v=(3/8)},
    
        --Triangle 11
    {x = (5/8)*w + mouseX/7, y=(3/8)*h + mouseX/7, z=0, u=(5/8), v=(3/8)},
    {x = (6/8)*w - mouseX/7, y=(4/8)*h - mouseX/7, z=0, u=(6/8), v=(4/8)},
    {x = (5/8)*w + mouseX/7, y=(4/8)*h - mouseX/7, z=0, u=(5/8), v=(4/8)},
        
        --Triangle 12
    {x = (5/8)*w + mouseX/15, y=(4/8)*h + mouseX/10, z=0, u=(5/8), v=(4/8)},
    {x = (6/8)*w - mouseX/20, y=(4/8)*h + mouseX/7, z=0, u=(6/8), v=(4/8)},
    {x = (5/8)*w + mouseX/7 , y=(5/8)*h - mouseX/15, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 13
    {x = (4/8)*w + mouseX/7, y=(5/8)*h + mouseX/12, z=0, u=(4/8), v=(5/8)},
    {x = (4/8)*w + mouseX/10, y=(6/8)*h - mouseX/15, z=0, u=(4/8), v=(6/8)},
    {x = (5/8)*w + mouseX/15, y=(5/8)*h + mouseX/10, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 14
    {x = (3/8)*w + mouseX/10, y=(5/8)*h + mouseX/20, z=0, u=(3/8), v=(5/8)},
    {x = (4/8)*w - mouseX/7, y=(6/8)*h + mouseX/12, z=0, u=(4/8), v=(6/8)},
    {x = (4/8)*w - mouseX/15, y=(5/8)*h + mouseX/17, z=0, u=(4/8), v=(5/8)},
    
        --Triangle 15
    {x = (3/8)*w - mouseX/7, y=(4/8)*h + mouseX/7, z=0, u=(3/8), v=(4/8)},
    {x = (2/8)*w + mouseX/7, y=(4/8)*h + mouseX/7, z=0, u=(2/8), v=(4/8)},
    {x = (3/8)*w , y=(5/8)*h + mouseX/7, z=0, u=(3/8), v=(5/8)},
        
        --Triangle 16
    {x = (3/8)*w - mouseX/10, y=(4/8)*h - mouseX/15, z=0, u=(3/8), v=(4/8)},
    {x = (2/8)*w + mouseX/7, y=(4/8)*h - mouseX/10, z=0, u=(2/8), v=(4/8)},
    {x = (3/8)*w + mouseX/15, y=(3/8)*h - mouseX/7, z=0, u=(3/8), v=(3/8)},
    
        --OUTER BOX
        --Triangle 17
    {x = (3/8)*w+ mouseX/10, y=(3/8)*h- mouseX/10, z=0, u=(3/8), v=(3/8)},
    {x = (2/8)*w+ mouseX/10, y=(2/8)*h+ mouseX/20, z=0, u=(2/8), v=(2/8)},
    {x = (4/8)*w- mouseX/10, y=(2/8)*h+ mouseX/17, z=0, u=(4/8), v=(2/8)},
    
    --Triangle 18
    {x = (4/8)*w+ mouseX/10, y=(2/8)*h, z=0, u=(4/8), v=(2/8)},
    {x = (6/8)*w- mouseX/10, y=(2/8)*h+ mouseX/10, z=0, u=(6/8), v=(2/8)},
    {x = (5/8)*w+ mouseX/10, y=(3/8)*h- mouseX/10, z=0, u=(5/8), v=(3/8)},
    
        --Triangle 19
    {x = (5/8)*w+ mouseX/10, y=(3/8)*h+ mouseX/7, z=0, u=(5/8), v=(3/8)},
    {x = (6/8)*w- mouseX/8, y=(4/8)*h- mouseX/20, z=0, u=(6/8), v=(4/8)},
    {x = (6/8)*w- mouseX/17, y=(2/8)*h+ mouseX/10, z=0, u=(6/8), v=(2/8)},
        
        --Triangle 20
    {x = (6/8)*w- mouseX/10, y=(6/8)*h- mouseX/10, z=0, u=(6/8), v=(6/8)},
    {x = (6/8)*w- mouseX/10, y=(4/8)*h- mouseX/10, z=0, u=(6/8), v=(4/8)},
    {x = (5/8)*w+ mouseX/10, y=(5/8)*h+ mouseX/10, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 21
    {x = (6/8)*w- mouseX/10, y=(6/8)*h+ mouseX/7, z=0, u=(6/8), v=(6/8)},
    {x = (4/8)*w+ mouseX/10, y=(6/8)*h- mouseX/18, z=0, u=(4/8), v=(6/8)},
    {x = (5/8)*w- mouseX/10, y=(5/8)*h+ mouseX/10, z=0, u=(5/8), v=(5/8)},
    
        --Triangle 22
    {x = (3/8)*w+ mouseX/10, y=(5/8)*h+ mouseX/10, z=0, u=(3/8), v=(5/8)},
    {x = (4/8)*w- mouseX/10, y=(6/8)*h+ mouseX/17, z=0, u=(4/8), v=(6/8)},
    {x = (2/8)*w+ mouseX/10, y=(6/8)*h+ mouseX/7, z=0, u=(2/8), v=(6/8)},
    
        --Triangle 23
    {x = (2/8)*w+ mouseX/10, y=(6/8)*h+ mouseX/18, z=0, u=(2/8), v=(6/8)},
    {x = (2/8)*w+ mouseX/7, y=(4/8)*h+ mouseX/15, z=0, u=(2/8), v=(4/8)},
    {x = (3/8)*w- mouseX/17, y=(5/8)*h+ mouseX/10, z=0, u=(3/8), v=(5/8)},
        
        --Triangle 24
    {x = (2/8)*w+ mouseX/10, y=(2/8)*h+ mouseX/7, z=0, u=(2/8), v=(2/8)},
    {x = (2/8)*w+ mouseX/15, y=(4/8)*h- mouseX/10, z=0, u=(2/8), v=(4/8)},
    {x = (3/8)*w- mouseX/10, y=(3/8)*h- mouseX/17, z=0, u=(3/8), v=(3/8)},
   
   
    --OUTER RING OF TRIANGLES 
    --Triangle 25
    {x = (0/8)*w, y=(0/8)*h, z=0, u=(0/8), v=(0/8)},
    {x = (2/8)*w, y=(0/8)*h , z=0, u=(2/8), v=(0/8)},
    {x = (2/8)*w- mouseX/10, y=(2/8)*h- mouseX/10, z=0, u=(2/8), v=(2/8)},  
    
    --Triangle 26
    {x = (4/8)*w, y=(0/8)*h, z=0, u=(4/8), v=(0/8)},
    {x = (2/8)*w, y=(0/8)*h, z=0, u=(2/8), v=(0/8)},
    {x = (2/8)*w+ mouseX/10, y=(2/8)*h- mouseX/10, z=0, u=(2/8), v=(2/8)}, 
    
    --Triangle 27
    {x = (4/8)*w, y=(0/8)*h, z=0, u=(4/8), v=(0/8)},
    {x = (4/8)*w - mouseX/10, y=(2/8)*h - mouseX/10, z=0, u=(4/8), v=(2/8)},
    {x = (2/8)*w+ mouseX/7, y=(2/8)*h - mouseX/10, z=0, u=(2/8), v=(2/8)},    
    
    --Triangle 28
    {x = (4/8)*w, y=(0/8)*h, z=0, u=(4/8), v=(0/8)},
    {x = (4/8)*w, y=(2/8)*h- mouseX/10, z=0, u=(4/8), v=(2/8)},
    {x = (6/8)*w, y=(2/8)*h- mouseX/10, z=0, u=(6/8), v=(2/8)},   

    --Triangle 29
    {x = (4/8)*w, y=(0/8)*h, z=0, u=(4/8), v=(0/8)},
    {x = (6/8)*w, y=(0/8)*h, z=0, u=(6/8), v=(0/8)},
    {x = (6/8)*w, y=(2/8)*h- mouseX/10, z=0, u=(6/8), v=(2/8)},  
   
     --Triangle 30
    {x = (8/8)*w, y=(0/8)*h, z=0, u=(8/8), v=(0/8)},
    {x = (6/8)*w, y=(0/8)*h, z=0, u=(6/8), v=(0/8)},
    {x = (6/8)*w, y=(2/8)*h- mouseX/10, z=0, u=(6/8), v=(2/8)},    
    
     --Triangle 31
    {x = (8/8)*w, y=(0/8)*h, z=0, u=(8/8), v=(0/8)},
    {x = (8/8)*w, y=(2/8)*h, z=0, u=(8/8), v=(2/8)},
    {x = (6/8)*w+ mouseX/10, y=(2/8)*h, z=0, u=(6/8), v=(2/8)},    
    
    --Triangle 32
    {x = (8/8)*w, y=(4/8)*h, z=0, u=(8/8), v=(4/8)},
    {x = (8/8)*w, y=(2/8)*h , z=0, u=(8/8), v=(2/8)},
    {x = (6/8)*w+ mouseX/10, y=(2/8)*h, z=0, u=(6/8), v=(2/8)},
    
    --Triangle 33
    {x = (8/8)*w, y=(4/8)*h, z=0, u=(8/8), v=(4/8)},
    {x = (6/8)*w+ mouseX/10, y=(4/8)*h , z=0, u=(6/8), v=(4/8)},
    {x = (6/8)*w+ mouseX/10, y=(2/8)*h, z=0, u=(6/8), v=(2/8)},  
    
    --Triangle 34
    {x = (8/8)*w, y=(4/8)*h, z=0, u=(8/8), v=(4/8)},
    {x = (6/8)*w+ mouseX/10, y=(4/8)*h , z=0, u=(6/8), v=(4/8)},
    {x = (6/8)*w+ mouseX/10, y=(6/8)*h, z=0, u=(6/8), v=(6/8)}, 
    
    --Triangle 35
    {x = (8/8)*w, y=(4/8)*h, z=0, u=(8/8), v=(4/8)},
    {x = (8/8)*w, y=(6/8)*h , z=0, u=(8/8), v=(6/8)},
    {x = (6/8)*w+ mouseX/10, y=(6/8)*h, z=0, u=(6/8), v=(6/8)},
    
    --Triangle 36
    {x = (8/8)*w, y=(8/8)*h, z=0, u=(8/8), v=(8/8)},
    {x = (8/8)*w, y=(6/8)*h , z=0, u=(8/8), v=(6/8)},
    {x = (6/8)*w+ mouseX/10, y=(6/8)*h, z=0, u=(6/8), v=(6/8)},     
  
      --Triangle 37
    {x = (8/8)*w, y=(8/8)*h, z=0, u=(8/8), v=(8/8)},
    {x = (6/8)*w, y=(6/8)*h+ mouseX/10 , z=0, u=(6/8), v=(6/8)},
    {x = (6/8)*w, y=(8/8)*h, z=0, u=(6/8), v=(8/8)},
    
       --Triangle 38
    {x = (4/8)*w, y=(8/8)*h, z=0, u=(4/8), v=(8/8)},
    {x = (6/8)*w, y=(6/8)*h+ mouseX/10, z=0, u=(6/8), v=(6/8)},
    {x = (6/8)*w, y=(8/8)*h, z=0, u=(6/8), v=(8/8)},   
    
        --Triangle 39
    {x = (4/8)*w, y=(8/8)*h, z=0, u=(4/8), v=(8/8)},
    {x = (6/8)*w, y=(6/8)*h+ mouseX/10 , z=0, u=(6/8), v=(6/8)},
    {x = (4/8)*w, y=(6/8)*h+ mouseX/10, z=0, u=(4/8), v=(6/8)},    
    
    --Triangle 40
    {x = (4/8)*w, y=(8/8)*h, z=0, u=(4/8), v=(8/8)},
    {x = (4/8)*w, y=(6/8)*h+ mouseX/10 , z=0, u=(4/8), v=(6/8)},
    {x = (2/8)*w, y=(6/8)*h+ mouseX/10, z=0, u=(2/8), v=(6/8)}, 

    --Triangle 41
    {x = (4/8)*w, y=(8/8)*h, z=0, u=(4/8), v=(8/8)},
    {x = (2/8)*w, y=(8/8)*h , z=0, u=(2/8), v=(8/8)},
    {x = (2/8)*w, y=(6/8)*h+ mouseX/10, z=0, u=(2/8), v=(6/8)},   

    --Triangle 42
    {x = (0/8)*w, y=(8/8)*h, z=0, u=(0/8), v=(8/8)},
    {x = (2/8)*w, y=(8/8)*h , z=0, u=(2/8), v=(8/8)},
    {x = (2/8)*w, y=(6/8)*h+ mouseX/10, z=0, u=(2/8), v=(6/8)}, 

    --Triangle 43
    {x = (0/8)*w, y=(8/8)*h, z=0, u=(0/8), v=(8/8)},
    {x = (0/8)*w, y=(6/8)*h, z=0, u=(0/8), v=(6/8)},
    {x = (2/8)*w- mouseX/10, y=(6/8)*h, z=0, u=(2/8), v=(6/8)}, 

    --Triangle 44
    {x = (0/8)*w, y=(4/8)*h, z=0, u=(0/8), v=(4/8)},
    {x = (0/8)*w, y=(6/8)*h, z=0, u=(0/8), v=(6/8)},
    {x = (2/8)*w- mouseX/10, y=(6/8)*h, z=0, u=(2/8), v=(6/8)}, 

    --Triangle 45
    {x = (0/8)*w, y=(4/8)*h, z=0, u=(0/8), v=(4/8)},
    {x = (2/8)*w- mouseX/10, y=(4/8)*h, z=0, u=(2/8), v=(4/8)},
    {x = (2/8)*w- mouseX/10, y=(6/8)*h, z=0, u=(2/8), v=(6/8)}, 

    --Triangle 46
    {x = (0/8)*w, y=(4/8)*h, z=0, u=(0/8), v=(4/8)},
    {x = (2/8)*w- mouseX/10, y=(4/8)*h, z=0, u=(2/8), v=(4/8)},
    {x = (2/8)*w- mouseX/10, y=(2/8)*h, z=0, u=(2/8), v=(2/8)}, 

    --Triangle 47
    {x = (0/8)*w, y=(4/8)*h, z=0, u=(0/8), v=(4/8)},
    {x = (0/8)*w, y=(2/8)*h, z=0, u=(0/8), v=(2/8)},
    {x = (2/8)*w- mouseX/10, y=(2/8)*h, z=0, u=(2/8), v=(2/8)}, 
    
    --Triangle 48
    {x = (0/8)*w, y=(0/8)*h, z=0, u=(0/8), v=(0/8)},
    {x = (0/8)*w, y=(2/8)*h, z=0, u=(0/8), v=(2/8)},
    {x = (2/8)*w- mouseX/10, y=(2/8)*h, z=0, u=(2/8), v=(2/8)},     
 }
  
    
  local attrs = {}
  attrs["geometry"] = {
      width = 1280,
      height = 720,
      type = "triangle",
      nvert = 3, --(X Y or Z - 2 or 3)
      nuv = 2,--(ON or OFF 0 or 2
      data = gdata
  }
  gre.set_layer_attrs("centerPoint_Images",attrs)
end


function switchTests(mapargs) 

  local data = {}
  local effect = {}
  local sdata = {}
  
  effect["name"] = "blur"
  effect["passes"] = 4
  effect["radius"] = 1
  effect["composite"] = false

  sdata["effect"] = effect
  gre.set_control_attrs("centerPoint_Images.transitionCircles",sdata)

  gre.animation_trigger("DETAILS_circleCollapse")
end


function blur()
  --print("blur : "..x, y, width, height)
  local data = {}
  local effect = {}
  local sdata = {}
  
  local blurSize = gre.get_value("aboutApp.aboutApp.blurAmt")
  effect["name"] = "blur"
  effect["passes"] = 4
  effect["radius"] = blurSize
  effect["composite"] = true
  
  sdata["effect"] = effect
  gre.set_control_attrs("aboutApp.aboutApp.title",sdata)
end
