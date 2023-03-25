local VehiclesClient = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientModules.VehiclesClient)

local VehicleTable = {}

VehicleTable.VehicleData = debug.getupvalues(VehiclesClient.GetVehicleFromModel)[1]

VehicleTable.GetTable = function()
	return VehicleTable.VehicleData
end

VehicleTable.GetLocalVehicle = function()
    local LocalVehicle = nil

    for Vehicle,Data in VehicleTable.GetTable() do
        for Player,Seat in Data.LuaVehicle.Occupants do
            if Player == LocalPlayer then
                return Vehicle, Data
            end
        end
    end
end


-- for i,v in VehicleTable.GetAllVehicles() do print(i,v) end
-- for b,c in a do
-- 	table.append()
-- 	-- for c,d in b do
-- 	-- 	if c == "Model" then print(d.parent.parent) end
-- 	-- end
-- 	print("-")
-- end

-- if c == "LuaVehicle" then
-- 	for e,f in d do
-- 		if e == "Occupants" then
-- 			for g,h in f do
-- 				print(g,h)
-- 			end
-- 		end
-- 	end
-- end