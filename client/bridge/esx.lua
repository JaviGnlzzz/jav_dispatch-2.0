if(GetResourceState('es_extended') ~= 'started') then
    return
end

ESX = exports["es_extended"]:getSharedObject()

print('Resource started with ^2[ESX]')

local function Player(panic)

    local job = ESX.GetPlayerData().job

    return {
        id = ESX.GetPlayerData().identifier,
        playerName = (ESX.GetPlayerData().firstName.. " "..ESX.GetPlayerData().lastName),
        name = job.name,
        label = job.label,
        grade = job.grade_label,
        panic = panic,
        allowed = true
    }
end

CreateThread(function()
    repeat
        Wait(1000)
    until ESX.IsPlayerLoaded()

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(ESX.GetPlayerData().job.name == k) then

            dispatch.player = Player(v.panic)

            GetAllChannels()
        end
    end
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)

    if(job == lastJob) then return end

    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then

            dispatch.player = Player()

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