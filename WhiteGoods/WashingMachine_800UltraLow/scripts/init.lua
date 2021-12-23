--This variable (when set to 1) will kill all erronious and fun animations to run on lower end boards
SIMPLE_MODE = 1
--this variable, when set to 1, will only allow the app to cycle through things, user interaction will not
--be allowed
AUTOMATED_MODE = 0
local animationImages = 40

washingModes = {
  [1] = {'normal',    32, sliderPos = { 0,     -1225, -2450}, img = 'images/title/normal.png'},
  [2] = {'eco',       40, sliderPos = { -175,  -1400, -2625}, img = 'images/title/eco.png'},
  [3] = {'active',    36, sliderPos = { -350,  -1575, -2800}, img = 'images/title/active.png'},
  [4] = {'bedding',   44, sliderPos = { -525,  -1750, -2975}, img = 'images/title/bedding.png'},
  [5] = {'heavy',     52, sliderPos = { -700,  -1925, -3150}, img = 'images/title/heavy.png'},
  [6] = {'steam',     28, sliderPos = { -875,  -2100, -3325}, img = 'images/title/steam.png'},
  [7] = {'delicates', 33, sliderPos = { -1050, -2275, -3500}, img = 'images/title/delicates.png'}
  }

local function initTablePositions()
  local tableDataMid = {}
  local tableDataTop = {}
  local tableDataBot = {}
  
  tableDataMid['yoffset'] = -(175*7)
  tableDataTop['yoffset'] = -(90*6) + 30
  tableDataBot['yoffset'] = -(90*8) 

  gre.set_table_attrs("homeSlider.midIcons",tableDataMid)
  gre.set_table_attrs("homeSlider.topIcons",tableDataTop)
  gre.set_table_attrs("homeSlider.botIcons",tableDataBot)
end

local function initTables()
  local rowAmounts = 18
  local data = {}
  local tableData = {}
  for i = 1, #washingModes do
  --for mid
    local image = 'images/activeIcons/'..washingModes[i][1]..'.png'
    local smallImage = 'images/inactiveIcons/'..washingModes[i][1]..'.png'
    local title = 'images/title/'..washingModes[i][1]..'.png'
    
    gre.load_image(image)
    gre.load_image(smallImage)
    gre.load_image(title)
    
    data["homeSlider.midIcons.image."..i..".1"] = image
    data["homeSlider.midIcons.image."..(i + #washingModes)..".1"] = image
    data["homeSlider.midIcons.image."..(i + #washingModes*2)..".1"] = image
    
    data["homeSlider.topIcons.image."..i..".1"] = smallImage
    data["homeSlider.topIcons.image."..(i + #washingModes)..".1"] = smallImage
    data["homeSlider.topIcons.image."..(i + #washingModes*2)..".1"] = smallImage
    
    data["homeSlider.botIcons.image."..i..".1"] = smallImage
    data["homeSlider.botIcons.image."..(i + #washingModes)..".1"] = smallImage
    data["homeSlider.botIcons.image."..(i + #washingModes*2)..".1"] = smallImage
    
    
  --for top and bottom
  end
  
  tableData['rows'] = rowAmounts
  gre.set_data(data)
  gre.set_table_attrs("homeSlider.midIcons",tableData)
  gre.set_table_attrs("homeSlider.topIcons",tableData)
  gre.set_table_attrs("homeSlider.botIcons",tableData)
  initTablePositions()
end

local function preloadImages()
  for i = 1, animationImages do
    local printName = "images/animation/"..i..".jpg"
    gre.load_image("images/animation/"..i..".jpg")
  end
  gre.load_image("images/washingBackground.png")
  gre.load_image("images/animation/1Trans.png")
  gre.load_image("images/washingBackgroundFlattened.jpg")
  gre.load_image("images/circleBG.png")
end

function CBInitApp()
  preloadImages()
  initTables()
  animateRotatingDrum()
end