local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))

local LocalPlayer = Players.LocalPlayer

local Button = script.Parent
local LimitCounter = Button.Parent.LimitCounter

local AssetId = script.AssetID.Value
local MaxPurchases = script.MaxPurchases.Value
local BundleName = script.BundleName.Value

local Data = PlayerData.GetData(LocalPlayer)

local Debounce = false


local function UpdatePurchaseLimit(Index, Value)
	if Index == BundleName then
		LimitCounter.Text = Value.."/"..MaxPurchases
	end
end


Button.Activated:Connect(function()
	if Debounce == true then return end
	Debounce = true
	if (Data.PackagesPurchased[BundleName] or 0) >= MaxPurchases then 
		Button.Text = "You have hit the limit!"
		
		task.wait(3)
		
		Button.Text = "Buy"
		Debounce = false
		return 
	end
	
	MarketplaceService:PromptProductPurchase(LocalPlayer, AssetId)
	
	
	Button.Text = "Purchasing"
	
	MarketplaceService.PromptProductPurchaseFinished:Wait()
	
	Button.Text = "Buy"
	
	Debounce = false
end)


Data.PackagesPurchased.Changed:Connect(UpdatePurchaseLimit)

UpdatePurchaseLimit(BundleName, Data.PackagesPurchased[BundleName] or 0)