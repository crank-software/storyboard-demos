local env = gre.env({"target_cpu","target_os"})
local target_cpu = env["target_cpu"]
local target_os = env["target_os"]
local target_dir = target_os .. "-" .. target_cpu
package.path = gre.SCRIPT_ROOT .. "/luasocket/?.lua;" .. package.path
if (target_os == "win32") then
  package.cpath = gre.SCRIPT_ROOT .. "\\luasocket\\" .. target_dir .. "\\?.dll;" .. package.cpath
else
  package.cpath = gre.SCRIPT_ROOT .. "/luasocket/" .. target_dir .. "/?.so;" .. package.cpath
end

--local http  = require("socket.http")
--local ltn12 = require("ltn12")
--local json  = require("dkjson")

local backendURL = "http://api.yummly.com/v1/"
local keys = "_app_id=7aa1768d&_app_key=dcfcb046c3cbeda3eca5d12d8bef0ec0"
local recipieEntryPoint = "api/recipes?"
local qTechnique = "&allowedTechnique=technique%5Etechnique-baking&allowedTechnique=technique%5Etechnique-broiling"
local qFlavor = "&flavor.sweet.min=0&flavor.meaty.min=0&flavor.sour.min=0&flavor.bitter.min=0&flavor.salty.min=0&flavor.piquant.min=0"
local query = ""
local lastQuery = ""
local queryTitle = ""
local rec_data = {}
local cancelBack = 'cancel'
local pressedRecipe = nil
local nutritionWidth = 700

local colourTwo = '0xF0AF34'
local colourOne = '0xFFD88F'

categories = { 

{query = "&q=meat&allowedCourse[]=course^course-Main+Dishes", title = "Meat"}, 
{query = "&q=desserts&excludedCourse[]=course^course-Breads", title = "Desserts"}, 
{query = "&q=casseroles", title = "Casseroles"}, 
{query = "&q=vegetables", title = "Vegetables"}, 
{query = "&q=appetizer", title = "Appetizers"}, 
{query = "&q=baked+goods&excludedCourse[]=course^course-Desserts", title = "BakedGoods"}

}

bubbles = {
{x = 928,   y = 68,   overlayImage = "images/overlay/1.png"},
{x = 1018,  y = 286,  overlayImage = "images/overlay/2.png"},
{x = 928,   y = 505,  overlayImage = "images/overlay/3.png"},
{x = 175,   y = 68,   overlayImage = "images/overlay/4.png"},
{x = 51,    y = 286,  overlayImage = "images/overlay/5.png"},
{x = 175,   y = 505,  overlayImage = "images/overlay/6.png"}
}

local clearCategory = {}
local clearRecipe = {}

function CBGetCategories() 

  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs("recipeList",layerData)
  layerData['hidden'] = 0
  gre.set_layer_attrs("categoryList",layerData)  
  
  for i = 1, #categories do
    local url = backendURL..recipieEntryPoint..keys..qTechnique..qFlavor..categories[i].query
    --TODO:NEW REQUESTS
    --local res = http.request{url=url, sink=ltn12.sink.file(io.open("http_cache/"..categories[i].title..".txt","w"))}
    local result = io.open(gre.SCRIPT_ROOT.."/../http_cache/"..categories[i].title..".txt","r")
    local json_data = json.decode(result:read("*a"))
    
    local recipeID = json_data.matches[1].id
    CBGetRecipe(recipeID)
    local filePath = "images/categories/"..recipeID..".jpg"
    local img =  rec_data.images[1].hostedLargeUrl
    --TODO:NEW REQUESTS
    --local r,s,h = http.request {url = img, sink = ltn12.sink.file(io.open(filePath,"wb"))}
    
    local data = {}
    data["x"] = bubbles[i].x
    data["y"] = bubbles[i].y
    gre.clone_object("categoryList.categoryCircle", categories[i].title, "categoryList", data)
    data = {}
    data["categoryList."..categories[i].title..".image"] = filePath
    data["categoryList."..categories[i].title..".overlayImage"] = bubbles[i].overlayImage
    data["categoryList."..categories[i].title..".grd_hidden"] = 1
    gre.set_data(data)
    
    table.insert(clearCategory,categories[i].title)
    
    local animData = {}
    animData['context'] = "categoryList."..categories[i].title
    animData['id'] = i
    gre.animation_trigger('RECIPE_categoryBubbleShow', animData)
    
  end
  cancelBack = 'cancel'
  centerRecipeAbout()
