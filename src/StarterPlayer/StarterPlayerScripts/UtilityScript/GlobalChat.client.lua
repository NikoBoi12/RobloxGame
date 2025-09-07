local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local TextChannels = TextChatService:WaitForChild("TextChannels")

local RollConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("RollConfig"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local ChatRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MessageSend")
local GiftedChatRemote = ReplicatedStorage.Remotes:WaitForChild("GiftedChat")
local LuckCircleMessage = ReplicatedStorage.Remotes:WaitForChild("LuckCircleMessage")
local GlobalTextMessage = ReplicatedStorage.Remotes:WaitForChild("GlobalTextMessage")

ChatRemote.OnClientEvent:Connect(function(Data)
	local Config = RollConfig[Data.AuraName]
	if not Config then return end
	
	local Message = Data.Player.." Just Rolled "..Data.AuraName.." (1 in "..(Config.Rarity or Config.RegionRarity or "Has no rarity")..")"
	
	TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#FF0000'>%s</font>", Message))
end)


GiftedChatRemote.OnClientEvent:Connect(function(Data)
	local Message = Data.Player.." Just Gifted "..Data.Pass.." To "..Data.GiftedPlayer.." Your awesome man :D"

	TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#00FF00'>%s</font>", Message))
end)


LuckCircleMessage.OnClientEvent:Connect(function(Modifier, Time, Name)
	local Data = PlayerData.GetData(LocalPlayer)
	local Message = "A "..(Modifier +1).."x luck circle just spawned! No way! It'll last for "..Time.." seconds!"
	
	local HasTrackerPass = Data.TrackerPass
	
	if HasTrackerPass then
		Message = "A "..(Modifier +1).."x luck circle just spawned! No way! It'll last for "..Time.." seconds! It spawned in "..Name
	end
	
	print("Sending Message")
	TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#0dff00'>%s</font>", Message))
end)

GlobalTextMessage.OnClientEvent:Connect(function(message)
	if typeof(message) == "string" then
		TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#aff7ab'>[Gerson]: %s</font>", message))
	end
end)