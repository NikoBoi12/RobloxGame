local HttpService = game:GetService("HttpService")

local Module = {}

local RetryDelay = 0.1
local MaxAttempts = 5

for _,SubModule in ipairs(script:GetChildren()) do
	if not SubModule:IsA("ModuleScript") then continue end

	Module[SubModule.Name] = require(SubModule)
end

local function Copy(Value)
	if type(Value) == "table" then
		local NewTable = {}

		for i,v in pairs(Value) do
			NewTable[Copy(i)] = Copy(v)
		end

		return NewTable
	else
		return Value
	end
end

function Module.Retry(CallBack,FunctionName,AttemptNumber,Delay)
	local Args = {pcall(CallBack)}
	if not Args[1] then
		if AttemptNumber == MaxAttempts then
			warn("Retry failed for:",FunctionName,"Message:",Args[2])
			return false
		else
			task.wait(Delay or RetryDelay)
			return Module.Retry(CallBack,FunctionName,(AttemptNumber or 1)+1)
		end
	else
		return unpack(Args)
	end
end

function Module.Factory(Class)
	local Object = {}

	for Property,Value in pairs(Class) do
		if Property ~= "new" then
			Object[Property] = Copy(Value)
		end
	end

	return Object
end

function Module.Inherit(Object,Class)
	for Property,Value in Class do
		if Object[Property] == nil then
			Object[Property] = Value
		end
	end

	return Object
end

function Module.TableCopy(Table,Cache)
	local NewTable = {}
	Cache = Cache or {[Table] = NewTable}

	for Index,Value in pairs(Table) do
		local TypeIndex,TypeValue = type(Index),type(Value)
		if TypeIndex == "table" and TypeValue == "table" then
			Cache[Index] = Cache[Index] or Module.TableCopy(Index,Cache)
			Cache[Value] = Cache[Value] or Module.TableCopy(Value,Cache)
			NewTable[Cache[Index]] = Cache[Value]
		elseif TypeIndex == "table" then
			Cache[Index] = Cache[Index] or Module.TableCopy(Index,Cache)
			NewTable[Cache[Index]] = Value
		elseif TypeValue == "table" then
			Cache[Value] = Cache[Value] or Module.TableCopy(Value,Cache)
			NewTable[Index] = Cache[Value]
		else
			NewTable[Index] = Value
		end
	end
	return NewTable
end

function Module.TableCombine(Table1,Table2)
	local NewTable = {}

	for Index,Value in pairs(Table1) do
		NewTable[Index] = Value
	end
	for Index,Value in pairs(Table2) do
		NewTable[Index] = Value
	end

	return NewTable
end

function Module.Create(ClassName, Properties)
	local Object,Parent = Instance.new(ClassName), nil
	for Property, Value in pairs(Properties) do
		if Property == "Parent" then
			Parent = Value
		else
			Object[Property] = Value
		end
	end
	Object.Parent = Parent
	return Object
end

function Module.CanSeeInFieldOfView(observer, target, fieldOfViewAngle)
	local Diff = target.CFrame.Position - observer.CFrame.Position
	local Angle = math.acos(Diff.Unit:Dot(observer.CFrame.LookVector))
	Angle = math.deg(Angle)
	return Angle <= fieldOfViewAngle, Angle
end
--------------------------
-- Networking Utilities --
--------------------------

function Module.MakeNetworkable(Table)
	local NewTable = {}
	local Meta = getmetatable(Table)

	--local MetaPairs = Meta and Meta.__pairs or pairs
	for Index,Value in Table do
		if type(Index) == "number" then
			Index = tostring(Index)
		elseif type(Index) == "userdata" and game.Players:FindFirstChild(Index.Name) then
			Index = Index.Name
		end

		if type(Value) == "table" then
			NewTable[Index] = Module.MakeNetworkable(Value)
		elseif type(Value) == "userdata" then
			local Metatable = getmetatable(Value)
			if type(Metatable) ~= "string" then -- getmetatable returns "The metatable is locked" for roblox instances
				NewTable[Index] = Module.MakeNetworkable(Metatable.InternalData)
			end
		else
			NewTable[Index] = Value
		end
	end
	return NewTable
end

