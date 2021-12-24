-- @author - Hysteryx 
-- @version - 1.0.2
-- https://github.com/Hysteryx

--Si vous ajoutez des coordonnées, il est important dans le serveur de modifier les 2 math.random(1,5)

--differents pos 
local positions = { 
    [1] = vector3(-98,91,71.78),
    [2] = vector3(1628.75, 1085.2, 81.4),
    [3] = vector3(-1162,-1178,5.6),
    [4] = vector3(-3044, 600.75,7.5),
    [5] = vector3(-280, 6124, 31.5),
}
--differents pos sacs 
local positionsSac = {
    [1] = vector3(-102.27, 89.9,70.67),
    [2] = vector3(1626.1, 1081.8, 80.3),
    [3] = vector3(-1162,-1182.4,4.6),
    [4] = vector3(-3040, 602.75,6.5),
    [5] = vector3(-281, 6120, 30.5),
}
--differents headings 
local headings = {
    [1] = 284.7,
    [2] = 320.71,
    [3] = 180,
    [4] = 116.1,
    [5] = 339.03,
}

function notif(message) --notifs 
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", "flash", "CHAR_BANK_FLEECA", "Fleeca Alert", "Accident")
    DrawNotification(true, false)
end 
--    notif('~r~[ALERT]~w~ Un de nos camions est accidenté au niveau de ~b~Archer Avenue North')

function spawnVehicle(position, heading, vehiclename, delay, gbPos)--fait spawn le vehicule et les obj 
    local gbPos = gbPos
    local pos = position 
    local heading = heading
    local vehiclename = vehiclename
    local vHash = GetHashKey(vehiclename)
    RequestModel(vHash)
    while not HasModelLoaded(vHash) do 
        Citizen.Wait(10)
    end 
    local veh = CreateVehicle(vHash, pos.x, pos.y, pos.z, heading, false, false)
    local obj = spawnObj(positionsSac[gbPos], 'prop_money_bag_01')
    blips(delay, gbPos)
    SetVehicleAlarm(veh, true)
    StartVehicleAlarm(veh)
    SetVehicleEngineOn(veh,false,false,false)
    SetVehicleEngineHealth(veh, 0)
    for i = 0, 3 do
        Citizen.Wait(5)
        SetVehicleDoorOpen(veh, i, false, true) -- will open every door from 0-5
    end
    SetVehicleLights(veh,2)
    -- supr après genre 10minutes 
    notif('~r~[ALERT]~w~ Un de nos camions est accidenté, ~b~La police est prévenue !') --notif spawn
    Citizen.Wait(delay)
    DeleteVehicle(veh)
    DeleteObject(obj)
end 


function spawnObj(position, objName) -- fait spawn le sac d'argent
    local pos = position
    local hash = GetHashKey(objName)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Citizen.Wait(10)
    end 
    local obj = CreateObject(hash, pos.x,pos.y,pos.z, false, false)
    return obj 
end 


function blips(delay, globalpos) --blip map rouge 
    local pos = globalpos
    local blips = {
        {title="Camion accidenté", colour=1, id=1, x = positions[pos].x, y = positions[pos].y, positions[pos].z}--blips 
     }   
   Citizen.CreateThread(function()
       for _, info in pairs(blips) do
         info.blip = AddBlipForCoord(info.x, info.y, info.z)
         SetBlipSprite(info.blip, info.id)
         SetBlipDisplay(info.blip, 4)
         SetBlipScale(info.blip, 1.0)
         SetBlipColour(info.blip, info.colour)
         SetBlipAsShortRange(info.blip, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString(info.title)
         EndTextCommandSetBlipName(info.blip)
         Citizen.Wait(delay)
         RemoveBlip(info.blip)
       end
   end)
end


function FaitLeMarker(position, delay) --Marker rouge avec action
    local delay = delay 
    local tps = 0
    Citizen.CreateThread(function()
        local pos = position
        while true do 
            local interval = 1
            local posPlayer = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(pos, posPlayer, true)
            if distance >= 30 then 
                interval = 500
            else 
                interval = 1
                tps = tps + 5
                DrawMarker(2, pos.x,pos.y,pos.z+0.75, 0.0, 0.0 ,0.0 ,0.0 ,0.0 ,0.0,0.5,0.5,0.5,255,0,0,170,0,1,2,0,nil,nil,0)
                if distance < 2 then 
                    AddTextEntry("vol", "Appuez sur ~INPUT_CONTEXT~ pour prendre ~r~l'argent !") --take money text
                    DisplayHelpTextThisFrame("vol", false )
                    if IsControlJustPressed(1,51) then
                        Citizen.Wait(200) 
                        TaskStartScenarioInPlace(PlayerPedId(),'CODE_HUMAN_MEDIC_KNEEL',0,true)
                        Citizen.Wait(5000)
                        TriggerServerEvent('EncoreMoney')
                        ClearPedTasks(PlayerPedId())
                        PlayPoliceReport('SCRIPTED_SCANNER_REPORT_SEC_TRUCK_03', 0.0)
                    end 
                end 
            end 
            Citizen.Wait(interval)
            tps = tps + interval 
            if tps >= delay then 
                return 
            end
        end  
    end)
end

-- Pour test et dev -- 
RegisterCommand('pos', function()
    print('Votre position est :'..GetEntityCoords(PlayerPedId(-1))..' avec un heading de '..GetEntityHeading(PlayerPedId()))

end)

--[[RegisterCommand('test', function() --dev command
    FaitLeMarker(positionsSac[1], 50000)  
    spawnVehicle(positions[1], headings[1], 'stockade',50000)
end)]]--

--Permet d'envoyer une notif comme quoi il y a ou non de l'argent 
RegisterNetEvent('NotifFromServer')
AddEventHandler("NotifFromServer", function(message)
    notif(message)
end)

RegisterNetEvent('SpawnTruck')
AddEventHandler('SpawnTruck', function(globalpos) --Global pos définit dans le dico la pos 
    local pos = globalpos
    print('Trigged')
    FaitLeMarker(positionsSac[pos], 50*6000) 
    spawnVehicle(positions[pos], headings[pos], 'stockade',50*6000,pos) -- 10minutes
end)

print('^4[Fleeca-Truck]^7 By ^1Hysteryx^7 - https://github.com/Hysteryx')











