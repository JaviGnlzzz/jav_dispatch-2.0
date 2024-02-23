RegisterCommand('entorno', function(source, args)

    local message = table.concat(args, ' ')

    if(message == '') then return Notification('Entorno', 'Debes añadir un mensaje', 'error') end

    local other = {
        coords = GetEntityCoords(PlayerPedId()),
        playerId = GetPlayerServerId(PlayerId())
    }

    SendNewCall(message, 'entorno', other)
end)

RegisterCommand('forzar', function(source, args)

    if(not IsPedInAnyVehicle(PlayerPedId())) then return Notification('Forzar', 'Debes estar en un vehículo!', 'error') end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(ped)))
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped))

    local other = {
        coords = coords,
        playerId = GetPlayerServerId(PlayerId()),
        carColor = tostring(GetVehicleColor(GetVehiclePedIsIn(ped)))
    }

    SendNewCall('Robo de vehículo con modelo '..model..' y matrícula '..plate..', cerca de '..street, 'forzar', other)
end)

RegisterCommand('tem', function(source, args)

    local ped = PlayerPedId()

    if(not IsPedInAnyVehicle(ped)) then return Notification('Tem', 'Debes estar en un vehículo!', 'error') end

    local coords = GetEntityCoords(ped)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(ped))))
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped))
    local speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(ped)) * 3.6)

    local other = {
        coords = coords,
        playerId = GetPlayerServerId(PlayerId()),
        carColor = tostring(GetVehicleColor(GetVehiclePedIsIn(ped)))
    }

    SendNewCall('Exceso de velocidad de un vehiculo modelo '..model.. ' con matrícula '..plate.. ', a una velocidad de '..speed..'KM', 'tem', other)
end)

RegisterCommand('auxilio', function(source, args)
    local ped = PlayerPedId()

    local coords = GetEntityCoords(ped)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

    local other = {
        coords = coords,
        playerId = GetPlayerServerId(PlayerId()),
    }

    SendNewCall('Alerta de auxilio cerca de '..street, 'auxilio', other)
end)

RegisterCommand('dispatch', function()

    if(not dispatch.player.allowed) then return end

    ShowDispatch()
end)

RegisterCommand('dispatch_cursor', function()
    EnableCursor()
end)

RegisterCommand("move_left", function()
    ChangeCallIndex('left')
end)

RegisterCommand("move_right", function()
    ChangeCallIndex('right')
end)

RegisterCommand("select_position", function()
    if(dispatch.open and not dispatch.cursor) then
        SetNewLocation(dispatch.data.calls[dispatch.data.index].other.coords)

        SendNUIMessage({
            type = 'location:selected'
        })
    end
end)

RegisterCommand("rchat", function(source, args)

    if(not dispatch.player.allowed) then return end

    local message = table.concat(args, ' ')

    if(message ~= '') then
        if(not next(dispatch.data.channels.channelOn)) then return Notification('Radio chat', 'No te encuentras en ningun chat de radio', 'error') end

        local tableMessage = {
            playerId = dispatch.player.id,
            job = dispatch.player.name,
            player = (dispatch.player.playerName..' - '..dispatch.player.label.. ' '..dispatch.player.grade),
            message = message,
            type = 'message'
        } 

        TriggerServerEvent('jav_dispatch:sendMessageServer', tableMessage, dispatch.data.channels.channelOn)
    else
        Notification('Radio chat', 'Debes poner un mensaje', 'error')
    end
end)

RegisterCommand("rlocation", function(source, args)
    if(not dispatch.player.allowed) then return end

    if(message ~= '') then
        if(not next(dispatch.data.channels.channelOn)) then return Notification('Radio chat', 'No te encuentras en ningun chat de radio', 'error') end

        local tableMessage = {
            playerId = dispatch.player.id,
            job = dispatch.player.name,
            player = (dispatch.player.playerName..' - '..dispatch.player.label.. ' '..dispatch.player.grade),
            message = 'Lozalización en tiempo real',
            other = {
                coords = GetEntityCoords(PlayerPedId())
            },
            type = 'location'
        } 

        TriggerServerEvent('jav_dispatch:sendMessageServer', tableMessage, dispatch.data.channels.channelOn)
    end
end)

RegisterCommand("rpanic", function(source, args)
    if(not dispatch.player.allowed) then return end

    if(message ~= '') then
        if(not next(dispatch.data.channels.channelOn)) then return Notification('Radio chat', 'No te encuentras en ningun chat de radio', 'error') end

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
    end
end)

RegisterKeyMapping('dispatch', 'Open Dispatch', 'KEYBOARD', 'F5')
RegisterKeyMapping('move_right', 'Move right Dispatch', 'KEYBOARD', 'right')
RegisterKeyMapping('move_left', 'Move left Dispatch', 'KEYBOARD', 'left')
RegisterKeyMapping('dispatch_cursor', 'Cursor Dispatch', 'KEYBOARD', 'K')
RegisterKeyMapping('select_position', 'Select GPS location', 'KEYBOARD', 'I')