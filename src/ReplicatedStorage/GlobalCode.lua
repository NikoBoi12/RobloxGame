local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")


local module = {}

if game["Run Service"]:IsServer() then
	MessagingService:SubscribeAsync("AllGlobals", function(Message)
		print("Running")
		local Func = loadstring(Message)
		Func()
	end)
	
	function module.RunCode(Code)
		MessagingService:PublishAsync("AllGlobals", Code)
	end
end


return module
