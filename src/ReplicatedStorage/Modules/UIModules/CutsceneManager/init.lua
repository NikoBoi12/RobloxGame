local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local UIManager = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("UI"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SceneScreen = PlayerGui:WaitForChild("Cutscene")

local Cutscene = {}


local function RandomizePosition(Button)
	local SizeX = Button.Size.X.Scale
	local SizeY = Button.Size.Y.Scale


	local PosX = math.random() * (1 - SizeX)
	local PosY = math.random() * (1 - SizeY)

	Button.Position = UDim2.new(PosX, 0, PosY, 0)
end


function Cutscene.StartScene(NewScene)
	for _, Gui in SceneScreen:GetChildren() do
		Gui:Destroy()
	end
	
	local OriginalVolume = {}
	
	for _, SoundObj in ReplicatedStorage.Configs.SoundConfig:GetChildren() do
		OriginalVolume[SoundObj] = SoundObj.Volume
		SoundObj.Volume = 0
	end
	
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	
	UIManager.Menus.Inventory:Hide()
	UIManager.Menus.Auras:Hide()
	UIManager.Menus.Info:Hide()
	UIManager.Menus.Settings:Hide()
	
	local SceneMain = script:FindFirstChild(NewScene):Clone()
	SceneMain.Scene:FindFirstChildWhichIsA("LocalScript").Enabled = true
	
	local SkipButton = script.Skip:Clone()
	
	SkipButton.Parent = SceneMain
	SceneMain.Parent = SceneScreen
	
	local Presses = 0
	
	local Connection = SkipButton.Activated:Connect(function()
		Presses += 1
		
		RandomizePosition(SkipButton)
		
		if Presses == 2 then
			
			Cutscene.Finished:Fire()
		end
	end)
	
	if PlayerData.PreviousCutsceneConnection then
		Cutscene.Finished:Fire()
	end
	
	PlayerData.PreviousCutsceneConnection = Cutscene.Finished.Event:Once(function()
		for _, SoundObj in ReplicatedStorage.Configs.SoundConfig:GetChildren() do
			SoundObj.Volume = OriginalVolume[SoundObj]
		end
		
		if SceneMain.Parent then
			SceneMain:Destroy()
		end
		
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		
		PlayerData.PreviousCutsceneConnection = nil
		
		Connection:Disconnect()
	end)		

end


Cutscene.Finished = ReplicatedStorage.Storage.Events.SceneCompleted


return Cutscene
