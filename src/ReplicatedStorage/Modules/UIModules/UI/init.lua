local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = require(ReplicatedStorage:WaitForChild("Utility"))

local module = {}
module.IsLoaded = false
module.Loaded = Utility.NewEvent()

local initilizeList = {}

function module:Show()
	for _, module in script:GetChildren() do
		local Class = require(module)
		if Class.Show then Class:Show() end 
	end
end

function module:Hide()
	for _, module in script:GetChildren() do
		local Class = require(module)
		if Class.Hide then Class:Hide() end 
	end
end


function module:initAll()
	for _, Class in initilizeList do
		if Class.init then
			task.spawn(function() 
				Class:init()
			end)
		end
	end
	table.clear(initilizeList)
	self.IsLoaded = true
	self.Loaded:Fire()
end

function module:recursiveLoop(moduleScript)
	local ParentClass = moduleScript and require(moduleScript) or self
	local ParentName = moduleScript and moduleScript.Name or "UI"

	for _, module in moduleScript and moduleScript:GetChildren() or script:GetChildren() do
		if module:IsA("ModuleScript") then
			local ChildClass = require(module)
			ChildClass[ParentName] = ParentClass
			if ParentName ~= "UI" then
				ChildClass["UI"] = self
			end
			table.insert(initilizeList, ChildClass)
			ParentClass[module.Name] = self:recursiveLoop(module)
		end
	end

	return ParentClass
end

function module:Initialize()	
	self.Player = game.Players.LocalPlayer
	self.PlayerGui = self.Player:WaitForChild("PlayerGui")

	self:recursiveLoop()
	self:initAll()
	return self
end

return module