end

function CBGetRecipe(recipeID)
  local url = backendURL.."api/recipe/"..recipeID.."?"..keys
  --TODO:NEW REQUESTS
  --local r,s,h = http.request{url = url, sink = ltn12.sink.file(io.open("http_cache/"..recipeID..".txt","wb"))}
  local result = io.open(gre.SCRIPT_ROOT.."/../http_cache/"..recipeID..".txt","r")
  rec_data = json.decode(result:read("*a"))
end

function CBDisplayRecipes(mapargs)

  local category = string.gsub(mapargs.context_group,"categoryList.", "")
  
  local data = {}
  data["hidden"] = 1
  gre.set_layer_attrs("categoryList",data)
  data["hidden"] = 0
  gre.set_layer_attrs("recipeList",data)
  
  local result = io.open(gre.SCRIPT_ROOT.."/../http_cache/"..category..".txt","r")
  local match_data = json.decode(result:read("*a"))
  
  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs("recipeList",layerData)
  layerData['hidden'] = 1
  gre.set_layer_attrs("categoryList",layerData) 
  
  for n = 1, 6 do
    local recipeID = match_data.matches[n].id 
    CBGetRecipe(recipeID)
    
    local filePath = "images/recipes/"..recipeID..".jpg"
    local img =  rec_data.images[1].hostedLargeUrl
    --TODO:NEW REQUESTS
    --local r,s,h = http.request {url = img, sink = ltn12.sink.file(io.open(filePath,"wb"))}
    
    local data = {}
    data["x"] = bubbles[n].x
    data["y"] = bubbles[n].y
    gre.clone_object("recipeList.recipeCircle", recipeID, "recipeList", data)
    --print(recipeID)
    data = {}
    data["recipeList."..recipeID..".image"] = filePath
    data["recipeList."..recipeID..".overlayImage"] = bubbles[n].overlayImage
    data["recipeList."..recipeID..".grd_hidden"] = 1
    gre.set_data(data)
    
    local animData = {}
    animData['context'] = "recipeList."..recipeID
    animData['id'] = n
    gre.animation_trigger('RECIPE_categoryBubbleShow', animData)
  
    table.insert(clearRecipe, recipeID)
  end

  cancelBack = 'back'
  centerRecipeAbout()
  
end

