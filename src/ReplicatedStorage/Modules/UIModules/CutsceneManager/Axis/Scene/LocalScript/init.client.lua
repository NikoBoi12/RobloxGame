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

DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true

local GlitchLabel = {}

local TempStatic = true 
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

script.EndOfTheLine:Play()

local Goal1 = {
	Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2),
}

TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), Goal1):Play()



local function RanNumbers(Binary)
	task.defer(function()
		while Binary.Parent do
			for _, Frame in Binary:GetChildren() do
				task.wait()
				if not Binary.Parent then return end
				if Frame:IsA("Frame") then
					Frame.TextLabel.Text = math.random(0, 1)
				end
			end
		end
	end)
end

function Shake(Binary)
	task.defer(function()

		
		while true do
			task.wait(1)
			for _, Frame in Binary:GetChildren() do
				if not Binary.Parent then return end
				if Frame:IsA("Frame") then
					local Pos = Frame.TextLabel.Position
					if math.random(0, 1) == 1 then
						task.defer(function()
							for i=1, 15 do
								task.wait(1/60)
								if not Binary.Parent then return end
								local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(30, 70)) * RandomObj:NextNumber(.035, 0.1))
								local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(45, 75)) * RandomObj:NextNumber(.045, 0.13)) 
								Frame.TextLabel.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
							end
							Frame.TextLabel.Position = Pos
						end)
					end
				end
			end
		end
	end)
end

task.defer(function()
	while true do
		task.wait(RandomObj:NextNumber(.10, .25))
		for i=1, 1 do
			local Binary = script.Binary:Clone()
			local ScaleFactor = RandomObj:NextNumber(.5, 4)
			Binary.Size = UDim2.fromScale(Binary.Size.X.Scale / ScaleFactor, Binary.Size.Y.Scale / ScaleFactor)
			Binary.Position = UDim2.fromScale(RandomObj:NextNumber(0, .975), 1)

			for _, TextLabel in Binary:GetChildren() do
				if TextLabel:IsA("TextLabel") then
					local Hue, Saturation, Value = TextLabel.TextColor3:ToHSV()
					TextLabel.UIStroke.Thickness = TextLabel.UIStroke.Thickness / ScaleFactor
					TextLabel.TextColor3 = Color3.fromHSV(Hue, Saturation, Value / ScaleFactor)
				end
			end

			Binary.ZIndex = Binary.ZIndex/ScaleFactor

			Binary.Parent = Scene.BinaryBackground
			
			table.insert(GlitchLabel, Binary)
			
			RanNumbers(Binary)
			Shake(Binary)
			
			local Tween = TweenService:Create(Binary, TweenInfo.new(RandomObj:NextNumber(2, 3)*ScaleFactor, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(Binary.Position.X.Scale, 0 - Binary.Size.Y.Scale )})
			Tween:Play()
			Tween.Completed:Connect(function() table.remove(GlitchLabel, table.find(GlitchLabel, Binary)) Binary:Destroy() end)
		end
	end
end)


task.wait(2)

for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end

TweenService:Create(script.EndOfTheLine, TweenInfo.new(.8), {Volume = 0}):Play()

task.wait(1)

SFX.ClosetImpact:Play()
Scene.BlackOut.Visible = true

task.wait(1)

script.Vaporized:Play()

task.wait(2)

local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.EndOfTheLine, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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