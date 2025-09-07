local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TextChatService = game:GetService("TextChatService")

local TextChannels = TextChatService:WaitForChild("TextChannels")
local Biomes = require(ReplicatedStorage.Configs.Biomes)

local Regions = CollectionService:GetTagged("Region")


local function CreateEvent(Region)
	Region:GetAttributeChangedSignal("CurrentBiome"):Connect(function()
		
		local CurrentBiome = Region:GetAttribute("CurrentBiome")
		if CurrentBiome ~= "Normal" then
			local Message = Biomes[Region.Name][CurrentBiome].ChatMessage
			if Message then
				local ChatMessage = "[BIOME] "..Message
				TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#FF0000'>%s</font>", ChatMessage))
			else
				local ChatMessage = "[BIOME] The owner needs to forgot to add a biome start message what a smelly guy (A biome has started in "..Region.Name..")"
				TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#FF0000'>%s</font>", ChatMessage))
			end
		else
			local ChatMessage = "[BIOME] "..Region.Name.." Seems to go back to normal"
			TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#FF0000'>%s</font>", ChatMessage))
		end
	end)
end

warn("Biome script ran")


for _, Region in Regions do
	CreateEvent(Region)
end


CollectionService:GetInstanceAddedSignal("Region"):Connect(CreateEvent)