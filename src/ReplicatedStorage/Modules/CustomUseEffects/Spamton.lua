local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local PlayerData = require(ReplicatedStorage.PlayerData)
local AnimationUtil = require(ReplicatedStorage.Modules.AnimationUtility)
local AbilityAnimConfig = require(ReplicatedStorage.Configs.AbilityAnimConfig)

local Debounce = false
local Cooldown = 15

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
	local RanNum = math.random(1, 2)
	if RanNum == 1 then
		AnimationUtil.Play(Character, AbilityAnimConfig.SpamCallForSpam)
	else
		AnimationUtil.Play(Character, AbilityAnimConfig.SpamCallForHuman)
	end

end

return UseEffect
