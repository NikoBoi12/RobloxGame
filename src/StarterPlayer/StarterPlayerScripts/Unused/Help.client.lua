local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local RNGMenu = PlayerGui:WaitForChild("RNG")

RNGMenu.Frame.MenuButtons.Help.Activated:Connect(function()
	local HelpMenu = PlayerGui.NewMenu.Canvas.HelpMenu
	if HelpMenu.Visible == false then
		HelpMenu.Visible = true
	else
		HelpMenu.Visible = false
	end
end)