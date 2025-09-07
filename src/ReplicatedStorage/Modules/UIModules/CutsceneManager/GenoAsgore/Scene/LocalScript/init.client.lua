local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))
local Utility = require(ReplicatedStorage.Modules:WaitForChild("Utility"))

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background
local Gradient = Background.UIGradient

local Amount = 15

DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true

script.GenoAsgoreIntro:Play()

Background.LocalScript.Enabled = true

local OriginalGoal = {Offset = Vector2.new(0, .55)}

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), OriginalGoal):Play()

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()

local Info = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

script.Particle.LocalScript.Enabled = true

local Bool = true
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

task.defer(function()
	while Bool do
		task.wait(.1)
		for i=1, 2 do
			GuiEffects.CreateFlameParticle(script.Particle, Scene, Info)
		end
	end
end)


task.wait(1)

for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end


SFX.FloweyLaugh:Play()

task.wait(2.8)

local Points = Utility.GeneratePointsOnCircle(Amount, Vector3.new(.5, .5), .3)


local Pellets = {}


task.defer(function()
	while true do
		task.wait(.1)
		for _, Pellet in Pellets do
			Pellet.Rotation += 90
		end
	end
end)


for i=1, Amount do
	task.wait(.05)
	local Pellet = script.Pellet:Clone()
	Pellet.Position = Points[i]
	Pellet.Parent = Scene.PelletBox
	table.insert(Pellets, Pellet)
end


for _, Pellet in Pellets do
	local Tween = TweenService:Create(Pellet, TweenInfo.new(7, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(.5, .5)})
	Tween:Play()
end

task.wait(3)

Scene.BlackOut.Visible = true

task.wait(.5)

script.Crack:Play()

task.wait(.9)

script.SoulShatter:Play()

task.wait(2)

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