QBCore = exports["qb-core"]:GetCoreObject()

local cooldown = false

local function DrawText3D(x, y, z, text) -- Draw text
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function spawnBike()
    local ped = PlayerPedId()    
    local hash = GetHashKey(Config.bikeModel)   
    if not IsModelInCdimage(hash) then 
        return 
    end    
    RequestModel(hash)    
    while not HasModelLoaded(hash) do 
        Wait(10) 
    end    
    local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)    
    TaskWarpPedIntoVehicle(ped, vehicle, -1)    
    SetModelAsNoLongerNeeded(vehicle)    
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
    cooldown = true
    Wait(Config.cooldownTime)
    cooldown = false
end


CreateThread(function() -- Main thread
	while cooldown == false do
		Wait(0)         
		for _, bike in pairs(Config.bikeLocations) do 
			local pos = GetEntityCoords(PlayerPedId())
            local distance = #(pos - bike)
            
			if distance <= 20 then
                DrawMarker(38, bike.x, bike.y, bike.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.80, 0.80, 0.80, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                if distance <= 20 then 
                    DrawText3D(bike.x, bike.y, bike.z -0.3, "~g~E~w~ - NOLEGGIO BICI")
                    if IsControlJustReleased(0, 38) then
                        spawnBike()
                    end
                end
            end    
        end
    end
end)



