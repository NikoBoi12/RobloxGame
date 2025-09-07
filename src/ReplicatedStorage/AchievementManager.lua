local AchievementManager = {}


local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local QuestManagerv2 = require(ReplicatedStorage.QuestManagerv2)
local PlayerData = require(ReplicatedStorage.PlayerData)
local Config = require(ReplicatedStorage.Configs.Quests.Achievements)

local selectedQuest: string = ""

local function SetUpQuest(Player, Quest)
	local Data = PlayerData.GetData(Player)

	Quest:StartQuest()
	
	script.QuestCreated:FireClient(Player, Quest.UID)

	Data.Quests[Quest.QuestName].Changed:Connect(function(Index, Value)
		if Index == "IsCompleted" and Value == true then
			if not Data.Quests[Quest.QuestName].IsClaimed then
				Quest:ClaimReward()
			end
		end
	end)
end


local function LoadQuests(Player)
	local Data = PlayerData.GetData(Player)
	
	for Quest, QuestData in Data.Quests do
		if Config[Quest] then
			local Quest = QuestManagerv2.NewQuest(Player, {
				QuestName = Quest,
				Config = ReplicatedStorage.Configs.Quests.Achievements,
				UID = QuestData.UID,
				Progress = QuestData.Progress,
				IsCompleted = QuestData.IsCompleted
			})

			SetUpQuest(Player, Quest)
		end
	end
end


local function CreateQuests(Player)
	local Data = PlayerData.GetData(Player)
	
	--Data.Quests = {}

	for QuestName, QuestData in Config do
		if not Data.Quests[QuestName] then
			local Quest = QuestManagerv2.NewQuest(Player, {
				QuestName = QuestName,
				Config = ReplicatedStorage.Configs.Quests.Achievements,
			})
			SetUpQuest(Player, Quest)
		end
	end
end

local function PlayerAdded(Player)
	local Data = PlayerData.GetData(Player)
	
	LoadQuests(Player)
	CreateQuests(Player)
end

local function updateClaim(status: "Locked" | "Claimed" | "CanClaim")
	local LocalPlayer = PlayerService.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui
	local AchievementGui = PlayerGui:WaitForChild("Menus").Canvas.Missions.AchievementsMissions  :: typeof(game.StarterGui.Menus.Canvas.Missions.AchievementsMissions)
	local Border = AchievementGui.Border
	
	if status == "Locked" then
		Border.Claim.TextLabel.Text = [[<font color='#FF0000'>Locked!</font>]];
	elseif status == "Claimed" then
		Border.Claim.TextLabel.Text = [[<font color='#00FF00'>Claimed!</font>]];
	elseif status == "CanClaim" then
		Border.Claim.TextLabel.Text = "Claim!";
	end
end

local function updateBorder(Config)
	local LocalPlayer = PlayerService.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui

	local AchievementGui = PlayerGui:WaitForChild("Menus").Canvas.Missions.AchievementsMissions  :: typeof(game.StarterGui.Menus.Canvas.Missions.AchievementsMissions)
	local Border = AchievementGui.Border
	
	Border.DescriptionLong.Text = Config.Description;
	Border.Title.Text = Config.Title;
	Border.Rewards.ScrollingFrame.TextLabel.Text = (Config.Rewards or "None")
	
	updateClaim(Config.CanClaim)
	Border.Claim.Visible = true;
end

local DefaultColor = Color3.fromRGB(255, 255, 0)
local ClaimedColor = Color3.fromRGB(0, 255, 0)

