local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FrameData = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("FrameData"))
local FaceConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FrameConfigs"):WaitForChild("Faces"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Canvas = PlayerGui:WaitForChild("Shop"):WaitForChild("Canvas")
local ShopUI = Canvas:WaitForChild("MainCanvas")
local TalkUI = Canvas:WaitForChild("TalkCanvas")
local MenuRight = ShopUI:WaitForChild("MenuRight")
local TalkCanvas = MenuRight:WaitForChild("TalkCanvas")
local TalkMenu = Canvas:WaitForChild("TalkCanvas"):WaitForChild("TalkMenu")


local module = {
	["Intro"] = {
		["Label"] = ShopUI:WaitForChild("MenuLeft"):WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* Hee hee...",
				SpeedAudio = script.Narraitor,
				DelayLine = .5,
				TextSpeed = .04,
			},
			{
				Text = "* Welcome, traveller.",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
				NewLine = true,
			},
		}
	}, 
	["Intro2"] = {
		["Label"] = ShopUI:WaitForChild("MenuLeft"):WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* Take your time...",
				SpeedAudio = script.Narraitor,
				DelayLine = .5,
				TextSpeed = .04,
			},
			{
				Text = "* Its not like your leaving here anytime soon Ha ha ha ha...",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
				NewLine = true,
			},
		}
	}, 
	["TalkIntro"] = {
		["Label"] = TalkCanvas:WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* ...Don't you have better things to do.",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
			},
		}
	},
	["BuyIntro"] = {
		["Label"] = TalkCanvas:WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* What would you like to buy?",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
			},
		}
	},
	["Purchase"] = {
		["Label"] = TalkCanvas:WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* Thanks for that",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
			},
		}
	},
	["NoMoney"] = {
		["Label"] = TalkCanvas:WaitForChild("TextLabel"),
		["Dialog"] = {
			{
				Text = "* I'm not running a charity",
				SpeedAudio = script.Narraitor,
				TextSpeed = .04,
			},
		}
	},
	["AboutYourself"] = {
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* The name's Seam.
* Pronounced "Shawm."]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* And this is my little Seap.
* Ha ha ha ha...]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* 'Course, I've no attachment to any of it.
* It's just a hobby of mine.]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* Around here, you learn to find ways to pass the time...
* ... or go mad like everyone else.]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
	},
	["WhereAmI"] = {
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* Where are you...?
* You've already forgotten? Your at ]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = .1,
		},
		{
			Label = TalkMenu:WaitForChild("TextLabel"),
			Type = "ManualWrite",
			Text = "���������������������������������������",
			RanSpeech = script.RanSpeech:GetChildren(),
			["CustomEffect"] = function() 
				script.Parent.Lantern:Pause()
				script.Parent.SlowShop:Play()
				Canvas.Seam.ImageColor3 = Color3.fromRGB(0, 0, 0)
			end,
			["EndCustomEffect"] = function() 
				script.Parent.Lantern:Play()
				script.Parent.SlowShop:Pause()
				Canvas.Seam.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end,
			DelayLine = .5,
			TextSpeed = .07,
		},
	},
	["WhatHappened"] = {
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* All of us just showed up here one day
* A big flash of light and... here we are.]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
		{
			["Label"] = TalkMenu:WaitForChild("TextLabel"),
			["Dialog"] = [[* I don't mind though plenty of new trinkets here.]],
			["Speed"] = .04,
			["SpeedAudio"] = script.Narraitor,
			["Persist"] = 1,
		},
	}
}

return module
