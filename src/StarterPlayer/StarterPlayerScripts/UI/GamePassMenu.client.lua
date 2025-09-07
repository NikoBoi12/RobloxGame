local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")

local PlayerData = require(ReplicatedStorage.PlayerData)

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")
local Menu = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local GamepassMenu = Menu:WaitForChild("GamepassMenu")

HUD:WaitForChild("PassStore").Activated:Connect(function()
	script.Select:Play()
	if GamepassMenu.Visible then
		GamepassMenu.Visible = false
	else
		if Menu.GiftMenu.Visible then return end
		GamepassMenu.Visible = true
	end
end)



