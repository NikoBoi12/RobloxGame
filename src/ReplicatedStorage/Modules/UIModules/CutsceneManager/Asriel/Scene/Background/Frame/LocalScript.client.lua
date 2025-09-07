local TweenService = game:GetService("TweenService")

local t = 5; --how long does it take to go through the rainbow

local tick = tick
local fromHSV = Color3.fromHSV

local Max = 1/.1

local RandomObj = Random.new()

for i=1, Max do
	local Clone = script.Frame:Clone()
	Clone.ZIndex = i
	Clone.LayoutOrder = i
	local OldSizeX = Clone.Image.Size.X.Scale
	local OldSizeY = Clone.Image.Size.Y.Scale
	Clone.Image.Size = UDim2.fromScale(Clone.Image.Size.X.Scale*i, Clone.Image.Size.Y.Scale)
	local DeltaSizeX = Clone.Image.Size.X.Scale - OldSizeX
	local DeltaSizeY = Clone.Image.Size.Y.Scale - OldSizeY
	Clone.Image.Position = UDim2.new((Clone.Image.Position.X.Scale + DeltaSizeX/2), 0, (Clone.Image.Position.Y.Scale + DeltaSizeY/2) , 0)
	Clone.Parent = script.Parent
	
	--+ RandomObj:NextNumber(0, DeltaSizeY/2)
	
	task.defer(function()
		while true do
			local Tween = TweenService:Create(Clone.Image, TweenInfo.new(6, Enum.EasingStyle.Linear), {ImageRectOffset = Vector2.new(0, 0)})
			Tween:Play()
			Tween.Completed:Wait()
			Clone.Image.ImageRectOffset = Vector2.new(512, 0)
		end
	end)
end

local Guis = script.Parent:GetChildren()

while true do
	task.wait()
	if not script.Parent then break end
	local Hue = tick() % t / t
	local Color = fromHSV(Hue, 1, 1)
	
	for _, Gui in Guis do
		if Gui:IsA("Frame") then
			Gui.Image.ImageColor3 = Color
		end
	end
end