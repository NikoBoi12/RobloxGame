local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local PlayerData = require(ReplicatedStorage.PlayerData)

local Replicate = script.Replicate

local Debounce = false
local Cooldown = 5

local UseEffect = {}

function UseEffect.SetUp()
	
end


function UseEffect.Use()
	if Debounce then return end
	Debounce = true
	Replicate:FireServer()
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.StartEffect(Player)
	
end


if RunService:IsServer() then
	Replicate.OnServerEvent:Connect(function(Player)
		local Data = PlayerData.GetData(Player)
		if not Data then return end

		if Data[script.Name] and (os.clock() - Data[script.Name]) < Cooldown - 2 then return end

		Data[script.Name] = os.clock()
		
		Replicate:FireAllClients(Player)
	end)
else
	Replicate.OnClientEvent:Connect(UseEffect.StartEffect)
end


return UseEffect
