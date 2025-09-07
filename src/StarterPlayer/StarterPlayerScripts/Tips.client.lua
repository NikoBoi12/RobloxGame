local TextChatService = game:GetService("TextChatService")

local TextChannels = TextChatService:WaitForChild("TextChannels")

local Tips = {
	"Biomes can increase rarities and decrease rarities!",
	"Each map can have its own unique biome!",
	"Some biomes can happen on multiple maps.",
	"We try to host major events every 1-2 months! Check our links under the game to stay updated!",
	"I attempt to update this game once a month!",
	"There are PVE battles around the map! Go check them out!",
	"Luck works like: Rarity/(Luck*Mult) So if your at 2 luck a 1 in 1 million is already a 1 in 500k!",
	":) I ran out of tip ideas :P",
	"If a cutscene can't be repeated that means it has a temporary cutscene meaning it will be replaced eventually",
	"Check out Seams shop! Tons of items to buy there!",
	"Spamtons trashcan has all sorts of neat items!",
	"Obbies give buffs when Completing them! Though I heard if you take to long something bad happens...",
	"Rolling in different maps provide buffs and debuffs to certain auras",
	"Rolling in a map with a series will buff the auras within the series very slightly",
	"NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL NIKO BALL ahem... sorry",
	"Next update I plan on adding npc's and more quests!",
	"Primary focus of this game is to add more non afk things to do!",
	"Luck circles spawn randomly! Finding them can bring a ton of luck!",
	"There are currently 2 pve fights!",
	"Check what auras are obtainable currently in info and roll info!",
}


while true do
	task.wait(300)
	local ChatMessage = "[Tip] "..Tips[math.random(1, #Tips)]
	TextChannels.RBXSystem:DisplaySystemMessage(string.format("<font color='#01f0b8'>%s</font>", ChatMessage))
end