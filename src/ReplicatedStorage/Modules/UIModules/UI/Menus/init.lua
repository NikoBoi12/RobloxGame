local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer
local module = {}

function module:Show()
	self.ScreenGui.Enabled = true
end

function module:Hide()
	self.ScreenGui.Enabled = false
end

function module:IsEnabled()
	return self.ScreenGui.Enabled
end

function module:CanClose()
	return self.IsOpen and self.IsEnabled
end

function module:CanOpen()
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChild("Humanoid")
	
	return true
end

function module:Open()
	if self:CanOpen() and self.IsEnabled then
		self:Show()
		
		self.IsOpen = true
	end
end

function module:Close()
	if self:CanClose() then
		self:Hide()
		
		self.IsOpen = false
	end
end

function module:init()
	local player = game.Players.LocalPlayer
	self.PlayerGui = Player:WaitForChild("PlayerGui")
	self.ScreenGui = self.PlayerGui:WaitForChild("Menus")
	self.PageLocked = false
	self.IsEnabled = true
	self.IsOpen = false
end

return module


--[[
function module:CanOpen()
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChild("Humanoid")
	return not self.UI.ZombieLab.ScreenGui.Enabled and self.UI.IsLoaded and not self.IsOpen and not self.UI.LobbyUI.Emote.Enabled and not self.UI.SettingsUI.ScreenGui.Enabled and not self.UI.DailyRewardUI.ScreenGui.Enabled and Humanoid and Humanoid:GetState() ~= Enum.HumanoidStateType.Seated and not Player:GetAttribute("InsideTrain") and Player.Team and Player.Team == game.Teams.Neutral and not self.PlayerGui.InventoryUI.Enabled and not self.PlayerGui.ZombieInventory.Enabled 
end

]]