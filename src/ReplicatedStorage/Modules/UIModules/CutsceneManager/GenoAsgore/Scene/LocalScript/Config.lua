local Config = {
	["DialogPackets"] = {
		{
			["Label"] = script.Parent.Parent.TextLabel,
			["Dialog"] = "Human...",
			["Speed"] = .1,
			["SpeedAudio"] = script.Asgore,
			["Persist"] = 2,
		},
		{
			["Label"] = script.Parent.Parent.TextLabel,
			["Dialog"] = "No...",
			["Speed"] = .1,
			["SpeedAudio"] = script.Asgore,
			["Persist"] = 2,
		},
		{
			["Label"] = script.Parent.Parent.TextLabel,
			["Dialog"] = "Whatever you are...",
			["Speed"] = .1,
			["SpeedAudio"] = script.Asgore,
			["Persist"] = 2,
		},
		{
			["Label"] = script.Parent.Parent.TextLabel,
			["Dialog"] = "Your fate has been sealed.",
			["Speed"] = .1,
			["SpeedAudio"] = script.Asgore,
			["Persist"] = 2,
		},
		{
			["Label"] = script.Parent.Parent.TextLabel,
			["Dialog"] = "Goodbye.",
			["Speed"] = .1,
			["SpeedAudio"] = script.Asgore,
			["Persist"] = 2,
		},
	},
}

return Config


--[[
		["CutscenePacket"] = {
			Name = "asgore",
			Text = {{text='Human...', speed='0.1'}, {text='No...', speed='0.1'}, {text='Whatever you are...', speed='0.1'}, {text="It is time...", speed='0.1'}, {text='Goodbye.', speed='0.1'}},
			TextInfo = {textcolor={255, 255, 255}, soulcolor={255, 0, 0}, fadecolor={150, 25, 25}},
			SoundInfo = {theme=CutsceneThemes.GenoAsgoreIntro, texteffect=CutsceneVoices.Asgore}
		},
]]