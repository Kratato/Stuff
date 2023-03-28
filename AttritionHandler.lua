local CharacterService = require(game:GetService("ReplicatedStorage").GameShared.SharedSystems.CharacterSystem.CharacterService)
local VehiclesClient = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientModules.VehiclesClient)
local StaffList = require(game:GetService("ReplicatedStorage").GameShared.SharedLib.StaffList).GetStaffData()
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Characters = workspace.Characters
local Vehicles = workspace.Vehicles

local AttritionHandler = {
	Vehicles = debug.getupvalues(VehiclesClient.GetVehicleFromModel)[1]
	Players = {},
	Connections = {},
	Table = {}
}

AttritionHandler.Destroy = function()
	for _,Connection in AttritionHandler.Connections do
		Connection:Disconnect()
	end
	hookfunction(CharacterService.GetControllerFromClient, function(a,b) return a._playerControllers[b] end)
	AttritionHandler.Catcher:Destroy()
	AttritionHandler = nil
	warn("Disconnected.")
end

--Temp Disconnector (For testing)
task.spawn(function()
	repeat task.wait() until game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.PageDown)
	AttritionHandler.Destroy()
end)

AttritionHandler.Catcher = Instance.new("RemoteEvent",game.Workspace)
AttritionHandler.Catcher.Name = "Catcher"

local function UpdatePlayerList()
	for Hash,Name in AttritionHandler.Table do
		for _,CharacterModel in Characters:GetChildren() do
			if CharacterModel:GetAttribute("Controller") == Hash then
				if Name == LocalPlayer then
					AttritionHandler.LocalChar = CharacterModel
				else
					AttritionHandler.Players[Name] = CharacterModel
				end
			end
		end
	end

end

AttritionHandler.Connections.UpdatePlayerList = RunService.Heartbeat:Connect(UpdatePlayerList)

hookfunction(AttritionHandler.Catcher.FireServer, function(EpicTable,Source)
	if Source == "GetControllerFromClient" then
		AttritionHandler.Table = EpicTable
	end
end)

hookfunction(CharacterService.GetControllerFromClient, function(a,b)
	task.spawn(function()
		local Table = {}
		table.foreach(a[2], function(i,v)
			Table[tostring(i)] = tostring(v):split(" ")[2]
		end)
		workspace:FindFirstChild("Catcher").FireServer(Table,"GetControllerFromClient")
	end)

	return a._playerControllers[b]
end)

AttritionHandler.GetPlayer = function(Char)
	if AttritionHandler.LocalChar == Char then
		return AttritionHandler.LocalChar
	end
	for Player,Character in AttritionHandler.Players
		if Character == Char then return Player end
	end
end

AttritionHandler.IsStaff = function(Object) -- Character or Player
	local PlayerName
	if Object.Parent == workspace.Characters then
		PlayerName = AttritionHandler.GetPlayer(Char)
	elseif Object.Parent == Players then
		PlayerName = Players[Object]
	end
	if PlayerName then
		for _,Catagory in StaffList do
			for Name, id in Catagory do
				if Name == PlayerName then
					return true
				end
			end
		end
	end
	return false
end

AttritionHandler.GetTeam = function(Object)
	if Object.Parent == Vehicles then
		local TeamColor = AttritionHandler.Vehicels[Object].Team
		if TeamColor == "Bright red" then return Teams["League of 1x1x1x1"]
		elseif TeamColor == "Bright blue"then return Teams["United Bloxxers"]
		else return Teams.Neutral end
	end
	elseif Object.Parent == Characters then
		return AttritionHandler.GetPlayer(Object).Team
	elseif Object.Parent = Players then
		return Object.Team
	end
	return Teams.Neutral
end

AttritionHandler.GetLocalVehicle = function(Vehicle)
	for Vehicle,Data in AttritionHandler.Vehicles do
        for Player,Seat in Data.LuaVehicle.Occupants do
            if Player == LocalPlayer then
                return Vehicle, Data
            end
        end
    end
    return
end

return AttritionHandler