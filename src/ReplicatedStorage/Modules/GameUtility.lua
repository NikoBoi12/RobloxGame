local Module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local PlayerDatabase = require(ReplicatedStorage.PlayerData)


function Module.Lerp(a, b, t)
	return a + (b - a) * t
end

function Module.GetRandomItem(Example)
	-- Gets max probability
	local Total = 0
	for Name,Probability in pairs(Example) do
		Total += Probability
	end

	local Random = math.random(Total)
	local Sum = 0
	for Name,Probability in pairs(Example) do
		Sum += Probability
		if Random <= Sum then
			return Name
		end
	end
end


function Module.RetryFunction(MaxAttempts,RetryDelay,Function,...)
	MaxAttempts = MaxAttempts or 3
	RetryDelay = RetryDelay or 1
	
	local Tries = 0
	local Success,Return = false,nil

	while Tries < MaxAttempts and not Success do
		Tries = Tries + 1
		Success,Return = pcall(Function,...)
		if not Success then task.wait(RetryDelay) warn("RetryFunction Failed:",Return, debug.traceback()) end
	end
	
	if not Success then return end
	
	return Return, Success
end

local RetryDelay = 0.5
local MaxAttempts = 5


function Module.Retry(CallBack,FunctionName,AttemptNumber)
	local Args = {pcall(CallBack)}
	if not Args[1] then
		if AttemptNumber == MaxAttempts then
			warn("Retry failed for:",FunctionName,"Message:",Args[2])
			return false
		else
			wait(RetryDelay)
			return Module.Retry(CallBack,FunctionName,(AttemptNumber or 1)+1)
		end
	else
		return unpack(Args)
	end
end

function Module.EmitClassicParticle(Position:Vector3, Color:BrickColor, Amount:number, LifeTime:number)
	Amount = Amount or math.random(3, 5)
	Color = Color or BrickColor.Red()
	LifeTime = LifeTime or 1

	for _ = 1, Amount do
		local blood = Instance.new("Part")
		blood.Size = Vector3.new(1, 0.2, 1)
		blood.BrickColor = Color
		blood.Position = Position + Vector3.new(math.random(-1.5, 1.5), math.random(-1.5, 1.5), math.random(-1.5, 1.5))
		blood.Velocity = Vector3.new(math.random(-10, 10), math.random(-10,10), math.random(-10, 10))
		blood.RotVelocity = Vector3.new(math.random(-3, 3), math.random(-3, 3), math.random(-3, 3))
		blood:AddTag("RaycastIgnore")
		blood.CollisionGroup = "Blood"
		blood.Parent = workspace.ClientBin

		game.Debris:AddItem(blood, LifeTime)
	end
end

function Module.GetHumanoid(parent)
	if parent and parent ~= workspace then
		local hum = parent:FindFirstChildOfClass("Humanoid")
		return (hum ~= nil and hum) or Module.GetHumanoid(parent.Parent)
	end
	return nil
end

function Module.FormatNumberWithCommas(number)
		-- Convert the number to a string
		local numberStr = tostring(number)

		-- Reverse the string to insert commas from right to left
		local reversedStr = string.reverse(numberStr)

		local formattedStr = ""

		for i = 1, #reversedStr do
			formattedStr = formattedStr .. reversedStr:sub(i, i)
			if i % 3 == 0 and i < #reversedStr then
				formattedStr = formattedStr .. ","
			end
		end

		-- Reverse the string again to get the final result
		return string.reverse(formattedStr)
	end

if RunService:IsServer() then
	
else -- IsClient
	local Player = Players.LocalPlayer
	local Mouse = Player:GetMouse()
	
	function Module.GetMouseResult()
		local Params = RaycastParams.new()
		Params.FilterDescendantsInstances = {workspace.ClientBin,workspace.HazardousGas,Player.Character, unpack(game:GetService("CollectionService"):GetTagged("RaycastIgnore"))}
		
		local Result = workspace:Raycast(Mouse.UnitRay.Origin,Mouse.UnitRay.Direction*1000,Params)
		return Result, Result and Result.Position or Mouse.UnitRay.Origin + Mouse.UnitRay.Direction*1000
	end
end

return Module
