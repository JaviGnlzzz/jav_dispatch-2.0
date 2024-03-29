if(GetResourceState('es_extended') ~= 'started') then
    return
end

ESX = exports["es_extended"]:getSharedObject()

print('Resource started with ^2[ESX]')

RegisterNetEvent('esx:playerLoaded', function(xPlayer)

    local job = xPlayer.job

    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then
            
            dispatch.player = {
                id = GetPlayerServerId(PlayerId()),
                playerName = (xPlayer.firstName.. " "..xPlayer.lastName),
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

RegisterNetEvent('esx:setJob', function(job, lastJob)

    if(job == lastJob) then return end

    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then

            dispatch.player = {
                id = GetPlayerServerId(PlayerId()),
                playerName = (ESX.GetPlayerData().firstName.. " "..ESX.GetPlayerData().lastName),
                label = job.label,
                name = job.name,
                grade = job.grade_label,
                panic = v.panic,
                allowed = true
            }

            GetAllChannels()
        end
    end


    if(dispatch.cursor) then
        EnableCursor()
    end

    if(dispatch.open) then
        ShowDispatch()
    end

end)