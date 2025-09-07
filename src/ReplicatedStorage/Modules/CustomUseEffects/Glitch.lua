local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local AnimationUtility = require(ReplicatedStorage.Modules:WaitForChild("AnimationUtility"))
local PlayerData = require(ReplicatedStorage.PlayerData)

local Replicate = script.Replicate

local LocalPlayer
local Data

local Debounce = false
local Cooldown = 25

local UseEffect = {}

function UseEffect.SetUp()
	
end


function UseEffect.Use(self)
	if Debounce then return end
	Debounce = true
	
	Replicate:FireServer()
	
	local Data = PlayerData.GetData(self.Owner)
	if not Data then return end
	Data.UseTool = true
	
	task.delay(9, function() Data.UseTool = false end)
	
	task.wait(Cooldown)
	Debounce = false
end


function UseEffect.StartUi(Player)
	local PlayerGui = Player.PlayerGui
	local ScreenEffects = PlayerGui.ScreenEffects.Canvas
	local UiGradient =  ScreenEffects.StaticOverlay.UIGradient
	
	local OriginalTransparency = UiGradient.Transparency
	
	UiGradient.Transparency = NumberSequence.new(1)
	
	ScreenEffects.StaticOverlay.Playing = true
	ScreenEffects.StaticOverlay.Visible = true
	ScreenEffects.DarkenSides.Visible = true
	
	for i=1, OriginalTransparency.Keypoints[1].Value, -.015 do
		task.wait()
		UiGradient.Transparency = NumberSequence.new(i)
	end
end


function UseEffect.FinishUi(Player)
	local PlayerGui = Player.PlayerGui
	local ScreenEffects = PlayerGui.ScreenEffects.Canvas
	local UiGradient =  ScreenEffects.StaticOverlay.UIGradient

	local OriginalTransparency = UiGradient.Transparency
	
	for i=OriginalTransparency.Keypoints[1].Value, 1, .01 do
		task.wait()
		UiGradient.Transparency = NumberSequence.new(i)
	end
	
	ScreenEffects.StaticOverlay.Playing = false
	ScreenEffects.StaticOverlay.Visible = false
	ScreenEffects.DarkenSides.Visible = false
	UiGradient.Transparency = OriginalTransparency
end


function UseEffect.StartEffect(Player)
	local PlayersFriends = {}
	
	local Sucess, Page = pcall(function() return PlayerService:GetFriendsAsync(Player.UserId) end)
	if Sucess then
		while true do
			for _, FriendInfo in Page:GetCurrentPage() do
				table.insert(PlayersFriends, FriendInfo)
			end

			if Page.IsFinished then
				break
			else
				Page:AdvanceToNextPageAsync()
			end
		end
	else
		return
	end

	local Character = Player.Character
	local HRP = Character.HumanoidRootPart
	
	local FindFriend = PlayersFriends[math.random(1, #PlayersFriends)]
	local FriendCharacter = PlayerService:CreateHumanoidModelFromDescription(PlayerService:GetHumanoidDescriptionFromUserId(FindFriend.Id), Enum.HumanoidRigType.R6)
	
	AnimationUtility.Play(Character, 18461192174)
	
	FriendCharacter:PivotTo((HRP.CFrame * CFrame.new(0, 0, -3)) * CFrame.Angles(0, math.rad(-180), 0))
	
	for _, Part in FriendCharacter:GetDescendants() do
		if Part:IsA("BasePart") then
			Part.CollisionGroup = "Player"
		end
		if Part:IsA("Accessory") then
			if Part.AccessoryType == "Face" then
				Part:Destroy()
			end
		end
	end
	for _, Particle in script.Glitch:GetChildren() do
		local Particle = Particle:Clone()
		Particle.Parent = FriendCharacter.Head
	end
	
	FriendCharacter.Head.face:Destroy()
	FriendCharacter.Head.Mesh.MeshId = ""
	FriendCharacter.Head.Mesh.MeshType = Enum.MeshType.Head
	FriendCharacter.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	
	local Sound = script.Sound:Clone()
	Sound.Parent = FriendCharacter.Head
	
	
	FriendCharacter.Parent = workspace
	if not (Player ~= LocalPlayer and Data.MuteOtherPlayers) then Sound:Play() end
	
	local OriginalWalkSpeed = Character.Humanoid.WalkSpeed
	local OriginalJumpHeight = Character.Humanoid.JumpHeight
	
	if Player == PlayerService.LocalPlayer then
		Character.Humanoid.AutoRotate = false

		Character.Humanoid.WalkSpeed = 0
		Character.Humanoid.JumpHeight = 0
		UseEffect.StartUi(Player)
	end
	
	task.wait(6.011)
	
	local Goal = {}
	Goal.Transparency = 1
	
	for _, Part in FriendCharacter:GetDescendants() do
		if Part:IsA("BasePart") then
			local Tween = TweenService:Create(Part, TweenInfo.new(1.5), Goal)
			Tween:Play()
		end
	end
	task.wait(1.5)
	
	AnimationUtility.Stop(Character, 18461192174)
	
	if Player == PlayerService.LocalPlayer then
		Character.Humanoid.AutoRotate = true
		Character.Humanoid.WalkSpeed = OriginalWalkSpeed
		Character.Humanoid.JumpHeight = OriginalJumpHeight
		UseEffect.FinishUi(Player)
	end
	
	FriendCharacter:Destroy()
end


if RunService:IsServer() then
	Replicate.OnServerEvent:Connect(function(Player)
		local Data = PlayerData.GetData(Player)
		if not Data then return end

		if Data[script.Name] and (os.clock() - Data[script.Name]) < Cooldown - 2 then return end

		Data[script.Name] = os.clock()
		
		Replicate:FireAllClients(Player)
	end)
else
	Replicate.OnClientEvent:Connect(UseEffect.StartEffect)
	LocalPlayer = PlayerService.LocalPlayer
	Data = PlayerData.GetData(LocalPlayer)
end


return UseEffect
