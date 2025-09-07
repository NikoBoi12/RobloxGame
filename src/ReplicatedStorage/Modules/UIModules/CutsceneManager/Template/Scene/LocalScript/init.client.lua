local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background
local Gradient = Background.UIGradient


game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

--DialogManager.ScreenDisplay({
--	ParentGui = Cutscene.Dialog,
--	String = "Memories from the past begin to resurface.",
--	Yield = .05,
--	Persist = 2,
--	CustomLabel = script.ScreenDisplay,
--	Effects = {"Shake"},
--})

Scene.Visible = true

script.Music:Play()



--[[for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end]]


--SFX.ClosetImpact:Play()

--Scene.BlackOut.Visible = true

--task.wait(.6)

--Cutscene:Destroy()

--CutsceneManager.Finished:Fire()