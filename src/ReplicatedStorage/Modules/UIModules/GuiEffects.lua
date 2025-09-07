local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RandomObj = Random.new()


local module = {}

function module.CreateFlameParticle(ParticleRef, ParentObj, Info, GoalAdditions)
	local Scale = RandomObj:NextNumber(.5, 1.5)
	
	local Particle = ParticleRef:Clone()
	Particle.Visible = true
	Particle.Size = UDim2.fromScale(Particle.Size.X.Scale * Scale, Particle.Size.Y.Scale)
	Particle.Position = UDim2.new(RandomObj:NextNumber(.1,.9), 0, 1, 0)
	Particle.Parent = ParentObj

	local TargetPosition = UDim2.new(
		Particle.Position.X.Scale - RandomObj:NextNumber(-.2, .2), 
		Particle.Position.X.Offset,
		Particle.Position.Y.Scale - RandomObj:NextNumber(.2, .7),
		Particle.Position.Y.Offset
	)
	
	local Goal = {Position = TargetPosition, Transparency = 1}
	
	if GoalAdditions then
		for Property, Value in GoalAdditions do
			Goal[Property] = Value
		end
	end
	
	local Tween = TweenService:Create(Particle, Info, Goal)
	Tween:Play()

	Tween.Completed:Connect(function()
		Particle:Destroy()
	end)
end


function module.SpawnConeOfParticles(ParticleRef, ParentObj, Info, GoalAdditions)
	local Scale = RandomObj:NextNumber(.5, 1.5)

	local Particle = ParticleRef:Clone()
	Particle.Visible = true
	Particle.Size = UDim2.fromScale(Particle.Size.X.Scale * Scale, Particle.Size.Y.Scale)
	Particle.Position = UDim2.new(RandomObj:NextNumber(.1,.9), 0, 1, 0)
	Particle.Parent = ParentObj

	local TargetPosition = UDim2.new(
		Particle.Position.X.Scale - RandomObj:NextNumber(-.2, .2), 
		Particle.Position.X.Offset,
		Particle.Position.Y.Scale - RandomObj:NextNumber(.2, .7),
		Particle.Position.Y.Offset
	)

	local Goal = {Position = TargetPosition, Transparency = 1}

	if GoalAdditions then
		for Property, Value in GoalAdditions do
			Goal[Property] = Value
		end
	end

	local Tween = TweenService:Create(Particle, Info, Goal)
	Tween:Play()

	Tween.Completed:Connect(function()
		Particle:Destroy()
	end)
end


function module.Shake(Packet)
	local Pos = Packet.Gui.Position

	local TotalTime = 0

	while TotalTime < Packet.Length do
		local DeltaTime = task.wait()
		if not Packet.Gui.Parent then break end
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(Packet.BobbleX.Min, Packet.BobbleX.Max)) * RandomObj:NextNumber(Packet.BobbleX.Min2, Packet.BobbleX.Max2))
		local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(Packet.BobbleY.Min, Packet.BobbleY.Max)) * RandomObj:NextNumber(Packet.BobbleY.Min2, Packet.BobbleY.Max2)) 
		Packet.Gui.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	Packet.Gui.Position = Pos
end


function module.ShakeInfinite(Packet)
	local Pos = Packet.Gui.Position

	local TotalTime = 0

	local KillLoop = {KillLoop = false}
	
	task.defer(function()
		while not KillLoop.KillLoop do
			local DeltaTime = task.wait()
			if not Packet.Gui.Parent then break end
			TotalTime += DeltaTime
			local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(Packet.BobbleX.Min, Packet.BobbleX.Max)) * RandomObj:NextNumber(Packet.BobbleX.Min2, Packet.BobbleX.Max2))
			local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(Packet.BobbleY.Min, Packet.BobbleY.Max)) * RandomObj:NextNumber(Packet.BobbleY.Min2, Packet.BobbleY.Max2)) 
			Packet.Gui.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
		end

		Packet.Gui.Position = Pos
	end)

	return KillLoop
end


function module.ApplyGravity(Packet)
	local Gravity = Packet.Gravity or Vector2.new(0, 5)

	local TotalTime = 0

	local Shards = Packet.CustomForce or {}
	
	if not Packet.CustomForce then
		for _, Shard in ReplicatedStorage.Storage.Gui.Shards:GetChildren() do
			Shards[Shard] = Vector2.new(RandomObj:NextNumber(-2,2), RandomObj:NextNumber(-2,1))
		end
	end

	


	while TotalTime < Packet.Length do
		local Dt = task.wait()
		TotalTime += Dt
		for _, Shard in Packet.Fragments do
			Shards[Shard] += Gravity*Dt
			Shard.Position += UDim2.fromScale(Shards[Shard].X*Dt,Shards[Shard].Y*Dt)
		end
	end
	for _, Shard in Packet.Fragments do
		Shard:Destroy()
	end
end


return module
