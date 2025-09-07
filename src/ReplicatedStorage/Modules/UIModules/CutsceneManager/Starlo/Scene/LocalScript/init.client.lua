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

script.Music:Play()

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, 0)}):Play()
local Info = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()

local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}


task.defer(function()
	while true do
		task.wait(.05)

		for i=1, 6 do
			task.wait()
			GuiEffects.CreateFlameParticle(script.Particle, Background, Info)
		end
	end
end)




task.defer(function()

	while true do
		local RandomTumble = math.random(1, 3)
		
		local SinValue = 1
		local Height = .05
		local Speed = 30
		
		local Weedspeed = .003
		
		local StartPos = .4
		if RandomTumble == 2 then
			Weedspeed = .0025
			Speed = 40
			Height = .04
			StartPos = .3
		elseif RandomTumble == 3 then
			Weedspeed = .002
			Speed = 50
			Height = .03
			StartPos = .2
		end
		
		local Tumbleweed = script[RandomTumble]:Clone()
		Tumbleweed.Position = UDim2.fromScale(1,StartPos)
		Tumbleweed.Parent = Background
		
		task.defer(function()
			while true do
				local Deltatime = task.wait()

				SinValue += 1

				local MathSin = Height * math.cos(SinValue / Speed)
				Tumbleweed.Rotation += 3
				Tumbleweed.Position = UDim2.fromScale(Tumbleweed.Position.X.Scale - Weedspeed, MathSin + StartPos)
				
				if Tumbleweed.Position.X.Scale <= -.2 then Tumbleweed:Destroy() break end
			end
		end)
		task.wait(math.random(5, 8))
	end
end)

task.wait(1)

for _, Packet in CutsceneConfig.DialogPackets.PartA do
	DialogManager.TypeWriteLabel(Packet)
end

for _, Packet in CutsceneConfig.DialogPackets.PartB do
	DialogManager.LetterDisplay(Packet)
end


script.Vaporized:Play()

TweenService:Create(script.Music, TweenInfo.new(1.6, Enum.EasingStyle.Linear), {Volume = 0})

task.defer(function()
	while true do
		task.wait(.05)

		for i=1, 6 do
			task.wait()
			GuiEffects.CreateFlameParticle(script.DustParticle, Background, Info)
		end
	end
end)

task.wait(2)

for _, Packet in CutsceneConfig.DialogPackets.PartC do
	DialogManager.LetterDisplay(Packet)
end

task.wait(2)

local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.Music, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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