function Module.ReceiveNetworkable(Table)
	local NewTable = {}

	for Index,Value in pairs(Table) do
		if type(Index) == "string" and game.Players:FindFirstChild(Index) then
			Index = game.Players:FindFirstChild(Index)
		end
		if type(Value) == "table" then
			NewTable[tonumber(Index) or Index] = Module.ReceiveNetworkable(Value)
		else
			NewTable[tonumber(Index) or Index] = Value
		end
	end
	return NewTable
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

	function EventWait(self)
		warn("Utility.NewEvent waiting was de-implemented for performance increases")
	end

	function EventFire(self,...)
		local Args = {...}
		for i,CallBack in self.OnceTask do
			task.defer(CallBack,...)
			self.OnceTask[i] = nil
		end
		
		for _,CallBack in pairs(self.Tasks) do
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

	function Module.NewEvent(EventName)
		return {
			Tasks = {},
			OnceTask = {},

			Connect = EventConnect,
			Once = EventOnce,
			Wait = EventWait,
			Fire = EventFire,
		}
	end
end

-------------------
-- Debug Drawing --
-------------------

function Module.DrawLine(A, B, RenderTime, Color)
	if Color then
		Color = ColorSequence.new(Color, Color)
	else
		Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0))
	end
	local Attachment1 = Module.Create("Attachment", {
		Parent = game.Workspace.Terrain,
		CFrame = CFrame.new(A),
	})
	local Attachment2 = Module.Create("Attachment", {
		Parent = game.Workspace.Terrain,
		CFrame = CFrame.new(B),
	})
	local Beam = Module.Create("Beam", {
		FaceCamera = true,
		Color = Color,
		LightEmission = 1,
		Transparency = NumberSequence.new(0),
		Attachment0 = Attachment1,
		Attachment1 = Attachment2,
		Width0 = 0.2,
		Width1 = 0.2,
		Parent = game.Workspace.Terrain,
	})

	delay(RenderTime or 1, function()	
		Attachment1:Destroy()
		Attachment2:Destroy()
		Beam:Destroy()
	end)
end

