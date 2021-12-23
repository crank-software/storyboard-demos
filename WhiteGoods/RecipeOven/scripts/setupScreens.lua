--- @param gre#context mapargs
function cb_SetupOvenScreenSetup(mapargs)
  local animData = {}
  animData["context"] =  "setupOven.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end

function cb_loopStartAnimationOvenScreen(mapargs)
  local animData = {}
  animData["context"] =  "setupOven.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end

function cb_RecipeScreenSetup(mapargs)
  local animData = {}
  animData["context"] =  "aboutRecipe.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end

function cb_loopStartAnimationRecipeScreen(mapargs)
  local animData = {}
  animData["context"] =  "aboutRecipe.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end

function cb_InstructionScreenSetup(mapargs)
  local animData = {}
  animData["context"] =  "instruction.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end

function cb_loopStartAnimationInstructionScreen(mapargs)
  local animData = {}
  animData["context"] =  "instruction.startButton"
  gre.animation_trigger("AMBIENT_StartButton", animData)
end