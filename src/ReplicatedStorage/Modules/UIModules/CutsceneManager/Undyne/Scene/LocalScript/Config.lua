local BodyConfig = require(script.Parent:WaitForChild("BodyConfig"))

local Config = {
	["DialogPackets"] = {
		PartA = {
			{
				["Label"] = script.Parent.Parent.UndyneDialog,
				["Dialog"] = "Dang it...",
				["Speed"] = .04,
				["SpeedAudio"] = script.Undyne,
				["Persist"] = 1.5,
				["Face"] = BodyConfig.Defeated
			},
			{
				["Label"] = script.Parent.Parent.UndyneDialog,
				["Dialog"] = "So even THAT power... It wasn't enough...?",
				["Speed"] = .04,
				["SpeedAudio"] = script.Undyne,
				["Persist"] = 1.5,
				["Face"] = BodyConfig.Defeated
			},
			{
				["Label"] = script.Parent.Parent.UndyneDialog,
				["Dialog"] = "...",
				["Speed"] = .04,
				["SpeedAudio"] = script.Undyne,
				["Persist"] = 1.5,
				["Face"] = BodyConfig.Defeated
			},
			{
				["Label"] = script.Parent.Parent.UndyneDialog,
				["Dialog"] = "Heh...",
				["Speed"] = .04,
				["SpeedAudio"] = script.Undyne,
				["Persist"] = 1.5,
				["Face"] = BodyConfig.DefeatedSmile
			},
			{
				["Label"] = script.Parent.Parent.UndyneDialog,
				["Dialog"] = "Heheheh...",
				["Speed"] = .04,
				["SpeedAudio"] = script.Undyne,
				["Persist"] = 1.5,
				["Face"] = BodyConfig.DefeatedSmile
			},
		},
		PartB = {
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "If you...",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.WideSmile,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .015},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .015},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "If you think I'm gonna give up hope, you're wrong.",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.WideSmile,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .02},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .02},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "'Cause I've... got my friends behind me.",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.WideSmile,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .02},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .02},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "Alphys told me that she would watch me fight you...",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.SweatLeft,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .02},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .02},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "And if anything went wrong, she would... evacuate everyone.",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.SweatSmile,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .02},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .02},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "By now she's called asgore and told him to absorb the 6 human SOULs.",
				Speed = .04,
				Persist = 1.5,
				Face = BodyConfig.SweatSmile,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"RanShake"},
				RanShake = {
					BobbleX = {Min = 20, Max = 30, Min2= .01, Max2 = .02},
					BobbleY = {Min = 15, Max = 25, Min2= .01, Max2 = .02},
				},
			},
		},
		PartC = {
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "And with that power...",
				Speed = .1,
				Persist = 1.5,
				Face = BodyConfig.Melt1,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"CustomShake"},
				CustomShake = {
					BobbleX = {Min = 40, Max = 85, Min2= .06, Max2 = .1},
					BobbleY = {Min = 55, Max = 100, Min2= .06, Max2 = .3},
				},
			},
			{
				ParentGui = script.Parent.Parent.DialogFrame,
				Dialog = "This world will live on...!",
				Speed = .14,
				Persist = 1.5,
				Face = BodyConfig.Melt2,
				CustomLabel = script.UndyneLetter,
				SpeechAudio = script.Undyne,
				Effects = {"CustomShake"},
				CustomShake = {
					BobbleX = {Min = 40, Max = 85, Min2= .06, Max2 = .1},
					BobbleY = {Min = 55, Max = 100, Min2= .06, Max2 = .4},
				},
			},
		}
	},
}

return Config