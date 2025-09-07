local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

local DialogModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local Utility = require(ReplicatedStorage.Modules:WaitForChild("Utility"))
local AnimationUtility = require(ReplicatedStorage.Modules:WaitForChild("AnimationUtility"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UpdateBage = Remotes:WaitForChild("BadgeManager")

local Debounce = false
local Cooldown = 5

local UseEffect = {}

local Dialog = {
	"You are lost...",
	"You feel like your being watched...",
	"Hello...?",
	"Where am I...?",
	"Is anyone there..?",
	"...",
	"Help me...",
	"Help me Help me Help me Help me Help me", 
}

function UseEffect.SetUp()
	
end


function UseEffect.Use(self)
	local Chance = math.random(1, 100)
	--local Chance = 1
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end
	
	if Debounce then return end
	if Data.Interation then return end

	Debounce = true
	
	if Chance <= 5 then
		UseEffect.StartSecret(self)
	else
		UseEffect.Norm(self)
	end
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.Norm(self)
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end
	
	local PlayerGui = self.Owner.PlayerGui
	local ScreenEffects = PlayerGui.ScreenEffects.Canvas
	
	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = Dialog[math.random(1, #Dialog)],
		Yield = .15,
		Persist = 2,
		Effects = {},
	})
end

local tpRemote = ReplicatedStorage.Remotes.SolarRemotes.NikosTeleport
function UseEffect.StartSecret(self)
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end

	Data.ActiveVoid = true
	local MusicGroupList = {}
	
	for i, v in ReplicatedStorage.Configs.SoundConfig:GetChildren() do
		if v.Volume ~= 0 then
			table.insert(MusicGroupList, v)
			v.Volume = 0
		end
	end

	script.HonestDaysWork:Play()
	
	local PlayerGui = self.Owner.PlayerGui
	local ScreenEffects = PlayerGui.ScreenEffects.Canvas
	
	local Character = self.Owner.Character
	local HRP = Character.HumanoidRootPart
	
	local WalkSpeed = Character.Humanoid.WalkSpeed
	
	Character.Humanoid.WalkSpeed = 0
	AnimationUtility.Play(Character, 18461192174)
	
	tpRemote:FireServer("Void")--workspace.Maps.Void1.Spawn.CFrame)
	
	for i, v in Character.HumanoidRootPart:GetChildren() do
		if CollectionService:HasTag(v, "Display") then
			v.Enabled = false
		end
	end
	
	local GuiList = {}
	
	local NewDisplay = script.HELP:Clone()
	
	for _, Gui in PlayerGui:GetChildren() do
		if Gui.Name == "ScreenEffects" then continue end
		table.insert(GuiList, Gui)
	end
	
	
	UpdateBage:FireServer("MeetHim")
	
	for i, v in NewDisplay:GetDescendants() do
		if v:IsA("Script") then
			v.Enabled = true
		end
	end
	
	NewDisplay.Parent = Character.Head
	
	Utility.HideGui(self.Owner, GuiList, "InTheVoid")
	
	ScreenEffects.StaticOverlay.Playing = true
	ScreenEffects.StaticOverlay.Visible = true
	ScreenEffects.DarkenSides.Visible = true
	
	
	task.wait(1)

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "THIS IS INTERESTING.",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})
	

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "MY READING ARE OFF THE CHARTS.",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "YET THE TIMELINE SEEMS TO BE FRACTURED.",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	}) 

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "THATS YOUR FAULT... ISN'T IT?",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "I WONDER HOW YOU DO IT.",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "HAVE SUCH POWER YET...",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})
	

	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "SO LITTLE COMPASSION.",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})
	
	
	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "I'M SURE WE'LL MEET AGAIN",
		Yield = .15,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})
	
	DialogModule.ScreenDisplay({
		ParentGui = ScreenEffects.TextDisplay.DialogA,
		String = "AND WHEN WE DO... WE WILL BEGIN OUR     GAME.",
		Yield = .1,
		Persist = 2,
		Effects = {"Shake", "GlitchFont"},
		RanSpeech = script.Txt:GetChildren()
	})
	
	for i, v in MusicGroupList do
		v.Volume = .5
	end
	
	for i, v in Character.HumanoidRootPart:GetChildren() do
		if CollectionService:HasTag(v, "Display") then
			v.Enabled = true
		end
	end
	
	AnimationUtility.Stop(Character, 18461192174)
	Character.Humanoid.WalkSpeed = WalkSpeed
	
	script.HonestDaysWork:Pause()
	
	NewDisplay:Destroy()

	ScreenEffects.StaticOverlay.Playing = false
	ScreenEffects.StaticOverlay.Visible = false
	ScreenEffects.DarkenSides.Visible = false
	
	Utility.UnHideGui(self.Owner, GuiList, "InTheVoid")
	
	tpRemote:FireServer("SchoolA")--workspace.Maps.School.SpawnA.CFrame)
	

	
	task.wait(Cooldown)
	Debounce = false
end


return UseEffect
