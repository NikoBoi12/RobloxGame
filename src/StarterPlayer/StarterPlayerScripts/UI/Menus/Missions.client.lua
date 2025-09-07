local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local MissionsGui = Menus:WaitForChild("Missions")

local CurrentScreen = nil

for _, Button in MissionsGui.Options:GetChildren() do
	if Button:IsA("GuiButton") then
		Button.Activated:Connect(function()
			script.Select:Play()
			if CurrentScreen then CurrentScreen.Visible = false end
			if CurrentScreen == MissionsGui[Button.Name.."Missions"] then CurrentScreen = nil return end
			CurrentScreen = MissionsGui[Button.Name.."Missions"]
			CurrentScreen.Visible = true
		end)
	end
end