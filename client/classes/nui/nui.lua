RegisterNUICallback('cursor', function()
    EnableCursor()
end)

RegisterNUICallback('getDistanceToCoords', function(data, cb)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - vector3(data.coords.x, data.coords.y, data.coords.z))
    cb(distance)
end)

RegisterNUICallback('controlAction', function(data, cb)

    if(data.control.value == 'panic') then

        if(not next(dispatch.data.channels.channelOn)) then
            Notification('PANIC', 'No estas en ningun canal para mandar ese aviso!', 'error')        
            return
        end
        
        Notification('PANIC', 'Mandaste una señal de panico', 'dispatch')

        local tableMessage = {
            playerId = dispatch.player.id,
            job = dispatch.player.name,
            player = (dispatch.player.playerName..' - '..dispatch.player.label.. ' '..dispatch.player.grade),
            message = 'AVISO DE PANICÓ',
            other = {
                coords = GetEntityCoords(PlayerPedId())
            },
            type = 'panic'
        } 

        TriggerServerEvent('jav_dispatch:sendMessageServer', tableMessage, dispatch.data.channels.channelOn)

        return
    end

    if (data.control and data.control.value) then
        local selectedControl = dispatch.data.controls[data.index + 1]

        selectedControl.disabled = not selectedControl.disabled
    end

    cb(dispatch.data.controls)
end)

RegisterNUICallback('enterChannel', function(data, cb)
    EnterChannel(data.index)
end)

RegisterNUICallback('sendLocation', function(data, cb)
    SetNewLocation(data.coords)
end)