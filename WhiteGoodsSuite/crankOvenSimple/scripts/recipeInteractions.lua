--start position on the 13th line
local startOffset

--below is all of the code for the looping infinite table
function CBSetupRecipeStartPosition(incOffset, incHeight)
  local tableData = {}
  startOffset = (incOffset*incHeight)
  tableData['yoffset'] = -startOffset
  gre.set_table_attrs('smallRecipeList.recipeTable',tableData)
end

function CBCheckRecipeTablePosition()
  local tableData = gre.get_table_attrs('smallRecipeList.recipeTable','yoffset')
  local offset = tableData['yoffset']
  
  local data = {}
  if(offset > -1920)then
    data['yoffset'] = offset - startOffset
  elseif(offset < -(startOffset*2))then
    data['yoffset'] = offset + startOffset
  end
  
  gre.set_table_attrs('smallRecipeList.recipeTable',data)
end

function CBResetRecipeScreen()
  local layerData = {}
  layerData['hidden'] = 1
  gre.set_layer_attrs_global("popupBG",layerData)
  gre.set_layer_attrs_global("smallRecipeIngredients",layerData)
  
  local tableData = {}
  tableData['yoffset'] = -startOffset
  gre.set_table_attrs('smallRecipeList.recipeTable',tableData)
end