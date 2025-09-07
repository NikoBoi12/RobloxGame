local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")
local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")

local PlayerData = require(ReplicatedStorage.PlayerData)

FunnelSessionId = HttpService:GenerateGUID()

local AnalyticRemotes = ReplicatedStorage.Remotes.AnalyticRemotes

local Analytics = {}

function Analytics.LogRollAnalytics(Player)
	local Data = PlayerData.GetData(Player)

	if Data.Rolls == 1 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			1, -- Step number
			"Rolls 1" -- Step name
		)
	elseif Data.Rolls == 10 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			2, -- Step number
			"Rolls 10" -- Step name
		)
	elseif Data.Rolls == 50 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			3, -- Step number
			"Rolls 50" -- Step name
		)
	elseif Data.Rolls == 100 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			4, -- Step number
			"Rolls 100" -- Step name
		)
	elseif Data.Rolls == 500 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			5, -- Step number
			"Rolls 500" -- Step name
		)
	elseif Data.Rolls == 1000 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			6, -- Step number
			"Rolls 1000" -- Step name
		)
	elseif Data.Rolls == 2500 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			7, -- Step number
			"Rolls 2500" -- Step name
		)
	elseif Data.Rolls == 5000 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			8, -- Step number
			"Rolls 5000" -- Step name
		)
	elseif
		Data.Rolls == 10000 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			9,
			"Rolls 10000" -- Step name
		)
	elseif
		Data.Rolls == 25000 then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			10, -- Step number
			"Rolls 25000" -- Funnel name used to group steps together
		)
	end
end


function Analytics.Shop(Player, Step)
	if Step == "Opened Shop" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			1,
			"Opened Shop" -- Step name
		)
	elseif Step == "Seen Item" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			2,
			"Seen Gear" -- Step name
		)
	elseif Step == "Craft Item" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			3,
			"Crafted Gear" -- Step name
		)
	elseif Step == "Used Gear" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			4,
			"Equipped Gear" -- Step name
		)
	end
end


function Analytics.EquipAura(Player, Step)
	if Step == "Opened Index" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			1,
			"Opened Index" -- Step name
		)
	elseif Step == "Equipped Aura" then
		AnalyticsService:LogOnboardingFunnelStepEvent(
			Player,
			2,
			"Equipped Aura" -- Step name
		)
	end
end

if game:GetService("RunService"):IsServer() then
	AnalyticRemotes.ShopRemote.OnServerEvent:Connect(Analytics.Shop)
end

return Analytics
