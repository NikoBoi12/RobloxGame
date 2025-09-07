local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")

local PlayerData = require(ReplicatedStorage.PlayerData)

local Utility = require(ReplicatedStorage.Modules.Utility)

local Model = script.Blaster
local Replicate = script.Replicate

local LocalPlayer
local Data

local Bindable = Instance.new("BindableEvent")

local OnCooldown = false

local Cooldown = 10

local UseEffect = {}


function UseEffect.SetUp()
	
end


function UseEffect.Use(self)
	if OnCooldown == false then
		OnCooldown = true	
		
		local Pos = Utility.GetMousePosition()
		Replicate:FireServer(Pos)
		
		local Data = PlayerData.GetData(self.Owner)
		if not Data then return end
		Data.UseTool = true
		task.delay(5, function() Data.UseTool = false end)
	
		task.wait(Cooldown)
		OnCooldown = false
	end
end


function UseEffect.StartEffect(Player, Pos)
	local Blaster = Model:Clone()
	local Character = Player.Character
	local HRP = Character:FindFirstChild("HumanoidRootPart")
	
	if not HRP then return end
	
	Blaster:PivotTo(HRP.CFrame + Vector3.new(0, 10, 0))
	Blaster:PivotTo(CFrame.lookAt(Blaster:GetPivot().Position, Pos))
	Blaster.Parent = workspace
	
	UseEffect.AnimateBlaster(Blaster, Pos, Player)
end


function UseEffect.StartBlast(Blaster, Pos, Tracks)
	local OutLine = script.OutLine:Clone()
	local Blast = script.Blast:Clone()

	local BlastSize = Blast.Size
	local OutLineSize = OutLine.Size
	
	local Magnitude = (Pos - Blaster.Main.Position).Magnitude + 8
	
	if Magnitude > 50 then
		Magnitude = 50
	end
	
	local BlastGoal = Vector3.new(Magnitude - 1, 8, 8)
	local OutlineGoal = Vector3.new(Magnitude, 9, 9)

	Blast.CFrame = Blaster.Main.CFrame * CFrame.Angles(0, math.rad(-90), 0)
	OutLine.CFrame = Blaster.Main.CFrame * CFrame.Angles(0, math.rad(-90), 0)
	
	task.wait()
	
	for i, v in Blaster.Main.Attachment:GetChildren() do
		v.Enabled = true
		v:Emit()
	end
	
	Blast.Parent = workspace
	OutLine.Parent = workspace
	
	for i = 0,1,0.05 do
		local DeltaTime = task.wait()

		local BlastLerp = BlastSize:Lerp(BlastGoal,i)
		local OutLineLerp = OutLineSize:Lerp(OutlineGoal,i)

		Blast.CFrame *= CFrame.new(-(BlastLerp.X - Blast.Size.X) / 2, 0, 0)
		Blast.Size = BlastLerp

		OutLine.CFrame *= CFrame.new(-(OutLineLerp.X - OutLine.Size.X) / 2, 0, 0)
		OutLine.Size = OutLineLerp
	end
	
	local TotalTime = 0
	local Goal = Vector3.new(1.5, 1.5, 1.5)

	while TotalTime ~= 2 do

		BlastSize = Blast.Size
		OutLineSize = OutLine.Size

		for i = 0,1,0.04 do
			local DelaTime = task.wait()

			local BlastLerp = BlastSize:Lerp(BlastSize + Goal,i)
			local OutLineLerp = OutLineSize:Lerp(OutLineSize + Goal ,i)


			Blast.Size = BlastLerp
			OutLine.Size = OutLineLerp

			TotalTime = math.min(TotalTime + DelaTime, 2)
			if TotalTime == 2 then
				break
			end 
		end
		
		if Vector3.new(math.abs(Goal.X), math.abs(Goal.Y), math.abs(Goal.Z)) == Goal then
			Goal = Goal - (Goal * 2)
			continue
		end
		Goal = Goal - (Goal * 2)
	end
	
	BlastSize = Blast.Size
	OutLineSize = OutLine.Size
	
	local Goal1 = Vector3.new(BlastSize.X, 2 - 1, 2 - 1)
	local Goal2 = Vector3.new(OutLineSize.X, 2 , 2)
	
	Blaster.Main.Blast:Pause()
	Tracks["BlasterIdle"].Looped = false
	
	OutLine.ParticleEmitter.Enabled = false
	
	for i = 0,1,.01 do
		local BlastLerp = BlastSize:Lerp(Goal1,i)
		local OutLineLerp = OutLineSize:Lerp(Goal2,i)

		Blast.Size = BlastLerp

		OutLine.Size = OutLineLerp
		Blast.Transparency = math.min(Blast.Transparency + .01, 1)
		OutLine.Transparency = math.min(OutLine.Transparency + .01, 1)

		task.wait()
	end
	
	task.delay(6, function() 	OutLine:Destroy() Blast:Destroy() end)
	
	Bindable:Fire()
	
	for i, v in Blaster.Main.Attachment:GetChildren() do
		v.Enabled = false
	end
end


function UseEffect.DespawnBlaster(Blaster)
	local TotalTime = 0

	while true do
		local DeltaTime = task.wait()
		for i, Part in Blaster:GetChildren() do
			if Part:IsA("MeshPart") then
				Part.Transparency = math.min(Part.Transparency + DeltaTime, 1)
				for i, Part in Part:GetChildren() do
					if Part:IsA("MeshPart") or Part:IsA("UnionOperation") then
						Part.Transparency = math.min(Part.Transparency + DeltaTime, 1)
					end
				end
			end
		end
		TotalTime += DeltaTime
		if TotalTime >= 3 then
			break
		end
	end
	
	Blaster:Destroy()
end


function UseEffect.AnimateBlaster(Blaster, Pos, Player)
	local AnimationController = Blaster.AnimationController
	local Animator = AnimationController.Animator
	local Animations = AnimationController.Animations

	local Tracks = {}

	for i, Animations in Animations:GetChildren() do
		local AnimationTrack = Animator:LoadAnimation(Animations)

		Tracks[Animations.Name] = AnimationTrack
	end

	for i, Particle in Blaster.Main.Attachment:GetChildren() do
		Particle.Enabled = true
	end
	
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then Blaster.Main.BlasterCharge:Play() end
	Tracks["BlasterFire"]:Play()
	Tracks["BlasterFire"].Stopped:Wait()
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then Blaster.Main.Blast:Play() end
	Tracks["BlasterIdle"].Looped = true
	Tracks["BlasterIdle"]:Play()

	task.defer(function()
		UseEffect.StartBlast(Blaster, Pos, Tracks)
	end)

	Bindable.Event:Once(function()
		UseEffect.DespawnBlaster(Blaster)
	end)
end



if RunService:IsServer() then
	Replicate.OnServerEvent:Connect(function(Player, Pos)
		local Data = PlayerData.GetData(Player)
		if not Data then return end

		if Data[script.Name] and (os.clock() - Data[script.Name]) < Cooldown - 2 then return end

		Data[script.Name] = os.clock()
		
		Replicate:FireAllClients(Player, Pos)
	end)
else
	Replicate.OnClientEvent:Connect(UseEffect.StartEffect)
	LocalPlayer = PlayerService.LocalPlayer
	Data = PlayerData.GetData(LocalPlayer)
	if not Data then return end
end



return UseEffect
