local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local SolarFunctions = require(ReplicatedStorage.Modules.SolarFunctions.Functions)
local NotificationHandler = require(ReplicatedStorage.Modules:WaitForChild("NotificationHandler"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")
local AreaLuck = HUD:FindFirstChild("AreaLuck")

local Canvas = PlayerGui:WaitForChild("Shop"):WaitForChild("Canvas")
local ShopUI = Canvas:WaitForChild("MainCanvas")
local MenuRight = ShopUI:WaitForChild("MenuRight")

local Data = PlayerData.GetData(LocalPlayer)

local function UpdatePity(Index, Value)
	if Index == "PityRollsNew" then
		PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas"):WaitForChild("Roll"):WaitForChild("Pity").Text = Value.."/10"
	end
	
	if Index == "DarkDollars" then
		MenuRight:WaitForChild("Money").Text = Value.."$"
	end
	
	if Index == "InCircle" then
		AreaLuck.Visible = Value 
	end
	
	if Index == "CircleColor" then
		AreaLuck.TextColor3 = Value
	end
	
	if Index == "CircleLuck" then
		AreaLuck.Text = 1 + Value.. "x Area Luck!"
	end
	
end

local function updateUI(message: string)
	if typeof(message) ~= "string" then return end
	local indicator = ReplicatedStorage.Storage.Gui.Other.SolarIndicator:Clone()
	indicator.Parent = PlayerGui
	indicator.TextLabel.Text = message
	task.delay(2,function()
		local tween = SolarFunctions.Tween(indicator.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 1})
		tween:Play();
		tween.Completed:Once(function()
			indicator:Destroy();
		end)
	end)
end

Data.Changed:Connect(UpdatePity)

ReplicatedStorage.Remotes.SolarRemotes.Indicator.OnClientEvent:Connect(updateUI)

UpdatePity("PityRollsNew", Data.PityRollsNew)
UpdatePity("DarkDollars", Data.DarkDollars)