local function QuestCreatedClient(UID)
	local LocalPlayer = PlayerService.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui
	
	local AchievementGui = PlayerGui:WaitForChild("Menus").Canvas.Missions.AchievementsMissions :: typeof(game.StarterGui.Menus.Canvas.Missions.AchievementsMissions)
	
	local Quest = QuestManagerv2.List[UID]
	
	local Config = Quest.Config
	local Apperance = Config.Appearance
	local Frame = Apperance.Frame:Clone() :: typeof(ReplicatedStorage.Achievements.Appearance.AchievementDisplay)
	local Configuration = Frame.Configuration
		local Data = PlayerData.GetData(LocalPlayer)
	local QuestData = Data.Quests[Quest.QuestName]

	Frame.Activated:Connect(function()
		updateBorder({
			Description = Apperance.Description;
			Title = Apperance.Title;
			Rewards = Apperance.Rewards;
			CanClaim = (
				
			if QuestData.IsClaimed
			then "Claimed"
			elseif QuestData.IsCompleted
			then "CanClaim"
			else "Locked"
			)
		})
		
		selectedQuest = Quest.QuestName
	end)
	
	
	
	Frame.ProgressBar.BackgroundColor3 = (
		if QuestData.IsClaimed
		then ClaimedColor
		else DefaultColor
	)
	
	Frame.LayoutOrder = Apperance.Layout or 0
	
	Configuration.Description.Value.Text = Apperance.Description or "Fall back"
	Configuration.Title.Value.Text = Apperance.Title or "Fall back"
	Configuration.ProgressText.Value.Text = 
		(Data.Quests[Quest.QuestName].IsClaimed and "Claimed") or
		(Data.Quests[Quest.QuestName].IsCompleted and "Completed") or 
		(if Data.Quests[Quest.QuestName].Progress % 1 == 0 then Data.Quests[Quest.QuestName].Progress else string.format("%.1f", Data.Quests[Quest.QuestName].Progress) or "Fall Back").." / "..(Config.Goal or "Fall Back")
	Configuration.Icon.Value.Image = Apperance.Icon or "rbxassetid://"..92279548586368
	
	Data.Quests[Quest.QuestName].Changed:Connect(function(Index, Value)
		if Index == "IsCompleted" and Value == true then
			if selectedQuest == Quest.QuestName then
				updateClaim("CanClaim")
			end
			Configuration.ProgressText.Value.Text = "Completed"
		elseif Index == "Progress" then
			Configuration.ProgressText.Value.Text = string.format("%.1f",Value).." / "..Config.Goal
		elseif Index == "IsClaimed" and Value == true then
			Configuration.ProgressText.Value.Text = "Claimed"
			if selectedQuest == Quest.QuestName then
				updateClaim("Claimed")
			end
			Frame.ProgressBar.BackgroundColor3 = ClaimedColor
		end
	end)
	
	Frame.Parent = AchievementGui.ScrollingFrame
end

local function redeemQuest(Player: Player, quest: string)
	local Data = PlayerData.GetData(Player)
	if not Data then return end
	
	local QuestData = Data.Quests[quest]
	local QuestConfig = Config[quest]
	local ActualQuest = QuestManagerv2.List[QuestData.UID]
	
	if QuestData and (QuestData.IsCompleted) and not QuestData.IsClaimed then
		ActualQuest:ClaimReward()
		QuestData.IsClaimed = true;

	end
	
end

if RunService:IsServer() then
	for _, Player in PlayerService:GetPlayers() do
		PlayerAdded(Player)
	end
	PlayerService.PlayerAdded:Connect(PlayerAdded)
	
	script.ClaimQuest.OnServerEvent:Connect(redeemQuest)
else
	local LocalPlayer = PlayerService.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UI = PlayerGui:WaitForChild("Menus").Canvas.Missions.AchievementsMissions :: typeof(game.StarterGui.Menus.Canvas.Missions.AchievementsMissions)
	local Data = assert(PlayerData.GetData(LocalPlayer), "Data not found!")
	UI.Border.Claim.Activated:Connect(function()
		if Config[selectedQuest] then
			script.ClaimQuest:FireServer(selectedQuest)
		end
	end)
	
	script.QuestCreated.OnClientEvent:Connect(QuestCreatedClient)
end

return AchievementManager