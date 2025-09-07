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

local TestTable = {
	"rbxassetid://82644639143068",
	"rbxassetid://99874917396937",
	"rbxassetid://87137307650557",
	"rbxassetid://140553961525706",
	"rbxassetid://96611592864931",
	"rbxassetid://125141381428947",
	"rbxassetid://79917622814995",
	"rbxassetid://81708519581897",
	"rbxassetid://117392228480097",
	"rbxassetid://109108272005449",
	"rbxassetid://98856720300767",
	"rbxassetid://117076250712214",
	"rbxassetid://114563321233999",
	"rbxassetid://76160112137854",
	"rbxassetid://76160112137854",
	"rbxassetid://86664386918052",
	"rbxassetid://101184079131709",
	"rbxassetid://137931754447276",
	"rbxassetid://109605524268240",
	"rbxassetid://136994427726574",
	"rbxassetid://114835897849285",
	"rbxassetid://76071085296964",
	"rbxassetid://83462914480214",
	"rbxassetid://99944247855056",
	"rbxassetid://111631596797895",
	"rbxassetid://76234194283774",
	"rbxassetid://108075860749380",
	"rbxassetid://87022799227783",
	"rbxassetid://110039772331096",
	"rbxassetid://71546322044893",
	"rbxassetid://117301516167450",
}

ContentProvider:PreloadAsync(TestTable)

DialogManager.ScreenDisplay({
	ParentGui = Cutscene.Dialog,
	String = "Memories from the past begin to resurface.",
	Yield = .05,
	Persist = 2,
	CustomLabel = script.ScreenDisplay,
	Effects = {"Shake"},
})

Scene.Visible = true

script.Reality:Play()

TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0, .55)}):Play()
TweenService:Create(Scene.Soul, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.fromScale(Scene.Soul.Size.X.Scale * 1.2, Scene.Soul.Size.Y.Scale * 1.2)}):Play()


local GlitchLabel = {}

local TempStatic = true 

task.defer(function()
	while TempStatic do
		task.wait(RandomObj:NextNumber(2, 5))
		script.Static:Play()
		for _, ID in TestTable do
			if not TempStatic then break end
			Scene.TestImage.Image = ID
			task.wait(1/30)
		end
		
		script.Static:Pause()

		Scene.TestImage.Image = ""
	end
end)

task.defer(function()
	while true do
		task.wait(RandomObj:NextNumber(.1, .25))
		for i=1, 2 do
			local Binary = script.Binary:Clone()
			local ScaleFactor = RandomObj:NextNumber(1, 3)
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

			Binary.Parent = Scene
			
			table.insert(GlitchLabel, Binary)

			local Tween = TweenService:Create(Binary, TweenInfo.new(RandomObj:NextNumber(1.5, 2.5)*ScaleFactor, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(Binary.Position.X.Scale, -.41)})
			Tween:Play()
			Tween.Completed:Connect(function() table.remove(GlitchLabel, table.find(GlitchLabel, Binary)) Binary:Destroy() end)
		end
	end
end)

task.wait(2)

for _, Packet in CutsceneConfig.DialogPackets do
	DialogManager.TypeWriteLabel(Packet)
end
local Backbackground = {Cutscene.WhiteOut.BrackBackground.Left, Cutscene.WhiteOut.BrackBackground.Right}

TempStatic = false

task.wait(1)

TweenService:Create(script.Reality, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

task.wait(1.5)

script.GasterSound:Play()

local TempStatic2 = true

task.defer(function()
	while TempStatic2 do
		for i=7, 22 do
			Scene.TestImage.Image = TestTable[i]
			task.wait(1/30)
		end
		Scene.TestImage.Image = ""
	end
end)

task.wait(6)

TempStatic2 = false

SFX.ClosetImpact:Play()

Scene.BlackOut.Visible = true

task.wait(.6)
local Tween = TweenService:Create(Cutscene.WhiteOut, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})

TweenService:Create(script.Reality, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()

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