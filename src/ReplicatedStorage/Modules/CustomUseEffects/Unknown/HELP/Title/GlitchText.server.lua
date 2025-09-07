-- Make sure this is in a TextLabel!

local label: TextLabel = script.Parent
local size: UDim2 = label.Size

local index: number = 1
local fonts: {Enum.Font} = Enum.Font:GetEnumItems()

local ABCs = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
	"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
while task.wait(3/60) do
   label.Font = fonts[index]
	label.Size = UDim2.new(1, 0, label.TextSize * (size.Height.Scale / 10), 0)
	label.Text = ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]..ABCs[math.random(1, #ABCs)]	index += 1
	if index > #fonts then
		index = 1
	end
end