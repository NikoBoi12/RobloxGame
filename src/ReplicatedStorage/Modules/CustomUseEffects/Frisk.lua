local module = {}

local spawned = false
local part
local Debounce = false
local Cooldown = 4

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = require(ReplicatedStorage.Modules.SolarFunctions.Functions)

local LocalPlayer = Players.LocalPlayer

function module.SetUp(self)
	
end

function module.Use(self)
	if Debounce then return end
	Debounce = true
	
	if spawned == false then
		spawned = true 
		local savePoint = script.SAVEPoint:Clone()
		savePoint.Position = LocalPlayer.Character.HumanoidRootPart.Position
		savePoint.Anchored = true
		savePoint.CanCollide = false
		
		for _,v in savePoint:GetDescendants() do
			if v:IsA("ParticleEmitter") then
				v.Enabled = true
			end
		end
		savePoint.Parent = workspace
		savePoint.Text.TextLabel.Text = "FILE 3 SAVED."
		task.wait(1)
		Functions.PlayTween(savePoint.Text.TextLabel, TweenInfo.new(.5), {TextTransparency = 1})
		--game:GetService("TweenService"):Create(savePoint.Text.TextLabel,TweenInfo.new(.5),{TextTransparency = 1}):Play()

		part = savePoint
	elseif spawned == true then
		spawned = false
		LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
		part.Text.TextLabel.Text = "FILE 3 LOADED."
		part.Text.TextLabel.TextTransparency = 0
		task.wait(1)
		Functions.PlayTween(part.Text.TextLabel, TweenInfo.new(.5), {TextTransparency = 1})
		task.wait(.6)
		part:Destroy()
	end
	
	task.wait(Cooldown)
	Debounce = false
end

return module
