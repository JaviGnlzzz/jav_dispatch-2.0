function ShowDispatch(new)
    if(new) then

        dispatch.open = true
        dispatch.data.index = #dispatch.data.calls

        SendNUIMessage({
            type = 'new:call',
            data = {
                player = dispatch.player,
                call = dispatch.data.calls[#dispatch.data.calls] or {},
                totalCalls = #dispatch.data.calls == 0 and 0 or #dispatch.data.calls,
                channels = dispatch.data.channels,
                controls = dispatch.data.controls
            },
        })
    else
        if(not dispatch.open) then

            dispatch.open = true
    
            SendNUIMessage({
                type = 'show:main',
                data = {
                    player = dispatch.player,
                    call = dispatch.data.calls[dispatch.data.index] or {},
                    totalCalls = #dispatch.data.calls == 0 and 0 or #dispatch.data.calls,
                    channels = dispatch.data.channels,
                    controls = dispatch.data.controls
                },
            })
        else
    
            dispatch.open = false
    
            SendNUIMessage({
                type = 'hide:main'
            })
        end
    end
end

function ChangeDispatchData(direction)
    SendNUIMessage({
        type = 'move:call',
        data = {
            player = dispatch.player,
            call = dispatch.data.calls[dispatch.data.index] or {},
            totalCalls = #dispatch.data.calls == 0 and 0 or #dispatch.data.calls,
            direction = direction
        },
    })
end

function EnableCursor()

    if(not dispatch.open) then return end

    if(not dispatch.cursor) then

        dispatch.cursor = true

        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'enable:cursor'
        })
    else

        dispatch.cursor = false

        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'disable:cursor'
        })
    end
end

function Notification(title, message)
    if(GetResourceState('es_extended') == 'started') then
        ESX.ShowNotification(title, message)
    elseif(GetResourceState('qbcore') == 'started') then
        QBCore.Functions.Notify(title, message)
    end
end

function SendNewCall(text, command, other)

    if(text == '' or not text or not command) then return end

    TriggerServerEvent('jav_dispatch:receiveCallServer', text, command, other)
end

exports('SendNewCall', SendNewCall)

function GetAllChannels()
    local currentJob = dispatch.player.name

    dispatch.data.channels = {
        channelOn = {},
        allowed = {} 
    }

    for job, data in pairs(Shared.Dispatch.Jobs) do
        if (data.channel and data.channel.allowedJobs) then
            if CheckTable(data.channel.allowedJobs, currentJob) then
                table.insert(dispatch.data.channels.allowed, {
                    id = data.channel.id,
                    title = data.channel.title,
                    data = {}
                })
            end
        end
    end

    Wait(200)

    SendNUIMessage({
        type = 'update:player',
        player = dispatch.player
    })
end

function IsIDTaken(id)
    for _, channel in ipairs(dispatch.data.channels.allowed) do
        if channel.id == id then
            return true
        end
    end
    return false
end

function EnterChannel(channel)

    channel = (tonumber(channel) + 1)

    if(dispatch.data.channels.channelOn == dispatch.data.channels.allowed[channel]) then
        Notification(Translate('leave_radio'):format(dispatch.data.channels.channelOn.title), 'dispatch')
        dispatch.data.channels.channelOn = {}
        UpdateChannelOn()
        return 
    end

    if(channel and dispatch.data.channels.allowed[channel]) then
        dispatch.data.channels.channelOn = dispatch.data.channels.allowed[channel]
        Notification(Translate('join_radio'):format(dispatch.data.channels.allowed[channel].title), 'dispatch')
        UpdateChannelOn()
    end
end

function UpdateChannelOn()
    SendNUIMessage({
        type = 'update:channelOn',
        channelOn = dispatch.data.channels.channelOn
    })
end

function CheckTable(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function ChangeCallIndex(direction)

    if(not dispatch.open) then return end
    
    if(dispatch.cursor) then return end

    if(direction == 'left') then
        if (dispatch.data.calls[dispatch.data.index - 1]) then

            dispatch.data.index = dispatch.data.index - 1

            ChangeDispatchData(direction)
        end
    end

    if(direction == 'right') then
        if (dispatch.data.calls[dispatch.data.index + 1]) then

            dispatch.data.index = dispatch.data.index + 1

            ChangeDispatchData(direction)
        end
    end
end

function SetNewLocation(coords)
    if(coords) then
        Notification(Translate('location_selected'), 'dispatch')
        SetNewWaypoint(coords.x, coords.y)
    end
end

function Translate(text)
    if(Language[Shared.Language][text]) then
        return Language[Shared.Language][text]
    else
        return print('No translation for: '..text)
    end
end

function GetPlayer()
    if(GetResourceState('es_extended') == 'started') then
        return ESX.GetPlayerData()
    elseif(GetResourceState('qbcore') == 'started') then
        return QBCore.Functions.GetPlayerData()
    end
end