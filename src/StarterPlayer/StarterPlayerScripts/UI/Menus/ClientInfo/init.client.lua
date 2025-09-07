local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrentTime = os.time()

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local RollConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("RollConfig"))
local DataManager = require(ReplicatedStorage.Modules.RNGManagers.DataManager)
local StatConfig = require(script:WaitForChild("StatInfo"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")
local AreaLuck = HUD:WaitForChild("AreaLuck")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InfoGui = Menus:WaitForChild("Info")
local ClientUi = InfoGui:WaitForChild("ClientInfo")
local StatGui = script:WaitForChild("Stat")
local FragGui = script:WaitForChild("Fragments")

local Data = PlayerData.GetData(LocalPlayer)


local function SetProperties(Gui, Properties)
	if Properties then
		for Property, Value in Properties do
			Gui[Property] = Value
		end
	end
end


local function CreateFragDisplay(Index, Value)
	local Fragment = FragGui:Clone()
	Fragment.Name = Index
	Fragment.Amount.Text = Value
	Fragment.FragName.Text = Index
	Fragment.Parent = ClientUi.DisplayFrags
end


for Index, Value in Data do
	local Config = StatConfig.DataUpdate[Index]
	if Config then
		local Stat = StatGui:Clone()
		Stat.Name = Index
		Stat.Description.Text = (Config.Start or "")..Value..(Config.End or "")

		SetProperties(Stat, Config.Properties)

		Stat.Parent = ClientUi.Stats
	end
end


for Name, TableValue in StatConfig.CustomUpdate do
	local Stat = StatGui:Clone()
	Stat.Name = Name
	Stat.Description.Text = (TableValue.Start or "")..TableValue.DefaultValue..(TableValue.End or "")

	SetProperties(Stat, TableValue.Properties)

	Stat.Parent = ClientUi.Stats
end


for Index, Value in Data.Fragments do
	CreateFragDisplay(Index, Value)
end


local function UpdateLuck(Index, Value)
	local Config = StatConfig.DataUpdate[Index]
	if Config then
		ClientUi.Stats[Index].Description.Text = Config.Start..Value..Config.End
	end
	
	local PremiumLuck = 0
	
	if LocalPlayer.MembershipType == Enum.MembershipType.Premium then
		PremiumLuck = .1
	end

	if Index == "Luck" or Index == "Mult" then
		local LuckDisplay = ClientUi.Stats.Luck

		LuckDisplay.Description.Text = StatConfig.CustomUpdate.Luck.Start..DataManager.GetLuck(LocalPlayer)
	end
end

Data.Changed:Connect(UpdateLuck)

UpdateLuck("GearLuck", 1)


Data.Fragments.Changed:Connect(function(Index, Value)
	local FragDisplay = ClientUi.DisplayFrags:FindFirstChild(Index)
	if FragDisplay then
		FragDisplay.Amount.Text = Value
	else
		CreateFragDisplay(Index, Value)
	end
end)


while true do
	local Time = os.time() - CurrentTime
	CurrentTime = os.time()
	Data.PlayTime += Time
	ClientUi:WaitForChild("Stats"):WaitForChild("PlayTime"):WaitForChild("Description").Text = StatConfig.CustomUpdate.PlayTime.Start..Utility.ConvertSeconds(Data.PlayTime)
	task.wait(1)
end