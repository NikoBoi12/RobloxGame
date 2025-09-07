local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local GearConfig = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("GearConfig"))
local ItemConfig = require(ReplicatedStorage.Configs:WaitForChild("ItemConfig"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local ManageGear = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("UIModules"):WaitForChild("ManageGear"))
local ManageItems = require(ReplicatedStorage.Modules.UIModules:WaitForChild("ManageItems"))
local DataManager = require(ReplicatedStorage.Modules.RNGManagers.DataManager)
local TitleConfig = require(ReplicatedStorage.Configs:WaitForChild("TitleConfig"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InventoryGui = Menus:WaitForChild("Inventory")
local GearUi = InventoryGui:WaitForChild("GearUI")
local ItemUi = InventoryGui:WaitForChild("ItemUI")
local TitleUI = InventoryGui:WaitForChild("TitleUI")


local Data = PlayerData.GetData(LocalPlayer)

local PreviousButton
local SelectedItem


local function Reset()
	local Config = GearConfig[SelectedItem]
	ItemUi.ItemDisplay.Image = ""
	if PreviousButton then
		InventoryGui.Description.Text = ""
		PreviousButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
		PreviousButton = nil
		SelectedItem = nil
		if Config then
			GearUi[Config.Type].ImageColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end


InventoryGui.InventoryButton.Activated:Connect(function()
	if GearUi.Visible then
		Reset()
		script.Select:Play()
		GearUi.Visible = false
		ItemUi.Visible = true
	end
end)

local function AddGear(Index, Value, OldValue)
	local Config = GearConfig[Value]
	
	if Value == nil then
		for _, Button in GearUi.DisplayGear:GetChildren() do
			if Button.Name == OldValue then
				Button:Destroy()
				return
			end
		end
	elseif Config then
		local Button = script:WaitForChild("InvButton"):Clone()
		Button.Name = Value
		Button.TextLabel.Text = Value
		Button.Parent = GearUi.DisplayGear

		Button.Activated:Connect(function()
			if PreviousButton == Button then Reset() return end
			if PreviousButton then Reset() end
			PreviousButton = Button
			SelectedItem = Value
			GearUi[Config.Type].ImageColor3 = Color3.fromRGB(255, 0, 0)
			PreviousButton.ImageColor3 = Color3.fromRGB(255, 255, 0)
			
			InventoryGui.Description.Text = Config.Description
		end)
	end
end

Data.Gear.Changed:Connect(AddGear)


for i, Gear in Data.Gear do
	AddGear(i, Gear)
end

--// Vanity Toggle

local imageIds = {[1] = "rbxassetid://13321848320", [2] = "rbxassetid://125716871945612"}
local vanityRemote = ReplicatedStorage.Remotes.SolarRemotes.Vanity
local Buttons = {GearUi:WaitForChild("Body"), GearUi:WaitForChild("Head"), GearUi:WaitForChild("Weapon")}

local function changeImage(button: ImageButton, slot: string)
	local hidden = Data.VanityHidden[slot]--LocalPlayer:GetAttribute(button.Name.."Hide")
	if hidden then
		button.Image = imageIds[2]
	else
		button.Image = imageIds[1]
	end
end

for _, Button: ImageButton in Buttons do
	local VanityToggle = Button:FindFirstChild("VanityToggle") :: ImageButton

	VanityToggle.Activated:Connect(function()
		vanityRemote:FireServer(Button.Name)
	end)
	changeImage(VanityToggle, Button.Name)
	LocalPlayer:GetAttributeChangedSignal(Button.Name.."Hide"):Connect(function()
		changeImage(VanityToggle, Button.Name)
	end)

	Button.Activated:Connect(function()
		if not SelectedItem then
			script.Select:Play()
			if ManageGear.SlotUsed(LocalPlayer, Button.Name) then
				ManageGear.Unequip(LocalPlayer, Button.Name)
				Button.TextLabel.Text = "None"
			end
		end

		local Config = GearConfig[SelectedItem]
		if not Config then return end

		if Config.Type == Button.Name then
			ManageGear.EquipGear(LocalPlayer, Button.Name, SelectedItem)
			Button.TextLabel.Text = SelectedItem
			PreviousButton:Destroy()
			Reset()
		end
	end)
end

local SelectionUi = ItemUi.Selections


for Slot, Item in Data.Equipped do
	GearUi:WaitForChild(Slot):WaitForChild("TextLabel").Text = Item or "None"
end



local function RemoveItem(Button)
	if PreviousButton == Button then Reset() end
	Button:Destroy()
end


local function AddItem(Index, Value, OldValue)
	local Config = ItemConfig[Index]
	local FindButton = ItemUi:WaitForChild("DisplayInventory"):FindFirstChild(Index)

	if Value == 0 or Value == nil then 
		if not FindButton then return end
		RemoveItem(FindButton) 
		return 
	end

	if not Config then return end

	-- Function to determine color based on quantity
	local function GetQuantityColor(amount)
			if amount <= 1 then
				return Color3.fromRGB(255, 80, 80) -- red
			elseif amount < 10 then
				return Color3.fromRGB(200, 118, 4) -- light gray
			elseif amount < 50 then
				return Color3.fromRGB(80, 255, 80) -- green
			else
				return Color3.fromRGB(50, 200, 255) -- cyan
			end
		end


	if FindButton then 
		FindButton.Quantity.Text = "x"..Value
		FindButton.Quantity.TextColor3 = GetQuantityColor(Value)
		return 
	end

	local Button = script.InvButton:Clone()
	Button.TextLabel.Text = Index
	Button.Name = Index
	Button.Quantity.Visible = true
	Button.Quantity.Text = "x"..Value
	Button.Quantity.TextColor3 = GetQuantityColor(Value)
	Button.Parent = ItemUi.DisplayInventory

	Button.Activated:Connect(function()
		if PreviousButton == Button then 
			Reset() 
			return 
		end
		if PreviousButton then Reset() end

		if Config.Image then
			ItemUi.ItemDisplay.Image = "rbxassetid://"..Config.Image
		end

		script.Select:Play()

		InventoryGui.Description.Text = Config.Description
		PreviousButton = Button
		SelectedItem = Index
		PreviousButton.ImageColor3 = Color3.fromRGB(255, 255, 0)
	end)
end

Data.Items.Changed:Connect(AddItem)

for Item, Amount in Data.Items do
	AddItem(Item, Amount)
end


SelectionUi.Consume.Activated:Connect(function()
	if not SelectedItem then return end
	local Quantity = math.abs(tonumber(SelectionUi.Quantity.Amount.Text)) or 1
	script.Select:Play()
	ManageItems.UseItem(LocalPlayer, SelectedItem, Quantity)
end)

GearUi.Trash.Activated:Connect(function()
	if not SelectedItem then return end
	ManageGear.RemoveGear(LocalPlayer, SelectedItem)
	script.Select:Play()
	PreviousButton:Destroy()
	Reset()
end)

InventoryGui.GearButton.Activated:Connect(function()
	if ItemUi.Visible then
		Reset()
		script.Select:Play()
		GearUi.Visible = true
		ItemUi.Visible = false
	end
end)



InventoryGui:GetPropertyChangedSignal("Visible"):Connect(function()
	Reset()
end)


GearUi.Trash.Activated:Connect(function()
	if not SelectedItem then return end
	ManageGear.RemoveGear(LocalPlayer, SelectedItem)
	script.Select:Play()
	PreviousButton:Destroy()
	Reset()
end)



local SelectedTitle

local function ResetTitle()
	if SelectedTitle then
		SelectedTitle.Soul.Visible = false
		SelectedTitle = nil
		InventoryGui.Description.Text = ""
	end
end

TitleUI.Selections.Equip.Activated:Connect(function()
	if not SelectedTitle then return end

	local Index = SelectedTitle.Name
	local Config = TitleConfig[Index]
	
	if Data.CurrentTitle == Index then
		-- Unequip
		DataManager.EquipTitle(LocalPlayer, nil)
		TitleUI.Selections.Equip.TextLabel.Text = "Equip"
	else
		DataManager.EquipTitle(LocalPlayer, Index)
		TitleUI.Selections.Equip.TextLabel.Text = "Equipped"
	end
end)



local function AddTitle(Index, Value, OldValue)
	local Config = TitleConfig[Value]
	if not Config then return end
	
	local Existing = TitleUI.Titles:FindFirstChild(Value)
	if Existing then return end

	local Display = script.Title:Clone()
	Display.Name = Value
	Display.TitleName.Text = Config.Title
	Display.Parent = TitleUI.Titles

	Display.Button.Activated:Connect(function()
		if SelectedTitle == Display then
			ResetTitle()
			return
		end

		if SelectedTitle then
			SelectedTitle.Soul.Visible = false
		end
		
		script.Select:Play()
		InventoryGui.Description.Text = Config.Description
		Display.Soul.Visible = true
		SelectedTitle = Display

		if Data.CurrentTitle == Index then
			TitleUI.Selections.Equip.TextLabel.Text = "Equipped"
		else
			TitleUI.Selections.Equip.TextLabel.Text = "Equip"
		end
		TitleUI.Selections.Equip.Visible = true
	end)
end


Data.Titles.Changed:Connect(AddTitle)

for Title, Owned in Data.Titles do
	AddTitle(Title, Owned)
end



InventoryGui.GearButton.Activated:Connect(function()
	if GearUi.Visible then return end
	Reset()
	script.Select:Play()
	GearUi.Visible = true
	ItemUi.Visible = false
	TitleUI.Visible = false
end)


InventoryGui.TitleButton.Activated:Connect(function()
	print("Pressed")
	if TitleUI.Visible then return end
		Reset()
		script.Select:Play()
		GearUi.Visible = false
		ItemUi.Visible = false
		TitleUI.Visible = true
end)

InventoryGui.InventoryButton.Activated:Connect(function()
	if ItemUi.Visible then return end
	Reset()
	script.Select:Play()
	GearUi.Visible = false
	ItemUi.Visible = true
	TitleUI.Visible = false
end)


InventoryGui:GetPropertyChangedSignal("Visible"):Connect(function()
	Reset()
end)


--Data.Gear.Changed:Connect(AddGear)


--[[AddGear(1, "Clowdy Glasses")
AddGear(2, "Chain Mail")
AddGear(3, "Real Knife")]]


--[[("Monster Candy", 3)
AddItem("Legendary Hero", 1)
AddItem("Mystery Potion", 2)]]



