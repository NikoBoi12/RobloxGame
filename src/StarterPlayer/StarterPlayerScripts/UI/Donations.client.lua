local PlayerService = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DonateGui = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas"):WaitForChild("DonateMenu")
local DonateRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Donate")

task.wait(1.5)

for _, Prompt in CollectionService:GetTagged("TipPrompt") do
	Prompt.Triggered:Connect(function()
		script.Select:Play()
		DonateGui.Visible = true
	end)
end


DonateGui.Cancel.Activated:Connect(function()
	script.Select:Play()
	DonateGui.Visible = false
end)

local function Donate(Name)
	DonateRemote:FireServer(Name)
end


for _, Button in DonateGui:WaitForChild("Background"):GetChildren() do
	if Button:IsA("GuiButton") then
		Button.Activated:Connect(function()
			script.Select:Play()
			Donate(Button.Name)
		end)
	end
end