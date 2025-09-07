local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local ContentService = game:GetService("ContentProvider")

local RNG = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RNG"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local CutsceneManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("CutsceneManager"))
local RollConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("RollConfig"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local NotificationHandler = require(ReplicatedStorage.Modules:WaitForChild("NotificationHandler"))


local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RollDisplay = PlayerGui:WaitForChild("RollingInterface"):WaitForChild("Canvas"):WaitForChild("RollDisplay")
local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")

local IndexMenu = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas"):WaitForChild("Auras"):WaitForChild("Recent")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RollRemote = Remotes:WaitForChild("Rolling")
local ChangeVFXRemote = Remotes:WaitForChild("ChangeVFX")
local UpdateNewClient = Remotes:WaitForChild("UpdateNewClient")
local SettingsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SettingUpdate")

local RandomObj = Random.new()

local SFX = ReplicatedStorage:WaitForChild("Storage"):WaitForChild("SFX")

local SelectSound = script.Select

local Data = PlayerData.GetData(LocalPlayer)

local Debounce = false
local AutoRoll = false
local FastRoll = false

if not game:GetService("RunService"):IsStudio() then task.wait(12) end

local function CreateDisplayName(Head, Aura, Config)
	local TextConfig = Config.TextBox

	local TextBox = TextConfig.DisplayBox:Clone()

	for Index, Table in TextConfig.TextProperties do
		for Property, Value in Table do
			TextBox[Index][Property] = Value
		end
	end

	if TextBox.Title.Text == "AURA NAME HERE" then TextBox.Title.Text = Config.Name end
	
	if TextBox.Rarity.Text == "1 in N/A" then
		if Config.Rarity or Config.RegionRarity then
			TextBox.Rarity.Text = "1 in "..Config.Rarity or Config.RegionRarity
		else
			TextBox.Rarity.Text = Config.Phrase
		end
	end
	
	TextBox.Parent = Head
end


local function EquipVFX(Player, Aura, OldAura)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local HRP = Character:WaitForChild("Humanoid")
	local Head = Character:WaitForChild("Head")
	
	local Config = RollConfig[Aura]
	
	if not HRP then return end
	
	if OldAura then
		local OldConfig = RollConfig[OldAura]
		
		if OldConfig.Theme and Player == LocalPlayer then
			OldConfig.Theme:Pause()
		end
	end
	
	if Config.Theme and Player == LocalPlayer then
		Data.CurrentSong = Config.Theme
		Config.Theme:Play()
	end
	
	--CreateDisplayName(Head, Aura, Config)
end

ChangeVFXRemote.OnClientEvent:Connect(EquipVFX)


local Recieved = true

local function Roll(Bool, YieldRoll)
	if Bool and AutoRoll then return end
	if Debounce == true then return end
	SelectSound:Play()
	Debounce = true
	Recieved = false

	RollRemote:FireServer()
	HUD.Roll.ButtonActive.Visible = true
	HUD.Roll.ButtonInactive.Visible = false
	
	Data.ActiveEffect = true
	
	local TotalTime = 0
	
	while Recieved == false do
		local DeltaTime = task.wait()
		TotalTime += DeltaTime
		if TotalTime >= 4 then Debounce = false warn("Debounce failed") break end
	end
end

HUD.Roll.Activated:Connect(function()
	Roll(true)
end)


--HUD.Roll.Activated:Connect(function()
--	SelectSound:Play()
--	Roll(true)
--end)


local function AutoRollButton()
	SelectSound:Play()
	if AutoRoll then
		SettingsRemote:FireServer("Auto Roll", false)
		HUD.Auto.ButtonActive.Visible = false
		HUD.Auto.ButtonInactive.Visible = true
		AutoRoll = false
	else
		SettingsRemote:FireServer("Auto Roll", true)
		HUD.Auto.ButtonActive.Visible = true
		HUD.Auto.ButtonInactive.Visible = false
		AutoRoll = true
		Roll()
	end
end

HUD.Auto.Activated:Connect(AutoRollButton)


local function FastRollButton()
	script.Select:Play()
	if Data.FastRollPass then
		if FastRoll then
			SettingsRemote:FireServer("Fast Roll", false)
			FastRoll = false
			HUD.Fast.ButtonActive.Visible = false
			HUD.Fast.ButtonInactive.Visible = true
		else
			SettingsRemote:FireServer("Fast Roll", true)
			FastRoll = true
			HUD.Fast.ButtonActive.Visible = true
			HUD.Fast.ButtonInactive.Visible = false
		end
	else
		MarketplaceService:PromptGamePassPurchase(LocalPlayer, 835236182)
	end
end

HUD.Fast.Activated:Connect(FastRollButton)
	
	
local function ApplyGravity(RollName)
	local Config = RollConfig[RollName]
	
	local Gravity = Vector2.new(0, 5)
	
	local Shards = {}
	
	for _, Shard in ReplicatedStorage.Storage.Gui.Shards:GetChildren() do
		local Shard = Shard:Clone()
		Shard.Visible = true
		
		for Property, Value in Config.Soul do
			Shard[Property] = Value
		end
		
		Shard.Parent = RollDisplay
		Shards[Shard] = Vector2.new(RandomObj:NextNumber(-2,2), RandomObj:NextNumber(-2,1))
	end

	local TotalTime = 0

	while TotalTime < 3 do
		local Dt = task.wait()
		TotalTime += Dt
		for Shard, Velocity in Shards do
			Shards[Shard] += Gravity*Dt
			Shard.Position += UDim2.fromScale(Shards[Shard].X*Dt,Shards[Shard].Y*Dt)
		end
	end
	for Shard, Velocity in Shards do
		Shard:Destroy()
	end
end


local function CrackSoul(RollName, Bool)
	local Config = RollConfig[RollName]
	
	local Rarity = "1 in "..(Config.Rarity or Config.RegionRarity)
	local TempName = RollName
	
	if Bool then
		Rarity = "??????"
		TempName = "??????"
	end
	
	RollDisplay.Position = UDim2.fromScale(0, -.3)
	RollDisplay.Soul.RollName.Text = TempName
	RollDisplay.Soul.RollRarity.Text = Rarity
	
	for _, Gui in RollDisplay.Soul:GetChildren() do
		Gui.TextColor3 = Config.DisplayTextColor or Color3.fromRGB(0, 0, 0)
	end
	for _, Gui in RollDisplay.SoulBreak:GetChildren() do
		Gui.TextColor3 = Config.DisplayTextColor or Color3.fromRGB(0, 0, 0)
	end

	
	for Property, Value in Config.Soul do
		if Property == "Rotation" then
			for _, Gui in RollDisplay.Soul:GetChildren() do
				Gui[Property] = Value
			end
			for _, Gui in RollDisplay.SoulBreak:GetChildren() do
				Gui[Property] = Value
				if string.find(Gui.Name, 1) then
					Gui.TextXAlignment = Enum.TextXAlignment.Left
				else
					Gui.TextXAlignment = Enum.TextXAlignment.Right
				end
			end
		end
		RollDisplay.Soul[Property] = Value
		RollDisplay.SoulBreak[Property] = Value
	end
	
	RollDisplay.Soul.Visible = true

	local Goal = {}
	Goal.Position = UDim2.new(0, 0, 0, 0)
	local Tween = TweenService:Create(RollDisplay, TweenInfo.new(.2, Enum.EasingStyle.Linear), Goal)

	Tween:Play()
	Tween.Completed:Wait()

	RollDisplay.Soul.Visible = false
	
	do 
	
		local NameCharacters = string.split(TempName, "")
		local RarityCharacters = string.split(Rarity, "")
		
		local NameSplitLength = #NameCharacters/2
		local RaritySplitLength = #RarityCharacters/2
		local String1 = ""
		local String2 = ""
		local String3 = ""
		local String4 = ""

		if math.floor(NameSplitLength) ~= NameSplitLength then
			for i=1, #NameCharacters do
				local SetName = math.floor(NameSplitLength) + 1
				if i <= SetName then
					String1 = String1..NameCharacters[i]
				else
					String2 = String2..NameCharacters[i]
				end
			end
		else
			for i=1, #NameCharacters do
				if i <= NameSplitLength then
					String1 = String1..NameCharacters[i]
				else
					String2 = String2..NameCharacters[i]
				end
			end
		end
		
		if math.floor(RaritySplitLength) ~= RaritySplitLength then
			for i=1, #RarityCharacters do
				local SetName = math.floor(RaritySplitLength) + 1
				if i <= SetName then
					String3 = String3..RarityCharacters[i]
				else
					String4 = String4..RarityCharacters[i]
				end
			end
		else
			for i=1, #RarityCharacters do
				if i <= RaritySplitLength then
					String3 = String3..RarityCharacters[i]
				else
					String4 = String4..RarityCharacters[i]
				end
			end
		end
		
		if RollDisplay.SoulBreak.Rotation ~= 0 then
			RollDisplay.SoulBreak.Name1.Text = String2
			RollDisplay.SoulBreak.Name2.Text = String1
			RollDisplay.SoulBreak.Rarity1.Text = String4
			RollDisplay.SoulBreak.Rarity2.Text = String3
		else
			RollDisplay.SoulBreak.Name1.Text = String1
			RollDisplay.SoulBreak.Name2.Text = String2
			RollDisplay.SoulBreak.Rarity1.Text = String3
			RollDisplay.SoulBreak.Rarity2.Text = String4
		end
		
		
		
	end


	RollDisplay.SoulBreak.Visible = true
	RollDisplay.SoulCrack:Play()
end


local function TypeWriter()
	local Text = "* But it refused."

	for _, Character in Text:split("") do
		RollDisplay.DisplayText.Text = RollDisplay.DisplayText.Text..Character
		task.wait(.03)
	end
end


local function Shake()
	local Pos = RollDisplay.SoulBreak.Position

	local TotalTime = 0

	while TotalTime < .8 do
		local DeltaTime = task.wait()
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * 30) * 0.03)
		local BobbleY = math.abs(math.sin(os.clock() * 35) * 0.03) 
		RollDisplay.SoulBreak.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	RollDisplay.SoulBreak.Position = Pos
