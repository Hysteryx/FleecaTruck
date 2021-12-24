local argent = math.random(10000,30000)
local mintime = 30*60*1000 
local maxtime = 120*60*1000
local globalposition = math.random(1,5)

ESX = nil 
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
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(argent)
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