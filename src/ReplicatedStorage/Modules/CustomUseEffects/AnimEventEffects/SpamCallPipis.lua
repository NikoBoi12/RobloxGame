local module = {}

local AbilityAnimConfig = require(game.ReplicatedStorage.Configs.AbilityAnimConfig)
local DialogModule = require(game.ReplicatedStorage.Modules.Dialog)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

function module.StartUp(Character, Animation)
	local Phone = Character:FindFirstChild("Phone") :: typeof(ReplicatedStorage.Storage.Auras.SpamtonNeo.Phone)
	Phone.Transparency = 0
	
	Character.HumanoidRootPart.String.String.Enabled = true
	
	local TextAudio = script.SpamText:Clone()
	TextAudio.Parent = Character.HumanoidRootPart
	Phone.Sound:Play()
	Animation.Stopped:Wait()
	Phone.Attachment.Pipis.Enabled = false
	Phone.Attachment.SpamEffect.Enabled = false
	Character.Head.HitEffect.Enabled = false
	Character.HumanoidRootPart.String.String.Enabled = false
	Phone.Transparency = 1
end


function module.DialogOne(Character)
	local Dialog = "What!?"
	DialogModule.DisplayDialog(Character, Dialog, .04, Character.HumanoidRootPart:FindFirstChild("SpamText"))
end

function module.DialogTwo(Character)
	local Dialog = "WHAT? ARE YOU SERIOUS!?"
	DialogModule.DisplayDialog(Character, Dialog, .04, Character.HumanoidRootPart:FindFirstChild("SpamText"))
end

function module.DialogThree(Character)
	local Dialog = "... IT'S FOR YOU."
	DialogModule.DisplayDialog(Character, Dialog, .05, Character.HumanoidRootPart:FindFirstChild("SpamText"))
end

function module.DialogFour(Character)
	local Dialog = "IT'S FOR ME!?"
	DialogModule.DisplayDialog(Character, Dialog, .05, Character.HumanoidRootPart:FindFirstChild("SpamText"))
end


function module.PipisCall(Character)
	Character:FindFirstChild("Phone").Attachment.Pipis.Enabled = true
end

function module.SpamCall(Character)
	Character:FindFirstChild("Phone").Attachment.SpamEffect.Enabled = true
	Character.Head.HitEffect.Enabled = true
end

return module
