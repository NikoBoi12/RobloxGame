-- Make sure this is in a TextLabel!

local label: TextLabel = script.Parent
local size: UDim2 = label.Size

local index: number = 1
local fonts: {Enum.Font} = Enum.Font:GetEnumItems()

while task.wait(3/60) do
   label.Font = fonts[index]
	label.Size = UDim2.new(1, 0, label.TextSize * (size.Height.Scale / 10), 0)
	label.Text =  math.random(1, 9)..math.random(1, 9)..math.random(1, 9)..math.random(1, 9)..math.random(1, 9)..math.random(1, 9)..math.random(1, 9)..math.random(1, 9)
	index += 1
	if index > #fonts then
		index = 1
	end
end