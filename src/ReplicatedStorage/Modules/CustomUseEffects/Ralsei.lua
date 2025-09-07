local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local PlayerData = require(ReplicatedStorage.PlayerData)
local AnimationUtil = require(ReplicatedStorage.Modules.AnimationUtility)
local AbilityAnimConfig = require(ReplicatedStorage.Configs.AbilityAnimConfig)

local Functions = require(ReplicatedStorage.Modules.SolarFunctions.Functions)

local Debounce = false
local Cooldown = 8

local LocalPlayer = Players.LocalPlayer

local SFX = ReplicatedStorage.Storage.SFX
local SoundConfig = ReplicatedStorage.Configs.SoundConfig

local UseEffect = {}

local anim = script.Sing

function UseEffect.SetUp()

end


function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	UseEffect.StartEffect(self.Owner)
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.StartEffect(Player:Player)
	local Character:Model = Player.Character
	local Humanoid:Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Order = Character:GetAttribute("RalseiSingOrder") or 1
	local IsPlayer = Player == LocalPlayer
	local ws = Humanoid.WalkSpeed
	local Data = PlayerData.GetData(Player)
	
	if IsPlayer then
		Humanoid.WalkSpeed = 0
	end
	
	SoundConfig.MusicMuted.Volume = 0
	
	local Animation = AnimationUtil.Get(Character, 86226096677417)
	local att = script.Part.Sing:Clone();
	att.Parent = Character.Head
	Animation:Play()

	local sfx:Sound = 	Functions.PlaySound(SFX.Effects.Ralsei["Sing"..Order], Character.PrimaryPart, IsPlayer and SoundConfig.MuteGear or SoundConfig.MuteOtherPlayersMusic, true) :: Sound
	sfx.Parent = Character.PrimaryPart;
	sfx:Play();
	if Order == 1 then
		Character:SetAttribute("RalseiSingOrder", 2)
	else
		Character:SetAttribute("RalseiSingOrder", 1)
	end
	sfx.Ended:Once(function()
		if IsPlayer then
			Humanoid.WalkSpeed = ws;
		end
		SoundConfig.MusicMuted.Volume = Data["Music Muted"] == true and 0 or 0.5
		sfx:Destroy();
		att:Destroy();
		Animation:Stop();
		Animation:Destroy();
	end)

end

return UseEffect
