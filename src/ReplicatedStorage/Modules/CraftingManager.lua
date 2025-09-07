local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CraftingConfig = require(ReplicatedStorage.Configs:WaitForChild("CraftingConfig"))
local PlayerData = require(ReplicatedStorage.PlayerData)

local CraftingModule = {}

function CraftingModule.CheckAndRemove(Player, ItemName)
	local Data = PlayerData.GetData(Player)
	if not Data then return end
	local Config = CraftingConfig[ItemName]
	
	for Name, ReqConfig in Config.Recipe do
		local DataType = Data[ReqConfig.Type]
		if not DataType then return end

		local Amount
		if DataType[Name] then
			Amount = DataType[Name]
		else
			Amount = CraftingModule.FindAmount(DataType, Name)
		end

		if Amount < ReqConfig.Amount then
			return true
		end
	end


	for Name, ReqConfig in Config.Recipe do
		local DataType = Data[ReqConfig.Type]

		if DataType[Name] then
			DataType[Name] -= ReqConfig.Amount
		else
			for i=1, ReqConfig.Amount do
				local FindValue = table.find(DataType.InternalData, Name)
				table.remove(DataType.InternalData, FindValue)
				Data[ReqConfig.Type].Changed:Fire(FindValue, nil, Name)
			end
		end
	end
end


function CraftingModule.FindAmount(Array, Value)
	local Amount = 0
	for _, v in Array do
		if v == Value then
			Amount += 1
		end
	end

	return Amount
end

return CraftingModule
