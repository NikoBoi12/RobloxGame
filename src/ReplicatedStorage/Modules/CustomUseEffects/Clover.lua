local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local PlayerData = require(ReplicatedStorage.PlayerData)
local AnimationUtil = require(ReplicatedStorage.Modules.AnimationUtility)
local AbilityAnimConfig = require(ReplicatedStorage.Configs.AbilityAnimConfig)

local Debounce = false
local Cooldown = 10

local UseEffect = {}

function UseEffect.SetUp()

end


function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	UseEffect.StartEffect(self.Owner)
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.StartEffect(Player)
	local Character = Player.Character
	
	AnimationUtil.Play(Character, AbilityAnimConfig.CloverGun)
end

return UseEffect
