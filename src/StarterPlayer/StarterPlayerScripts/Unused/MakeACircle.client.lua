local function generateRandomPointInCircle(center, radius)
	local Vectors = {}
	
	local x = center.x + radius * math.cos(math.rad(angle))
	local y = center.y + radius * math.sin(math.rad(angle))
	return Vector2.new(x, y)
end

-- Center and radius of the circle
local center = Vector2.new(0, 0) -- Change this to your desired center
local radius = 6 -- Change this to your desired radius

-- Generate 6 random points
local points = {}
local slice = 360/6
for i=0, 360 - slice, slice do
	table.insert(points, generateRandomPointInCircle(center, radius, i))
end

task.wait(1)

-- Print the points
for i, point in points do
	workspace.FireBalls[i].Position = Vector3.new(point.X, 0, point.Y)
end