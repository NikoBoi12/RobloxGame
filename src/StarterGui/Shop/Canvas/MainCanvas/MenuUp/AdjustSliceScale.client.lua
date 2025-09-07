local player = game.Players.LocalPlayer

local y = workspace.CurrentCamera.ViewportSize.Y

local function calculateSliceScale(screenHeight: number)
	local constant = 2880

	return screenHeight / constant
end

script.Parent.SliceScale = calculateSliceScale(y)