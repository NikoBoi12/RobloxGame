local TweenService = game:GetService("TweenService")

local Button = script.Parent.ExitButton

local Ads = {17695714844, 17695684399, 17695600723, 17695528639}
script.Parent.Image = "rbxassetid://"..Ads[math.random(1, #Ads)]

local Goal = {}
Goal.Size = UDim2.fromOffset(0, 0)

local AdRemoving = false

local function RemoveAd()
	if AdRemoving then return end
	AdRemoving = true
	local Tween = TweenService:Create(script.Parent, TweenInfo.new(.5), Goal)
	Tween:Play()
	Tween.Completed:Wait()

	script.Parent:Destroy()
end

Button.Activated:Once(function()
	RemoveAd()
end)

task.wait(10)

RemoveAd()