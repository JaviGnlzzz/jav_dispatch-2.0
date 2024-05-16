if(GetResourceState('qb-core') ~= 'started') then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

print('Resource started with ^2[QBCore]')

local function Player(panic)
    local job = QBCore.Functions.GetPlayerData().job

    return {
        id = GetPlayerServerId(PlayerId()),
        playerName = QBCore.Functions.GetPlayerData().charinfo.firstname.. " "..QBCore.Functions.GetPlayerData().charinfo.lastname,
        name = job.name,
        label = job.label,
        grade = job.grade_label,
        panic = panic,
        allowed = true
    }
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then

            dispatch.player = Player(v.panic)

            GetAllChannels()
        end
    end

end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job, lastJob)

    if(job == lastJob) then return end

    dispatch.player = {}

    for k,v in pairs(Shared.Dispatch.Jobs) do
        if(job.name == k) then

            dispatch.player = Player(v.panic)

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