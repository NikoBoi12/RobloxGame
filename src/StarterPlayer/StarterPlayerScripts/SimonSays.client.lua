local camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local SimonSays = workspace.simonsays
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local PlayerData = require(ReplicatedStorage.PlayerData).GetData(LocalPlayer)

local possibleColors = { "red", "yellow", "blue", "green" }

local TeleportRemote = ReplicatedStorage.Remotes.TeleportServer

local timeRemaining = 2
local elapsedTime = 0

local currentOrder = {}
local playerOrder = {}
local round = 1
local lastCameraCFrame
local ui

local function FindButton(Prompt, QuestName)
	for _, PromptName in PlayerData.ButtonQuest[QuestName].ButtonsFound do
		if PromptName == Prompt then
			return true
		end
	end
end

local function CheckTableEquality(t1, t2)
	for i, v in next, t1 do
		if t2[i] ~= v then return false end
	end
	for i, v in next, t2 do
		if t1[i] ~= v then return false end
	end
	return true
end

local function ResetCamera()
	for _, part in SimonSays:GetChildren() do
		local cd = part:FindFirstChildOfClass("ClickDetector")
		if cd then cd:Destroy() end
	end

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, tweenInfo, { CFrame = lastCameraCFrame })
	tween:Play()
	tween.Completed:Wait()

	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
	SimonSays.camera.Attachment.ProximityPrompt.Enabled = true

	if ui then
		ui:Destroy()
		ui = nil
	end
end

local rewards = {
	[14] = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		
		ResetCamera()
		
		if FindButton("3", "Quest100") then return end
		
		TeleportRemote:FireServer(Vector3.new(44.63, 4, 1803.56))
	end,
}

ReplicatedStorage.SetSSCamera.OnClientEvent:Connect(function(targetPart)
	SimonSays.camera.Attachment.ProximityPrompt.Enabled = false

	for _, part in SimonSays:GetChildren() do
		local cd = part:FindFirstChildOfClass("ClickDetector")
		if cd then cd:Destroy() end
	end

	ui = script.SimonSays:Clone()
	ui.Parent = game.Players.LocalPlayer.PlayerGui
	ui.Round.Text = "Round: 1"

	lastCameraCFrame = camera.CFrame

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CameraSubject = targetPart

	local tween = TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = targetPart.CFrame })
	tween:Play()

	task.wait(3)

	local function ChooseColor()
		currentOrder[round] = possibleColors[math.random(1, #possibleColors)]
	end

	local function MainLoop()
		ChooseColor()
		playerOrder = {}

		ui.Round.Text = "Round: " .. round

		local timeRemaining = 3 + ((round - 1) * 2)
		local elapsedTime = 0

		ui.Time.Text = string.format("0.0s/%.1fs", timeRemaining)

		for _, color in ipairs(currentOrder) do
			local part = SimonSays[color]
			part.Material = Enum.Material.Neon
			task.wait(0.5)
			part.Material = Enum.Material.Glass
			task.wait(0.25)
		end

		local i = 1

		for _, part in SimonSays:GetChildren() do
			if part:IsA("MeshPart") and part.Name ~= "base" then
				local cd = Instance.new("ClickDetector")
				cd.MaxActivationDistance = 32
				cd.Parent = part

				cd.MouseClick:Connect(function()
					if #playerOrder >= round then return end

					local color = part.Name
					playerOrder[i] = color
					SimonSays.base.click:Play()

					if playerOrder[i] ~= currentOrder[i] then
						ResetCamera()
						return
					end

					if i < round then
						i += 1
					end
				end)
			end
		end

		while elapsedTime < timeRemaining and #playerOrder < round and ui do
			task.wait(0.1)
			elapsedTime += 0.1
			if not ui then return end
			ui.Time.Text = string.format("%.1fs/%.1fs", elapsedTime, timeRemaining)
		end

		if #playerOrder < round then
			ResetCamera()
			return
		end

		if CheckTableEquality(playerOrder, currentOrder) then
			round += 1

			if rewards[round] then
				rewards[round]()
			end

			local sfx = SimonSays.base.success:Clone()
			sfx.Parent = game.Players.LocalPlayer.PlayerGui
			sfx:Play()
			sfx.Ended:Connect(function()
				sfx:Destroy()
			end)

			for _, part in SimonSays:GetChildren() do
				local cd = part:FindFirstChildOfClass("ClickDetector")
				if cd then cd:Destroy() end

				if part.Name ~= "base" and part:IsA("MeshPart") then
					task.spawn(function()
						for j = 1, 2 do
							part.Material = Enum.Material.Neon
							task.wait(0.2)
							part.Material = Enum.Material.Glass
							task.wait(0.2)
						end
					end)
				end
			end

			task.wait(1.5)

			-- Do not continue if game ended (e.g., after round 2 reward)
			if ui then
				MainLoop()
			end
		else
			ResetCamera()
		end
	end

	round = 1
	playerOrder = {}
	currentOrder = {}

	MainLoop()
end)