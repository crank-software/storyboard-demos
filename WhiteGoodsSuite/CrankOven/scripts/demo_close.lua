local DEMO_MODE = 1
gVideoSupport = nil

function cb_demo_init(mapargs)
    print('demo mode check')
    local demo_value = os.getenv('SB_DEMO')

    if demo_value ~= nil or DEMO_MODE == 1 then
        if demo_value == '1' or DEMO_MODE == 1 then
            local sdata = {}
            print('unhidingCloseButton')
            sdata['hidden'] = 0
            gre.set_layer_attrs_global('home_screen.closeButton_layer', sdata)
            print('To hide voice related controls add SB_NO_VOICE=1 to launcher script.')
        end
    end

    local voice_value = os.getenv('SB_NO_VOICE')
    if voice_value == '1' or voice_value == 1 then
        local layer = 'voiceActivationHeader'
        local infoIcon_hidden_key = string.format('%s.infoIcon.grd_hidden', layer)
        local backgroundOne_hidden_key = string.format('%s.backgroundOne.grd_hidden', layer)
        local backgroundTwo_hidden_key = string.format('%s.backgroundTwo.grd_hidden', layer)
        local backgroundThree_hidden_key = string.format('%s.backgroundThree.grd_hidden', layer)
        local talkingLinesPlaceholder_hidden_key = string.format('%s.talkingLinesPlaceholder.grd_hidden', layer)
        local callToAction_hidden_key = string.format('%s.callToAction.grd_hidden', layer)
        local dotRightOuter_hidden_key = string.format('%s.dotRightOuter.grd_hidden', layer)
        local dotRightInner_hidden_key = string.format('%s.dotRightInner.grd_hidden', layer)
        local dotLeftOuter_hidden_key = string.format('%s.dotLeftOuter.grd_hidden', layer)
        local dotLeftInner_hidden_key = string.format('%s.dotLeftInner.grd_hidden', layer)

        local data = {}
        data[infoIcon_hidden_key] = 1
        data[backgroundOne_hidden_key] = 1
        data[backgroundTwo_hidden_key] = 1
        data[backgroundThree_hidden_key] = 1
        data[talkingLinesPlaceholder_hidden_key] = 1
        data[callToAction_hidden_key] = 1
        data[dotRightOuter_hidden_key] = 1
        data[dotRightInner_hidden_key] = 1
        data[dotLeftOuter_hidden_key] = 1
        data[dotLeftInner_hidden_key] = 1

        gre.set_data(data)

    end

    local video_value = os.getenv('SB_VIDEO')
    if (video_value == '0') then
        gVideoSupport = 0
    else
        gVideoSupport = 1
    end

    --APP_INIT()
end

function cb_close_button(mapargs)
    gre.quit()
end
