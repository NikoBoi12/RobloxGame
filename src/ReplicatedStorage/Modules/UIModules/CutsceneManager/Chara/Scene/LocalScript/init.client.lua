local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DialogManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local GuiEffects = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("GuiEffects"))

local CutsceneManager = require(ReplicatedStorage.Modules.UIModules:WaitForChild("CutsceneManager"))
local CutsceneConfig = require(script:WaitForChild("Config"))

local RandomObj = Random.new()

local Scene = script.Parent
local Cutscene = Scene.Parent
local Background = Scene.Background
local Soul = Scene:WaitForChild("soul")
Soul.Position = UDim2.fromScale(0.5, 0.5)
Soul.AnchorPoint = Vector2.new(0.5, 0.5)
Soul.Size = UDim2.new(0.115, 0, 0.223, 0)
Soul.ImageColor3 = Color3.fromRGB(255, 0, 0)
Soul.BackgroundTransparency = 1
Soul.BorderSizePixel = 0

local HitSound = script:WaitForChild("hit")
local LevelUpSound = script:WaitForChild("LevelUp")

-- Level UI
local NameLabel = Instance.new("TextLabel")
NameLabel.Text = "Chara"
NameLabel.Font = Enum.Font.Arcade
NameLabel.TextScaled = true
NameLabel.Size = UDim2.new(0.15, 0, 0.05, 0)
NameLabel.Position = UDim2.new(0.35, 0, 0.65, 0)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.Parent = Scene

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Text = "LV. 1"
LevelLabel.Font = Enum.Font.Arcade
LevelLabel.TextScaled = true
LevelLabel.Size = UDim2.new(0.15, 0, 0.05, 0)
LevelLabel.Position = UDim2.new(0.5, 0, 0.65, 0)
LevelLabel.BackgroundTransparency = 1
LevelLabel.TextColor3 = Color3.new(1, 1, 1)
LevelLabel.Parent = Scene

-- EXP bar
local ExpBar = Instance.new("Frame")
ExpBar.Size = UDim2.new(0.3, 0, 0.015, 0)
ExpBar.Position = UDim2.new(0.35, 0, 0.7, 0)
ExpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ExpBar.BorderSizePixel = 0
ExpBar.Parent = Scene

local ExpFill = Instance.new("Frame")
ExpFill.Size = UDim2.new(0, 0, 1, 0)
ExpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
ExpFill.BorderSizePixel = 0
ExpFill.Parent = ExpBar

local exp = 0
local level = 1
local maxLevel = 20
local heartsNeeded = 3

local function clamp(val, min, max)
	return math.clamp(val, min, max)
end

local function darkenColor(color, amount)
	return Color3.new(
		clamp(color.R - amount, 0, 1),
		clamp(color.G - amount, 0, 1),
		clamp(color.B - amount, 0, 1)
	)
end

local soulHitCount = 0
local HeartId = "rbxassetid://18136718208"
local canPlaySound = false

-- Heartbeat tween loop
task.spawn(function()
	while Soul.Parent do
		TweenService:Create(Soul, TweenInfo.new(0.2), {
			Size = UDim2.new(0.12, 0, 0.23, 0)
		}):Play()
		task.wait(0.2)
		TweenService:Create(Soul, TweenInfo.new(0.2), {
			Size = UDim2.new(0.165, 0, 0.273, 0)
		}):Play()
		task.wait(0.2)
	end
end)

