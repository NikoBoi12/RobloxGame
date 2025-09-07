local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local Dialog = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Dialog"))
local FrameData = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("FrameData"))
local SpriteSheet = require(ReplicatedStorage.Modules:WaitForChild("UIModules"):WaitForChild("SpriteSheet"))
local SeamState = require(ReplicatedStorage.Modules:WaitForChild("States"):WaitForChild("SeamState"))
local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local FaceConfig = require(ReplicatedStorage.Modules:WaitForChild("FrameConfigs"):WaitForChild("Faces"))
local DialogConfig = require(script:WaitForChild("DialogConfig"))
local SeamShopConfig = require(ReplicatedStorage.Configs:WaitForChild("SeamShopConfig"))
local ShopManager = require(ReplicatedStorage.Modules:WaitForChild("ShopManager"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Canvas = PlayerGui:WaitForChild("Shop"):WaitForChild("Canvas")
local ShopUI = Canvas:WaitForChild("MainCanvas")
local TalkUI = Canvas:WaitForChild("TalkCanvas")
local MenuRight = ShopUI:WaitForChild("MenuRight")
local MenuUp = ShopUI:WaitForChild("MenuUp")
local MenuLeft = ShopUI:WaitForChild("MenuLeft")
local Remotes = ReplicatedStorage.Remotes

local BuyCanvas = MenuLeft:WaitForChild("CanvasBuy")
local BuyMenu = BuyCanvas:WaitForChild("BuyMenu")
local StartCanvas = MenuRight:WaitForChild("StartCanvas")
local TalkCanvas = MenuRight:WaitForChild("TalkCanvas")
local RightBuyCanvas = MenuRight:WaitForChild("RightBuyCanvas")

local StoreRemote = Remotes.SolarRemotes.EnterShop
--local StoreEnter = workspace:WaitForChild("Maps"):WaitForChild("Store"):WaitForChild("ProximityPrompt")

local CurrentHover
local CurrentHoverBuy

local ActiveSpeech = false

local Data = PlayerData.GetData(LocalPlayer)

local Images = {"rbxassetid://135654140537972", "rbxassetid://101891915149078"}

local TextScaleData = {}
local TextScalingConnection

local function ProperScaling()
	TextScalingConnection = true
	task.defer(function()
		while TextScalingConnection do
			local TextSize = workspace.CurrentCamera.ViewportSize.Y/20
			task.wait()
			if TextScalingConnection == false then break end
			for _, Label in TextScaleData do
				if math.round(Label.TextSize) == math.round(TextSize) then continue end
				Label.TextSize = TextSize
			end
		end
	end)
end



function AbsolutePosition(Container, Element)
	local Position = UDim2.new(Element.Position.X.Scale*Container.Size.X.Scale+Container.Position.X.Scale, Element.Position.Y.Scale*Container.Size.Y.Scale+Container.Position.Y.Scale)
	local Size = UDim2.fromScale(Container.Size.X.Scale*Element.Size.X.Scale, Container.Size.Y.Scale*Element.Size.Y.Scale)
	return Position, Size
end



local CurrentDialog

local function DefaultMenu(Alt)
	if CurrentDialog then CurrentDialog.KillDialog = true end
	
	ActiveSpeech = true

	MenuLeft.TextLabel.Text = ""
	TextScaleData = {}
	table.insert(TextScaleData, MenuLeft.TextLabel)
	SeamState.Talking()
	local Dialog = Dialog.ManualWrite(Alt or DialogConfig.Intro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
	CurrentDialog = Dialog

	CurrentDialog.Completed.Event:Wait()
	
	ActiveSpeech = false

	if CurrentDialog == Dialog then
		SeamState.Idling()
	end
end


local SelectedItem = nil

local function CancelPrompt()
	TalkCanvas.Visible = true
	RightBuyCanvas.Visible = false
	TalkCanvas.TextLabel.Text = ""
	MenuUp.TextLabel.Text = ""
	 
	if CurrentHoverBuy then
		CurrentHoverBuy.Visible = false
		CurrentHoverBuy = nil
	end

	SelectedItem = nil
end


local OriginalVolume = {}


local function OpenShop(Player: Player)
	local Prompt = workspace.Maps.Store.ProximityPrompt
	for _, SoundObj in ReplicatedStorage.Configs.SoundConfig:GetChildren() do
		if SoundObj.Name == "CutscenePlaying" then continue end
		OriginalVolume[SoundObj] = SoundObj.Volume
		SoundObj.Volume = 0
	end
	
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	
	ProperScaling()
	Canvas.Visible = true
	Prompt.Enabled = false
	script.Lantern:Play()
	DefaultMenu()
end

StoreRemote.OnClientEvent:Connect(OpenShop)


local function CloseBuy()
	TextScaleData = {}
	CurrentDialog.KillDialog = true
	TalkCanvas.TextLabel.Text = ""
	MenuRight.TalkCanvas.Visible = false
	BuyCanvas.Visible = false
	
	CancelPrompt()
	
	TweenService:Create(MenuUp, TweenInfo.new(.4, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(0.614, 0.577)}):Play()
	TweenService:Create(Canvas.Seam, TweenInfo.new(.4, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(0.321, 0.161)}):Play()
	
	task.wait(.5)
	
	MenuRight.StartCanvas.Visible = true
	MenuUp.Visible = false
	
	DefaultMenu(DialogConfig.Intro2)
end

BuyMenu:WaitForChild("Exit").Activated:Connect(CloseBuy)


local function OpenBuy()
	TextScaleData = {}
	CurrentDialog.KillDialog = true
	TalkCanvas.TextLabel.Text = ""
	MenuLeft.TextLabel.Text = ""
	table.insert(TextScaleData, TalkCanvas.TextLabel)
	MenuRight.StartCanvas.Visible = false
	MenuRight.TalkCanvas.Visible = true
	MenuUp.Visible = true
	BuyCanvas.Visible = true
	SeamState.Talking()

	local Dialog = Dialog.ManualWrite(DialogConfig.BuyIntro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
	CurrentDialog = Dialog

	TweenService:Create(MenuUp, TweenInfo.new(.4, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(0.614, 0.188)}):Play()
	TweenService:Create(Canvas.Seam, TweenInfo.new(.4, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(0.2, 0.161)}):Play()
	task.defer(function()
		CurrentDialog.Completed.Event:Wait()

		if CurrentDialog == Dialog then
			SeamState.Idling()
		end
	end)
end

StartCanvas.Buttons.Buy.Activated:Connect(OpenBuy)


local function BuyPrompt(ItemName)
	local Config = SeamShopConfig[ItemName]
	local CostType = Config.Price.Type == "DarkDollars" and "$" or Config.Price.Type
	
	CurrentDialog.KillDialog = true
	
	if SelectedItem == ItemName then
		SeamState.Talking()
		local Dialog = Dialog.ManualWrite(DialogConfig.BuyIntro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
		CurrentDialog = Dialog
		CancelPrompt()
		CurrentDialog.Completed.Event:Wait()
		if CurrentDialog == Dialog then
			SeamState.Idling()
		end
		return
	end

	TalkCanvas.Visible = false
	RightBuyCanvas.Visible = true
	TalkCanvas.TextLabel.Text = ""
	SelectedItem = ItemName
	
	MenuUp.TextLabel.Text = Config.Description
	RightBuyCanvas.AskPrompt.Text = "Buy it for "..Config.Price.Amount..CostType.."?"
end


local function Purchase()
	if not SelectedItem then return end
	local Config = SeamShopConfig[SelectedItem]
	if not Config then return end
	CurrentDialog.KillDialog = true
	CurrentHoverBuy.Visible = false
	CurrentHoverBuy = nil
	
	local CanPurchase = ShopManager.CanPurchase(LocalPlayer, SelectedItem)
	
	if CanPurchase then
		script.Purchase:Play()
		SeamState.Laugh()

		local Dialog = Dialog.ManualWrite(DialogConfig.Purchase, function() if SeamState.PlayerStates:Current() ~= "Laugh" then return true end end)
		CurrentDialog = Dialog

		ShopManager.BuyItem(LocalPlayer, SelectedItem)
		
		CancelPrompt()
		
		CurrentDialog.Completed.Event:Wait()
		task.wait(2)
		if CurrentDialog == Dialog and SeamState.PlayerStates:Current() == "Laugh" then
			SeamState.Idling()
		end
	else
		script.No:Play()
		SeamState.Impatient()

		local Dialog = Dialog.ManualWrite(DialogConfig.NoMoney, function() if SeamState.PlayerStates:Current() ~= "Upset" then return true end end)
		CurrentDialog = Dialog

		CancelPrompt()
		
		CurrentDialog.Completed.Event:Wait()
		task.wait(2)
		if CurrentDialog == Dialog and SeamState.PlayerStates:Current() == "Upset" then
			SeamState.Idling()
		end
	end
	

	

end

RightBuyCanvas.Buttons.Yes.Activated:Connect(Purchase)

RightBuyCanvas.Buttons.No.Activated:Connect(function()
	CurrentDialog.KillDialog = true
	SeamState.Talking()
	local Dialog = Dialog.ManualWrite(DialogConfig.BuyIntro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
	CurrentDialog = Dialog
	CancelPrompt()
	CurrentDialog.Completed.Event:Wait()
	if CurrentDialog == Dialog then
		SeamState.Idling()
	end
end)



local function AddShopItem()
	for Index, Config in SeamShopConfig do
		local ShopTab = script:WaitForChild("CloneMe"):Clone()
		
		for Property, Value in Config.Properties or {} do
			ShopTab[Property] = Value
		end
		
		local CostType = Config.Price.Type == "DarkDollars" and "$" or Config.Price.Type
		
		ShopTab.Amount.Text = CostType..Config.Price.Amount
		ShopTab.Item.Text = Index
		ShopTab.Parent = BuyMenu:FindFirstChildWhichIsA("ScrollingFrame")
		ShopTab.Activated:Connect(function()
			if CurrentHoverBuy then
				CurrentHoverBuy.Visible = false
				if CurrentHoverBuy == ShopTab.Soul then
					CurrentHoverBuy = nil
					BuyPrompt(Index)
					return
				end
			end
			script.MenuMove:Play()
			CurrentHoverBuy = ShopTab.Soul
			CurrentHoverBuy.Visible = true
			BuyPrompt(Index)
		end)
	end
end

AddShopItem()


StartCanvas.Buttons.Talk.Activated:Connect(function()
	TextScaleData = {}
	CurrentDialog.KillDialog = true
	MenuLeft.TextLabel.Text = ""
	table.insert(TextScaleData, TalkCanvas.TextLabel)
	table.insert(TextScaleData, TalkUI.TalkMenu.TextLabel)
	MenuRight.StartCanvas.Visible = false
	MenuRight.TalkCanvas.Visible = true
	MenuLeft.CanvasTalk.Visible = true
	SeamState.Talking()
	
	local Dialog = Dialog.ManualWrite(DialogConfig.TalkIntro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
	CurrentDialog = Dialog

	CurrentDialog.Completed.Event:Wait()

	if CurrentDialog == Dialog then
		SeamState.Idling()
	end
end)


for _, Button in MenuLeft.CanvasTalk.Buttons:GetChildren() do
	if Button:IsA("GuiButton") then
		Button.Activated:Connect(function()
			if not DialogConfig[Button.Name] then return end
			CurrentDialog.KillDialog = true
			TalkUI.Visible = true
			ShopUI.Visible = false
			
			CurrentDialog = nil
			SeamState.Talking()
			
			for _, Packet in DialogConfig[Button.Name] do
				if Packet.CustomEffect then
					Packet.CustomEffect()
				end
				if Packet.Type then

					CurrentDialog = Dialog[Packet.Type](Packet)
					if CurrentDialog.Completed then
						CurrentDialog.Completed.Event:Wait()
					end
				else
					CurrentDialog = Dialog.TypeWriteLabel(Packet)
				end
				
				if Packet.EndCustomEffect then
					Packet.EndCustomEffect()
				end

			end
			
			TalkCanvas.TextLabel.Text = ""
			TalkUI.TalkMenu.TextLabel.Text = ""
			TalkUI.Visible = false
			ShopUI.Visible = true
			
			local Dialog = Dialog.ManualWrite(DialogConfig.TalkIntro, function() if SeamState.PlayerStates:Current() ~= "Talk" then return true end end)
			CurrentDialog = Dialog

			CurrentDialog.Completed.Event:Wait()
			
			ActiveSpeech = false
			
			if Dialog == CurrentDialog then
				SeamState.Idling()
			end
		end)
		Button.MouseEnter:Connect(function()
			if CurrentHover then
				CurrentHover.Visible = false
			end
			CurrentHover = MenuLeft.CanvasTalk[Button.Name]
			CurrentHover.Visible = true
			script.MenuMove:Play()
		end)
	end
end

MenuLeft.CanvasTalk.Buttons.Exit.Activated:Connect(function()
	CurrentDialog.KillDialog = true
	MenuRight.TalkCanvas.Visible = false
	MenuLeft.CanvasTalk.Visible = false
	MenuRight.StartCanvas.Visible = true
	TalkCanvas.TextLabel.Text = ""
	DefaultMenu(DialogConfig.Intro2)
end)

local function exitShop()
	local Prompt = workspace.Maps.Store.ProximityPrompt
	SeamState.Inactivity()
	script.Lantern:Pause()
	Canvas.Visible = false
	TextScalingConnection = false
	Prompt.Enabled = true

	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

	for _, SoundObj in ReplicatedStorage.Configs.SoundConfig:GetChildren() do
		if SoundObj.Name == "CutscenePlaying" then continue end
		SoundObj.Volume = OriginalVolume[SoundObj]
	end

	OriginalVolume = {}
end

StartCanvas.Buttons.Exit.Activated:Connect(exitShop)

local function buttonEnterEvent(Button: GuiButton)
	Button.MouseEnter:Connect(function()
		if CurrentHover then
			CurrentHover.Visible = false
		end
		CurrentHover = StartCanvas[Button.Name]
		CurrentHover.Visible = true
		script.MenuMove:Play()
	end)
end

for _, Button in StartCanvas.Buttons:GetChildren() do
	if Button:IsA("GuiButton") then
		buttonEnterEvent(Button)
	end
end