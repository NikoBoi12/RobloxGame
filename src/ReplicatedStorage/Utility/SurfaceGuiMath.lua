local Module = {}

local DirectionLookup = {
	[Enum.NormalId.Right] = {
		Vector3.new(0.5,  0.5,  0.5),
		Vector3.new(0.5,  0.5, -0.5),
		Vector3.new(0.5, -0.5, -0.5),
	},
	[Enum.NormalId.Left] = {
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new(-0.5,  0.5,  0.5),
		Vector3.new(-0.5, -0.5,  0.5),
	},
	[Enum.NormalId.Front] = {
		Vector3.new( 0.5,  0.5, -0.5),
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new(-0.5, -0.5, -0.5),
	},
	[Enum.NormalId.Back] = {
		Vector3.new(-0.5,  0.5, 0.5),
		Vector3.new( 0.5,  0.5, 0.5),
		Vector3.new( 0.5, -0.5, 0.5),
	},
	[Enum.NormalId.Top] = {
		Vector3.new(-0.5,  0.5,  0.5),
		Vector3.new(-0.5,  0.5, -0.5),
		Vector3.new( 0.5,  0.5, -0.5),
	},
	[Enum.NormalId.Bottom] = {
		Vector3.new( 0.5, -0.5,  0.5),
		Vector3.new( 0.5, -0.5, -0.5),
		Vector3.new(-0.5, -0.5, -0.5),
	},
}

local Surfaces = {
	LookVector = {
		[1] = Enum.NormalId.Front,
		[-1] = Enum.NormalId.Back,
	},
	RightVector = {
		[1] = Enum.NormalId.Right,
		[-1] = Enum.NormalId.Left,
	},
	UpVector = {
		[1] = Enum.NormalId.Top,
		[-1] = Enum.NormalId.Bottom,
	},
}

local function GetSurfaceFromRay(Result)
	if Result then
		local Normal = Result.Normal
		local HitCF = Result.Instance.CFrame

		local Surface = nil
		local Projection = nil
		for DirectionVector,Data in pairs(Surfaces) do
			Projection = math.floor( Normal:Dot(HitCF[DirectionVector]) + 0.5 )            
			Surface = Data[math.sign(Projection)]
			if Surface then break end
		end

		return Surface
	end
end
Module.GetSurfaceFromRay = GetSurfaceFromRay

local function GetNearestPointOnLine(Origin,End,WorldPosition)
	local Direction = (End-Origin).Unit
	local Diff = WorldPosition - Origin
	local Projection = Diff:Dot(Direction)
	return Origin + (Direction * Projection)
end

Module.GetRelative2DPosition = function(Part,WorldPosition,Surface,GetRelativeSize)	
	local TriangleData = DirectionLookup[Surface]
	local TopLeft = Part.CFrame * (TriangleData[1]*Part.Size)
	local TopRight = Part.CFrame * (TriangleData[2]*Part.Size)
	local BottomRight = Part.CFrame * (TriangleData[3]*Part.Size)
	
	local P4 = GetNearestPointOnLine(TopLeft, TopRight, WorldPosition)
	local P5 = GetNearestPointOnLine(TopRight, BottomRight, WorldPosition)
	
	local SizeX,SizeY = nil,nil
	local RelativeWidth = ((P4-TopLeft).Magnitude)
	local RelativeHeight = ((P5-TopRight).Magnitude)
	
	if GetRelativeSize then
		SizeX = (TopRight-TopLeft).Magnitude
		SizeY = (BottomRight-TopRight).Magnitude
	end
	
	return RelativeWidth,RelativeHeight,SizeX,SizeY
end

return Module