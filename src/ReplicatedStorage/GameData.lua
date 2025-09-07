local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local NetSync = require(ReplicatedStorage:WaitForChild("NetSync"))

local Module = nil

if RunService:IsServer() then
	Module = NetSync.Add("GameData",{
		FunValue = 1,
		CurrentFunIndex = nil
	})
else -- IsClient
	Module = NetSync.WaitFor("GameData")
end

return Module
