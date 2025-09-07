local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

local AbilityAnimConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("AbilityAnimConfig"))
local DialogModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

function module.StartUp(Character, Animation)
	local OwnersPlayer = Players:GetPlayerFromCharacter(Character)
	
	local LocalPlayer = Players.LocalPlayer
	local Data = PlayerData.GetData(LocalPlayer)
	
	Character.Revolver.Base.FirePoint.Bang:Emit(1)
	
	if not (LocalPlayer ~= OwnersPlayer and Data.MuteOtherPlayers) then Character.Revolver.Base.Shoot:Play() end
end


return module
