local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PlayerData = require(ReplicatedStorage.PlayerData)
local Utility = require(ReplicatedStorage.Utility)

local Replicate = script:WaitForChild("Replicate")

type Player = Player
type RBXConnection = RBXScriptConnection
type RBXSignal<T...> = (T...) -> ()

type Packet = {
	UID: string?,
	QuestName: string,
	ConfigName: string,
	Progress: number?,
	IsCompleted: boolean?,
}

type Task = {
	Changed: RBXScriptSignal,
	Start: (self: Task) -> (),
}

type QuestConfig = {
	ClientTask: ((Quest) -> Task)?,
	ServerTask: ((Quest) -> Task)?,
	QuestData: (Quest) -> (),
	Reward: (Quest) -> (),
}

type Quest = {
	Owner: Player,
	UID: string,
	QuestName: string,
	ConfigName: string,
	Config: QuestConfig,
	Task: Task?,
	Progress: number,
	IsCompleted: boolean,
	ClientTask: Task?,
	ServerTask: Task?,
	Completed: BindableEvent,
	Changed: RBXScriptSignal,
	Connections: { RBXConnection },

	CreateQuestData: (self: Quest) -> (),
	CreatePacket: (self: Quest) -> {
		QuestName: string,
		ConfigName: string,
		UID: string,
		Progress: number,
		IsCompleted: boolean,
	},
	StartTask: (self: Quest) -> (),
	StartQuest: (self: Quest) -> (),
	ClaimReward: (self: Quest) -> (),
	Destroy: (self: Quest) -> (),
	DisconnectAll: (self: Quest) -> (),
}

local module = {
	List = {} :: { [string]: Quest },
	NewQuest = nil :: ((Player, Packet) -> Quest)?,
}

local Quest = {} :: Quest


function module.NewQuest(Player: Player, Packet: Packet): Quest
	local self = Utility.Factory(Quest) :: Quest

	self.Owner = Player
	self.UID = Packet.UID or Utility.GenerateUID()
	
	self.Progress = Packet.Progress or 0
	self.IsCompleted = Packet.IsCompleted or false
	self.QuestName = Packet.QuestName	
	
	self.ConfigRefrence = Packet.Config
	self.Config = require(Packet.Config)[self.QuestName] :: QuestConfig
	self.Connections = {}

	if RunService:IsServer() then
		self:CreateQuestData()
		Replicate:FireClient(Player, Player, self:CreatePacket())
	end

	self.Completed = Utility.NewEvent(self)
	self.Changed = Utility.NewEvent(self)

	module.List[self.UID] = self

	return self
end

function Quest:StartQuest(): ()
	if not self.IsCompleted then
		self:StartTask()
	end
	
	if self.Config.ClientInit then
		self.Config.ClientInit(self)
	end
	
	if self.Config.ServerInit then
		self.Config.ServerInit(self)
	end
end

function Quest:StartTask(): ()
	if RunService:IsClient() then
		if self.Config.ClientTask then
			self.ClientTask = self.Config.ClientTask(self)
		end
	else
		self:CreateQuestData()
		if self.Config.ServerTask then
			self.ServerTask = self.Config.ServerTask(self)
		end

		script.StartQuest:FireClient(self.Owner, self.UID)
	end
end

function Quest:ClaimReward(): ()
	self.Config.Reward(self)
end

function Quest:CreateQuestData(): ()
	self.Config.QuestData(self)
end

function Quest:CreatePacket(): {
	QuestName: string,
	Config: ModuleScript,
	UID: string,
	Progress: number,
	IsCompleted: boolean,
	}
	return {
		QuestName = self.QuestName,
		Config = self.ConfigRefrence,
		UID = self.UID,
		Progress = self.Progress,
		IsCompleted = self.IsCompleted,
	}
end


function Quest:DisconnectAll(): ()
	for _, Connection in self.Connections do
		Connection:Disconnect()
	end

	if RunService:IsServer() then
		script.DisconnectAll:FireClient(self.Owner, self.UID)
	else
		if self.Config.EndClientTask then
			self.EndClientTask = self.Config.EndClientTask(self)
		end
	end
end

function Quest:Destroy(): ()
	for _, Connection in self.Connections do
		Connection:Disconnect()
	end

	module.List[self.UID] = nil

	if RunService:IsServer() then
		script.DestroyQuest:FireClient(self.Owner, self.UID)
	end
end

if RunService:IsServer() then
	
else
	script.Replicate.OnClientEvent:Connect(function(Player: Player, Packet: Packet)
		if module.NewQuest then
			module.NewQuest(Player, Packet)
		end
	end)

	script.StartQuest.OnClientEvent:Connect(function(UID: string)
		local self = module.List[UID]

		if self then
			self:StartTask()
		end
	end)

	script.DestroyQuest.OnClientEvent:Connect(function(UID: string)
		local self = module.List[UID]
		if self then
			self:Destroy()
		end
	end)
	
	script.DisconnectAll.OnClientEvent:Connect(function(UID: string)
		local self = module.List[UID]
		if self then
			self:DisconnectAll()
		end
	end)
end

return module