-- Heart attack loop
task.spawn(function()
	while Soul.Parent do
		-- Stop spawning hearts if max level reached
		if level >= maxLevel then
			break
		end

		local heart = Instance.new("ImageLabel")
		heart.Image = HeartId
		heart.BackgroundTransparency = 1
		heart.Size = UDim2.new(0.05, 0, 0.08, 0)
		heart.AnchorPoint = Vector2.new(0.5, 0.5)
		heart.Rotation = RandomObj:NextNumber(-180, 180)
		heart.ZIndex = 5
		heart.Parent = Scene

		local grad = Instance.new("UIGradient")
		grad.Rotation = 90
		grad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
		}
		grad.Parent = heart

		local sides = {"Top", "Bottom", "Left", "Right"}
		local side = sides[RandomObj:NextInteger(1, #sides)]
		local spawnPos = side == "Top" and UDim2.new(RandomObj:NextNumber(0,1), 0, 0, 0)
			or side == "Bottom" and UDim2.new(RandomObj:NextNumber(0,1), 0, 1, 0)
			or side == "Left" and UDim2.new(0, 0, RandomObj:NextNumber(0,1), 0)
			or UDim2.new(1, 0, RandomObj:NextNumber(0,1), 0)
		heart.Position = spawnPos

		local flyTime = 1.5
		TweenService:Create(heart, TweenInfo.new(flyTime, Enum.EasingStyle.Quad), {
			Position = Soul.Position,
			Rotation = heart.Rotation + 360
		}):Play()

		-- Breathe animation
		task.spawn(function()
			while heart and heart.Parent do
				TweenService:Create(heart, TweenInfo.new(0.2), {
					Size = UDim2.new(0.06, 0, 0.09, 0)
				}):Play()
				task.wait(0.2)
				TweenService:Create(heart, TweenInfo.new(0.2), {
					Size = UDim2.new(0.05, 0, 0.08, 0)
				}):Play()
				task.wait(0.2)
			end
		end)

		-- Heart reaches soul
		task.delay(flyTime, function()
			if heart and heart.Parent then
				Soul.ImageColor3 = soulHitCount == 0 and Color3.fromRGB(255, 0, 0)
					or darkenColor(Soul.ImageColor3, 0.02)
				soulHitCount += 1

				local originalPos = Soul.Position
				TweenService:Create(Soul, TweenInfo.new(0.1), {
					Position = originalPos + UDim2.new(0.01, 0, 0, 0)
				}):Play()
				task.wait(0.1)
				TweenService:Create(Soul, TweenInfo.new(0.1), {
					Position = originalPos
				}):Play()

				if canPlaySound then HitSound:Play() end

				if level < maxLevel then
					exp += 1 / heartsNeeded
					exp = clamp(exp, 0, 1)

					TweenService:Create(ExpFill, TweenInfo.new(0.3), {
						Size = UDim2.new(exp, 0, 1, 0)
					}):Play()

					ExpFill.BackgroundColor3 = exp >= 1 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0)

					if exp >= 1 then
						level += 1
						level = clamp(level, 1, maxLevel)
						LevelLabel.Text = "LV. " .. level
						exp = 0
						ExpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)

						local popup = Instance.new("TextLabel")
						popup.Text = "LV. UP!"
						popup.Font = Enum.Font.Arcade
						popup.TextColor3 = Color3.fromRGB(255, 255, 0)
						popup.BackgroundTransparency = 1
						popup.ZIndex = 30
						popup.TextScaled = true
						popup.Size = UDim2.new(0.2, 0, 0.05, 0)
						popup.Position = UDim2.new(0.4, 0, 0.55, 0)
						popup.Parent = Scene

						TweenService:Create(popup, TweenInfo.new(0.5), {
							Position = popup.Position - UDim2.new(0, 0, 0.05, 0),
							TextTransparency = 1
						}):Play()

						task.delay(0.5, function() popup:Destroy() end)

						local originalColor = Soul.ImageColor3
						TweenService:Create(Soul, TweenInfo.new(0.15), {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						}):Play()
						task.wait(0.15)
						TweenService:Create(Soul, TweenInfo.new(0.15), {
							ImageColor3 = originalColor
						}):Play()

						if canPlaySound then LevelUpSound:Play() end
					end
				end
				heart:Destroy()
			end
		end)

		task.wait(1)
	end
end)

-- Cutscene begins

DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = 0.05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true
canPlaySound = true

script["Rain Effect"]:Play()
TweenService:Create(script.Windy, TweenInfo.new(3), {Volume = 0.2}):Play()
script.Windy:Play()

local Backbackground = {
	Cutscene.WhiteOut.BrackBackground.Left,
	Cutscene.WhiteOut.BrackBackground.Right
}
ContentProvider:PreloadAsync(Backbackground)

for _, Packet in ipairs(CutsceneConfig.DialogPackets) do
	DialogManager.LetterDisplay(Packet)
	task.wait(1)
end

task.wait(2)

TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5), {
	BackgroundTransparency = 0
}):Play()
TweenService:Create(script.Windy, TweenInfo.new(2.5), {Volume = 0}):Play()
TweenService:Create(script["Rain Effect"], TweenInfo.new(2.5), {Volume = 0}):Play()

task.wait(2.5 + 0.5)

ContentProvider:PreloadAsync(Backbackground)
Backbackground[1].ImageTransparency = 0
Backbackground[2].ImageTransparency = 0

script.Break1:Play()
GuiEffects.Shake({
	BobbleX = {Min = 100, Max = 250, Min2 = 0.1, Max2 = 0.2},
	BobbleY = {Min = 100, Max = 250, Min2 = 0.1, Max2 = 0.2},
	Length = 0.1,
	Gui = Cutscene.WhiteOut.BrackBackground
})

task.wait(0.2)
Cutscene.WhiteOut.BackgroundTransparency = 1
task.wait(1)

script.Break2:Play()
Scene.Visible = false

TweenService:Create(Backbackground[1], TweenInfo.new(1), {
	Position = UDim2.fromScale(-0.6, 0)
}):Play()
TweenService:Create(Backbackground[2], TweenInfo.new(1), {
	Position = UDim2.fromScale(0.6, 0)
}):Play()

task.wait(1.5)

Cutscene:Destroy()

CutsceneManager.Finished:Fire()