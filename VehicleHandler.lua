local VehiclesClient = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientModules.VehiclesClient)

local VehicleTable = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
    return
end

return VehicleTable