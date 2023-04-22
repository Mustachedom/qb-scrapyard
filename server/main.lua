local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        Wait(1000)
        GenerateVehicleList()
        Wait((1000 * 60) * 60)
    end
end)

RegisterNetEvent('qb-scrapyard:server:LoadVehicleList', function()
    local src = source
    TriggerClientEvent("qb-scapyard:client:setNewVehicles", src, Config.CurrentVehicles)
end)


QBCore.Functions.CreateCallback('qb-scrapyard:checkOwnerVehicle', function(_, cb, plate)
    local result = MySQL.scalar.await("SELECT `plate` FROM `player_vehicles` WHERE `plate` = ?",{plate})
    if result then
        cb(false)
    else
        cb(true)
    end
end)


RegisterNetEvent('qb-scrapyard:server:ScrapVehicle', function(listKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if  Config.CurrentVehicles[listKey] ~= nil then
		if Player.Functions.AddItem('car_door', 4) then
			if Player.Functions.AddItem('car_tires', 4) then
				if Player.Functions.AddItem('car_hood', 1) then
					if Player.Functions.AddItem('car_trunk', 1) then
						if Player.Functions.AddItem('car_headlights', 2) then
							TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_headlights'], "add", 2)
							TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_trunk'], "add", 1)
							TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_hood'], "add", 1)
							TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_tires'], "add", 4)
							TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_door'], "add", 4)
						end
					end
				end
			end
        end
	end
	 TriggerClientEvent("qb-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, Config.VehicleCount, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("qb-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then
        for k in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then
                retval = true
            end
        end
    end
    return retval
end

RegisterServerEvent('md-scrapyard:server:breakdown', function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local randomChance = math.random(10, 40)
	local randomChance2 = math.random(10,40)
	
	if Player.Functions.RemoveItem('car_trunk', 1) then
		Player.Functions.AddItem('iron', randomChance)
		Player.Functions.AddItem('aluminum', randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['iron'], "add", randomChance)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['aluminum'], "add", randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_trunk'], "remove", 1)
	elseif Player.Functions.RemoveItem('car_headlights', 1) then
		Player.Functions.AddItem('plastic', randomChance) 
		Player.Functions.AddItem('rubber', randomChance2) 
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['plastic'], "add", randomChance)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rubber'], "add", randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_headlights'], "remove")
		TriggerClientEvent('QBCore:Notify', src, ("you got plastic"), "success")
		TriggerClientEvent('QBCore:Notify', src, ("you got rubber"), "success")		
	elseif Player.Functions.RemoveItem('car_hood', 1) then
		Player.Functions.AddItem('metalscrap', randomChance) 
		Player.Functions.AddItem('steel', randomChance2) 
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['metalscrap'], "add", randomChance)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['steel'], "add", randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_hood'], "remove")
		TriggerClientEvent('QBCore:Notify', src, ("you got metalscrap"), "success")
		TriggerClientEvent('QBCore:Notify', src, ("you got steel"), "success")		
	elseif Player.Functions.RemoveItem('car_tires', 1) then
		Player.Functions.AddItem('rubber', randomChance) 
		Player.Functions.AddItem('iron', randomChance2) 
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['metalscrap'], "rubber", randomChance)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['steel'], "add", randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_tires'], "remove")
		TriggerClientEvent('QBCore:Notify', src, ("you got rubber"), "success")
		TriggerClientEvent('QBCore:Notify', src, ("you got steel"), "success")		
	elseif Player.Functions.RemoveItem('car_door', 1) then
		Player.Functions.AddItem('iron', randomChance) 
		Player.Functions.AddItem('metalscrap', randomChance2) 
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['iron'], "add", randomChance)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['metalscrap'], "add", randomChance2)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['car_door'], "remove")
		TriggerClientEvent('QBCore:Notify', src, ("you got iron"), "success")
		TriggerClientEvent('QBCore:Notify', src, ("you got metalscrap"), "success")
	else
	TriggerClientEvent('QBCore:Notify', src, "no parts!", "error")
	end
end)