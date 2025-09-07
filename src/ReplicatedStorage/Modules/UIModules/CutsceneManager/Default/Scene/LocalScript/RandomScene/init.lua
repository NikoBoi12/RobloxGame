local CutsceneConfig = require(script:WaitForChild("Config"))

local Config = {
	{
		Music = script.MysteryMan,
		Dialog = CutsceneConfig.Entry17,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255)},
	},
	{
		Music = script.WaterSlow,
		Dialog = CutsceneConfig.RiverPerson,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 127), Color3.fromRGB(85, 255, 255)},
	},
	{
		Music = script.Waterfall,
		Dialog = CutsceneConfig.RiverPerson2,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 127), Color3.fromRGB(255, 255, 255)},
	},
	{
		Music = script.MysteryMan,
		Dialog = CutsceneConfig.Warning,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(150, 150, 150)},
	},
	{
		Music = script.AnotherMediumSlow,
		Dialog = CutsceneConfig.Follower,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 127)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(159, 159, 159)},
	},
	{
		Music = script.CoreSlow,
		Dialog = CutsceneConfig.Follower2,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(.5, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(.8, Color3.fromRGB(255, 85, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 155, 105)),
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(159, 159, 159)},
	},
	{
		Music = script.AnotherMediumSlow,
		Dialog = CutsceneConfig.Follower3,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(.4, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(.6, Color3.fromRGB(30, 30, 30)),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(65, 65, 65)),
			ColorSequenceKeypoint.new(0.9, Color3.fromRGB(75, 75, 75)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(158, 158, 158))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(159, 159, 159)},
	},
	{
		Music = script.WaterSlow,
		Dialog = CutsceneConfig.GonerKid1,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(.35, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 127)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 90))
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 0, 0)},
	},
	{
		Music = script.WaterSlow,
		Dialog = CutsceneConfig.GonerKid2,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 61)),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 61)),
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 0, 0)},
	},
	{
		Music = script.WaterSlow,
		Dialog = CutsceneConfig.Hello,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 18)),
		},
		ParticleColorShift = {Color3.fromRGB(39, 39, 39), Color3.fromRGB(17, 17, 17)},
	},
	{
		Music = script.MysteryMan,
		Dialog = CutsceneConfig.Anomaly,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		},
		ParticleColorShift = {Color3.fromRGB(170, 0, 0), Color3.fromRGB(39, 39, 39)},
	},
	{
		Music = script.MysteryMan,
		Dialog = CutsceneConfig.Purity,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(111, 111, 111)),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(59, 59, 59)},
	},
	{
		Music = script.MysteryMan,
		Dialog = CutsceneConfig.IKnowWhatYouDid,
		GradColors = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.4, Color3.fromRGB(170, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		},
		ParticleColorShift = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(59, 59, 59)},
	},
}

return Config
