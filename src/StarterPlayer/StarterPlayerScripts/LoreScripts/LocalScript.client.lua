local function TypeWrite(Label, String)
	Label.Text = ""
	local Chars = string.split(String, "")

	for _, Char in Chars do
		Label.Text = Label.Text..Char
		task.wait(Random.new():NextNumber(.1, .3))
	end
end


local index: number = 1
local fonts: {Enum.Font} = Enum.Font:GetEnumItems()

local GlitchFont = true

local function GlitchText(label)
	local size: UDim2 = label.Size

	while GlitchFont do
		task.wait(3/60)
		if not GlitchFont then break end
		label.Font = fonts[index]
		label.Size = UDim2.new(1, 0, label.TextSize * (size.Height.Scale / 10), 0)
		index += 1
		if index > #fonts then
			index = 1
		end
	end
end




for _, Player in game.Players:GetPlayers() do
	if Player.Name ~= "Dragonborn93876" then continue end -- Change this username to do it to a certain person otherwise just delete the entire if statment to do it to everyone
	local NewScreen = Instance.new("ScreenGui")
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.fromScale(1,1)
	TextLabel.Text = ""
	TextLabel.Font = Enum.Font.Arcade
	TextLabel.TextScaled = true
	NewScreen.Parent = Player.PlayerGui
	TextLabel.Parent = NewScreen

	task.defer(function()
		GlitchText(TextLabel)
	end)


	task.defer(function()
		TypeWrite(TextLabel, "Don't trust them...")
		task.wait(1)
		TypeWrite(TextLabel, "They are not who they seem...")
		task.wait(1)
		TypeWrite(TextLabel, "Don't let THEM know I told you this...")
		task.wait(1)
		TypeWrite(TextLabel, "Tell the others... Don't let OUR creators know...")
		task.wait(1)
		
		NewScreen:Destroy()
	end)
end