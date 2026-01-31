import("CoreLibs/graphics")
import("CoreLibs/ui")
import("CoreLibs/sprites.lua")
import("CoreLibs/object.lua")

import("tile")

local pd = playdate
local gfx = playdate.graphics

local tileWidth = 75

local noiseImages = {}
-- 16 perlin rectangles
local function initPerlinRectangles()
	for i = 1, 16 do
		local img = gfx.image.new(tileWidth, tileWidth)
		gfx.pushContext(img)

		local zOffset = i * 10
		for x = 0, tileWidth - 1 do
			for y = 0, tileWidth - 1 do
				local noiseVal = gfx.perlin(x * 0.05, y * 0.05, zOffset)
				if noiseVal > 0.5 then
					gfx.setColor(gfx.kColorWhite)
				else
					gfx.setColor(gfx.kColorBlack)
				end
				gfx.drawPixel(x, y)
			end
		end

		gfx.popContext()
		noiseImages[i] = img
	end
end

local tiles = {}
local function initClassTiles()
	for i = 0, 3 do
		for j = 0, 3 do
			local index = j * 4 + i + 1
			tiles[index] = Tile(
				50 + (tileWidth / 2) + (i * tileWidth),
				-15 + (j * tileWidth) + (tileWidth / 2),
				tileWidth,
				noiseImages[index]
			)
			tiles[index]:add()
		end
	end
end

initPerlinRectangles()
initClassTiles()

local row = 0
local column = 0
local isVertical = false

local mirroredStartTile = Tile(0, 0, tileWidth, tiles[1]:getImage())
mirroredStartTile:add()
local mirroredEndTile = Tile(0, 0, tileWidth, tiles[1]:getImage())
mirroredEndTile:add()

local function updateMirroredTiles(startTile, endTile)
	mirroredEndTile:setImage(endTile:getImage())
	x, y = endTile:getPosition()
	if isVertical then
		y -= 300
	else
		x -= 300
	end
	mirroredEndTile:moveTo(x, y)
	mirroredStartTile:setImage(startTile:getImage())
	x, y = startTile:getPosition()
	if isVertical then
		y += 300
	else
		x += 300
	end
	mirroredStartTile:moveTo(x, y)
end

local function updateAxis(isCurrentVertical, isTargetVertical, delta)
	if isCurrentVertical == isTargetVertical then
		return isTargetVertical, delta
	else
		return isTargetVertical, 0
	end
end

updateMirroredTiles(tiles[1], tiles[4])

function pd.update()
	-- gfx.clear()

	gfx.sprite.update()
	pd.timer.updateTimers()

	-- Determine row/column
	local delta
	if pd.buttonJustPressed(pd.kButtonDown) then
		isVertical, delta = updateAxis(isVertical, false, 1)
		row += delta
	elseif pd.buttonJustPressed(pd.kButtonUp) then
		isVertical, delta = updateAxis(isVertical, false, -1)
		row += delta
	elseif pd.buttonJustPressed(pd.kButtonLeft) then
		isVertical, delta = updateAxis(isVertical, true, -1)
		column += delta
	elseif pd.buttonJustPressed(pd.kButtonRight) then
		isVertical, delta = updateAxis(isVertical, true, 1)
		column += delta
	end
	row = row % 4
	column = column % 4

	-- Update mirrored tiles on changed row/column
	local extraTilesDirty = pd.buttonJustPressed(pd.kButtonDown)
		or pd.buttonJustPressed(pd.kButtonUp)
		or pd.buttonJustPressed(pd.kButtonLeft)
		or pd.buttonJustPressed(pd.kButtonRight)
	if extraTilesDirty then
		if isVertical then
			updateMirroredTiles(tiles[1 + column], tiles[1 + column + 12])
		else
			updateMirroredTiles(tiles[1 + (row * 4)], tiles[4 + (row * 4)])
		end
	end

	-- Select tiles to move
	local tilesToMove = {}
	if not isVertical then
		for i = 1, 4 do
			tilesToMove[i] = tiles[i + (row * 4)]
		end
	else
		for i = 1, 4 do
			tilesToMove[i] = tiles[column + (4 * (i - 1)) + 1]
		end
	end
	tilesToMove[5] = mirroredStartTile
	tilesToMove[6] = mirroredEndTile

	-- Move tiles on crank change
	local crankChange = pd.getCrankChange()
	for i = 1, 6 do
		x, y = tilesToMove[i]:getPosition()
		if not isVertical then
			x += crankChange / 4
		else
			y += crankChange / 4
		end
		tilesToMove[i]:moveTo(x, y)
	end

	-- Top bar
	gfx.fillRect(0, 0, 400, 30)
end
