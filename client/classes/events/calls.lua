RegisterNetEvent('jav_dispatch:sendCallClient', function(text, command, other)

    local sended = false

    if (command == 'entorno' and not dispatch.data.controls[2].disabled) then

        table.insert(dispatch.data.calls, {
            id = #dispatch.data.calls == 0 and 1 or #dispatch.data.calls + 1,
            message = text,
            type = command,
            other = other
        })

        sended = true
    end

    if(command == 'drugs' and not dispatch.data.controls[3].disabled) then
        table.insert(dispatch.data.calls, {
            id = #dispatch.data.calls == 0 and 1 or #dispatch.data.calls + 1,
            message = text,
            type = 'drogas',
            other = other
        })

        sended = true
    end

    if(command == 'tem' and not dispatch.data.controls[4].disabled) then
        table.insert(dispatch.data.calls, {
            id = #dispatch.data.calls == 0 and 1 or #dispatch.data.calls + 1,
            message = text,
            type = 'aviso de TEM',
            other = other
        })

        sended = true
    end

    if(command == 'forzar') then
        table.insert(dispatch.data.calls, {
            id = #dispatch.data.calls == 0 and 1 or #dispatch.data.calls + 1,
            message = text,
            type = 'robo de vehículo',
            other = other
        })

        sended = true
    end

    if(command == 'auxilio') then
        table.insert(dispatch.data.calls, {
            id = #dispatch.data.calls == 0 and 1 or #dispatch.data.calls + 1,
            message = text,
            type = 'Aviso de auxilio',
            other = other
        })

        sended = true
    end

    if(sended) then
        ShowDispatch(true)
    end
end)