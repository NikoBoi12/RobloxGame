local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RNG = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RNG"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local AnimationUtility = require(ReplicatedStorage.Modules:WaitForChild("AnimationUtility"))
local Dialog = require(ReplicatedStorage.Modules:WaitForChild("Dialog"))
local FrameData = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("FrameData"))
local UiManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("UI"))
local SpriteSheet = require(ReplicatedStorage.Modules.UIModules:WaitForChild("SpriteSheet"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local NPCAnims = require(script.Animations)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ShopUI = PlayerGui:WaitForChild("SpamtonTrades"):WaitForChild("Canvas")
local DialogUi = PlayerGui.SpamtonTrades:WaitForChild("Canvas2")

local SpamtonShop = workspace:WaitForChild("Maps"):WaitForChild("SpamtonsShop")
local Spamton = SpamtonShop:WaitForChild("SpamtonTradeShop"):WaitForChild("Spamton")
local PromptBlock = SpamtonShop.SpamtonTradeShop:WaitForChild("ShopPrompt")

local ShopAnalyticRemote = ReplicatedStorage.Remotes.AnalyticRemotes.ShopRemote

for _, ID in NPCAnims do
	AnimationUtility.Get(Spamton, ID)
end


AnimationUtility.Play(Spamton, NPCAnims.Sleeping)

local function StartTrade()
	PromptBlock.ProximityPrompt.Enabled = false

	ShopAnalyticRemote:FireServer("Opened Shop")

	AnimationUtility.Stop(Spamton, NPCAnims.Sleeping)
	local Track = AnimationUtility.Play(Spamton, NPCAnims.WakeUp)
	task.wait(.1)
	AnimationUtility.Play(Spamton, NPCAnims.WakeUpIdle)
	Track.Ended:Wait()
	
	UiManager.CraftingMenu:Show()
	
	DialogUi.DialogBox.Visible = true
	
	Dialog.TypeWriteLabel({
		Label = DialogUi.DialogBox.TextLabel,
		Dialog = "DON'T YOU WANNA BE A [BIG SHOT]?",
		Speed = .04,
		Persist = 1,
		SpeedAudio = script.SpamText
	})
	
	DialogUi.DialogBox.Visible = false
	
	ShopUI.Visible = true
end


PromptBlock.ProximityPrompt.Triggered:Connect(StartTrade)


local function StopTrade()
	UiManager.CraftingMenu:Hide()
	script.Select:Play()
	ShopUI.Visible = false
	AnimationUtility.Stop(Spamton, NPCAnims.CraftedItem)
	local Track = AnimationUtility.Get(Spamton, NPCAnims.WakeUp)
	Track:Play(0.100000001, 1, -1)
	task.wait(.1)
	AnimationUtility.Stop(Spamton, NPCAnims.WakeUpIdle)
	AnimationUtility.Play(Spamton, NPCAnims.Sleeping)
	Track.Ended:Wait()
	PromptBlock.ProximityPrompt.Enabled = true
	
end

ShopUI.Close.Activated:Connect(StopTrade)