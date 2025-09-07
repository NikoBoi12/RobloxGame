local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TitleConfig = require(ReplicatedStorage.Configs:WaitForChild("TitleConfig"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))


TextChatService.OnIncomingMessage = function(Message)
	local Props = Instance.new("TextChatMessageProperties")

	local success, err = pcall(function()
		if Message.TextSource then
			local Player = Players:GetPlayerByUserId(Message.TextSource.UserId)
			local Data = PlayerData.GetData(Player)
			local Config = TitleConfig[Data.CurrentTitle]
			
			if Config then
				Props.PrefixText = "<font color='#"..Config.Color.."'>"..Config.Title.."</font> " .. Message.PrefixText
			end
			
			--if PlayerRank == 255 then
			--	Props.PrefixText = "<font color='#FFC0CB'>[Niko Ball Himself]</font> " .. Message.PrefixText
			--elseif PlayerRank == 254 then
			--	Props.PrefixText = "<font color='#815bf5'>[Chaotic Chaos Devil]</font> " .. Message.PrefixText
			--elseif PlayerRank == 244 then
			--	Props.PrefixText = "<font color='#FF9500'>[the solar]</font> " .. Message.PrefixText
			--elseif PlayerRank == 243 then
			--	Props.PrefixText = "<font color='#AA4A44'>[Mr. Danger]</font> " .. Message.PrefixText
			--elseif PlayerRank <= 242 and PlayerRank >= 223 then
			--	Props.PrefixText = "<font color='#0000FF'>[Developer]</font> " .. Message.PrefixText
			--elseif PlayerRank == 100 then
			--	Props.PrefixText = "<font color='#EABC25'>[Contributor]</font> " .. Message.PrefixText
			--elseif PlayerRank == 2 then
			--	Props.PrefixText = "<font color='#f07d12'>[Tester]</font> " .. Message.PrefixText
			--elseif Data and Data.VIPPass then
			--	Props.PrefixText = "<font color='#FFD700'>[VIP]</font> " .. Message.PrefixText
			--elseif Data and Data.Tips >= 250 then
			--	Props.PrefixText = "<font color='#FFC0CB'>[Donator]</font> " .. Message.PrefixText
			--elseif PlayerRank then
			--	Props.PrefixText = "<font color='#008000'>[Fallen Down]</font> " .. Message.PrefixText
			--end
		end
	end)

	if not success then
		warn("[Chat Prefix Error]:", err)
	end

	return Props
end

