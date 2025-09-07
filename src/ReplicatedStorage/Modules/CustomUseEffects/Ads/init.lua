local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage.PlayerData)

local RandomObj = Random.new()

local Debounce = false
local Cooldown = 2

local UseEffect = {}

function UseEffect.SetUp()

end

local Goal = {}
Goal.Size = UDim2.fromScale(0.273, 0.343)

function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end
	Data.UseTool = true
	
	for i=1, 3 do
		local Ad = script.Ad:Clone()
		Ad.Position = UDim2.fromScale(RandomObj:NextNumber(.136, .836), RandomObj:NextNumber(.171, .827))
		Ad.Parent = self.Owner.PlayerGui.ScreenEffects.Canvas
		
		local Tween =TweenService:Create(Ad, TweenInfo.new(.8), Goal)
		Tween:Play()
		task.wait(.3)
	end
	
	Data.UseTool = false
	task.wait(Cooldown)
	Debounce = false
end


return UseEffect
