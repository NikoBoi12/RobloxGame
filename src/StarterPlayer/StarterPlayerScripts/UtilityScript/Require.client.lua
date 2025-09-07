local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpriteSheetNew = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("SpriteSheetNew"))
local EffectService = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Services"):WaitForChild("EffectService"))
local AuraService = require(ReplicatedStorage.Modules.Services:WaitForChild("AuraService"))
local FollowHRP = require(ReplicatedStorage:WaitForChild("Components"):WaitForChild("FollowComp"):WaitForChild("FollowHRP"))
local MissionsHandler = require(ReplicatedStorage.Modules:WaitForChild("MissionsHandler"))
local AchievementsHandler = require(ReplicatedStorage.AchievementManager)
local Buttons = require(ReplicatedStorage.Modules.Buttons)
local NotificationHandler = require(ReplicatedStorage.Modules.NotificationHandler)
local CreateNPCDisplay = require(ReplicatedStorage.Modules.CreateNPCDisplay)
print("All required")

for _, mod in ReplicatedStorage.Modules.SolarFunctions:GetDescendants() do
	if mod:IsA("ModuleScript") and mod:HasTag("client") then
		local a = require(mod)
		if a.init then
			a.init()
		end
	end
end

--local HalloweenEvent = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HalloweenEvent"))