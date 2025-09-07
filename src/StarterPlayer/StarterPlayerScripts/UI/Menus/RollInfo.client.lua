local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrentTime = os.time()

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local RollConfig = require(ReplicatedStorage:WaitForChild("Configs").RollConfig)
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local RNG = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RNG2.0"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")
local AreaLuck = HUD:WaitForChild("AreaLuck")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InfoGui = Menus:WaitForChild("Info")
local RollUi = InfoGui:WaitForChild("RollInfo")
local RollableDisplay = script:WaitForChild("RollableDisplay")

local Data = PlayerData.GetData(LocalPlayer)



local function CreateDisplay()
	local Fragment = RollableDisplay:Clone()
	Fragment.Parent = RollUi.DisplayRollable
	
	return Fragment
end


local function ClearTable()
	for _, Gui in RollUi.DisplayRollable:GetChildren() do
		if Gui:IsA("Frame") then
			Gui:Destroy()
		end
	end
end


local function CreateTable()
	local RollConfig = Utility.Copy(RollConfig)
	
	local Rollable = RNG.CheckForEffects(LocalPlayer, RollConfig)
	
	RollUi.RollableAuras.Text = "Rollable Auras: "..#Rollable
	
	for _, RollingTable in Rollable do
		if RollingTable.Rarity then
			local RollConfig = RollConfig[RollingTable.AuraName]

			local Frame = CreateDisplay()
			
			if table.find(Data.Index.InternalData, RollingTable.AuraName) then
				Frame.AuraName.Text = RollConfig.Name
				Frame.Rarity.Text = "1 in "..math.floor(RollingTable.Rarity)
			else
				Frame.AuraName.Text = "?????????"
				Frame.Rarity.Text = "1 in ?????????"
			end
			
			
			
		end
	end
end


RollUi.Refresh.Activated:Connect(function()
	ClearTable()
	CreateTable()
end)