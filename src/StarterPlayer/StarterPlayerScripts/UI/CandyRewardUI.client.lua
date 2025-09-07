local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local RewardsManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RewardsManager"))

local DailyRewardClient = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DailyReward")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Effect = PlayerGui:WaitForChild("ScreenEffects"):WaitForChild("Canvas")

local RandomObj = Random.new()

local function UIEffect(Check)
	if Check then
		script.No:Play()
		return
	end
	script.SpellCast:Play()
	for i=1, 10 do
		local CandyUI = script.Candy:Clone()
		CandyUI.Position = UDim2.fromScale(CandyUI.Position.X.Scale - RandomObj:NextNumber(-.1, .1), CandyUI.Position.Y.Scale - RandomObj:NextNumber(-.1, .1))
		CandyUI.Parent = Effect
		
		local Tween = TweenService:Create(CandyUI, TweenInfo.new(RandomObj:NextNumber(1, 2), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(0.899,0.844)})
		Tween:Play()
		Tween.Completed:Once(function()
			CandyUI:Destroy()
		end)
		task.wait(5/60)
	end

end

DailyRewardClient.OnClientEvent:Connect(UIEffect)
