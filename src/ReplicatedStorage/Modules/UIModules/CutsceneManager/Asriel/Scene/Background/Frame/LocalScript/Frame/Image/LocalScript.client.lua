local TweenService = game:GetService("TweenService")

local t = 5; --how long does it take to go through the rainbow

local tick = tick
local fromHSV = Color3.fromHSV
local RunService = game:GetService("RunService")
local Frame = script.Parent

task.defer(function()
	while true do
		task.wait()
		if not script.Parent then break end
		local Hue = tick() % t / t
		local Color = fromHSV(Hue, 1, 1)
		Frame.ImageColor3 = Color
	end
end)


while true do
	local Tween = TweenService:Create(script.Parent, TweenInfo.new(5, Enum.EasingStyle.Linear), {ImageRectOffset = Vector2.new(512, 0)})
	Tween:Play()
	Tween.Completed:Wait()
	script.Parent.ImageRectOffset = Vector2.new(0, 0)
end
