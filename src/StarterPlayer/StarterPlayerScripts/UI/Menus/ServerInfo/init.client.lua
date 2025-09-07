local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ReplicatedStorage:WaitForChild("PlayerData"))
local Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
local StatConfig = require(script.StatInfo)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Menus = PlayerGui:WaitForChild("Menus"):WaitForChild("Canvas")
local InfoGui = Menus:WaitForChild("Info")
local ServerUi = InfoGui:WaitForChild("ExtrasInfo"):WaitForChild("Server")
local ServerInfoUi = ServerUi:WaitForChild("ServerInfo")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RemoteFunction = Remotes:WaitForChild("RemoteFunctions")
local RequestInfo = RemoteFunction:WaitForChild("RequestServerInfo")

local Data = PlayerData.GetData(LocalPlayer)

local ServerInfo = RequestInfo:InvokeServer()

ServerInfoUi.Region.Text = "Region : "..(ServerInfo.Region or "Unknown")
ServerInfoUi.Version.Text = "Version : "..(ServerInfo.ServerVersion or "")
ServerInfoUi.UpTime.Text = "Server Uptime : "


if ServerInfo.ServerTime then
	while true do
		ServerInfoUi.UpTime.Text = "Server Uptime : "..Utility.ConvertSeconds(os.time() - ServerInfo.ServerTime)
		task.wait(1)
	end
end