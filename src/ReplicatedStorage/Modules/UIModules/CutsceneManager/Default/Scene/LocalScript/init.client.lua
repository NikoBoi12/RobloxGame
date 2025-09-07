local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("RandomScene"))

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background
local Gradient = Background.UIGradient


DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})


local RandomNum = RandomObj:NextInteger(1, #CutsceneConfig)

local RandomConfig = CutsceneConfig[RandomNum]

Scene.Visible = true

RandomConfig.Music:Play()

local function RandomizeSoulColor()
	local Red = math.random(0,255)
	local Green = math.random(0,255)
	local Blue = math.random(0,255)
	
	Scene.Soul.ImageColor3 = Color3.fromRGB(Red, Green, Blue)
	Scene.SoulCrack.ImageColor3 = Color3.fromRGB(Red, Green, Blue)
end

RandomizeSoulColor()

if RandomConfig.GradColors then Gradient.Color = RandomConfig.GradColors end
if RandomConfig.ParticleColorShift then script.Particle.BackgroundColor3 = RandomConfig.ParticleColorShift[1] end

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, .55)}):Play()

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

local Goal2 = {
	Size = UDim2.fromScale(Scene.SoulCrack.Size.X.Scale * 1.2, Scene.SoulCrack.Size.Y.Scale * 1.2),
}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()
local Tween = TweenService:Create(Scene.SoulCrack, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal2)
Tween:Play()

local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

local Info = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local GoalAdditions = {BackgroundColor3 = RandomConfig.ParticleColorShift[2] or Color3.fromRGB(0, 0, 0)}

task.defer(function()
	while true do
		task.wait(.1)

		for i=1, 2 do
			task.wait()
			GuiEffects.CreateFlameParticle(script.Particle, Background, Info, GoalAdditions)
		end
	end
end)


task.wait(3)


for _, Packet in RandomConfig.Dialog do
	DialogManager.TypeWriteLabel(Packet)
end

local Tween = TweenService:Create(RandomConfig.Music, TweenInfo.new(1.5), {Volume = 0})
Tween:Play()
Tween.Completed:Wait()

script.Crack:Play()
Scene.Soul.Visible = false
Scene.SoulCrack.Visible = true

task.wait(.2)

SFX.ClosetImpact:Play()

Scene.BlackOut.Visible = true

task.wait(.6)

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