local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Characters = ReplicatedStorage.Modules.Characters
local Noelle = Characters["Noelle"]

local Replication = {
	["Ability1"] = require(Noelle.Ability1)
}

return Replication
