local Module = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ReplicatedStorage.PlayerData)

if RunService:IsServer() then

else  -- IsClient
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local Mouse = Player:GetMouse()

	function Module.GetMousePosition(IgnoreParams)
		local Origin, Direction = Mouse.UnitRay.Origin, Mouse.UnitRay.Direction*1000
		local MouseIgnoreParams = RaycastParams.new()
		MouseIgnoreParams.FilterDescendantsInstances = IgnoreParams or {} -- Ignores certain things
		MouseIgnoreParams.FilterType = Enum.RaycastFilterType.Exclude
		local Result = workspace:Raycast(Origin, Direction, MouseIgnoreParams)
		local Position = Result and Result.Position
		if Position == nil then
			Position = Origin + Direction * 1000
		end
		return Position, Result
	end
	
	function Module.FindTarget(Data, Mouse)
		local TargetPos = nil

		if Data.Target then
			TargetPos = Data.Target.Position
		else
			local MousePos = Module.GetMousePosition()
			TargetPos = MousePos
		end
		return TargetPos
	end
	
	
	function Module.HideGui(Player, Guis, Name)
		local Data = PlayerData.GetData(Player)
		if not Data then return end
		for _, Gui in Guis do
			if not Data[Gui] then
				Data[Gui] = {}
			end
			
			local Bool = true
			for i, v in Data[Gui] do
				if v then
					Bool = false
					break
				end		
			end
			if Bool then
				if Gui:IsA("ScreenGui") then
					Gui.Enabled = false
				else
					Gui.Visible = false
				end
			end
			
			Data[Gui][Name] = true
		end
	end
	
	function Module.UnHideGui(Player, Guis, Name)
		local Data = PlayerData.GetData(Player)
		if not Data then return end
		for _, Gui in Guis do
			Data[Gui][Name] = nil
			
			local Bool = true
			for i, v in Data[Gui] do
				if v then
					Bool = false
					break
				end		
			end
			if Bool then
				if Gui:IsA("ScreenGui") then
					Gui.Enabled = true
				else
					Gui.Visible = true
				end
			end
		end
	end
end


function Module.Copy(Value)
	if type(Value) == "table" then
		local NewTable = {}

		for i, v in Value do
			NewTable[Module.Copy(i)] = Module.Copy(v)
		end

		return NewTable
	else
		return Value
	end
end

function Module.Factory(Class)
	local Object = {}

	for Property,Value in Class do
		if Property ~= "new" then
			Object[Property] = Module.Copy(Value)
		end
	end

	return Object
end


function Module.Inherit(Object, Class)
	for Property,Value in Class do
		if Object[Property] then continue end

		Object[Property] = Value
	end
end


function Module.Inherit2(Object,Class)
	for Property,Value in Class do
		if Object[Property] == nil then
			Object[Property] = Value
		end
	end

	return Object
end


function Module.IsArray(Table)
	if Table[1] then return true else return false end
end


function Module.GeneratePointsOnCircle(Slices, Center, Radius)
	local Vectors = {}
	local Iteration = 0
	
	local Slice = 360/Slices
	
	for i=0, 360 - Slice, Slice do
		local X = Center.x + Radius * math.cos(math.rad(i))
		local Y = Center.y + Radius * math.sin(math.rad(i))
	
		table.insert(Vectors, UDim2.fromScale(X, Y))
	end
	

	return Vectors
end


function Module.GetGroundFromPlayer(Character, IgnoreParams)
	local HRP = Character:FindFirstChild("HumanoidRootPart")
	
	local FilterList  = {Character, unpack(IgnoreParams or {})}
	
	local RayCastParams = RaycastParams.new()
	
	RayCastParams.FilterDescendantsInstances = FilterList
	RayCastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local RayCast = workspace:Raycast(HRP.Position, Vector3.new(0, -1, 0) * 20, RayCastParams)
	
	if RayCast then
		return RayCast.Position, RayCast
	else
		return Vector3.new(HRP.Position.X, Character:GetPivot().Position.Y - Character:GetExtentsSize().Y, HRP.Position.Z), nil
	end
end


