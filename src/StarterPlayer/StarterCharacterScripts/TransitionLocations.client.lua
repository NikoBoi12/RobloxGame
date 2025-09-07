local CollectionService = game:GetService("CollectionService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local AnimationUtility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AnimationUtility"))
local Transitions = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Transitions"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))

local LocalPlayer = PlayerService.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local Camera = game.Workspace.CurrentCamera

local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

local PlayerGui = LocalPlayer.PlayerGui
local ScreenEffects = PlayerGui:WaitForChild("ScreenEffects"):WaitForChild("Canvas")

local Data = PlayerData.GetData(LocalPlayer)
local tpRemote = ReplicatedStorage.Remotes.SolarRemotes.NikosTeleport

local function UseTransition(Prompt)
	for _, Prompt in CollectionService:GetTagged("Transition") do
		Prompt.Enabled = false
	end
	
	Data.Interaction = true
	
	print("ran")

	if Data.CurrentSong then
		Data.CurrentSong:Pause()
	end
	
	Utility.HideGui(LocalPlayer, {PlayerGui.Menus}, "TransitionSequence")
	
	Transitions[Prompt.TransitionType.Value](Character)
	
	tpRemote:FireServer(Prompt.TeleportObject.Value.CFrame)
	
	Utility.UnHideGui(LocalPlayer, {PlayerGui.Menus}, "TransitionSequence")

	if Data.CurrentSong then
		Data.CurrentSong:Play()
	end
	
	for _, Prompt in CollectionService:GetTagged("Transition") do
		Prompt.Enabled = true
	end
end


for _, Prompt in CollectionService:GetTagged("Transition") do
	Prompt.Triggered:Connect(function()
		UseTransition(Prompt)
	end)
end
CollectionService:GetInstanceAddedSignal("Transition"):Connect(function(Prompt)
	Prompt.Triggered:Connect(function()
		UseTransition(Prompt)
	end)
end)


AnimationUtility.Get(Character, 17836216322)
AnimationUtility.Get(Character, 17836249811)
