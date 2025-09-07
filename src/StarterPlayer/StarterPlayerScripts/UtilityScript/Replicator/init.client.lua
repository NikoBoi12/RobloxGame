local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Abilities = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CustomUseEffects"):WaitForChild("AnimEventEffects")

local Animations = {}

local function RunReplication(Character, Module, Function, Animation)
	local LocalPlayer = Players.LocalPlayer
	
	require(Abilities[Module])[Function](Character, Animation)
end


local function BindAnimation(Character)
	local Humanoid = Character:WaitForChild("Humanoid")
	
	Animations[Character] = {}
	
	local AnimationTable = Animations[Character]["Animations"]
	
	Humanoid.Animator.AnimationPlayed:Connect(function(Animation)
		if Animations[Character][Animation] then return end
		
		Animations[Character][Animation] = Animation:GetMarkerReachedSignal("CustomAbility"):Connect(function(Params)
			local Arguments = string.split(Params, ",")
			
			local Module = Arguments[1]
			local Function = Arguments[2]
			
			RunReplication(Character, Module, Function, Animation)
		end)
	end)
end


local function NewPlayer(Player)
	if Player.Character then
		BindAnimation(Player.Character)
	end
	Player.CharacterAdded:Connect(BindAnimation)
end

Players.PlayerAdded:Connect(NewPlayer)

for i, Player in Players:GetPlayers() do
	task.defer(function()
		NewPlayer(Player)
	end)
end