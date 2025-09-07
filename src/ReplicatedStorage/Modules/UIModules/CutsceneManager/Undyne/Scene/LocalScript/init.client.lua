local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local CutsceneManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))
local BodyConfig = require(script:WaitForChild("BodyConfig"))
local GuiEffects = require(ReplicatedStorage.Modules.UIModules.GuiEffects)
local SpriteSheetService = require(ReplicatedStorage.Modules.UIModules.SpriteSheet)
local FrameConfig = require(ReplicatedStorage.Configs.FrameData)

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background

DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true

KillLoop = GuiEffects.ShakeInfinite({
	BobbleX = {Min = 3, Max = 4, Min2= .0015, Max2 = .002},
	BobbleY = {Min = 3, Max = 5, Min2= .0015, Max2 = .002},
	Gui = Background.Undyne
})

for _, Packet in CutsceneConfig.DialogPackets.PartA do
	SpriteSheetService.SetFrame(Packet.Face, Background.Undyne)
	DialogManager.TypeWriteLabel(Packet)
end

for _, Packet in CutsceneConfig.DialogPackets.PartB do
	SpriteSheetService.SetFrame(Packet.Face, Background.Undyne)
	DialogManager.LetterDisplay(Packet)
end

KillLoop.KillLoop = true

for _, Packet in CutsceneConfig.DialogPackets.PartC do
	SpriteSheetService.SetFrame(Packet.Face, Background.Undyne)
	DialogManager.LetterDisplay(Packet)
end
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

task.wait(1.3)

local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

Tween:Play()
Tween.Completed:Wait()

task.wait(.5)

ContentProvider:PreloadAsync(Backbackground)

Backbackground[1].ImageTransparency = 0
Backbackground[2].ImageTransparency = 0

task.wait()
script.Break1:Play()

GuiEffects.Shake({
	BobbleX = {Min = 100, Max = 250, Min2= .1, Max2 = .2},
	BobbleY = {Min = 100, Max = 250, Min2= .1, Max2 = .2},
	Length = .1,
	Gui = Cutscene.WhiteOut.BrackBackground
})

task.wait(.2)

Cutscene.WhiteOut.BackgroundTransparency = 1

task.wait(1)

script.Break2:Play()
Scene.Visible = false

TweenService:Create(Backbackground[1], TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
	Position = UDim2.fromScale(-.6, 0)
}):Play()

TweenService:Create(Backbackground[2], TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
	Position = UDim2.fromScale(.6, 0)
}):Play()


task.wait(1.5)

Cutscene:Destroy()

CutsceneManager.Finished:Fire()