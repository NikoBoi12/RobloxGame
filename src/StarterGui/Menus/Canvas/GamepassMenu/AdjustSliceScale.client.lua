task.wait(5)

local player = game.Players.LocalPlayer

local y = workspace.CurrentCamera.ViewportSize.Y

local function calculateSliceScale(screenHeight: number)
	local constant = script.Constant.Value
	
	return screenHeight / constant
end

script.Parent.SliceScale = calculateSliceScale(y)