function Module.DrawPath(Waypoints, PathfindingRequestRate)
	local Junk = {}
	for Index = 2, #Waypoints do
		local LastWaypoint = Waypoints[Index-1]
		local CurrentWaypoint = Waypoints[Index]
		-- Color the adornment based on the action of the waypoints. Green indicates walking,
		-- yellow indicates a jump.
		local WaypointType = CurrentWaypoint.Action	
		local Color
		local CurveSize = 0
		if WaypointType == Enum.PathWaypointAction.Jump then
			Color = Color3.new(1, 1, 0)
			Color = ColorSequence.new(Color, Color)
			CurveSize = 10
		else
			Color = Color3.new(0, 1, 0)
			Color = ColorSequence.new(Color, Color)
		end

		local Attachment1 = Module.Create("Attachment", {
			Parent = game.Workspace.Terrain,
			CFrame = CFrame.new(LastWaypoint.Position + Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, math.rad(90)),
		}) 
		Junk[#Junk+1] =  Attachment1
		local Attachment2 = Module.Create("Attachment", {
			Parent = game.Workspace.Terrain,
			CFrame = CFrame.new(CurrentWaypoint.Position + Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, math.rad(90)),
		})
		Junk[#Junk+1] = Attachment2
		local Beam = Module.Create("Beam", {
			FaceCamera = true,
			Color = Color,
			LightEmission = 1,
			Transparency = NumberSequence.new(0),
			Attachment0 = Attachment1,
			Attachment1 = Attachment2,
			CurveSize0 = CurveSize,
			CurveSize1 = -CurveSize,
			Width0 = 0.2,
			Width1 = 0.2,
			Parent = game.Workspace.Terrain,
		})
		Junk[#Junk+1] = Beam
		--[[local Fire = Create("Fire", {
			Parent = Attachment1
		})
		Junk[#Junk+1] = Fire
		local Fire = Create("Fire", {
			Parent = Attachment2
		})
		Junk[#Junk+1] = Fire--]]
	end

	delay(PathfindingRequestRate or 10, function()
		for i = 1, #Junk do
			Junk[i]:Destroy()
		end
		Junk = nil
	end)
end

function Module.Draw3DDebugText(Object, TextLabelIndenty, Text)
	local BillboardGui = Object:FindFirstChild("DevDebuggerVisualTextTool")
	if not BillboardGui then
		BillboardGui = script.DebugBillboardGui.BillboardGui:Clone()
		BillboardGui.Name = "DevDebuggerVisualTextTool"
		BillboardGui.Adornee = Object
		BillboardGui.Parent = Object
	end
	
	BillboardGui.AlwaysOnTop = true
	BillboardGui.Enabled = true
	
	local Textlabel = BillboardGui:FindFirstChild(TextLabelIndenty) 
	if not Textlabel then
		Textlabel = script.DebugBillboardGui.TextLabel:Clone()
		Textlabel.Name = TextLabelIndenty
		Textlabel.Parent = BillboardGui
	end
	
	Textlabel.Text = Text
end
-------------------
--
-------------------
function Module.ConvertPartToRegion3(Part)
	local PartCFrame = Part.CFrame
	local PartSize = Part.Size

	-- Calculate the half size of the part
	local HalfSize = PartSize / 2

	-- Get the Corners of the part
	local Corners = {
		PartCFrame * CFrame.new( HalfSize.X,  HalfSize.Y,  HalfSize.Z),
		PartCFrame * CFrame.new(-HalfSize.X,  HalfSize.Y,  HalfSize.Z),
		PartCFrame * CFrame.new( HalfSize.X, -HalfSize.Y,  HalfSize.Z),
		PartCFrame * CFrame.new( HalfSize.X,  HalfSize.Y, -HalfSize.Z),
		PartCFrame * CFrame.new(-HalfSize.X, -HalfSize.Y,  HalfSize.Z),
		PartCFrame * CFrame.new( HalfSize.X, -HalfSize.Y, -HalfSize.Z),
		PartCFrame * CFrame.new(-HalfSize.X,  HalfSize.Y, -HalfSize.Z),
		PartCFrame * CFrame.new(-HalfSize.X, -HalfSize.Y, -HalfSize.Z)
	}

	-- Find the min and max points
	local MinPoint = Vector3.new(math.huge, math.huge, math.huge)
	local MaxPoint = Vector3.new(-math.huge, -math.huge, -math.huge)

	for _, corner in ipairs(Corners) do
		MinPoint = Vector3.new(
			math.min(MinPoint.X, corner.X),
			math.min(MinPoint.Y, corner.Y),
			math.min(MinPoint.Z, corner.Z)
		)
		MaxPoint = Vector3.new(
			math.max(MaxPoint.X, corner.X),
			math.max(MaxPoint.Y, corner.Y),
			math.max(MaxPoint.Z, corner.Z)
		)
	end

	-- Create and return the Region3
	return Region3.new(MinPoint, MaxPoint)
end

function Module.IsPointInRegion3(Point, Region)
	local RelativePosition = Region.CFrame:Inverse() * Point
	local HalfSize = Region.Size/2

	return math.abs(RelativePosition.X) <= HalfSize.X and math.abs(RelativePosition.Y) <= HalfSize.Y and math.abs(RelativePosition.Z) <= HalfSize.Z
end


function Module.GetMousePosition(Mouse, IgnoreParams)
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


function Module.TableToString(Table,Indentation,TablesEvaluated)
	Indentation = Indentation or 0
	if TablesEvaluated then
		TablesEvaluated[Table] = true
	else
		TablesEvaluated = {[Table] = true}
	end

	local Metatable = getmetatable(Table)
	if Metatable and Metatable.__tostring then
		local SubString = tostring(Table)
		local Lines = string.split(SubString,"\n")

		local NewString = Lines[1].."\n"
		for i=2,#Lines do
			NewString = NewString..string.rep("\t",Indentation)..Lines[i]
			if i ~= #Lines then
				NewString = NewString.."\n"
			end
		end
		return NewString
	else
		local String = "{"
		local FirstIndex = true
		for Index,Value in Table do
			local IndexString,ValueString
			if type(Index) == "table" then
				if TablesEvaluated[Index] then
					IndexString = "[(CyclicTable){...}]"
				else
					IndexString = "["..Module.TableToString(Index,Indentation+1,TablesEvaluated).."]"
				end
			elseif type(Index) == "string" then
				IndexString = Index
			else
				IndexString = "["..tostring(Index).."]"
			end

			if type(Value) == "table" then
				if TablesEvaluated[Value] then
					ValueString = "(CyclicTable){...}"
				else
					ValueString = Module.TableToString(Value,Indentation+1,TablesEvaluated)
				end
			elseif type(Value) == "string" then
				ValueString = "\""..Value.."\""
			else
				ValueString = tostring(Value)
			end

			if not FirstIndex then
				String = String..","
			else
				FirstIndex = false
			end
			String = String.."\n"..string.rep("\t",Indentation+1)..IndexString.." = "..ValueString
		end

		return String.."\n"..string.rep("\t",Indentation).."}"
	end
end

function Module.GenerateUID()
	return HttpService:GenerateGUID(false)
end

return Module