local padding = 15
local function setupNutritionBars(incProtien, incFat, incCarb)

  local data = {}
  local largestWidth = 0
  local largestControl = ''
  local excess = 0
  
  data["ingredientList.nutritionTitleGroup.protienBlob.text"] = 'P: '..incProtien..'g'
  data["ingredientList.nutritionTitleGroup.carbsBlob.text"] = 'C: '..incCarb..'g'
  data["ingredientList.nutritionTitleGroup.fatsBlob.text"] = 'F: '..incFat..'g'
  
  local totalValues = incProtien + incCarb + incFat
  
  local perPro = incProtien/totalValues
  local perCarb = incCarb/totalValues
  local perFat = incFat/totalValues
  
  local widthPro = math.floor(nutritionWidth*perPro)
  local widthCarb = math.floor(nutritionWidth*perCarb)
  local widthFat = math.floor(nutritionWidth*perFat)
  
  --find the largest one, keep in background to subtract from
  for i = 1, 3 do
    if(widthPro > largestWidth)then
      largestWidth = widthPro
      largestControl = 'pro'
    elseif(widthCarb > largestWidth)then
      largestWidth = widthCarb
      largestControl = 'carb'
    elseif(widthFat > largestWidth)then
      largestWidth = widthFat
      largestControl = 'fat'
    end
  end
  
  --print(largestWidth, largestControl)
  
  if(widthPro < 60)then
    excess = excess + (60-widthPro)
    widthPro = 60
  elseif(widthFat < 60)then
    excess = excess + (60-widthFat)
    widthFat = 60
  elseif(widthCarb < 60)then
    excess = excess + (60-widthCarb)
    widthCarb = 60
  end
  
  if(largestControl == 'pro')then
    widthPro = widthPro - excess
  elseif(largestControl == 'carb')then
    widthCarb = widthCarb - excess
  elseif(largestControl == 'fat')then
    widthFat = widthFat - excess
  end
  
  local xPosPro = widthFat + widthCarb + (padding*2)
  local xPosCarb = widthFat + padding
  local xPosFat = 0
  
  --print(widthPro, widthCarb, widthFat)

  data["ingredientList.nutritionTitleGroup.protienBlob.grd_width"] = widthPro
  data["ingredientList.nutritionTitleGroup.carbsBlob.grd_width"] = widthCarb
  data["ingredientList.nutritionTitleGroup.fatsBlob.grd_width"] = widthFat
  
  data["ingredientList.nutritionTitleGroup.protienBlob.grd_x"] = xPosPro
  data["ingredientList.nutritionTitleGroup.carbsBlob.grd_x"] = xPosCarb
  data["ingredientList.nutritionTitleGroup.fatsBlob.grd_x"] = xPosFat

  gre.set_data(data)
end

function CBRecipeInfo(mapargs)
  local recipe = string.gsub(mapargs.context_group,"recipeList.", "")
  
  CBGetRecipe(recipe)
  
  local formattedText = formatRecipeTitle(rec_data.name)
  --setup the middle text for the recipe information
  local data = {}
  data["recipeSelectionCenter.middleText.text"] = formattedText
  data["recipeSelectionCenter.servingText.text"] = string.upper("Serves "..rec_data.numberOfServings.." . "..rec_data.totalTime)
  data["recipeSelectionCenter.middleText.grd_hidden"] = 1
  data["recipeSelectionCenter.servingText.grd_hidden"] = 1
  data["recipeSelectionCenter.startButton_group.grd_hidden"] = 1
  data["recipeSelectionCenter.ingredient_group.grd_hidden"] =1
  data["recipeSelectionCenter.selectPromptRecipe.grd_hidden"] = 1
    
  local formattedIngredients
  for i = 1, #rec_data.ingredientLines do
    --choose colour 1 or 2 depending on if its even or odd
    local fontColour
    
    if (i % 2 == 0) then
      fontColour = colourOne
    else
      fontColour = colourTwo
    end

    if(formattedIngredients == nil)then
      formattedIngredients = '<span style="color:#'..fontColour..';">'..rec_data.ingredientLines[i]..'</span><br>'
    else
      formattedIngredients = formattedIngredients..'<span style="color:#'..fontColour..';">'..rec_data.ingredientLines[i]..'</span><br>'
    end
  end
  
  ts = {}
  table.foreach (rec_data.flavors, function (k, v) table.insert (ts, v.." = "..k) end )
  table.sort (ts)
  
  local flav = {}
  for i = 6,5,-1 do 
    local len = string.len(ts[i])
    k, v = string.find(ts[i], "=")
    local f = string.sub(ts[i],v+2)
    if (f == "Meaty") then f = "Savory"
    elseif (f == "Piquant") then f = "Spicy" end
    table.insert(flav,f)
  end
  
  
  local protien, cal, fat, carb
  
  for i = 1, #rec_data.nutritionEstimates do
    local info = rec_data.nutritionEstimates[i]
    local attr = info.attribute

    --only display Fat, Protein, Carbs, Cal (there are about 80 different fields)
    if (attr == "FAT")then
      fat =  math.floor(info.value)
    elseif(attr == "PROCNT")then
      protien =  math.floor(info.value)
    elseif(attr == "CHOCDF") then
      carb = math.floor(info.value)
    elseif (attr == "ENERC_KCAL") then -- info.description is 'nil' for calories
      cal =  math.floor(info.value)
    end    
  end
  
  --setupNutritionBars(protien, fat, carb)
  data["ingredientList.nutritionTitleGroup.calories1.text"] = '<p style="color:#ffffff; text-align:center;">fats: <span style="color:#'..colourOne..';">'..fat..'g</span> . proteins: <span style="color:#'..colourOne..';">'..protien..'g</span> . carbs: <span style="color:#'..colourOne..';">'..carb..'g</span></p>'
  data["ingredientList.nutritionTitleGroup.calories.text"] = cal..' CALORIES'
  data["ingredientList.ingredient.text"] = '<p style="text-align:center">'..formattedIngredients..'</p>'
  data["recipeSelectionCenter.ingredient_group.flavours.text"] = string.upper(table.concat(flav, " . "))
  gre.set_data(data)
  
  gre.animation_trigger('RECIPE_recipeOptions')
