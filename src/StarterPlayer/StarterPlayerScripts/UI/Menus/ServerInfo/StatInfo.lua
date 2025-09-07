local module = {
	["DataUpdate"] = {
		Rolls = {
			["Start"] = "Rolled : ",
			["End"] = " Times",
			["Properties"] = {
				LayoutOrder = 1
			},
		},
	},
	["CustomUpdate"] = {
		PlayTime = {
			Start = "Playtime : ",
			DefaultValue = "00:00:00",
			Properties = {
				LayoutOrder = 2
			},
		},
		Luck = {
			Start = "Luck Multiplier : x",
			DefaultValue = "1",
			Properties = {
				LayoutOrder = 3
			},
		},
	},
}

return module
