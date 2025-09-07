--local Players = game:GetService("Players")
--local ReplicatedStorage = game:GetService("ReplicatedStorage")

--local Dialog = require(ReplicatedStorage.Modules:WaitForChild("Dialog"))

--Dialog.TypeWriteLabelCustomRich("\"Red\" <color = \"Red\">Hello world!</color>")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.PlayerData)

local Player = game.Players.LocalPlayer

local PlayerGUI = Player.PlayerGui
local HUD = PlayerGUI:WaitForChild("HUD")
local HUDCanvas = HUD:WaitForChild("Canvas")
local doubleLuckLabel = HUDCanvas:WaitForChild("DoubleLuck")

local data = PlayerData.GetData(Player)

local weekendDates = {
	[1] = 1, --Doing this since doing weekendDates[os.date("*t").wday] would mean it'd show on tuesday since saturday value was the 3rd value
	[6] = 6,
	[7] = 7,
}

while true do
	if weekendDates[os.date("*t").wday] then
		doubleLuckLabel.Visible = true
		data.DateLuck = 1
	else
		doubleLuckLabel.Visible = false
		data.DateLuck = 0
	end
	task.wait(60)
end