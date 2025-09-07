local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Config = require(script:WaitForChild("Config"))
local WeightedRNG = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("WeightedRNG"))
local DataManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RNGManagers"):WaitForChild("DataManager"))
local AnimationUtility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AnimationUtility"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))

local Server = RunService:IsServer()
local Client = RunService:IsClient()

local Module = {}


function Module.Candy(Player, Reward)
	local Data = PlayerData.GetData(Player)
	
	if not Data.Items[Reward.Item] then
		Data.Items[Reward.Item] = 1
	else
		Data.Items[Reward.Item] += 1
	end
	
	return true
end

function Module.Item(Player, Reward)
	local Data = PlayerData.GetData(Player)

	if not Data.Items[Reward.Item] then
		Data.Items[Reward.Item] = 1
	else
		Data.Items[Reward.Item] += 1
	end
	
	return true
end

function Module.Gear(Player, Reward)
	local Data = PlayerData.GetData(Player)
	
	local HasTool = DataManager.AddTool(Player, Reward)
	
	if HasTool then
		Module.Item(Player, {Item = "Monster Candy", Amount = math.random(1, 3)})
		
		return true
	end
end

function Module.Aura(Player, Reward)
	local Data = PlayerData.GetData(Player)
	
	local HasAura = DataManager.AddToIndex(Player, Reward)
	
	if HasAura then
		Module.Item(Player, {Item = "Monster Candy", Amount = math.random(10, 20)})
		
		return true
	end
end

function Module.Interact(Player)
	if not Player.Parent then warn("Missing Player") return end
	local Data = PlayerData.GetData(Player)
	
	if Server then
		local Rarity = WeightedRNG.CalculateRng(Config.Rarities)
		local Reward = WeightedRNG.RandomChance(Config.Choices[Rarity])
		
		local IsCandy = Module[Rarity](Player, Reward)
		
		script.StartClientEffects:FireClient(Player, Reward.Item or Reward, IsCandy)
	end
	
	return true
end




local RandomObj = Random.new()

local function UIEffect(Player)
	local PlayerGui = Player.PlayerGui
	local Effect = PlayerGui:WaitForChild("ScreenEffects"):WaitForChild("Canvas")
	
	script.SpellCast:Play()
	for i=1, 10 do
		local CandyUI = script.Candy:Clone()
		CandyUI.Position = UDim2.fromScale(CandyUI.Position.X.Scale - RandomObj:NextNumber(-.1, .1), CandyUI.Position.Y.Scale - RandomObj:NextNumber(-.1, .1))
		CandyUI.Parent = Effect
		
		CandyUI.Sparkle:Play()
		
		local Tween = TweenService:Create(CandyUI, TweenInfo.new(RandomObj:NextNumber(1, 2), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(0.899,0.844)})
		Tween:Play()
		Tween.Completed:Once(function()
			CandyUI:Destroy()
		end)
		task.wait(5/60)
	end
	
	task.wait(1)
end


function Module.Chance(Reward, IsCandy)
	local LocalPlayer = Players.LocalPlayer
	local HalloweenRoll = LocalPlayer.PlayerGui.RewardsInterface.Canvas.RollDisplay
	
	local Data = PlayerData.GetData(LocalPlayer)
	
	Utility.HideGui(LocalPlayer, {LocalPlayer.PlayerGui.RollingInterface}, "SpamtonRolling")
	ReplicatedStorage.Configs.SoundConfig.RollMuted.Volume = 0
	script["Asgore- EyeFlash"]:Play()

	local RandomChoices = {}
	
	HalloweenRoll.Shine.Visible = true
	
	task.defer(function()
		while true do
			task.wait()
			if HalloweenRoll.Shine.Visible == false then
				HalloweenRoll.Shine.Rotation = 0
				break 
			end
			HalloweenRoll.Shine.Rotation += 2
		end
	end)
	
	TweenService:Create(HalloweenRoll.Shine, TweenInfo.new(1), {ImageTransparency = .5}):Play()
	
	script.Computer:Play()
	
	task.wait(2.512)
	
	script.Computer:Pause()
	
	script.Create:Play()
	
	HalloweenRoll.Candy.Reward.Text = Reward
	HalloweenRoll.Candy.Visible = true
	
	TweenService:Create(HalloweenRoll.Candy.Reward, TweenInfo.new(1), {TextTransparency = 0}):Play()
	TweenService:Create(HalloweenRoll.Candy, TweenInfo.new(1), {ImageTransparency = 0}):Play()
	
	script.Saved:Play()
	
	task.wait(3)
	
	TweenService:Create(HalloweenRoll.Candy.Reward, TweenInfo.new(1), {TextTransparency = 1}):Play()
	TweenService:Create(HalloweenRoll.Candy, TweenInfo.new(1), {ImageTransparency = 1}):Play()
	TweenService:Create(HalloweenRoll.Shine, TweenInfo.new(1), {ImageTransparency = 1}):Play()
	
	script["Undertale- Vaporized"]:Play()
	
	task.wait(1)
	
	HalloweenRoll.Candy.Reward.Text = ""
	HalloweenRoll.Candy.Visible = false
	HalloweenRoll.Shine.Visible = false
	
	if IsCandy then
		UIEffect(LocalPlayer)
	end
	
	Utility.UnHideGui(LocalPlayer, {LocalPlayer.PlayerGui.RollingInterface}, "SpamtonRolling")
	if Data["Roll Muted"] then
		ReplicatedStorage.Configs.SoundConfig.RollMuted.Volume = 0
	else
		ReplicatedStorage.Configs.SoundConfig.RollMuted.Volume = .5
	end
	
	Data.SpamtonRollInProgress = false
end


if Server then
	
else
	script.StartClientEffects.OnClientEvent:Connect(Module.Chance)
end



return Module
