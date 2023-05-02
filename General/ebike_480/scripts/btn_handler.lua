---
-- Handles the toggle button.
-- To add a toggle button make sure you
-- Declare a variable
-- Update the update_context_variable
-- Add the context strings in the toggle_handler
-- Reuse the code thats in the toggle handler if statements
-- Add a get method to get your value

local unit_id = 1
local time_id = 2
local light_id = 1
local function update_context_variable(context_id, new_value)
    if(context_id == 1) then
        unit_id = new_value
    elseif(context_id == 2) then
        time_id = new_value
    else
        light_id = new_value
    end
end

function toggle_handler(mapargs)
    local on_img = 'images/radio_on.png'
    local off_img = 'images/radio_off5.png'
    local settings_str = "settings_layer."
    local unit_context = "units_group"
    local time_context = "time_group"
    local light_context = "light_group"
    local btn1 = "radio_on"
    local btn2 = "radio_off"
    local contxt = mapargs.context_control
    print(contxt)
    local btn1_str
    local btn2_str
    local context_id
    if(contxt:find(unit_context)) then
        btn_on_id = unit_id
        btn1_str = string.format("%s%s.%s.radio_btn_1", settings_str,unit_context,btn1)
        btn2_str = string.format("%s%s.%s.radio_btn_2", settings_str,unit_context,btn2)
        context_id = 1
    elseif(contxt:find(time_context)) then
        btn_on_id = time_id
        btn1_str = string.format("%s%s.%s.radio_btn_1", settings_str,time_context,btn1)
        btn2_str = string.format("%s%s.%s.radio_btn_2", settings_str,time_context,btn2)
        context_id = 2
    else
        btn_on_id = light_id
        btn1_str = string.format("%s%s.%s.radio_btn_1", settings_str,light_context,btn1)
        btn2_str = string.format("%s%s.%s.radio_btn_2", settings_str,light_context,btn2)
        context_id = 3
    end
    
    -- Toggles the button
    if(contxt:find(btn1)) then
        print(contxt, btn1)
        local swap = on_img
        on_img = off_img
        off_img = swap
        update_context_variable(context_id, 2)

    else
        update_context_variable(context_id, 1)
    end

    gre.set_value(btn1_str, off_img)
    gre.set_value(btn2_str, on_img)
end

---
-- Gets the unit ID
function get_unit_id()
    return unit_id
end

--- Gets the time ID
function get_time_id()
    return time_id
end