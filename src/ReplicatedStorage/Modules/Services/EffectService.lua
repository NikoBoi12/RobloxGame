local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local EffectConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("EffectConfig"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local Replicate = script:WaitForChild("Replicate")

local module = {
	List = {}
}

local Effect = {}

function module.CreateEffect(Player, Packet)
	local self = Utility.Factory(Effect)
	self.Config = EffectConfig[Packet.EffectName]
	self.Owner = Packet.Owner or Player
	self.UID = Packet.UID or Utility.GenerateUID()
	self.EffectName = Packet.EffectName
	self.Name = Packet.Name
	self.Model = self.Config.Effect
	self.RandomSeed = Packet.RandomSeed or math.random(99999)
	self.Connections = {}
	
	module.List[self.UID] = self
	
	if RunService:IsServer() then
		Replicate:FireAllClients(Player, self:CreatePacket())
		table.insert(self.Connections, Players.PlayerAdded:Connect(function(NewPlayer)
			Replicate:FireClient(NewPlayer, Player, self:CreatePacket())
		end))
	else 
		self:Start() 
	end
	
	return self
end


function Effect:Start()
	if not self.Owner and not self.Owner.Character then return end
	local Character = self.Owner.Character
	local HRP = Character:WaitForChild("HumanoidRootPart")
	
	self.Model = self.Model:Clone()
	if self.Model.PrimaryPart then
		self.Model.PrimaryPart.CFrame = HRP.CFrame
	else
		self.Model:PivotTo(HRP.CFrame)
	end
	
	if self.Config.FollowType then
		self.FollowEffect = require(ReplicatedStorage.Components.FollowComp[self.Config.FollowType]).new(self.Owner, self:FollowPacket())
		
		task.defer(function()
			self.FollowEffect:StartFollow()
		end)
	end

	self.Model.Parent = HRP
	
	for _, Emitter in self.Model:GetDescendants() do
		if Emitter:IsA("ParticleEmitter") and Emitter.Enabled == true then
			Emitter:Emit(1)
		end
	end
	
	local Part = self.Model.PrimaryPart or self.Model:FindFirstChildWhichIsA("BasePart")
	local Module = Part:FindFirstChildWhichIsA("ModuleScript")
	
	if Module then
		task.defer(function()
			local Custom = require(Module)
			local Packet = Custom.CreatePacket(self)
			Custom.Start(Packet)
		end)
	end
end


function Effect:CreatePacket()
	return {
		Owner = self.Owner,
		EffectName = self.EffectName,
		Name = self.Name,
		UID = self.UID,
		RandomSeed = self.RandomSeed,
		AuraUID = self.UID,
	}

end

function Effect:FollowPacket()
	return {
		Owner = self.Owner,
		Name = self.EffectName,
		EffectUID = self.UID,
		Model = self.Model,
	}
end


function Effect:Destroy()
	module.List[self.UID] = nil
	
	for _, Connection in self.Connections do Connection:Disconnect() end
	
	if RunService:IsServer() then
		script.DestroyEffect:FireAllClients(self.UID)
	else
		self.Model:Destroy()
	end
	
	self = nil
end


if RunService:IsServer() then

else
	script.DestroyEffect.OnClientEvent:Connect(function(UID)
		local Effect = module.List[UID]
		local TotalTime = 0
		
		while Effect == nil do
			local DeltaTime = task.wait()
			TotalTime += DeltaTime
			
			Effect = module.List[UID]
			
			if TotalTime >= 10 then warn("UID not found") return end
		end
		Effect:Destroy()
	end)
	Replicate.OnClientEvent:Connect(module.CreateEffect)
end

return module