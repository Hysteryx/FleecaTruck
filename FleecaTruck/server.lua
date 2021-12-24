local argent = math.random(10000,30000)
local mintime = 30*60*1000 
local maxtime = 120*60*1000
local globalposition = math.random(1,5)

function ExtractIdentifiers()
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20*6000) --20*6000
        print('^1[Camion-Fleeca] ^2Un camion a spawn !^7') --config spawn console 
        TriggerClientEvent('SpawnTruck','-1',globalposition)
        Citizen.Wait(math.random(mintime,maxtime))
        argent = math.random(10000,30000)
        globalposition = math.random(1,5)
    end 
end)

RegisterNetEvent("EncoreMoney")
AddEventHandler("EncoreMoney", function()
    local _src = source 
    if argent >= 10000 then 
        --requete donne l'argent
        local identifiers = ExtractIdentifiers()
        local steam = identifiers.steam --identifier  dans le sql 
        MySQL.Async.execute("UPDATE user_accounts SET user_accounts.money = user_accounts.money + @a WHERE identifier = @b", {['a'] = argent,['b'] = steam}, function(result)
        end)
        print('^1[Camion-Fleeca] ^3Argent volée ('..argent.."$ par "..GetPlayerName(_src)..") ^7") --config console
        argent = 0
        TriggerClientEvent('NotifFromServer',-1, "~r~[ALERT]~w~ L'argent de nôtre camion a été dérobée ! ~b~Police en route !")--truckStollen 
    else 
        TriggerClientEvent('NotifFromServer',_src, "~b~[INFO]~w~ Il n'y a plus rien à prendre ici....")--nothingNotif 
    end 
end)
print('^4--------------------------------------------------------')
print('^4[Fleeca-Truck]^7 By ^1Hysteryx^7 - https://github.com/Hysteryx')
print('^1--------------------------------------------------------^7')