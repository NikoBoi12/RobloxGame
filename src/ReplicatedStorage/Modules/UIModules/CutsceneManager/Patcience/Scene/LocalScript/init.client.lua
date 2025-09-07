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

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, .55)}):Play()

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()



task.defer(function()
	while true do
		task.wait(.01)
		for i=1, 8 do
			task.wait(.01)
			local Debris = script.Debris:Clone()
			Debris.Position = UDim2.fromScale(RandomObj:NextNumber(0, 9.68), RandomObj:NextNumber(0, .568))
			Debris.Visible = true
			Debris.Parent = Scene.Particles
			
			local Tween = TweenService:Create(Debris, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{
				Size = UDim2.fromScale(.02, .04), 
				Rotation = RandomObj:NextNumber(0, 360),
				ImageTransparency = 1,
					Position = Debris.Position + UDim2.fromScale(RandomObj:NextNumber(-.05, .05), RandomObj:NextNumber(-.04, .04))
				})
			Tween:Play()
			Tween.Completed:Connect(function()
				Debris:Destroy()
			end)
		end
	end
end)


--[[task.defer(function()
	while true do
		task.wait(.01)
		for i=1, 8 do
			task.wait(.01)
			local Debris = script.BallDebris:Clone()
			Debris.Position = UDim2.fromScale(RandomObj:NextNumber(0, 9.68), 1)
			Debris.Visible = true
			Debris.Parent = Scene.Particles

			local Tween = TweenService:Create(Debris, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{
					Size = UDim2.fromScale(.015, .035), 
					Rotation = RandomObj:NextNumber(0, 360),
					ImageTransparency = 1,
					Position = Debris.Position + UDim2.fromScale(0, RandomObj:NextNumber(-.7, -.3))
				})
			Tween:Play()
			Tween.Completed:Connect(function()
				Debris:Destroy()
			end)
		end
	end
end)]]


task.defer(function()
	while true do
		task.wait(RandomObj:NextNumber(.10, .25))
		for i=1, 3 do
			local ScaleFactor = RandomObj:NextNumber(1, 4)
			local Particle = script.BallDebris:Clone()
			Particle.Visible = true
			Particle.Size = UDim2.fromScale(Particle.Size.X.Scale / ScaleFactor, Particle.Size.Y.Scale / ScaleFactor)
			Particle.Position = UDim2.fromScale(RandomObj:NextNumber(0, .975), 1)

			local ImageParticle = Particle


			local Hue, Saturation, Value = ImageParticle.ImageColor3:ToHSV()
			--TextLabel.UIStroke.Thickness = ImageParticle.UIStroke.Thickness / ScaleFactor
			ImageParticle.ImageColor3 = Color3.fromHSV(Hue, Saturation, Value / ScaleFactor)


			Particle.ZIndex = Particle.ZIndex/ScaleFactor
			Particle.Parent = Scene.Particles
			
			local TimeFactor = RandomObj:NextNumber(1, 2)*ScaleFactor

			local Tween = TweenService:Create(Particle, TweenInfo.new(TimeFactor, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
				{Position = Particle.Position + UDim2.fromScale(0, RandomObj:NextNumber(-.7, -.3))})
			Tween:Play()
			
			Tween.Completed:Connect(function() Particle:Destroy() end)
			
			task.defer(function()
				task.wait(TimeFactor/2)

				TweenService:Create(Particle, TweenInfo.new(TimeFactor/2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{ImageTransparency = 1}):Play()
			end)
		end
	end
end)


task.wait(1)


for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end


task.wait(2)


SFX.ClosetImpact:Play()

Scene.BlackOut.Visible = true

task.wait(.6)

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