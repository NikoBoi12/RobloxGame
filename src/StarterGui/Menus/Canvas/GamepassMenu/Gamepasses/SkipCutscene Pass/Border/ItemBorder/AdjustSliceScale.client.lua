local player = game.Players.LocalPlayer

local y = workspace.CurrentCamera.ViewportSize.Y

local function calculateSliceScale(screenHeight: number)
	local constant = screenHeight/script.Parent.SliceScale

	return screenHeight / constant
end

script.Parent.SliceScale = calculateSliceScale(y)