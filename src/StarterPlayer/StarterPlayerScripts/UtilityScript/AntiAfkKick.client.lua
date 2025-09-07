local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")

local GameUtility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameUtility"))

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local LocalPlayer = PlayersService.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Data = PlayerData.GetData(LocalPlayer)

local TotalTime = 0
local TeleportMaxTime = 600

local function InputBegan(Input, GameService)
	TotalTime = 0
end

UserInput.InputBegan:Connect(InputBegan)

local AfkRun = Data["Anti Afk Kick"]

local function StartTime()
	while AfkRun do
		local DeltaTime = task.wait()
		TotalTime += DeltaTime

		if TotalTime >= TeleportMaxTime then
			local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local positionToSave = Character:GetPivot().Position
			
			if positionToSave and not RunService:IsStudio() then
				ReplicatedStorage.Remotes.SolarRemotes.AfkTeleport:FireServer(positionToSave)
				print("Teleporting", LocalPlayer)
			end
			break
		end
	end
	TotalTime = 0
end

Data.Changed:Connect(function(Index, Value)
	if Index == "Anti Afk Kick" then
		AfkRun = Value
		if Value == true then
			StartTime()
		end
	end
end)


local TeleportData = TeleportService:GetLocalPlayerTeleportData()

if TeleportData and TeleportData.SpawnPosition then
	Character:PivotTo(CFrame.new(TeleportData.SpawnPosition))
end




if AfkRun == true then
	StartTime()
end

