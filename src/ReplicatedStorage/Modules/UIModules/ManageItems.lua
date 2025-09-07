local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")


local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local ItemConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("ItemConfig"))
local Timer = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Timer"))
local BuffManager = require(ReplicatedStorage.Modules.RNGManagers.BuffManager)
local QuestEvents = require(ReplicatedStorage.Configs.Quests.QuestEvents)


local Item = {}


function Item.StartBuff(Player, ItemName, Amount)
	local Data = PlayerData.GetData(Player)	
	if not Data then return end
	local Config = ItemConfig[ItemName]
	local BuffConfig = require(Config.Buffs)[ItemName]
	local BuffData = Data.ItemBuffs[ItemName]

	if not BuffData then
		local Buff = BuffManager.NewBuff(Player, {
			BuffName = ItemName,
			Config = Config.Buffs,
			StartProgress = BuffConfig.BuffLength * Amount,
		})

		Buff:StartBuff()
	else
		local Buff = BuffManager.List[BuffData.UID]

		Buff:AddProgress(BuffConfig.BuffLength * Amount)
	end
end


function Item.UseItem(Player, ItemName: string, Amount: number)
	local Config = ItemConfig[ItemName]
	if not Config then warn("No Config Found") return end
	if Amount < 0 then return end
	
	local Data = PlayerData.GetData(Player)
	if not Data then return end
	
	local ItemData = Data.Items[ItemName]
	if ItemData and ItemData >= Amount then
		if RunService:IsClient() then
			script.Consume:FireServer(ItemName, Amount)
		else
			Item.StartBuff(Player, ItemName, Amount)
			
			QuestEvents.UserUsedItem:Fire(Player, ItemName, Amount)
			
			if Data.Items[ItemName] - Amount <= 0 then
				Data.Items[ItemName] = nil
			else
				Data.Items[ItemName] -= Amount
			end
		end
	end
end


if RunService:IsServer() then
	script.Consume.OnServerEvent:Connect(Item.UseItem)
else
	
end

return Item