end


local function ShakeSoul()
	local Pos = RollDisplay.Soul.Position

	local TotalTime = 0

	while TotalTime < .5 do
		local DeltaTime = task.wait()
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * 30) * 0.03)
		local BobbleY = math.abs(math.sin(os.clock() * 35) * 0.03) 
		RollDisplay.Soul.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	RollDisplay.Soul.Position = Pos
end


local function TestRoll()
	local DisplayRolls = {}
	for i=1, 1 do
		local RandomRolls = RNG.CalculateRng(LocalPlayer, RollConfig)
		if not DisplayRolls[RandomRolls] then
			DisplayRolls[RandomRolls] = 1
		else
			DisplayRolls[RandomRolls] += 1
		end
	end
end


local LayoutOrder = 10000

local function DisplayRoll(RollName, IsNew)
	--TestRoll()
	--if true then return end
	
	if RollName == nil then return end
	local Config = RollConfig[RollName]
	--RngButtonsGui.RollButtons.Visible = false
	Recieved = true
	
	local Goal = {}
	Goal.Position = UDim2.new(0, 0, .4, 0)
	
	local RollList = {}
	
	if not FastRoll then
		for i=1, 3 do
			local RandomRolls = RNG.CalculateRng(LocalPlayer, RollConfig)
			table.insert(RollList, RandomRolls)
		end
	end
	
	for i, RollName in RollList do
		if RollDisplay.Soul.Rotation ~= 0 then
			for _, Gui in RollDisplay.Soul:GetChildren() do
				Gui.Rotation = 0
			end
			for _, Gui in RollDisplay.SoulBreak:GetChildren() do
				if string.find(Gui.Name, 1) then
					Gui.TextXAlignment = Enum.TextXAlignment.Right
				else
					Gui.TextXAlignment = Enum.TextXAlignment.Left
				end
				Gui.Rotation = 0
			end
			RollDisplay.Soul.Rotation = 0
			RollDisplay.SoulBreak.Rotation = 0
		end
		CrackSoul(RollName)
		task.wait(.4)
		RollDisplay.SoulBreak.Visible = false

		task.defer(function()
			ApplyGravity(RollName)
		end)

		RollDisplay.SoulShatter:Play()
		
		task.wait(.2)
	end
	
	local PlayCutscene = Config.Cutscene or (Config.Rarity or Config.RegionRarity or 0) >= 15000 and "Default"
	
	if Data["Skip Cutscene"] then
		PlayCutscene = nil
	end

	CrackSoul(RollName, PlayCutscene)
	Shake()
	

	
	if PlayCutscene then
		CutsceneManager.StartScene(PlayCutscene)
		CutsceneManager.Finished.Event:Wait()
		RollDisplay.Soul.RollName.Text = RollName
		RollDisplay.Soul.RollRarity.Text = "1 in "..(Config.Rarity or Config.RegionRarity)
		RollDisplay.SoulBreak.Visible = false
		RollDisplay.Soul.Visible = true
		RollDisplay.DisplayText.Visible = true
		task.defer(function()
			ShakeSoul()
		end)
		task.wait(.8)
	else

	end
	
	RollDisplay.SoulCrack:Play()
	RollDisplay.SoulBreak.Visible = false
	RollDisplay.Soul.Visible = true
	RollDisplay.DisplayText.Visible = true
	
	TypeWriter()
	
	script["Undertale- Victory"]:Play()
	
	task.wait(.7)
	RollDisplay.DisplayText.Text = ""

	RollDisplay.Soul.Visible = false


	Data.ActiveEffect = false

	HUD.Roll.ButtonActive.Visible = false
	HUD.Roll.ButtonInactive.Visible = true

	HUD.Roll.Cooldown.Size = UDim2.fromScale(1,1)
	
	--NotificationHandler.CreateNotification("Aura Obtained", ("You obtained: "..RollName), 6)
	
	local Tween = TweenService:Create(HUD.Roll.Cooldown, TweenInfo.new(1+Data.CooldownReduction, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(0, 1)})
	Tween:Play()
	Tween.Completed:Wait()
	
	task.defer(function()
		local RecentlyEarnedAura = script.Aura:Clone()

		RecentlyEarnedAura.AuraName.Text = Config.Name
		RecentlyEarnedAura.Parent = IndexMenu.Auras
		RecentlyEarnedAura.LayoutOrder = LayoutOrder

		LayoutOrder -= 1

		local Children = IndexMenu.Auras:GetChildren()

		if #Children > 11 then
			if not Children[2]:IsA("UIGridLayout") then
				Children[2]:Destroy()
			end
		end
	end)

	
	Debounce = false
	if AutoRoll then Roll(nil, true) end --6.25 without fast roll 3.85 Seconds with fast roll
end


RollRemote.OnClientEvent:Connect(DisplayRoll)


if Data["Fast Roll"] then
	HUD.Fast.ButtonActive.Visible = true
	HUD.Fast.ButtonInactive.Visible = false
	FastRoll = true
end

if Data["Auto Roll"] then
	HUD.Auto.ButtonActive.Visible = true
	HUD.Auto.ButtonInactive.Visible = false
	AutoRoll = true
	Roll()
end



