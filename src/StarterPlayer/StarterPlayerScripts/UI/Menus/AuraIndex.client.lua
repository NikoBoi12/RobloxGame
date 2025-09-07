local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local RollConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("RollConfig"))
local AnimationUtility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AnimationUtility"))
local ConfigAnimations = require(ReplicatedStorage.Configs:WaitForChild("AnimationConfig"))
local Utility = require(ReplicatedStorage.Modules:WaitForChild("Utility"))
local CutsceneManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("CutsceneManager"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local AuraGui = Menus:WaitForChild("Auras")
local AuraCount = AuraGui.AuraLists.AuraCount or AuraGui.AuraLists:WaitForChild("AuraCount") -- Zeros Code Reminder

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChangeVFXRemote = Remotes:WaitForChild("ChangeVFX")
local AuraIndexAnalytic = Remotes.AnalyticRemotes.AuraIndexAnalytic

local Data = PlayerData.GetData(LocalPlayer)

local NewOrder = {}
local NameOrder = {}

local NumberOfAuras = {}
local OwnedAuras = {}

local Connections = {}

local SelectedAura = nil


AuraCount.Text = (#Data.Index .. "/" .. #RollConfig.RollableAuras)



for _, Value in RollConfig.OrderedIndex do
	local AuraName = Value.AuraName
	if RollConfig[AuraName].Unobtainable then
		if Data.Index then
			if not table.find(Data.Index.InternalData, AuraName) then
				continue
			end
		end
	end

	table.insert(NewOrder, AuraName)
end

if not game:GetService("RunService"):IsStudio() then task.wait(12) end


local function Reset()
	for _, Connection in Connections do
		Connection:Disconnect()
	end
	Connections = {}
	if SelectedAura then
		SelectedAura.Soul.Visible = false
		SelectedAura = nil
	end
	
	AuraGui.Options.Equip.Visible = false
	AuraGui.Options.Cutscene.Visible = false
	AuraGui.Display.Rarity.TextLabel.Text = ""
	AuraGui.Display.AuraTitle.TextLabel.Text = ""
end


local CurrentlyLoadingAura


local function StartAnimations(Aura)
	task.defer(function()
		local AnimationConfig = RollConfig[Aura].Animation
		local Character = LocalPlayer.Character
		
		CurrentlyLoadingAura = Aura
		
		AnimationUtility.StopAllTracks(Character)

		if AnimationConfig.OverrideMovment then
			local AnimationTable = Utility.Copy(ConfigAnimations.Default.OverrideMovment)
			for AnimationName, Animation in AnimationConfig.OverrideMovment do
				if AnimationTable[AnimationName] then
					AnimationTable[AnimationName] = Animation
				end
			end
			AnimationUtility.SetDefaultAnimations(Character, AnimationTable)
		end

		if AnimationConfig.StaticAnimations then
			local CurrentLoad = Aura
			for _, Table in AnimationConfig.StaticAnimations do
				if CurrentlyLoadingAura ~= CurrentLoad then break end
				AnimationUtility.Play(Character, Table[1])
				task.wait(Table[2])
			end
		end

		CurrentlyLoadingAura = nil
	end)
end

local function AddAura(Index, Value)
	local Config = RollConfig[Value]
	
	if not Config then warn(Value.." Config Not Found") return end

	local FindPos = table.find(NewOrder, Value)

	local AuraDisplay = script.Aura:Clone()
	AuraDisplay.Name = Value
	AuraDisplay.LayoutOrder = FindPos
	AuraDisplay.AuraName.Text = Config.Name
	AuraDisplay.Parent = AuraGui.AuraLists.Auras
	
	local Button = AuraDisplay.Button
	
	Button.Activated:Connect(function()
		if SelectedAura then 
			SelectedAura.Soul.Visible = false
			if SelectedAura == AuraDisplay then
				Reset()
				return
			end
		end
		
		if not Data.OpenedIndexAnalytic then
			AuraIndexAnalytic:FireServer("Opened Index")
			Data.OpenedIndexAnalytic = true
		end
		
		if AuraDisplay.Name == Data.CurrentEffect then AuraGui.Options.Equip.TextLabel.Text = "Equipped" else AuraGui.Options.Equip.TextLabel.Text = "Equip" end
		
		script.Select:Play()
		
		AuraGui.Options.Equip.Visible = true
		
		if Config.Cutscene then
			AuraGui.Options.Cutscene.Visible = true
		else
			AuraGui.Options.Cutscene.Visible = false
		end
		
		AuraGui.Display.AuraTitle.TextLabel.Text = Config.Name
		AuraGui.Display.Rarity.TextLabel.Text = Config.Rarity and "1 in "..Config.Rarity or 
			Config.RegionRarity and "1 in "..Config.RegionRarity or 
			Config.Phrase or 
			""
		SelectedAura = AuraDisplay
		AuraDisplay.Soul.Visible = true
	end)
end

local SortOptions = {
	RollConfig.OrderedIndex,
	RollConfig.HighestToLowest,
	RollConfig.Newest,
	RollConfig.Oldest
}

local CurrentSelection = 1

local function SortUI()
	CurrentSelection += 1
	if CurrentSelection > #SortOptions then
		CurrentSelection = 1
	end
	
	for _, Gui in AuraGui.AuraLists.Auras:GetChildren() do
		if not RollConfig[Gui.Name] then continue end
		
		local Position = nil
		
		for i, Config in SortOptions[CurrentSelection] do
			if Config.AuraName == Gui.Name then
				Position = i
				break
			end			
		end
		
		Gui.LayoutOrder = Position
	end
end

AuraGui.AuraLists.Sort.Activated:Connect(SortUI)

Data.Index.Changed:Connect(AddAura)
Data.Index.Changed:Connect(function()
	AuraCount.Text = (#Data.Index .. "/" .. #RollConfig.RollableAuras)
end)



local function EquipAura()
	if not SelectedAura then return end
	if SelectedAura.Name == Data.CurrentEffect then return end
	script.Select:Play()
	ChangeVFXRemote:FireServer(SelectedAura.Name)
	StartAnimations(SelectedAura.Name)
	Reset()
end


AuraGui:WaitForChild("Options"):WaitForChild("Equip").Activated:Connect(EquipAura)


local function PlayCutscene()
	if not SelectedAura then return end
	local Config = RollConfig[SelectedAura.Name]
	if not Config.Cutscene then return end

	script.Select:Play()

	CutsceneManager.StartScene(Config.Cutscene)
end

AuraGui.Options:WaitForChild("Cutscene").Activated:Connect(PlayCutscene)


local function CharacterAdded(Characer)
	if Data.CurrentEffect then
		if RollConfig[Data.CurrentEffect] then
			ChangeVFXRemote:FireServer(Data.CurrentEffect, true)
			StartAnimations(Data.CurrentEffect)
		end
	end
end

LocalPlayer.CharacterAdded:Connect(CharacterAdded)

if LocalPlayer.Character then
	CharacterAdded(LocalPlayer.Character)
end


for i, Aura in Data.Index do
	AddAura(i, Aura)
end

AuraGui:GetPropertyChangedSignal("Visible"):Connect(function()
	Reset()
end)