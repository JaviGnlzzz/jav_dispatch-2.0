RegisterNetEvent('jav_dispatch:sendMessageClient', function(message, channel)
    if (dispatch.data.controls[1].disabled) then return end

    if(type(dispatch.data.channels.channelOn) == nil) then return end 

    local inserted = false

    if (dispatch.data.channels.channelOn.id == channel.id) then

        table.insert(dispatch.data.channels.channelOn.data, message)

        inserted = true

        UpdateChannelOn()
    end

    if (not inserted) then
        for k, v in pairs(dispatch.data.channels.allowed) do
            if (v.id == channel.id) then
                table.insert(v.data, message)
                inserted = true
                break
            end
        end
    end
end)
