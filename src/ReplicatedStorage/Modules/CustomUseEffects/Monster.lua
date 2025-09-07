local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local PlayerData = require(ReplicatedStorage.PlayerData)

local LocalPlayer
local Data

local AnimationUtility = require(ReplicatedStorage.Modules.AnimationUtility)
local Functions = require(ReplicatedStorage.Modules.SolarFunctions.Functions)

local Replicate = script.Replicate
local Damage = script.Damage

local Debounce = false
local Cooldown = 25

local UseEffect = {}

function UseEffect.SetUp()
	
end


local Animations = {
	Shake = 17703357142
}

function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	Replicate:FireServer()
	
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end
	Data.UseTool = true
	task.delay(9, function() Data.UseTool = false end)
	
	AnimationUtility.Get(self.Owner.Character, Animations.Shake)
	

	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.DamagePlayer(Player)
	Player.Character.Humanoid:TakeDamage(1)
end


function UseEffect.StartEffect(Player)
	local Character = Player.Character
	local HRP = Character.HumanoidRootPart
	
	local Hit = script.Hit
	local Swing = script.Swing
	local LevelUp = script.LevelUp
	
	--if Player ~= PlayerService.LocalPlayer then
		Hit = script.Hit:Clone()
		Swing = script.Swing:Clone()
		LevelUp = script.LevelUp:Clone()
		LevelUp.Parent = HRP
		Hit.Parent = HRP
		Swing.Parent = HRP
	--end
	
	local IsPlayer = Player == LocalPlayer do
		if IsPlayer then
			Hit.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteGear
			Swing.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteGear
			LevelUp.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteGear
		else
			Hit.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteOtherPlayersMusic
			Swing.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteOtherPlayersMusic
			LevelUp.SoundGroup = ReplicatedStorage.Configs.SoundConfig.MuteOtherPlayersMusic
		end
	end
	
	local SlashEffect = script.Slash:Clone()
	local Nines = script.DamageNum:Clone()
	local Dusting = script.DustingParticle:Clone()
	
	Dusting.Parent = HRP
	Nines.Parent = HRP.RootAttachment
	SlashEffect.Parent = HRP.RootAttachment
	
	
	for i=1, 8 do
		
		Swing:Play() 
		SlashEffect:Emit(1)
		task.wait(.6)
		if not HRP.Parent then return end
		if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then Hit:Play() end
		Nines:Emit(15)
		if Player == PlayerService.LocalPlayer then
			AnimationUtility.Play(Character, Animations.Shake)
			Damage:FireServer()
		end
		task.wait(.56 - (i* 0.08) )
	end
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then LevelUp:Play() end
	Dusting.Enabled = true
	task.wait(2.5)
	if not HRP.Parent then return end
	
	LevelUp:Destroy()
	Hit:Destroy()
	Swing:Destroy()

	Nines:Destroy()
	SlashEffect:Destroy()
	
	task.wait(2.5)
	Dusting.Enabled = false
	task.wait(5)
	Dusting:Destroy()
end


if RunService:IsServer() then
	Replicate.OnServerEvent:Connect(function(Player)
		local Data = PlayerData.GetData(Player)
		if not Data then return end
		
		if Data[script.Name] and (os.clock() - Data[script.Name]) < Cooldown - 2 then return end

		Data[script.Name] = os.clock()
		
		Replicate:FireAllClients(Player)
	end)
	Damage.OnServerEvent:Connect(UseEffect.DamagePlayer)
else
	Replicate.OnClientEvent:Connect(UseEffect.StartEffect)
	LocalPlayer = PlayerService.LocalPlayer
	Data = PlayerData.GetData(LocalPlayer)
end

return UseEffect
