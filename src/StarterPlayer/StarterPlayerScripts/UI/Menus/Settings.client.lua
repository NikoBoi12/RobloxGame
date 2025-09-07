local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local SettingsConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("SettingsConfig"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SettingsRemote = Remotes:WaitForChild("SettingUpdate")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InventoryGui = Menus:WaitForChild("Settings")

local Data = PlayerData.GetData(LocalPlayer)

task.wait(12)

local function CreatePacket(ActiveStatus)
	return {
		Humanoid = LocalPlayer.Character:WaitForChild("Humanoid"),
		Status = ActiveStatus,
	}
end

for SettingName, Table in SettingsConfig do
	local Setting = script[Table.Type]:Clone()
	
	if Table.Type == "PassBool" or Table.Type == "Bool" then Setting.Button.TextLabel.Text = Data[SettingName] and "X" or "" end
	Setting.SettingName.Text = SettingName
	Setting.Parent = InventoryGui.Frame
	
	if Table.Effect then
		Table.Effect(CreatePacket(Data[SettingName]))
	end
	
	Setting.Button.Activated:Connect(function()
		script.Select:Play()
		
		if Table.Type == "Bool" then
			if Table.Pass then
				if not Data[SettingName.."Pass"] then
					MarketplaceService:PromptGamePassPurchase(LocalPlayer, Table.Pass)
					return
				end
			end
			if Data[SettingName] then
				Data[SettingName] = false
			else
				Data[SettingName] = true
			end

			
			SettingsRemote:FireServer(SettingName, Data[SettingName])
			Setting.Button.TextLabel.Text = Data[SettingName] and "X" or ""
			
			if Table.Effect then
				Table.Effect(CreatePacket(Data[SettingName]))
			end
		end
	end)
end