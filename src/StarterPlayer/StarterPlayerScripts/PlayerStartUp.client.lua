local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InventoryGui = Menus:WaitForChild("Inventory")
local ViewPort = InventoryGui:WaitForChild("GearUI"):WaitForChild("ViewportFrame")

local function StartViewPort()
	local Rig = ReplicatedStorage.Storage.Misc.Rig:Clone()

	Rig:PivotTo(Character:GetPivot() + Vector3.new(0, 200, 0))
	Rig.Parent = workspace

	local Description = Humanoid:GetAppliedDescription()
	Rig.Humanoid:ApplyDescription(Description)
	
	task.wait()

	local NewCamera = Instance.new("Camera")
	NewCamera.CFrame = script.CamCframe.Value
	ViewPort.CurrentCamera = NewCamera
	
	

	Rig:PivotTo(ViewPort.CharacterLocation.Value)
	Rig.Parent = ViewPort
end

StartViewPort()

require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("UIModules"):WaitForChild("UI")):Initialize()