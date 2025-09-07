local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MenuOptions = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas")

local DisplayLists = {}
local OriginalImagePos = {}

local ActiveEffects = {
	["Connections"] = {},
	["ActiveTweens"] = {},
}

local ActiveEffectsHeart = {
	["Connections"] = {},
	["ActiveTweens"] = {},
}

local MenuOpen = false

local Speed = 600
local SoulSpeed = 400

local Assets = {}

for _, Gui in MenuOptions:WaitForChild("List"):GetChildren() do
	if Gui:IsA("Frame") then
		local Button = Gui:FindFirstChildWhichIsA("ImageButton")
		OriginalImagePos[Button] = {}
		
		table.insert(DisplayLists, Gui)
		table.insert(Assets, Button)
		
		OriginalImagePos[Button]["Position"] = Button.Position
		OriginalImagePos[Button]["AbsPosition"] = Button.AbsolutePosition
	end
end


local function DeactivateButton()
	for _, Button in Assets do
		Button.Interactable = false
	end
end


local function CheckIfEnabled()
	for _, Frame in PlayerGui.Menus.Canvas:GetChildren() do
		if Frame.Visible then
			return true
		end
	end
end


local function StopHeart()
	for _, Connection in ActiveEffectsHeart.Connections do
		Connection:Disconnect()
	end
	for _, Tween in ActiveEffectsHeart.ActiveTweens do
		Tween:Pause()
	end

	ActiveEffectsHeart.Connections = {}
	ActiveEffectsHeart.ActiveTweens = {}
end


local function StopAll()
	for _, Connection in ActiveEffects.Connections do
		Connection:Disconnect()
	end
	for _, Tween in ActiveEffects.ActiveTweens do
		Tween:Pause()
	end
	ActiveEffects.Connections = {}
	ActiveEffects.ActiveTweens = {}
	
	StopHeart()
end


local function StartHeart(ButtonName, IgnoreSound)
	if CheckIfEnabled() then return end
	StopHeart()
	local Heart = MenuOptions.Heart
	local Goal = MenuOptions[ButtonName]
	local GoalPos = MenuOptions[ButtonName].Position
	local Distance = (Goal.AbsolutePosition - Heart.AbsolutePosition).Magnitude

	local SoundClone = script.MenuMove:Clone()
	SoundClone.Parent = script
	if not IgnoreSound then SoundClone:Play() end
	game:GetService("Debris"):AddItem(SoundClone, .2)

	if Heart.Visible == false then
		Heart.Position = GoalPos
		Heart.Visible = true
	else
		local Tween = TweenService:Create(Heart, TweenInfo.new(Distance/SoulSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Position = GoalPos})
		Tween:Play()
		table.insert(ActiveEffectsHeart.ActiveTweens, Tween)
	end
end


for _, Button in Assets do
	Button.MouseEnter:Connect(function()
		StartHeart(Button.Name)
	end)
end



MenuOptions.OpenMenus.Activated:Connect(function()
	script.Select:Play()
	if MenuOpen then
		if CheckIfEnabled() then return end
		MenuOpen = false
		StopAll()
		DeactivateButton()
		MenuOptions.Heart.Visible = false
		
		local Tween = TweenService:Create(MenuOptions.OpenMenus.MenuName, TweenInfo.new(.5, Enum.EasingStyle.Linear), {TextTransparency = 0})
		Tween:Play()
		table.insert(ActiveEffects.ActiveTweens, Tween)
		
		for _, Display in DisplayLists do
			local Button = Display:FindFirstChildWhichIsA("ImageButton")
			local Distance = (Button.AbsolutePosition - OriginalImagePos[Button].AbsPosition).Magnitude
			
			Display.MenuName.Visible = false
			
			local Tween = TweenService:Create(Button, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = OriginalImagePos[Button].Position})
			Tween:Play()
			table.insert(ActiveEffects.ActiveTweens, Tween)
			
			table.insert(ActiveEffects.Connections, Tween.Completed:Connect(function()
				Button.Visible = false
				MenuOptions.OpenMenus.MenuName.Visible = true
			end))
		end
	else
		MenuOpen = true
		StopAll()
		MenuOptions.Heart.Position = MenuOptions.Items.Position
		
		local Tween = TweenService:Create(MenuOptions.OpenMenus.MenuName, TweenInfo.new(.5, Enum.EasingStyle.Linear), {TextTransparency = 1})
		Tween:Play()
		table.insert(ActiveEffects.ActiveTweens, Tween)
		
		for _, Display in DisplayLists do
			local Button = Display:FindFirstChildWhichIsA("ImageButton")
			local Distance = (Button.AbsolutePosition - Display.PositionButton.AbsolutePosition).Magnitude
			
			Button.Visible = true
			local Tween = TweenService:Create(Button, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Back), {Position = Display.PositionButton.Position})
			Tween:Play()
			table.insert(ActiveEffects.ActiveTweens, Tween)
			table.insert(ActiveEffects.Connections, Tween.Completed:Connect(function()
				Button.Interactable = true
				Display.MenuName.Visible = true
				local Tween = TweenService:Create(Display.MenuName, TweenInfo.new(.5, Enum.EasingStyle.Linear), {TextTransparency = 0})
				Tween:Play()
				table.insert(ActiveEffects.ActiveTweens, Tween)
			end))
		end
	end
end)


for _, Button in Assets do
	Button.Activated:Connect(function()
		script.Select:Play()
		if CheckIfEnabled() then return end
		StartHeart(Button.Name, true)
	end)
end

--local self = 

--PlayerGui.TestScreen.OpenMenus.Activated:Connect(function()
--	UIManager.TestScreen:Hide()
--end)