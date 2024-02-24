if(GetResourceState('qb-core') ~= 'started') then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

print('Resource started with ^2[QBCore]')

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()

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

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job, lastJob)

    if(job == lastJob) then return end

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


    if(dispatch.cursor) then
        EnableCursor()
    end

    if(dispatch.open) then
        ShowDispatch()
    end

end)