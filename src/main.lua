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

-- Extra Tiles
local x, y = tiles[4]:getPosition()
x -= 300
local extraTile1 = Tile(x, y, tileWidth, tiles[4]:getImage())
extraTile1:add()
x, y = tiles[1]:getPosition()
x += 300
local extraTile2 = Tile(x, y, tileWidth, tiles[1]:getImage())
extraTile2:add()

local row = 0
local column = 0
local isVertical = false

function pd.update()
	-- gfx.clear()

	gfx.sprite.update()
	pd.timer.updateTimers()

	-- Determine row/column
	local extraTilesDirty = false
	if pd.buttonJustPressed(pd.kButtonDown) then
		if isVertical then
			isVertical = false
		else
			row += 1
		end
		extraTilesDirty = true
	elseif pd.buttonJustPressed(pd.kButtonUp) then
		if isVertical then
			isVertical = false
		else
			row -= 1
		end
		extraTilesDirty = true
	elseif pd.buttonJustPressed(pd.kButtonLeft) then
		if not isVertical then
			isVertical = true
		else
			column -= 1
		end
		extraTilesDirty = true
	elseif pd.buttonJustPressed(pd.kButtonRight) then
		if not isVertical then
			isVertical = true
		else
			column += 1
		end
		extraTilesDirty = true
	end
	row = row % 4
	column = column % 4

	-- Update extra tiles on changed row/column
	if extraTilesDirty then
		if not isVertical then
			extraTile1:setImage(tiles[4 + (row * 4)]:getImage())
			x, y = tiles[4 + (row * 4)]:getPosition()
			extraTile1:moveTo(x - 300, y)
			extraTile2:setImage(tiles[1 + (row * 4)]:getImage())
			x, y = tiles[1 + (row * 4)]:getPosition()
			extraTile2:moveTo(x + 300, y)
		else
			extraTile1:setImage(tiles[column + (4 * (4 - 1)) + 1]:getImage())
			x, y = tiles[column + (4 * (4 - 1)) + 1]:getPosition()
			extraTile1:moveTo(x, y - 300)
			extraTile2:setImage(tiles[column + (4 * (1 - 1)) + 1]:getImage())
			x, y = tiles[column + (4 * (1 - 1)) + 1]:getPosition()
			extraTile2:moveTo(x, y + 300)
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
	tilesToMove[5] = extraTile1
	tilesToMove[6] = extraTile2

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
