
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local PlayerData = require(ReplicatedStorage.PlayerData)
local Functions = require(ReplicatedStorage.Modules.SolarFunctions.Functions)

local Data = PlayerData.GetData(LocalPlayer)

local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas") :: typeof(StarterGui.HUD.Canvas)
local Menu = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas") :: typeof(StarterGui.Menus.Canvas)
local TravelMenu = Menu:WaitForChild("FastTravel") :: typeof(StarterGui.Menus.Canvas.FastTravel)
local Options = TravelMenu:WaitForChild("Options")

local function addButton(button: TextButton)
	local tween: Tween = nil
	local uistroke = button:FindFirstChildOfClass("UIStroke")

	button.TextColor3 = Color3.new(1,1,1)
	button.MouseEnter:Connect(function()
		local strokeColor = Color3.fromRGB(127, 127, 68)
		local textColor = Color3.fromRGB(255, 255, 0)
		local Info = TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0)

		uistroke.Color = strokeColor
		uistroke.Thickness = 1.5;
		uistroke.Transparency = 0;
		tween = Functions.Tween(uistroke, Info, {Thickness = 5; Transparency = 0.5})
		tween:Play();
		ReplicatedStorage.Storage.SFX.UI.MenuMove:Play();
		button.TextColor3 = textColor
	end)
	button.MouseLeave:Connect(function()
		local strokeColor = Color3.fromRGB(127, 127, 127)
		local textColor = Color3.new(1,1,1)

		if tween then tween:Cancel(); tween:Destroy(); end

		button.TextColor3 = textColor
		uistroke.Color = strokeColor
		uistroke.Thickness = 1.5;
		uistroke.Transparency = 0;
	end)
	button.Activated:Connect(function()
		TravelMenu.Visible = false;
		ReplicatedStorage.Storage.SFX.UI.Select:Play();
		ReplicatedStorage.Storage.Gui.Other.FastTravelTransition:Clone().Parent = PlayerGui
		task.delay(2, function() ReplicatedStorage.Remotes.SolarRemotes.Teleport:FireServer(button.Name) end)

		--ReplicatedStorage.Remotes.SolarRemotes.Teleport:FireServer(button.Name)
	end)
end

local autoText = {
	["TrueLab"] = "True Lab"
}

for index, button: TextButton in Options:GetChildren() do
	if button.ClassName ~= "TextButton" then
		continue
	end
	
	print(button.Name)
	print(Data.UnlockedLocations)
	if Data.UnlockedLocations[button.Name] == false then
		button:Destroy()
		continue;
	end
		
	addButton(button)
end

Data.UnlockedLocations.Changed:Connect(function(index, value)
	if value ~= true then return end
	print("eee", index, value)
	local cloneButton = Options.Snowdin:Clone();
	cloneButton.Name = index;
	cloneButton.Text = autoText[index] or index;
	cloneButton.Parent = Options;
	
	addButton(cloneButton)
end)