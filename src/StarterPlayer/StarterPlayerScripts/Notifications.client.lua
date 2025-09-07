local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SendNotifRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SendNotification")

local Data = PlayerData.GetData(LocalPlayer)


local function Notification(Index, Value)
	if Value then
		local NewNotification = script.Notification:Clone()
		NewNotification.Text = "+"..Value
		NewNotification.Parent = PlayerGui.RNG.Frame.Notification
		
		task.wait(5)
		NewNotification:Destroy()
	end
end

Data.Inventory.Changed:Connect(Notification)
Data.Equipment.Changed:Connect(Notification)


SendNotifRemote.OnClientEvent:Connect(function(Display)
	local NewNotification = script.FullNotif:Clone()
	NewNotification.Text = "Your "..Display.." is full"
	NewNotification.Parent = PlayerGui.RNG.Frame.Notification
	task.wait(5)
	NewNotification:Destroy()
end)


