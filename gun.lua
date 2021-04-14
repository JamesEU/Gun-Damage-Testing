local ped = nil 
local pedoldhealth = nil 
local pedoldarmour = nil
-- Made by JamesUK#6793 Many Thanks. 

-- DO NOT USE IN PRODUCTION ENVIRONMENTS. ONLY TEST SERVERS.


function ChatNotice(msg)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"JamesUK's Gun Test", msg}
      })          
end

RegisterCommand('guntest', function()
    if not ped then
        local pedm = GetHashKey('mp_m_freemode_01')    
        repeat Wait(0) RequestModel(pedm) until HasModelLoaded(pedm)
        local coords = GetEntityCoords(PlayerPedId())
        ped = CreatePed(4, pedm, coords.x,coords.y + 0.5,coords.z - 0.9, 0.0 , true, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        ChatNotice("Ped Spawned! Shoot it to test the weapon's damage")
    else 
        DeletePed(ped)
        ped = nil 
        pedoldhealth = nil
        pedoldarmour = nil
    end
end)

RegisterCommand('guntestarmour', function()
    if ped then 
        AddArmourToPed(ped, 100)
        ChatNotice("Given Ped Full Armour")
    else 
        ChatNotice("No Ped Spawned")
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if ped then
            local health = GetEntityHealth(ped)
            if not pedoldhealth then
                pedoldhealth = health 
            else 
                if health ~= pedoldhealth then
                    ChatNotice("Health Changed: " .. pedoldhealth - health .. " The ped's new health is: " .. health)
                    pedoldhealth = health 
                    if health == 0 then
                        DeletePed(ped)
                        ped = nil 
                        pedoldhealth = nil
                        pedoldarmour = nil
                        ChatNotice("Ped deleted due to it's death.")
                    end
                end
            end
            local armour = GetPedArmour(ped)
            if not pedoldarmour then
                pedoldarmour = armour 
            else 
                if armour ~= pedoldarmour then
                    ChatNotice("Armour Changed: " .. pedoldarmour - armour .. " The ped's new armour is: " .. armour)
                    pedoldarmour = armour 
                end
            end
        end
    end
end)

RegisterCommand('gun', function()
    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL"), 250, false, true)
end)