local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataBase = require(ReplicatedStorage:WaitForChild("PlayerData"))
local ReverbUtility = require(ReplicatedStorage.Modules.GameUtility)
local Utility = require(ReplicatedStorage.Modules:WaitForChild("Utility"))

local Player = Players.LocalPlayer
local PlayerData = PlayerDataBase.GetData(Player)

local Module = {}


local function formatNumber(number)
	if type(number) ~= "number" then
		return "Invalid input"
	end

	if number >= 100000 then
		local absNumber = math.abs(number)

		local abbreviations = {
			{ 1e12, "T" }, -- Trillion
			{ 1e9, "B" }, -- Billion
			{ 1e6, "M" }, -- Million
			{ 1e3, "K" }  -- Thousand
		}

		for _, data in ipairs(abbreviations) do
			local value, suffix = unpack(data)
			if absNumber >= value then
				local formatted = number / value
				local roundedFormatted = tonumber(string.format("%.2f", formatted))
				if roundedFormatted == math.floor(roundedFormatted) then
					return string.format("%d%s", roundedFormatted, suffix)
				else
					return string.format("%.2f%s", roundedFormatted, suffix)
				end
			end
		end
	end

	return tostring(number)
end


function Module:UpdateBoard(OrderedData)
	if OrderedData then
		self.OrderedData = OrderedData
	end

	if not OrderedData then warn("MissingData")
	end

	if not self.Visible then
		return
	end

	self.Updating = true
	self:ClearBoard()

	local IsLocalPlayerIncluded = false

	for Rank, Data in self.OrderedData do
		local NewLabel = self.DefaultLabel:Clone()
		NewLabel.LayoutOrder = Rank
		NewLabel.Rank.Text = "#"..Rank
		NewLabel.Player.Text = Data.UserName or "Failed to load"
		NewLabel.Value.Text = formatNumber(Data.value)

		--local Success, URL, IsReady = ReverbUtility.Retry(function()
		--	return Players:GetUserThumbnailAsync(Data.key, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		--end, "GetUserThumbnail")

		--if Success then
		--	NewLabel.PlayerProfile.Image = URL
		--	NewLabel.PlayerProfile.Visible = true
		--end

		if Data.ImageId then
			NewLabel.PlayerProfile.Image = Data.ImageId or "rbxassetid://7845625278"
			NewLabel.PlayerProfile.Visible = true
		end

		if Rank == 1 then
			NewLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 127)
		elseif Rank == 2 then
			NewLabel.BackgroundColor3 = Color3.fromRGB(207, 212, 255)
		elseif Rank == 3 then
			NewLabel.BackgroundColor3 = Color3.fromRGB(221, 157, 120)
		end

		if tonumber(Data.key) == Player.UserId then
			--change color of local player label to make it easier to see?
			IsLocalPlayerIncluded = true
		end

		NewLabel.Visible = true
		NewLabel.Parent = self.ScrollingFrame
	end

	if not IsLocalPlayerIncluded and self.DataType then
		local NewLabel = self.DefaultLabel:Clone()
		NewLabel.LayoutOrder = #self.OrderedData+1
		NewLabel.Rank.Text = ""
		NewLabel.Player.Text = Player.Name
		NewLabel.Value.Text = formatNumber(PlayerData[self.DataType])

		local Success, URL, IsReady = ReverbUtility.Retry(function()
			return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end, "GetUserThumbnail")

		if Success then
			NewLabel.PlayerProfile.Image = URL
			NewLabel.PlayerProfile.Visible = true
		end

		--change color of local player label to make it easier to see?

		NewLabel.Visible = true
		NewLabel.Parent = self.ScrollingFrame
	end

	self.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, self.UiList.AbsoluteContentSize.Y)
	self.LastUpdate = os.time()
	self.Updating = false
end

function Module:ClearBoard()
	for _, Object in self.ScrollingFrame:GetChildren() do
		if Object:IsA("Frame") then
			Object:Destroy()
		end
	end
end


function Module:UpdateLocalPlayerData()
	if not PlayerData[self.DataType] then
		return
	end

	for _, Data in self.OrderedData do
		if tonumber(Data.key) == Player.UserId then
			Data.value = PlayerData[self.DataType]
			break
		end
	end

	table.sort(self.OrderedData, function(A, B)
		return A.value > B.value
	end)
end


return {
	new = function(Board, DataType, OrderedData)
		local Body = Board:WaitForChild("Body")
		local Leaderboard = Body:WaitForChild("Leaderboard")
		local ScrollingFrame = Leaderboard:WaitForChild("ScrollingFrame")
		local UiList = ScrollingFrame:WaitForChild("UIListLayout")
		local DefaultLabel = ScrollingFrame:FindFirstChild("Default") or Leaderboard:FindFirstChild("Default")
		DefaultLabel.Visible = false
		DefaultLabel.Parent = Leaderboard

		local NewLeaderboard = Utility.Inherit2({
			OrderedData = OrderedData or {},
			DataType = DataType, --for local player updates. example: "HumanKills"
			Visible = true,

			ScrollingFrame = ScrollingFrame,
			UiList = UiList,
			DefaultLabel = DefaultLabel,
		}, Module)

		return NewLeaderboard
	end,
}