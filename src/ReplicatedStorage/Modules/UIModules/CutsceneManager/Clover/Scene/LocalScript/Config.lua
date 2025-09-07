local Config = {
	["DialogPackets"] = {
		PartA = {
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "* (Break free from your chains.)",
				Speed = .05,
				Persist = 2,
				CustomLabel = script.JusticeLetter,
				Effects = {"CustomShake", "FadeIn"},
				CustomShake = {
					BobbleX = {Min = 20, Max = 25, Min2= .01, Max2 = .02},
					BobbleY = {Min = 20, Max = 25, Min2= .01, Max2 = .02},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "* (They are no longer of intrest to you.)",
				Speed = .05,
				Persist = 2,
				CustomLabel = script.JusticeLetter,
				Effects = {"CustomShake", "FadeIn"},
				CustomShake = {
					BobbleX = {Min = 10, Max = 15, Min2= .01, Max2 = .02},
					BobbleY = {Min = 10, Max = 15, Min2= .01, Max2 = .02},
				},
			},
		},
	},
}

return Config