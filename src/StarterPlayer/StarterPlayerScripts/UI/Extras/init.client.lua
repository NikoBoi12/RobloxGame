local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage.PlayerData)
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local StatConfig = require(script.StatInfo)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local ExtrasGui = Menus:WaitForChild("Info"):WaitForChild("ExtrasInfo") :: typeof(game.StarterGui.Menus.Canvas.Info.ExtrasInfo)

local Data = PlayerData.GetData(LocalPlayer)

if not Data then return end

local CurrentScreen = nil

for _, Button in ExtrasGui:WaitForChild("Options"):GetChildren() do
	if Button:IsA("GuiButton") then
		Button.Activated:Connect(function()
			script.Select:Play()
			if CurrentScreen then CurrentScreen.Visible = false end
			if CurrentScreen == ExtrasGui[Button.Name] then CurrentScreen = nil return end
			CurrentScreen = ExtrasGui[Button.Name]
			CurrentScreen.Visible = true
		end)
	end
end

--// Codes

local CodesMenu = ExtrasGui.Codes;
local CodeRemote = ReplicatedStorage.Remotes.SolarRemotes.Codes
local removeThread: thread?
local codeIDList = {
	[1] = [[<font color='#FF0000'>Code does not exist!</font>]];
	[2] = [[<font color='#FF0000'>Code has already expired!</font>]];
	[3] = [[<font color='#00FF00'>Code succesfully redeemed!</font>]];
	[4] = [[<font color='#FF0000'>Code has already been redeemed!</font>]];
	[5] = [[<font color='#FF0000'>Please wait a few seconds before trying again!</font>]];
}

CodesMenu.Redeem.Activated:Connect(function()
	local getText = CodesMenu.TextBox.Text;
	if getText then
		CodeRemote:FireServer(getText)
	end
end)

CodeRemote.OnClientEvent:Connect(function(id: number, custom: string?)
	if id == 5 then return end
	if codeIDList[id] or custom then
		CodesMenu.TextLabel.Text = custom or codeIDList[id];
		if removeThread and typeof(removeThread) == "thread" then
			task.cancel(removeThread)
		end
		removeThread = task.delay(5, function()
			CodesMenu.TextLabel.Text = ""
		end)
	end
end)

