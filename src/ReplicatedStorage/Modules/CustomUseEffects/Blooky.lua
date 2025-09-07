local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local AnimationUtility = require(ReplicatedStorage.Modules.AnimationUtility)

local Debounce = false
local Cooldown = 5

local UseEffect = {}

function UseEffect.SetUp()
	
end


function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	
	AnimationUtility.Play(self.Owner.Character, 18283643136)
	
	task.wait(Cooldown)
	Debounce = false
end


return UseEffect
