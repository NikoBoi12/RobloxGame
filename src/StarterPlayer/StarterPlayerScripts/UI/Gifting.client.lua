local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")


local HUD = PlayerGui:WaitForChild("HUD"):WaitForChild("Canvas") :: typeof(StarterGui.HUD.Canvas)
local Menu = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas") :: typeof(StarterGui.Menus.Canvas)
local GiftMenu = Menu:WaitForChild("GiftMenu") :: typeof(StarterGui.Menus.Canvas.GiftMenu)

local GiftRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GiftPass")

local Storage = ReplicatedStorage.Storage
local SFX = Storage.SFX

task.wait(1.5)

HUD:WaitForChild("Gift").Activated:Connect(function()
	script.Select:Play()
	if GiftMenu.Visible then
		GiftMenu.Visible = false
	else
		if Menu.GamepassMenu.Visible then return end
		GiftMenu.Visible = true
	end
end)


GiftMenu:WaitForChild("Cancel").Activated:Connect(function()
	script.Select:Play()
	GiftMenu.Visible = false
end)

local Descriptions = {
	["Fast Roll"] = "Allows someone to roll quicker." ;
	["Movement Speed"] = "Gives someone increased movement speed." ;
	["Niko Ball"] = "Gives someone Niko's Sun.";
	["Higher Jump"] = "Gives someone increased jump height.",
	["VIP"] = "Give someone VIP! Perks: Grants 1.5x total luck, 1.5x mission rewards, and a chat title!",
	["Skip Cutscenes"] = "Gives someone the ability to skip cutscenes you can still view missed cutscenes in the index.",
}

task.defer(function() -- just hovering/unhovering button stuff
	GiftMenu.Cancel.MouseEnter:Connect(function()
		script.MenuMove:Play()
		GiftMenu.Cancel.TextColor3 = Color3.new(1,1,0)
		GiftMenu.Cancel.TextStroke.Enabled = false;
		GiftMenu.Cancel.BorderStroke.Color = Color3.new(1,1,0);
	end)
	GiftMenu.Cancel.MouseLeave:Connect(function()
		GiftMenu.Cancel.TextColor3 = Color3.new(1,1,1)
		GiftMenu.Cancel.TextStroke.Enabled = true;
		GiftMenu.Cancel.BorderStroke.Color = Color3.new(1,1,1);
	end)
	
	for _, button in GiftMenu.Background.List:GetChildren() do
		if button:IsA("TextButton") then

			button.Activated:Connect(function()
				script.Select:Play()
				GiftMenu:SetAttribute("SelectedGift", button.Name)
				GiftMenu.Description.Text = Descriptions[button.Name]
				GiftMenu.Selected.Text = button.Text
			end)

			button.MouseEnter:Connect(function()
				script.MenuMove:Play()
				button.BorderColor3 = Color3.new(1,1,0);
				button.TextColor3 = Color3.new(1,1,0)
				button.ZIndex = 2
			end)
			button.MouseLeave:Connect(function()
				button.BorderColor3 = Color3.new(1,1,1);
				button.TextColor3 = Color3.new(1,1,1);
				button.ZIndex = 1
			end)

		else continue end
	end
end)

local function GiftPass(UserId : number , GiftName : string)
	GiftRemote:FireServer(UserId, GiftName )
end


local function GiftRecieved(Bool:boolean)
	if Bool then
		GiftMenu.Background.TextBox.Text = ""
		GiftMenu.Background.TextBox.PlaceholderText = "Sucessfully gifted! Make sure you tell them you gifted them <3"
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(85, 255, 0)

		task.wait(3)

		GiftMenu.Background.TextBox.PlaceholderText = "Enter a player's username here."
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(30, 30, 30)
	else
		GiftMenu.Background.TextBox.Text = ""
		GiftMenu.Background.TextBox.PlaceholderText = "There seemed to be an issue with receiving a gift. Please contact the game owner,"
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(170, 0, 0)

		task.wait(4)

		GiftMenu.Background.TextBox.PlaceholderText = "Enter a player's username here."
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(30, 30, 30)
	end
end

GiftRemote.OnClientEvent:Connect( GiftRecieved :: (boolean) )

local function PurchaseGift()
	local PlayerName = GiftMenu.Background.TextBox.Text
	
	local TargetPlayer = PlayerService:FindFirstChild(PlayerName)
	
	script.Select:Play()
	if TargetPlayer then
		local OtherPlayersData = PlayerData.GetData(TargetPlayer)
		GiftPass(TargetPlayer.UserId , GiftMenu:GetAttribute("SelectedGift") )
	else
		GiftMenu.Background.TextBox.Text = ""
		GiftMenu.Background.TextBox.PlaceholderText = string.format("%s is not a valid account. Please try again!", PlayerName) --"Player is not found Try again"
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(170, 0, 0)
		
		task.wait(2)
		
		GiftMenu.Background.TextBox.PlaceholderText = "Enter someone's username to gift them."
		GiftMenu.Background.TextBox.PlaceholderColor3 = Color3.fromRGB(30, 30, 30)
	end
end


GiftMenu:WaitForChild("Purchase").Activated:Connect(PurchaseGift)
