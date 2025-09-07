local module = {
	["DataUpdate"] = {
		Rolls = {
			["Start"] = "Rolled : ",
			["End"] = " Times",
			["Properties"] = {
				LayoutOrder = 2
			},
		},
		DarkDollars = {
			["Start"] = "DarkDollars : ",
			["End"] = "",
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
				LayoutOrder = 3
			},
		},
		Luck = {
			Start = "Luck Multiplier : x",
			DefaultValue = "1",
			Properties = {
				LayoutOrder = 4
			},
		},
	},
}

return module
