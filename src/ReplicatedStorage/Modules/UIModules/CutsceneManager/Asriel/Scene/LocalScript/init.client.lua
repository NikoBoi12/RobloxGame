local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background


local Speed = 25


local function Shake()
	local Pos = Scene.SoulCrack.Position

	local TotalTime = 0

	while TotalTime < 2 do
		local DeltaTime = task.wait()
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * 30) * 0.03)
		local BobbleY = math.abs(math.sin(os.clock() * 35) * 0.03) 
		Scene.SoulCrack.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	Scene.SoulCrack.Position = Pos
end


DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true

script.HopesAndDreams:Play()


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


task.wait(2)


for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end

task.wait(1)


script.StarCast:Play()

task.wait(1.7)

for i=1, 5 do
	local Sound = SFX.StarFire:Clone()
	Sound.Parent = script
	Sound:Destroy()
	task.wait(RandomObj:NextNumber(.5, 1))
end


script.HopesAndDreams:Pause()

Scene.DeathScreen.Visible = true

script.Crack:Play()
Scene.Soul.Visible = false
Scene.SoulCrack.Visible = true

task.wait(2)

Shake()

script.Crack:Play()
Scene.Soul.Visible = true
Scene.SoulCrack.Visible = false


DialogManager.TypeWriteLabel(CutsceneConfig.SpecialPacket[1])

SFX.ClosetImpact:Play()
script.HopesAndDreams:Pause()

task.wait(1)
local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.HopesAndDreams, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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