local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local FrameData = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("FrameData"))
local SpriteSheetService = require(ReplicatedStorage.Modules.UIModules:WaitForChild("SpriteSheet"))
local CutsceneConfig = require(script:WaitForChild("Config"))

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

local function ApplyGravity()
	local Gravity = Vector2.new(0, 5)

	local Shards = {}

	for _, Shard in script.Shards:GetChildren() do
		local Shard = Shard:Clone()
		Shard.Visible = true
		
		Shard.ImageColor3 = Color3.new(1, 0, 0)

		Shard.Parent = Background
		Shards[Shard] = Vector2.new(RandomObj:NextNumber(-2,2), RandomObj:NextNumber(-3,1))
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




local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}
local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

local Goal2 = {
	Size = UDim2.fromScale(Scene.SoulCrack.Size.X.Scale * 1.2, Scene.SoulCrack.Size.Y.Scale * 1.2),
}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()
local Tween = TweenService:Create(Scene.SoulCrack, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal2)
Tween:Play()


task.wait(1)


Tween:Pause()
script.Crack:Play()
Scene.Soul.Visible = false
Scene.SoulCrack.Visible = true

task.wait(.5)

script.SoulShatter:Play()
Scene.SoulCrack.Visible = false
ApplyGravity()

script.Determination:Play()

TweenService:Create(Scene.GameOver, TweenInfo.new(1, Enum.EasingStyle.Linear), {ImageTransparency = 0}):Play()

task.wait(1)

for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end

TweenService:Create(Scene.GameOver, TweenInfo.new(1, Enum.EasingStyle.Linear), {ImageTransparency = 1}):Play()
TweenService:Create(script.Determination, TweenInfo.new(1, Enum.EasingStyle.Linear), {Volume = 0}):Play()


task.wait(1.5)


script.Saved:Play()

task.wait(1)
local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.Determination, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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