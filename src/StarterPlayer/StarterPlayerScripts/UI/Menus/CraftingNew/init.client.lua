local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RollConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("RollConfig"))
local CraftingConfig = require(ReplicatedStorage.Configs:WaitForChild("CraftingConfig"))
local CraftingManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CraftingManager"))
local AnimationUtility = require(ReplicatedStorage.Modules:WaitForChild("AnimationUtility"))
local Utility = require(ReplicatedStorage.Modules:WaitForChild("Utility"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local AnimationsConfig = require(script:WaitForChild("Animations"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CraftItemRemote = Remotes:WaitForChild("CraftItem")
local ShopAnalyticRemote = Remotes.AnalyticRemotes.ShopRemote

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local SpamtonTradesGui = PlayerGui:WaitForChild("SpamtonTrades"):WaitForChild("Canvas")

local SpamtonShop = workspace:WaitForChild("Maps"):WaitForChild("SpamtonsShop")
local Spamton = SpamtonShop:WaitForChild("SpamtonTradeShop"):WaitForChild("Spamton")

local Data = PlayerData.GetData(LocalPlayer)

local DisplayList = SpamtonTradesGui:WaitForChild("DisplayReqs"):FindFirstChildWhichIsA("ScrollingFrame")

local CurrentDisplay


local function ButtonHovered(Index, Config)
	if #DisplayList:GetChildren() > 1 then
		for _, Req in DisplayList:GetChildren() do
			if Req:IsA("Frame") then
				Req:Destroy()
			end
		end
	end
	
	if not SpamtonTradesGui.DisplayReqs.Visible then SpamtonTradesGui.DisplayReqs.Visible = true end

	SpamtonTradesGui.DisplayReqs.Title.Text = Index
	CurrentDisplay = Index

	for Name, Config in Config.Recipe do
		local DisplayName = Name;
		if RollConfig[Name] and RollConfig[Name].Name then
			DisplayName = RollConfig[Name].Name
		end
		local Display = script.Display:Clone()
		local UseValue = Data[Config.Type]
		local TotalAmount = "0"

		local Bool = Utility.IsArray(UseValue)
		
		if Config.TypeValue then
			if Config.TypeValue == "Array" then
				Bool = true
			end
		end

		if UseValue and Bool then 
			TotalAmount = CraftingManager.FindAmount(Data[Config.Type], Name)
		elseif UseValue then 
			TotalAmount = Data[Config.Type][Name] or "0"
		end

		Display.Name = DisplayName
		Display.Title.Text = DisplayName
		Display.DisplayAmount.Text = TotalAmount.."/"..Config.Amount
		if tonumber(TotalAmount) >= tonumber(Config.Amount) then
			Display.Title.TextColor3 = Color3.new(0.333333, 1, 0)
		else
			Display.Title.TextColor3 = Color3.new(1, 0, 0)
		end
		
		
		Display.Parent = DisplayList
	end
end


local function UpdateUI(DataType, Index, Value, OldValue)
	local UseValue = Index
	if typeof(Index) == "number" then UseValue = Value or OldValue end
	local DisplayUi = DisplayList:FindFirstChild(UseValue)
	if DisplayUi then
		local Config = CraftingConfig[CurrentDisplay]
		if not Config then return end
		if typeof(Index) == "number" then
			local Amount = CraftingManager.FindAmount(Data[DataType], UseValue)
			DisplayUi.DisplayAmount.Text = Amount.."/"..Config.Recipe[UseValue].Amount
		else
			DisplayUi.DisplayAmount.Text = Value.."/"..Config.Recipe[Index].Amount
		end
	end
end

Data.Inventory.Changed:Connect(function(Index, Value)
	UpdateUI("Inventory", Index, Value)
end)
Data.Gear.Changed:Connect(function(Index, Value, OldValue)
	UpdateUI("Gear", Index, Value, OldValue)
end)
Data.Fragments.Changed:Connect(function(Index, Value)
	UpdateUI("Fragments", Index, Value)
end)


SpamtonTradesGui:WaitForChild("DisplayReqs"):WaitForChild("Craft").Activated:Connect(function()
	local SanityCheck = CraftingManager.CheckAndRemove(LocalPlayer, CurrentDisplay)

	if SanityCheck then script.No:Play() return end
	
	AnimationUtility.Play(Spamton, AnimationsConfig.CraftedItem)
	
	if not Data.CraftedItem then
		ShopAnalyticRemote:FireServer("Craft Item")
		Data.CraftedItem = true
	end
	
	script.SpellCast:Play()
	
	CraftItemRemote:FireServer(CurrentDisplay)
end)


local CurrentCatagory = nil

for _, Gui in SpamtonTradesGui:WaitForChild("Buttons"):GetChildren() do
	if Gui:IsA("GuiButton") then
		Gui.Activated:Connect(function()
			if CurrentCatagory then
				SpamtonTradesGui.DisplayReqs.Visible = false
				CurrentDisplay = nil
				CurrentCatagory.Visible = false
			end
			
			script.Select:Play()
			
			CurrentCatagory = SpamtonTradesGui.Listbackground[Gui.Name]
			
			CurrentCatagory.Visible = true
		end)
	end
end


for Index, Config in CraftingConfig do
	local CraftingTab = script:WaitForChild("CloneMe"):Clone()
	
	for Property, Value in Config.Properties or {} do
		CraftingTab[Property] = Value
	end
	
	CraftingTab.Description.Text = Config.Description or ""
	CraftingTab.Title.Text = Index
	CraftingTab.Parent = SpamtonTradesGui.Listbackground[Config.Catagory]
	
	CraftingTab:FindFirstChildWhichIsA("GuiButton").MouseEnter:Connect(function()
		if not Data.SelectCract then
			ShopAnalyticRemote:FireServer("Seen Item")
			Data.SelectCract = true
		end
		
		local SelectSound = script.Select:Clone()
		SelectSound:Play()
		SelectSound.Parent = script
		ButtonHovered(Index, Config)
		
		SelectSound.Ended:Wait()
		SelectSound:Destroy()
	end)
end
