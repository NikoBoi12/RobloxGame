local t = 5; --how long does it take to go through the rainbow

local tick = tick
local fromHSV = Color3.fromHSV
local RunService = game:GetService("RunService")
local Frame = script.Parent

while true do
	task.wait()
	if not script.Parent then break end
	local Hue = tick() % t / t
	local Color = fromHSV(Hue, 1, 1)
	Frame.BackgroundColor3 = Color
end