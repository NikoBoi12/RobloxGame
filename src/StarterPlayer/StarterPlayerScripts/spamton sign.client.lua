local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Get the MeshPart inside the "spamton sign" model
local meshPart = workspace:WaitForChild("spamton sign"):WaitForChild("spamtonsign") -- Replace with actual part name

-- Optional offset to fix forward-facing direction
local yOffset = 90 -- adjust to 0, 90, -90, or 180 based on how the mesh is oriented

RunService.RenderStepped:Connect(function()
	local partPos = meshPart.Position
	local playerPos = camera.CFrame.Position

	local direction = (Vector3.new(playerPos.X, partPos.Y, playerPos.Z) - partPos).Unit
	local lookAt = CFrame.new(partPos, partPos + direction)

	local _, y, _ = lookAt:ToEulerAnglesYXZ()
	meshPart.CFrame = CFrame.new(partPos) * CFrame.Angles(0, y + math.rad(yOffset), 0)
end)
