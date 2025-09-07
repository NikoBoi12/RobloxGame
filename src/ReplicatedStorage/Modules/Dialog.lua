local TweenService = game:GetService("TweenService")

local module = {}
local DialogEffects = {}

local RandomObj = Random.new()


function module.ManualWrite(Packet, KillCondition)
	local ReturnPacket = {
		Completed = Instance.new("BindableEvent"),
		KillDialog = false,
	}
	
	
	task.defer(function()
		for _, DialogPacket in Packet.Dialog or {Packet} do
			if ReturnPacket.KillDialog == true then break end
			if KillCondition and KillCondition() == true then break end
			if DialogPacket.NewLine then
				Packet.Label.Text = Packet.Label.Text.."<br />"
			end
			local Chars = string.split(DialogPacket.Text, "")

			for _, Char in Chars do
				if ReturnPacket.KillDialog == true then break end
				if DialogPacket.SpeedAudio then DialogPacket.SpeedAudio:Play() end
				if DialogPacket.RanSpeech then Packet.RanSpeech[RandomObj:NextInteger(1, #Packet.RanSpeech)]:Play() end
				Packet.Label.Text = Packet.Label.Text..Char
				task.wait(DialogPacket.TextSpeed)
			end

			task.wait(DialogPacket.DelayLine or 0)
		end
		ReturnPacket.Completed:Fire()
		ReturnPacket.Completed:Destroy()
	end)
	
	return ReturnPacket
end


function module.TypeWriteLabel(Packet)
	Packet.Label.Text = ""
	local Chars = string.split(Packet.Dialog, "")
	
	for _, Char in Chars do
		if Packet.SpeedAudio then Packet.SpeedAudio:Play() end
		if Packet.Speech then Packet.Speech:Play() end
		Packet.Label.Text = Packet.Label.Text..Char
		if Packet.RanSpeech then Packet.RanSpeech[RandomObj:NextInteger(1, #Packet.RanSpeech)]:Play() end
		task.wait(Packet.Speed)
	end
	
	if Packet.Persist then
		task.wait(Packet.Persist)
	end
	
	if Packet.Persist ~= false then
		Packet.Label.Text = ""
	end
end


function module.DisplayDialog(Character, String, Yield, SpeechAudio, Effect)
	local Chars = string.split(String, "")
	
	local DisplayText = Character.Head:FindFirstChild("DisplayDialog")
	
	if not DisplayText then return end
	if DisplayText.IsActive.Value == true then return end
	
	DisplayText.IsActive.Value = true
	
	for _, Char in Chars do
		local DialogChar = script.TextLabel:Clone()
		DialogChar.Text = Char
		DialogChar.Parent = DisplayText
		if SpeechAudio then SpeechAudio:Play() end

		task.wait(Yield)
	end

	task.wait(.5)

	for _, Label in DisplayText:GetChildren() do
		if Label:IsA("TextLabel") then Label:Destroy() end
	end
	
	DisplayText.IsActive.Value = false
end


function module.ScreenDisplay(Packet) -- String, Gui, SpeechAudio, Yield, Persist, CustomLabel
	local Chars = string.split(Packet.String, "")

	for _, Char in Chars do
		local DialogChar = Packet.CustomLabel and Packet.CustomLabel:Clone() or script.ScreenDisplay:Clone()
		DialogChar.ScreenLabel.Text = Char
		DialogChar.Parent = Packet.ParentGui
		if Packet.SpeechAudio then Packet.SpeechAudio:Play() end
		if Packet.RanSpeech then Packet.RanSpeech[RandomObj:NextInteger(1, #Packet.RanSpeech)]:Play() end
		
		if Packet.Effects then
			for _, Effect in Packet.Effects do
				task.defer(function()
					DialogEffects[Effect](DialogChar.ScreenLabel, Packet[Effect])
				end)
			end
		end
		task.wait(Packet.Yield)
	end

	task.wait(Packet.Persist or .5)

	for _, Label in Packet.ParentGui:GetChildren() do
		if Label:IsA("Frame") then Label:Destroy() end
	end
end


function DialogEffects.FadeIn(Gui, Packet)
	TweenService:Create(Gui, TweenInfo.new(.5, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
	TweenService:Create(Gui.UIStroke, TweenInfo.new(.5, Enum.EasingStyle.Linear), {Transparency = 0}):Play()
end


function module.LetterDisplay(Packet) -- String, ParentGui, SpeechAudio, Yield, Persist, CustomLabel
	local Words = string.split(Packet.Dialog, " ")
	
	local LineLimit = math.floor(1/Packet.ParentGui.UIGridLayout.CellSize.X.Scale)
	
	local Characters = 0
	
	local CurrentLine = 1
	
	local String = {}
	
	table.insert(String, {})
	for _, Word in Words do
		local Chars = string.split(Word, "")
		if Characters + #Chars + 1 > LineLimit then
			for i=1, LineLimit - Characters do
				table.insert(String[CurrentLine], "")
			end
			CurrentLine += 1
			table.insert(String, {})
			Characters = 0
		end
		for _, Char in Chars do
			Characters += 1
			table.insert(String[CurrentLine], Char)
		end
		Characters += 1
		table.insert(String[CurrentLine], " ")
	end
	
	local Letters = {}

	for _, Words in String do
		for _, Word in Words do
			local DialogChar = Packet.CustomLabel and Packet.CustomLabel:Clone() or script.ScreenDisplay:Clone()
			DialogChar.ScreenLabel.Text = Word
			DialogChar.Parent = Packet.ParentGui
			if Word == "" then
				continue
			end
			if Packet.SpeechAudio then Packet.SpeechAudio:Play() end
			if Packet.RanSpeech then Packet.RanSpeech[RandomObj:NextInteger(1, #Packet.RanSpeech)]:Play() end
			
			if Packet.Effects then
				for _, Effect in Packet.Effects do
					task.defer(function()	
						DialogEffects[Effect](DialogChar.ScreenLabel, Packet[Effect] or {})
					end)
				end
			end
			task.wait(Packet.Speed)
		end
	end

	task.wait(Packet.Persist or .5)

	for _, Label in Packet.ParentGui:GetChildren() do
		if Label:IsA("Frame") then Label:Destroy() end
	end
end


local fonts = Enum.Font:GetEnumItems()

function DialogEffects.GlitchFont(Gui)
	local Size = Gui.Size

	local Index = 1
	
	while task.wait(RandomObj:NextNumber(1/60, 3/60)) do
		Gui.Font = fonts[Index]
		Gui.Size = UDim2.new(1, 0, Gui.TextSize * (Size.Height.Scale / 10), 0)
		Index += 1
		if Index > #fonts then
			Index = 1
		end
	end
end


function DialogEffects.Shake(Gui)
	local Pos = Gui.Position

	local TotalTime = 0

	while Gui.Parent do
		local DeltaTime = task.wait()
		if not Gui.Parent then break end
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(15, 45)) * RandomObj:NextNumber(.01, 0.08))
		local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(20, 50)) * RandomObj:NextNumber(.01, 0.08)) 
		Gui.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	Gui.Position = Pos
end


function DialogEffects.CustomShake(Gui, Packet)
	local Pos = Gui.Position

	local TotalTime = 0

	while Gui.Parent do
		local DeltaTime = task.wait()
		if not Gui.Parent then break end
		TotalTime += DeltaTime
		local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(Packet.BobbleX.Min, Packet.BobbleX.Max)) * RandomObj:NextNumber(Packet.BobbleX.Min2, Packet.BobbleX.Max2))
		local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(Packet.BobbleY.Min, Packet.BobbleY.Max)) * RandomObj:NextNumber(Packet.BobbleY.Min2, Packet.BobbleY.Max2)) 
		Gui.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
	end

	Gui.Position = Pos
end

function DialogEffects.RanShake(Gui, Packet)
	local Pos = Gui.Position

	local TotalTime = 0

	while Gui.Parent do
		task.wait(RandomObj:NextNumber(0, 8))
		local DeltaTime = task.wait()
		TotalTime += DeltaTime
		for i=1, 10 do
			task.wait(1/60)
			local BobbleX = (math.cos(os.clock() * RandomObj:NextInteger(Packet.BobbleX.Min, Packet.BobbleX.Max)) * RandomObj:NextNumber(Packet.BobbleX.Min2, Packet.BobbleX.Max2))
			local BobbleY = math.abs(math.sin(os.clock() * RandomObj:NextInteger(Packet.BobbleY.Min, Packet.BobbleY.Max)) * RandomObj:NextNumber(Packet.BobbleY.Min2, Packet.BobbleY.Max2)) 
			Gui.Position = Pos + UDim2.new(BobbleX,0,BobbleY,0)
		end
		Gui.Position = Pos
	end
end


return module