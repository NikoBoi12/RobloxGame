local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer
local module = {}

function module:Show()
	if self.UI.Menus.Inventory:IsVisible() or self.UI.Menus.Auras:IsVisible() or self.UI.Menus.Settings:IsVisible() or self.UI.Menus.Missions:IsVisible() then
		self.UI.Menus.Inventory:Hide()
		self.UI.Menus.Auras:Hide()
		self.UI.Menus.Settings:Hide()
		self.UI.Menus.Missions:Hide()
		return
	end
	self.MenuFrame.Visible = true
end

function module:Hide()
	self.MenuFrame.Visible = false
end

function module:IsVisible()
	return self.MenuFrame.Visible
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
	self.ScreenGui = self.Menus.ScreenGui
	self.MenuFrame = self.ScreenGui:WaitForChild("Canvas"):WaitForChild("FastTravel")
	self.PageLocked = false
	self.IsEnabled = true
	self.IsOpen = false
	self.PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas"):WaitForChild("List"):WaitForChild("FastTravel"):WaitForChild("FastTravel").Activated:Connect(function()
		if self:IsVisible() == false then
			self:Open()
		else
			self:Close()
		end

	end)
end

return module