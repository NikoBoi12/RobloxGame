local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))
local SpriteSheetService = require(ReplicatedStorage.Modules.UIModules.SpriteSheet)
local FrameConfig = require(ReplicatedStorage.Configs.FrameData)

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

Scene.Visible = true

script.Memory:Play()

local ParticleSpawn = UDim2.fromScale(-.1, -.1)

local Active = true

local TableFlowers = {}
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

task.defer(function()
	while Active do
		task.wait(.3)

		local Flower = script.Flower:Clone()
		Flower.Position = ParticleSpawn
		Flower.Parent = Background
		
		local Tween = TweenService:Create(Flower, TweenInfo.new(RandomObj:NextNumber(40, 50)), {Rotation = RandomObj:NextNumber(0, 360), Position = UDim2.fromScale(RandomObj:NextNumber(.1, 1.5), RandomObj:NextNumber(1.1, 1.5))})
		Tween:Play()
		
		table.insert(TableFlowers, Flower)
		
		Tween.Completed:Connect(function() table.remove(TableFlowers, table.find(TableFlowers, Flower)) Flower:Destroy() end)
	end
end)

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, .55)}):Play()
TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()


task.delay(10, function() Active = false end)


task.wait(3)

for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end


TweenService:Create(script.Memory, TweenInfo.new(1), {Volume = 0}):Play()
script.Parent.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)



task.wait(2)


script.Memory:Pause()
script.FallenChild:Play()

for _, Flower in TableFlowers do
	Flower.ImageColor3 = Color3.fromRGB(255, 0, 0)
end

for _, Packet in CutsceneConfig.DialogPackets2 do
	DialogManager.TypeWriteLabel(Packet)
end

Scene.Soul.Visible = false

task.wait(.1)


Scene.Slash.Visible = true


local Sprite = SpriteSheetService.PlaySprite({
	Frames = FrameConfig["Slash"].Frames,
	FramesPerSecond = 6,
	Image = Scene.Slash
})

script.Swing:Play()

Sprite.Completed.Event:Wait()

Scene.Slash.Visible = false

task.wait(.1)

script.Hit:Play()

Scene.BlackOut.Visible = true

task.wait(.6)

local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.FallenChild, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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