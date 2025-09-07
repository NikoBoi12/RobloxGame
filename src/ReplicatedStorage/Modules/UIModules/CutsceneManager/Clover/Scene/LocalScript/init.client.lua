local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local CutsceneManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))
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


local SetUpFrames = {}
local MidFrames = {}
local EndingFrames = {}

local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}


for i=1, 7 do
	table.insert(SetUpFrames, FrameConfig[Background.Clover.Image].Frames[i])
end

for i=8, 9 do
	table.insert(MidFrames, FrameConfig[Background.Clover.Image].Frames[i])
end

for i=10, 16 do
	table.insert(EndingFrames, FrameConfig[Background.Clover.Image].Frames[i])
end


for _, Packet in CutsceneConfig.DialogPackets.PartA do
	DialogManager.LetterDisplay(Packet)
end



local Sprite = SpriteSheetService.PlaySprite({
	Image = Background.Clover,
	Frames = SetUpFrames,
	FramesPerSecond = 8
})

Sprite.Completed.Event:Wait()


task.wait(1)
script.CockWeapon:Play()
task.wait(.4)
local Sprite = SpriteSheetService.PlaySprite({
	Image = Background.Clover,
	Frames = MidFrames,
	FramesPerSecond = 8
})

script.Shoot:Play()

Sprite.Completed.Event:Wait()

task.wait(.3)

Background.BloodySides.Visible = true

TweenService:Create(Background.BloodySides, TweenInfo.new(4, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.6}):Play()

task.wait(1)

local Sprite = SpriteSheetService.PlaySprite({
	Image = Background.Clover,
	Frames = EndingFrames,
	FramesPerSecond = 8
})

Sprite.Completed.Event:Wait()

task.wait(2)


SFX.ClosetImpact:Play()

Scene.BlackOut.Visible = true

task.wait(1.5)

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
--[[
	Background.GunShot.Visible = true
	
	local Sprite = SpriteSheetService.PlaySprite({
		Image = Background.GunShot,
		Frames = FrameConfig[Background.GunShot.Image].Frames,
		FramesPerSecond = 12,
	})
	Background.GunShot.Visible = false
]]