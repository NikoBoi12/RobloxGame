local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataBase = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Leaderboard = require(script:WaitForChild("Leaderboard"))

local EventsFolder = ReplicatedStorage:WaitForChild("Remotes")
local UpdateLeaderboard = EventsFolder:WaitForChild("UpdateLeaderboard")

local Player = Players.LocalPlayer
local PlayerData = PlayerDataBase.GetData(Player)

local LeaderboardsFolder = workspace:WaitForChild("Leaderboards")
local Leaderboards = {}
local UpdateRate = 0 --seconds

for _, Board in LeaderboardsFolder:GetChildren() do
	local DataType = Board:WaitForChild("DataType").Value
	Leaderboards["Global"..DataType] = Leaderboard.new(Board, DataType)
	if Board:FindFirstChild("ToggleLocal") and Board.ToggleLocal.Value == true then
		Leaderboards["Local"..DataType] = Leaderboard.new(Board, DataType)
		Leaderboards["Global"..DataType].Visible = false

		local CurrentVisible = "Local"
		local ToggleButton = Board:WaitForChild("ToggleButton")
		local OriginalColor = ToggleButton.Color
		ToggleButton.SurfaceGui.TextLabel.Text = "Local"

		ToggleButton.ClickDetector.MouseClick:Connect(function()
			if Leaderboards[CurrentVisible..DataType].Updating or ToggleButton.Color ~= OriginalColor then
				return
			end

			ToggleButton.Color = BrickColor.Red().Color

			if CurrentVisible == "Local" then
				Leaderboards["Global"..DataType].Visible = true
				Leaderboards["Local"..DataType].Visible = false
				ToggleButton.SurfaceGui.TextLabel.Text = "Global"
				CurrentVisible = "Global"
			else
				Leaderboards["Local"..DataType].Visible = true
				Leaderboards["Global"..DataType].Visible = false
				ToggleButton.SurfaceGui.TextLabel.Text = "Local"
				CurrentVisible = "Local"
			end

			Leaderboards[CurrentVisible..DataType]:UpdateBoard()

			task.wait(UpdateRate)
			ToggleButton.Color = OriginalColor
		end)
	end
end


UpdateLeaderboard.OnClientEvent:Connect(function(LeaderboardsData)
	for _, LeaderboardData in LeaderboardsData do
		if Leaderboards[LeaderboardData.DataType] then
			Leaderboards[LeaderboardData.DataType]:UpdateBoard(LeaderboardData.OrderedData)
		end
	end
end)

PlayerData.Changed:Connect(function(Index)
	if Leaderboards[Index] and (not Leaderboards[Index].LastUpdate or os.time()-Leaderboards[Index].LastUpdate >= UpdateRate) then
		Leaderboards[Index]:UpdateLocalPlayerData()
		Leaderboards[Index]:UpdateBoard()
	end
end)