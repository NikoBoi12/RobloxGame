local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InfoGui = Menus:WaitForChild("Info")

local CurrentScreen = nil

for _, Button in InfoGui:WaitForChild("Options"):GetChildren() do
	if Button:IsA("GuiButton") then
		Button.Activated:Connect(function()
			if CurrentScreen then CurrentScreen.Visible = false end
			if CurrentScreen == InfoGui[Button.Name.."Info"] then CurrentScreen = nil return end
			ReplicatedStorage.Storage.SFX.UI.Select:Play()
			CurrentScreen = InfoGui[Button.Name.."Info"]
			CurrentScreen.Visible = true
		end)
	end
end