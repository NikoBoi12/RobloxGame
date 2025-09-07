local Config = {
	["DialogPackets"] = {
		{
			["ParentGui"] = script.Parent.Parent.Dialog,
			["String"] = "I've watched you kill them...",
			["Yield"] = .1,
			["Persist"] = 1.5,
		},
		{
			["ParentGui"] = script.Parent.Parent.Dialog,
			["String"] = "HAHAHAHAHAHAHAHAHAHAHAHAHA... hahaha..",
			["Yield"] = .1,
			["Persist"] = 1.5,
			["Effects"] = {"Shake"},
		},
		{
			["ParentGui"] = script.Parent.Parent.Dialog,
			["String"] = "LEAVE ME ALONE.",
			["Yield"] = .1,
			["Persist"] = 1.5,
			["Effects"] = {"Shake", "GlitchFont"},
		},
		{
			["ParentGui"] = script.Parent.Parent.Dialog,
			["String"] = "I HATE YOU I HATE YOU I HATE YOU",
			["Yield"] = .1,
			["Persist"] = 1.5,
			["Effects"] = {"Shake", "GlitchFont"},
		},
		{
			["ParentGui"] = script.Parent.Parent.Dialog,
			["String"] = "...I'll be waiting... =)",
			["Yield"] = .1,
			["Persist"] = 1.5,
			["Effects"] = {"Shake", "GlitchFont"},
		},
	},
}

return Config