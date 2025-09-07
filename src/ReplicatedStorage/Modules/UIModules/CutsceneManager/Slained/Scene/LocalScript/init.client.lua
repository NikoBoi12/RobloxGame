local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))
local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local SpriteSheetService = require(ReplicatedStorage.Modules.UIModules:WaitForChild("SpriteSheet"))
local FrameData = require(ReplicatedStorage.Configs.FrameData)
local CutsceneConfig = require(script:WaitForChild("Config"))

local SFX = ReplicatedStorage.Storage.SFX.Effects

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background


game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)


--[DialogManager.ScreenDisplay({
--	ParentGui = Cutscene.Dialog,
--	String = "Memories from the past begin to resurface.",
--	Yield = .05,
--	Persist = 2,
--	CustomLabel = script.ScreenDisplay,
--	Effects = {"Shake"},
--})

function Shake()
	task.defer(function()
		local Pos = Background.Nines.Position
		while true do
			task.wait(.1)
			local ParticleImage = Background.Nines

			task.defer(function()
				local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(30, 70)) * RandomObj:NextNumber(.03, 0.09))
				local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(45, 65)) * RandomObj:NextNumber(.04, 0.1)) 
				ParticleImage.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
			end)
		end
	end)
end


Scene.Visible = true

script.Music:Play()
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

task.wait(3)

Scene.Slash.Visible = true


script.Swing:Play()

local Sprite = SpriteSheetService.PlaySprite({
	Frames = FrameData["Slash"].Frames,
	FramesPerSecond = 24,
	Image = Scene.Slash
})

Sprite.Completed.Event:Wait()
task.wait(.1)

Scene.Slash.Visible = false

task.wait(.5)

script.Hit:Play()

Background.Nines.Visible = true

Shake()

task.wait(4)

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