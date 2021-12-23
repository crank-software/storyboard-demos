popup = 0

function fit_next_popup(mapargs)
    local data = gre.get_data("fit_popup_layer.popup")
    local value = data["fit_popup_layer.popup"]

    if (value == 1) then
        gre.animation_trigger("popup_cal_tar") 
        data["fit_popup_layer.popup"] = "2"

    elseif (value == 2) then
        gre.animation_trigger("popup_tar_step") 
        data["fit_popup_layer.popup"] = "3"
    elseif (value == 3) then
        gre.animation_trigger("popup_step_lead") 
        data["fit_popup_layer.popup"] = "4"
    elseif (value == 4) then
        gre.animation_trigger("popup_lead_cal") 
        data["fit_popup_layer.popup"] = "1"
    end
    gre.set_data(data)

end

function fit_prev_popup(mapargs)
    local data = gre.get_data("fit_popup_layer.popup")
    local value = data["fit_popup_layer.popup"]

    if (value == 1) then
        gre.animation_trigger("popup_cal_lead") 
        data["fit_popup_layer.popup"] = "4"

    elseif (value == 2) then
        gre.animation_trigger("popup_tar_cal") 
        data["fit_popup_layer.popup"] = "1"
    elseif (value == 3) then
        gre.animation_trigger("popup_step_tar") 
        data["fit_popup_layer.popup"] = "2"
    elseif (value == 4) then
        gre.animation_trigger("popup_lead_step") 
        data["fit_popup_layer.popup"] = "3"
    end
    gre.set_data(data)

end


