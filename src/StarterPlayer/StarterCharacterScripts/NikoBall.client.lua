local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SpawnBall = Remotes:WaitForChild("SpawnBall")

local Data = PlayerData.GetData(Players.LocalPlayer)

local Debounce = false


local function SpawnNikoBall(ActionName, InputState, InputObject)
	if InputState == Enum.UserInputState.Begin then
		if Debounce then return end
		Debounce = true
		SpawnBall:FireServer()
		task.wait(10)
		Debounce = false
	end
end


if Data.HasBallPass then
	ContextActionService:BindAction("Spawn Niko Ball", SpawnNikoBall, true, Enum.KeyCode.B, Enum.KeyCode.ButtonR2)
end

