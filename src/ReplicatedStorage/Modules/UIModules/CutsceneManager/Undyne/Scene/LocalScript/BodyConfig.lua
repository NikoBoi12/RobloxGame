local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FrameConfig = require(ReplicatedStorage.Configs.FrameData)


local UndyneSheet = FrameConfig["rbxassetid://18839452200"].Frames

local Config = {
	["Neuteral"] = UndyneSheet[1],
	["WideSmile"] = UndyneSheet[2],
	["Sweat"] = UndyneSheet[3],
	["SweatLeft"] = UndyneSheet[4],
	["SweatSmile"] = UndyneSheet[5],
	["Defeated"] = UndyneSheet[6],
	["DefeatedSmile"] = UndyneSheet[7],
	["Melt1"] = UndyneSheet[8],
	["Melt2"] = UndyneSheet[9],
}

return Config