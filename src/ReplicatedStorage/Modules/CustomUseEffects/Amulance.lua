local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DebrisService = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local PlayerData = require(ReplicatedStorage.PlayerData)

local Ambulance = script.MeshPart
local Replicate = script.Replicate

local Debounce = false

local UseEffect = {}

function UseEffect.SetUp()
	
end


function UseEffect.Use(self)
	if Debounce == false then
		Debounce = true
		local Character = self.Owner.Character
		local Ambulance = Ambulance:Clone()

		local Data = PlayerData.GetData(self.Owner)
		if not Data then return end
		Data.UseTool = true
		
		Ambulance.CFrame = Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 50)
		Ambulance.CFrame = CFrame.lookAt(Ambulance.Position, Character.HumanoidRootPart.Position)
		Ambulance.Parent = workspace

		local Goal = {}
		Goal.Position = Character.HumanoidRootPart.Position + Vector3.new(0, 1, 0)

		local Tween = TweenService:Create(Ambulance, TweenInfo.new(2), Goal)
		Ambulance.Siren:Play()
		Tween:Play()
		Tween.Completed:Wait()

		task.wait(5)

		Ambulance.Anchored = false

		DebrisService:AddItem(Ambulance, 2)
		
		Data.UseTool = false
		
		task.wait(3)
		Debounce = false
	end

end


return UseEffect