end

function CBRecipeClear()
  for i = 1, #clearRecipe do
    --print('clearing '..clearRecipe[i])
    gre.delete_object("recipeList."..clearRecipe[i])
  end
  clearRecipe = {}
end

function CBCategoryClear()
  for i = 1, #clearCategory do
    --print('clearing '..clearCategory[i])
    gre.delete_object("categoryList."..clearCategory[i])
  end
  clearCategory = {}
end

local pressedCancel = 0
function CBRecipeCancelBack()

  if(cancelBack == 'cancel')then
    if(pressedCancel == 1)then
      return
    end
    pressedCancel = 1
    CBCategoryClear()
    CBHideHomeLayers()
    --gre.send_event('goToHomeScreen')
    gre.animation_trigger('APP_recipeHide')
    gre.timer_set_timeout(function()
      gre.send_event('goToHomeScreen')
      pressedCancel = 0
    end,500)
    
  elseif(cancelBack == 'back')then
    CBRecipeClear()
    CBGetCategories()
    pressedRecipe = nil
  end

end

function CBPressRecipeCategory(mapargs)
  --call an animation on the mapargs.context_group
  local animData = {}
  animData['context'] = mapargs.context_group
  gre.animation_trigger('RECIPE_categoryBubblePress', animData)
  
  --go through the rest of the categories in clearCategory and hide them
  for i = 1, #clearCategory do
    local checkCategory = "categoryList."..clearCategory[i]
    if(checkCategory ~= mapargs.context_group)then
      animData['context'] = checkCategory
      animData['id'] = i
      gre.animation_trigger('RECIPE_categoryBubbleFadeOut', animData)
    end
  end
  
  gre.timer_set_timeout(function()
    CBDisplayRecipes(mapargs)
  end,600)
  
end

function CBPressRecipe(mapargs)

  if(mapargs.context_group == pressedRecipe)then
    return
  end

  local animData = {}
  animData['context'] = mapargs.context_group
  gre.animation_trigger('RECIPE_recipeBubblePress', animData)
  
  if(pressedRecipe ~= nil)then
    animData['context'] = pressedRecipe
    gre.animation_trigger('RECIPE_categoryBubbleUnselect', animData)
  end
  
  pressedRecipe = mapargs.context_group
end

function CBOpenRecipePopUp(mapargs)
  gre.animation_trigger('POPUP_recipeOpen')
  gre.timer_set_timeout(function() 
    local layerData = {}
    layerData["hidden"] = 0
    gre.set_layer_attrs("ingredientList",layerData)
  end,500)
end

