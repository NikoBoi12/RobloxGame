local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Button = script.Parent

local AssetId = script.AssetID.Value

local Debounce = false

Button.Activated:Connect(function()
	if Debounce == true then return end
	Debounce = true
	
	MarketplaceService:PromptGamePassPurchase(LocalPlayer, AssetId)
	
	Button.Text = "Purchasing"
	
	MarketplaceService.PromptGamePassPurchaseFinished:Wait()
	
	Button.Text = "Buy"
	
	Debounce = false
end)