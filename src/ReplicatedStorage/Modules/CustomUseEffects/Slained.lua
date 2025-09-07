local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local PlayerData = require(ReplicatedStorage.PlayerData)
local AnimationUtility = require(ReplicatedStorage.Modules.AnimationUtility)

local Replicate = script.Replicate

local LocalPlayer
local Data

local Debounce = false
local Cooldown = 20

local UseEffect = {}

local Animations = {
	Shake = 17703357142
}

function UseEffect.SetUp()
	
end


function UseEffect.Use()
	if Debounce then return end
	Debounce = true
	Replicate:FireServer()
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.StartEffect(Player)
	local Character = Player.Character
	local HRP = Character.HumanoidRootPart

	local Hit = script.Hit
	local Swing = script.Swing
	
	local Nines = script.DamageNum:Clone()
	local SlashEffect = script.Slash:Clone()
	
	Nines.Parent = HRP.RootAttachment
	SlashEffect.Parent = HRP.RootAttachment
	
	SlashEffect:Emit(1)
	
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then script.Swing:Play() end
	task.wait(.6)
	
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then Hit:Play() end
	
	if Player == PlayerService.LocalPlayer then
		AnimationUtility.Play(Character, Animations.Shake)
	end
	
	Nines:Emit(15)
	
	task.wait(.6)
	
	for _, Part in script.Dummy:GetChildren() do
		if Part:IsA("BasePart") then
			TweenService:Create(Character[Part.Name], TweenInfo.new(3), {Transparency = .5}):Play()
		end
	end
	
	Character.Head:FindFirstChildWhichIsA("Decal").Transparency = 1
	
	task.wait(5)
	
	
	for _, Part in script.Dummy:GetChildren() do
		if Part:IsA("BasePart") then
			TweenService:Create(Character[Part.Name], TweenInfo.new(3), {Transparency = 0}):Play()
		end
	end
	
	TweenService:Create(Character.Head:FindFirstChildWhichIsA("Decal"), TweenInfo.new(3), {Transparency = 0}):Play()
	
	Nines:Destroy()
	SlashEffect:Destroy()
end


if RunService:IsServer() then
	Replicate.OnServerEvent:Connect(function(Player)
		local Data = PlayerData.GetData(Player)
		if not Data then return end
		
		if Data[script.Name] and (os.clock() - Data[script.Name]) < Cooldown - 2 then return end
		
		Data[script.Name] = os.clock()
		
		Replicate:FireAllClients(Player)
	end)
else
	Replicate.OnClientEvent:Connect(UseEffect.StartEffect)
	LocalPlayer = PlayerService.LocalPlayer
	Data = PlayerData.GetData(LocalPlayer)
end


return UseEffect
