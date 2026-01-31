import("CoreLibs/graphics")
import("CoreLibs/ui")
import("CoreLibs/sprites.lua")
import("CoreLibs/object.lua")

import("tile")

local pd = playdate
local gfx = playdate.graphics

local tileWidth = 75

local tileImages = {
	gfx.image.new("images/dissapointed/Dissapointed_LB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_LT.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RB.png"),
	gfx.image.new("images/dissapointed/Dissapointed_RT.png"),
}

local tiles = {}
local function initClassTiles()
	for i = 0, 3 do
		for j = 0, 3 do
			local index = j * 4 + i + 1
			tiles[index] = Tile(
				50 + (tileWidth / 2) + (i * tileWidth),
				-15 + (j * tileWidth) + (tileWidth / 2),
				tileWidth,
				tileImages[index]
			)
			tiles[index]:add()
		end
	end
end

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

updateMirroredTiles(tiles[1], tiles[4])

local function updateAxis(isCurrentVertical, isTargetVertical, delta)
	if isCurrentVertical == isTargetVertical then
		return isTargetVertical, delta
	else
		return isTargetVertical, 0
	end
end

local function rearrangeRow(rowIndex, direction)
	local rowStart = 1 + (rowIndex * 4)
	local rowTiles = {}

	for i = 0, 3 do
		rowTiles[i] = tiles[rowStart + i]
	end

	if direction > 0 then
		-- Moving right: last wraps to first
		tiles[rowStart] = rowTiles[3]
		tiles[rowStart + 1] = rowTiles[0]
		tiles[rowStart + 2] = rowTiles[1]
		tiles[rowStart + 3] = rowTiles[2]
	else
		-- Moving left: first wraps to last
		tiles[rowStart] = rowTiles[1]
		tiles[rowStart + 1] = rowTiles[2]
		tiles[rowStart + 2] = rowTiles[3]
		tiles[rowStart + 3] = rowTiles[0]
	end

	for i = 0, 3 do
		local t = tiles[rowStart + i]
		t.homeX = 50 + (tileWidth / 2) + (i * tileWidth)
		t:moveTo(t.homeX, t.homeY)
	end
end

local function rearrangeColumn(colIndex, direction)
	local colTiles = {}

	for i = 0, 3 do
		colTiles[i] = tiles[colIndex + 1 + (i * 4)]
	end

	if direction > 0 then
		-- Moving down: last wraps to first
		tiles[colIndex + 1] = colTiles[3]
		tiles[colIndex + 1 + 4] = colTiles[0]
		tiles[colIndex + 1 + 8] = colTiles[1]
		tiles[colIndex + 1 + 12] = colTiles[2]
	else
		-- Moving up: first wraps to last
		tiles[colIndex + 1] = colTiles[1]
		tiles[colIndex + 1 + 4] = colTiles[2]
		tiles[colIndex + 1 + 8] = colTiles[3]
		tiles[colIndex + 1 + 12] = colTiles[0]
	end

	for i = 0, 3 do
		local t = tiles[colIndex + 1 + (i * 4)]
		t.homeY = -15 + (i * tileWidth) + (tileWidth / 2)
		t:moveTo(t.homeX, t.homeY)
	end
end

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

		for i = 1, 16 do
			tiles[i]:moveTo(tiles[i].homeX, tiles[i].homeY)
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

	-- Check if tiles moved far enough to rearrange indices
	if not isVertical then
		local startTile = tiles[1 + (row * 4)]
		local currentX = startTile:getPosition()
		local offset = currentX - startTile.homeX
		if offset >= tileWidth then
			rearrangeRow(row, 1)
			updateMirroredTiles(tiles[1 + (row * 4)], tiles[4 + (row * 4)])
		elseif offset <= -tileWidth then
			rearrangeRow(row, -1)
			updateMirroredTiles(tiles[1 + (row * 4)], tiles[4 + (row * 4)])
		end
	else
		local startTile = tiles[1 + column]
		local _, currentY = startTile:getPosition()
		local offset = currentY - startTile.homeY
		if offset >= tileWidth then
			rearrangeColumn(column, 1)
			updateMirroredTiles(tiles[1 + column], tiles[1 + column + 12])
		elseif offset <= -tileWidth then
			rearrangeColumn(column, -1)
			updateMirroredTiles(tiles[1 + column], tiles[1 + column + 12])
		end
	end
end

import("topBar")
