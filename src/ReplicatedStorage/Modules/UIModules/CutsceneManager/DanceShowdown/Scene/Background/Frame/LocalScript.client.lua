local TweenService = game:GetService("TweenService")

local Gui = script.Parent

local Colors = {Color3.fromRGB(255, 55, 128), Color3.fromRGB(22, 255, 69), Color3.fromRGB(58, 97, 255)}

local Count = 1


task.defer(function()
	while true do
		if Count > #Colors then Count = 1 end
		Gui.ImageLabel.ImageColor3 = Colors[Count]
		Count += 1
		task.wait(5)
	end
end)


TweenService:Create(Gui, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = -123}):Play()