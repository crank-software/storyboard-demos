local amount = 16

function CBincrease(mapargs)
  amount = amount + 1
  if(amount > 16)then
  amount = 16
  end
  setupRecipes()
end

function CBdecrease(mapargs)
  amount = amount - 1
  if(amount < 0)then
    amount = 0
  end
  setupRecipes()
end

function setupRecipes()

  local dk_data = {}
  dk_data["hidden"] = 1
  for i=1, 16 do
    gre.set_control_attrs("animIcons.recipe"..i,dk_data)
  end
  
  dk_data["hidden"] = 0  
  for i=1, amount do
    gre.set_control_attrs("animIcons.recipe"..i,dk_data)
  end
end