function centerRecipeAbout()
  --if Cancel, we are on the first one, if back we are on the second, do it from there
  local data = {}
  data["recipeSelectionCenter.middleText.grd_hidden"] = 1
  data["recipeSelectionCenter.servingText.grd_hidden"] = 1
  data["recipeSelectionCenter.startButton_group.grd_hidden"] = 1
  data["recipeSelectionCenter.ingredient_group.grd_hidden"] = 1
  if(cancelBack == 'cancel')then
    data["recipeSelectionCenter.cancel_group.cancelText.image"] = 'images/cancelText.png'
    data["recipeSelectionCenter.selectPrompt.grd_hidden"] = 1
    data["recipeSelectionCenter.selectPromptRecipe.grd_hidden"] = 1
    gre.animation_trigger('RECIPE_categoryPrompt')
    --print('setup middle for saying you should select a category')
  elseif(cancelBack == 'back')then
    data["recipeSelectionCenter.cancel_group.cancelText.image"] = 'images/back.png'
    data["recipeSelectionCenter.selectPrompt.grd_hidden"] = 1
    data["recipeSelectionCenter.selectPromptRecipe.grd_hidden"] = 1
    gre.animation_trigger('RECIPE_recipePrompt')
    --print('setup middle for saying you should start a recipe')
  end
  gre.set_data(data)
end

function formatRecipeTitle(incText)
  local newText = incText
  local shortened = false
  local stringSize = gre.get_string_size('fonts/METROPOLIS.OTF', 36, newText)
  
  --keep taking off a letter until it fits under size
  while stringSize.width > 425 do
    --shjorten new text
    --print(newText)
    local length = string.len(newText) - 1
    newText = string.sub(newText, 1, length) 
    --print(newText)
    stringSize = gre.get_string_size('fonts/METROPOLIS.OTF', 36, newText)
    shortened = true
  end
  
  if(shortened == true)then
    newText = newText..'...'
  end
  --print(stringSize.width)

  return newText
end

local function setupRecipeValues()

  local values = {}

  values.temp = math.random(300,500)
  values.timer = math.random(1800,7200)
  local mode = math.random(1,5)
  if(mode == 1)then
    values.mode = 'bake'
  elseif(mode == 2)then
    values.mode = 'broil'
  elseif(mode == 3)then
    values.mode = 'smartCook'
  elseif(mode == 4)then
    values.mode = 'convBake'
  elseif(mode == 5)then
    values.mode = 'roast'
  end
  
  --round the numbers
  values.temp = math.floor((values.temp / 5)+0.5)*5
  values.timer = math.floor((values.timer / 5)+0.5)*5
  
  return values
end

local recipeStartPressed = 0
function CBStartRecipe()
  --select a random cook mode and temp and time to make it look different
  if(recipeStartPressed == 1)then
    return
  end
  --play animation, after animation is finished we do all the fun stuff. Dont allow another press during animation
  recipeStartPressed = 1
  gre.animation_trigger('RECIPE_pressStart')
  CBSmartToggleToCook()
  
  gre.timer_set_timeout(function()
    local recipeValues = setupRecipeValues() 
    --print(recipeValues.mode, recipeValues.temp, recipeValues.timer)
    cookingRequest.mode = recipeValues.mode
    cookingRequest.temperature = recipeValues.temp
    activeCookingValues.timer = recipeValues.timer
    
    startOvenHeating()
    startOvenTimer()
    CBHideCookingLayer()
    gre.send_event('goToCookScreen')
    CBRecipeClear()
    pressedRecipe = nil
    recipeStartPressed = 0
  end,250)
end


function recipeIdleCancel()
  if(cancelBack == 'cancel')then
    CBCategoryClear()
  elseif(cancelBack == 'back')then
    CBRecipeClear()
    pressedRecipe = nil
  end
  closeRecipePopup()
  CBHideHomeLayers()
  gre.send_event('goToHomeScreen')
end




