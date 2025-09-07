if true then return end
--// Services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ProximityService = game:GetService("ProximityPromptService")

--// Variables

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local DialogueUi = PlayerGui:WaitForChild("DialogueTest")
local Canvas = DialogueUi.Canvas;
local MainFrame = Canvas.Main;
local TextLabel = MainFrame.TextLabel

local ChoiceTemplate = script.Template

local Remote = ReplicatedStorage.Remotes.Dialogue

--// Types

type ChoiceParameters = {
	Text : string;
	Next : TextParameters;
	Callback : (any) -> nil
}

type TextParameters = {
	Text : string; 
	Choices : {ChoiceParameters}?;
	Sound : Sound?;
	Module : ModuleScript;
}

--// Tables

local charWaitList = {
	[" "] = 0.03;
	["."] = 0.15;
	[","] = 0.08;
	["!"] = 0.1
}

local SavedPrompts = {};

--// Functions

local function clearChoices()
	for _,v in MainFrame.Choices:GetChildren() do
		if v:IsA("TextButton") then v:Destroy(); end
	end
end

local function newChat( Data : TextParameters )
	
	local text = Data.Text
	local sound = Data.Sound
	local id = HttpService:GenerateGUID()

	
	DialogueUi.Enabled = true
	
	script:SetAttribute("ID", id)
	
	TextLabel.MaxVisibleGraphemes = 0
	TextLabel.Text = text
	
	for i = 1, #text do
		if script:GetAttribute("ID") ~= id then break end
		
		local char = text:sub(i,i)
		
		TextLabel.MaxVisibleGraphemes += 1
		sound:Play();
		
		task.wait( charWaitList[char] or 0.05)
		
	end
	if script:GetAttribute("ID") ~= id then return end
	
	if Data.Choices then
		local Choices = Data.Choices
		for _, choiceData in ipairs(Choices) do
			local frame = ChoiceTemplate:Clone();
			frame.Text = choiceData.Text;
			frame.Parent = MainFrame.Choices
			
			local Callback = choiceData.Callback
			
			frame.MouseEnter:Connect(function()
				frame.TextColor3 = Color3.new(1,1,0)
			end)
			
			frame.MouseLeave:Connect(function()
				frame.TextColor3 = Color3.new(1,1,1)
			end)
			print(Callback)
			frame.Activated:Connect(function()
				clearChoices()
				if choiceData.Next then
					newChat(choiceData.Next)
				else
					DialogueUi.Enabled = false
				end
				
				if Callback then
					task.defer(Callback)
				end
				
			end)
			
		end
	end
	
end

local function promptTriggered(prompt : ProximityPrompt, player : Player)
	
	if prompt:HasTag("Dialogue") then
		
		local Prompt_Module = prompt:FindFirstChildOfClass("ModuleScript") do if not Prompt_Module then return end end
		
		if not SavedPrompts[Prompt_Module] then
			SavedPrompts[Prompt_Module] = require(Prompt_Module)
		end
		
		local required = SavedPrompts[Prompt_Module]
		
		newChat(required)
		
	end
	
end

ProximityService.PromptTriggered:Connect()

Remote.OnClientEvent:Connect(newChat)