RegisterNetEvent('jav_dispatch:receiveCallServer', function(text, command, other)
    for _, player in ipairs(GetPlayers()) do
        local targetPlayer = GetPlayer(player)

        if (targetPlayer) then
            local playerJobName = targetPlayer.job and targetPlayer.job.name

            if playerJobName and Shared.Dispatch.Jobs[playerJobName] then

                if Shared.Dispatch.Jobs[playerJobName].commands and CheckTable(Shared.Dispatch.Jobs[playerJobName].commands, command) then
                    TriggerClientEvent('jav_dispatch:sendCallClient', player, text, command, other)
                end

            end
        end
    end
end)

function CheckTable(table, element)
    for _, value in pairs(table) do
        if (value == element) then
            return true
        end
    end
    return false
end

function GetPlayer(source)
    if(GetResourceState('es_extended') == 'started') then
        return ESX.GetPlayerFromId(source)
    elseif(GetResourceState('qb-core') == 'started') then
        return QBCore.Functions.GetPlayer(source)
    end
end

RegisterNetEvent('jav_dispatch:sendMessageServer', function(message, channel)
    TriggerClientEvent('jav_dispatch:sendMessageClient', -1, message, channel)
end)