--functions for the small recipes
function CBGetSmallRecipes(mapargs)

  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs("recipeList",layerData)
  layerData['hidden'] = 0
  gre.set_layer_attrs("categoryList",layerData)  
  
  local data = {}
  local overallSize
  local heldCategory
  for i = 1, #categories do
    local url = backendURL..recipieEntryPoint..keys..qTechnique..qFlavor..categories[i].query
    --TODO:NEW REQUESTS
    --local res = http.request{url=url, sink=ltn12.sink.file(io.open("http_cache/"..categories[i].title..".txt","w"))}
    local result = io.open(gre.SCRIPT_ROOT.."/../http_cache/"..categories[i].title..".txt","r")
    local json_data = json.decode(result:read("*a"))

    --START OF RECIPES
    local category = categories[i].title
    local recipeResult = io.open(gre.SCRIPT_ROOT.."/../http_cache/"..category..".txt","r")
    local match_data = json.decode(recipeResult:read("*a"))
    
    
    for n = 1, 6 do
      local recipeID = match_data.matches[n].id 
      CBGetRecipe(recipeID)
      
      local filePath = "images/recipes/"..recipeID..".jpg"
      local img =  rec_data.images[1].hostedLargeUrl
  
      --setup the correct pos
      for j = 1, 3 do
        local overallPos = (((i-1)*6)+n) + ((j-1)*36)
              
        if(string.len(rec_data.name) > 40)then
          data["smallRecipeList.recipeTable.text."..overallPos..".1"] = string.sub(rec_data.name, 1, 40).."..."
        else
         data["smallRecipeList.recipeTable.text."..overallPos..".1"] = rec_data.name
        end
        
        if(category ~= heldCategory)then
          data["smallRecipeList.recipeTable.catText."..overallPos..".1"] = string.upper(category)
        else
          data["smallRecipeList.recipeTable.catText."..overallPos..".1"] = ''
        end
        
        data["smallRecipeList.recipeTable.image."..overallPos..".1"] = filePath
        data["smallRecipeList.recipeTable.recipeID."..overallPos..".1"] = recipeID
        
        overallSize = overallPos
      end
      heldCategory = category
    end

  end
  local tableData = {}
  tableData["rows"] = overallSize
  gre.set_table_attrs('recipeTable',tableData)
  gre.set_data(data)
  
  local startOffset = overallSize/3
  local recipeCellHeight = 80
  CBSetupRecipeStartPosition(startOffset, recipeCellHeight)
end

function CBPressSmallRecipe(mapargs)
  
  local pressedID = gre.get_value(mapargs.context_control..".recipeID."..mapargs.context_row..".1")
  CBGetRecipe(pressedID)
  
  local formattedIngredients
  for i = 1, #rec_data.ingredientLines do
    --choose colour 1 or 2 depending on if its even or odd
    local fontColour
    
    if (i % 2 == 0) then
      fontColour = colourOne
    else
      fontColour = colourTwo
    end

    if(formattedIngredients == nil)then
      formattedIngredients = '<span style="color:#'..fontColour..';">'..rec_data.ingredientLines[i]..'</span><br>'
    else
      formattedIngredients = formattedIngredients..'<span style="color:#'..fontColour..';">'..rec_data.ingredientLines[i]..'</span><br>'
    end
  end
  
  local data = {}
  local name = rec_data.name
  if(string.len(name) > 25)then
    name = string.sub(name,1,25).."..."
  end
  
  data["smallRecipeIngredients.ingredient.text"] = '<p style="text-align:center">'..formattedIngredients..'</p>'
  data["smallRecipeIngredients.recipeTitle.text"] = name.." - Serves: "..rec_data.numberOfServings
  gre.set_data(data)
  
  local layerData = {}
  layerData['hidden'] = 0
  gre.set_layer_attrs("popupBG",layerData)
  gre.timer_set_timeout(function()
    gre.set_layer_attrs("smallRecipeIngredients",layerData)
  end, 300
  )
  gre.animation_trigger("POPUP_open")
end

function CBSmallRecipeBack(mapargs)
    CBHideHomeLayers()
    gre.send_event('goToHomeScreen')
end