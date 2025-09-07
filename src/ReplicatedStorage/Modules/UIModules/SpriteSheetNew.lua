local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local SpriteSheet = {}

function SpriteSheet.GetRectSize(Resolution, Packet) --{Width, Height} (Resolution), Rows, Columns
	return Vector2.new(Resolution.X/Packet.Columns, Resolution.Y/Packet.Rows)
end


function SpriteSheet.GetFrames(Packet) --{Width, Height} (Resolution), Rows, Columns
	local Resolution = Packet.Resolution or Vector2.new(1024, 1024)

	if not Packet.Rows or not Packet.Columns then warn("Missing Rows or Column Data") return end

	local FrameVectors = {}

	local Column = 0
	local Row = 0
	for i=1, Packet.MaxFrames or Packet.Rows*Packet.Columns do
		if Column == Packet.Columns then
			Column = 0
			Row += 1
		end

		table.insert(FrameVectors, Vector2.new(Column, Row))
		Column += 1
	end


	local RectSize = SpriteSheet.GetRectSize(Resolution, Packet)

	return {Frames = FrameVectors, ImageRectSize = RectSize}
end


function SpriteSheet.PlaySprite(Packet) -- ["FrameData"] = {{Width, Height} (Resolution), Rows, Columns}, Frames, Image, FramesPerSecond, ImageRectSize
	if not Packet.Image then warn("Missing Image") return end
	if not Packet.Frames then
		if not Packet.FrameData then warn("Missing Frame Data") return end
		local FramesInfo = SpriteSheet.GetFrames(Packet["FrameData"])
		Packet.Frames = FramesInfo.Frames
		Packet.ImageRectSize = FramesInfo.ImageRectSize
	end

	if Packet.ImageRectSize and Packet.Image.ImageRectSize ~= Packet.ImageRectSize then
		Packet.Image.ImageRectSize = Packet.ImageRectSize
	end

	local ExitPacket = {
		StopPlay = false,
		Completed = Instance.new("BindableEvent"),
	}

	task.defer(function()
		for i, Frame in Packet.Frames do
			task.wait(1/(Packet.FramesPerSecond or 1))
			if ExitPacket.StopPlay == true then break end
			SpriteSheet.SetFrame(Frame, Packet.Image)
		end

		--SpriteSheet.SetFrame(Packet.Frames[1], Packet.Image)
		ExitPacket.Completed:Fire()
		ExitPacket.Completed:Destroy()
	end)

	return ExitPacket
end


function SpriteSheet.SetFrame(Frame, Image, StartingOffset)
	if not Frame then warn("Missing Frame") return end 
	if not Image then warn("Missing Image") return end

	Image.ImageRectOffset = Frame * (Image:GetAttribute("FrameOffset") or Image.ImageRectSize) + StartingOffset
end


local SpriteProperties = {}


task.defer(function()
	while true do
		task.wait()
		for _, Image in CollectionService:GetTagged("Sprite") do
			if not SpriteProperties[Image] then
				SpriteProperties[Image] = SpriteSheet.GetFrames({
					Resolution = Image:GetAttribute("Resolution"),
					Rows = Image:GetAttribute("Rows"),
					Columns = Image:GetAttribute("Columns"),
					MaxFrames = Image:GetAttribute("Frames"),
				})

				SpriteProperties[Image]["CurrentFrame"] = 1
				SpriteProperties[Image]["LastFrameTime"] = os.clock()

				Image.Destroying:Once(function()
					SpriteProperties[Image] = nil
				end)
			end

			if Image.Visible == true then
				if os.clock() - SpriteProperties[Image]["LastFrameTime"] <= 1/Image:GetAttribute("FramesPerSecond") then continue end

				if #SpriteProperties[Image]["Frames"] < SpriteProperties[Image]["CurrentFrame"] then 
					SpriteProperties[Image]["CurrentFrame"] = 1
				end

				SpriteProperties[Image]["LastFrameTime"] = os.clock()
				SpriteSheet.SetFrame(SpriteProperties[Image]["Frames"][SpriteProperties[Image]["CurrentFrame"]], Image, Image:GetAttribute("RectOffsetStartingValue"))
				SpriteProperties[Image]["CurrentFrame"] += 1
			end
		end
	end
end)



return SpriteSheet