function Module.Time(Distance, Speed) -- Distance/Speed = Time
	local Time = Distance/Speed
	return Time
end


function Module.PartsInHitBox(HitBox, Humanoid)
	local AlreadyDamaged = {}
	local Enemies = {}
	
	local GetParts = workspace:GetPartsInPart(HitBox)
	
	for i, Parts in GetParts do
		
		local FindPart = Parts.Parent
		
		if FindPart:FindFirstChild("Humanoid") == Humanoid or FindPart.Parent:FindFirstChild("Humanoid") == Humanoid then
			continue
		end

		local EnemyHumanoid = FindPart:FindFirstChild("Humanoid") or FindPart.Parent:FindFirstChild("Humanoid")
		
		if EnemyHumanoid and AlreadyDamaged[EnemyHumanoid] == nil then
			AlreadyDamaged[EnemyHumanoid] = true
			table.insert(Enemies, EnemyHumanoid)
		end
	end
	
	return Enemies
end


function Module.PlayAudio(Audio)
	if Audio == nil then return end
	Audio:Play()
end

function Module.FireToOtherClients(Remote,Player,...)
	if RunService:IsServer() then
		for _,OtherPlayer in Players:GetPlayers() do
			--if Player == OtherPlayer then continue end
			Remote:FireClient(OtherPlayer, OtherPlayer, ...)
		end
	else
		Remote:FireServer(...)
	end
end


function Module.DisconnectAll(Array)
	for _, Connection in Array do
		Connection:Disconnect()
	end
end


function Module.CheckForObstacles(TargetHRP, Speed, DeltaTime)
	local Params = RaycastParams.new()

	local IgnoreList = {}

	for _, Character in workspace.Entities:GetChildren() do
		table.insert(IgnoreList, Character)
	end
	for _, Dummy in workspace.Dummies:GetChildren() do
		table.insert(IgnoreList, Dummy)
	end

	Params.FilterDescendantsInstances = IgnoreList
	Params.FilterType = Enum.RaycastFilterType.Exclude
	
	local Distance = -TargetHRP.CFrame.LookVector * (Speed+50) * (DeltaTime*2)
	
	--[[local Visual = script.Visual:Clone()
	
	Visual.CFrame = TargetHRP.CFrame + Distance
	Visual.Parent = workspace]]
	
	local RayCast = workspace:Raycast(TargetHRP.Position, Distance, Params)

	return RayCast
end


function Module.ConvertSeconds(seconds)
	local days = math.floor(seconds / (24 * 3600))
	seconds = seconds % (24 * 3600)
	local hours = math.floor(seconds / 3600)
	seconds = seconds % 3600
	local minutes = math.floor(seconds / 60)
	local remainingSeconds = seconds % 60

	local formattedTime = ""
	if days > 0 then
		formattedTime = string.format("%02d", days) .. ":"
	end

	if hours > 0 then
		formattedTime = formattedTime .. string.format("%02d", hours) .. ":"
	end

	formattedTime = formattedTime .. string.format("%02d:%02d", minutes, remainingSeconds)

	return formattedTime
end


do
	function EventConnect(self,CallBack)
		local Connection; Connection = {
			Disconnect = function()
				self.Tasks[Connection] = nil
			end
		}
		self.Tasks[Connection] = CallBack
		return Connection
	end


	function EventFire(self,...)
		local Args = {...}
		for i,CallBack in self.OnceTask do
			task.defer(CallBack,...)
			self.OnceTask[i] = nil
		end

		for _,CallBack in self.Tasks do
			task.defer(function()
				CallBack(unpack(Args))
			end)
		end
	end

	function EventOnce(self,CallBack)
		local Connection; Connection = {
			Disconnect = function()
				self.OnceTask[Connection] = nil
			end,
		}
		self.OnceTask[Connection] = CallBack
		return Connection
	end

	function Module.NewEvent()
		return {
			Tasks = {},
			OnceTask = {},

			Connect = EventConnect,
			Once = EventOnce,
			Fire = EventFire,
		}
	end
end


function Module.GenerateUID()
	return HttpService:GenerateGUID(false)
end




return Module

