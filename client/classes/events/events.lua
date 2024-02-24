AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local job = GetPlayer().job

    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then

            dispatch.player = {
                id = GetPlayerServerId(PlayerId()),
                playerName = (GetPlayer().firstName.. " "..GetPlayer().lastName),
                label = job.label,
                name = job.name,
                grade = job.grade_label,
                panic = v.panic,
                allowed = true
            }

            GetAllChannels()
        end
    end
end)

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
