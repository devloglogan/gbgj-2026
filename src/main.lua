import("CoreLibs/graphics")
import("CoreLibs/math")
import("CoreLibs/timer")
import("CoreLibs/ui")
import("CoreLibs/sprites.lua")
import("CoreLibs/object.lua")

import("tile")
import("levelLoader")
import("topBar")
import("particleManager")
import("screenWipe")

local pd = playdate
local gfx = playdate.graphics

local tileWidth = 75

local currentLevel = 0

local row = 1
local column = 1
local isVertical = false
local acceptCrankInput = true

local tiles = {}
local mirroredStartTile, mirroredEndTile

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

local function initClassTiles()
	local tileImages = GetTileImages(currentLevel)
	local tileIds = GetTileIds(currentLevel)

	row = 1
	column = 1

	for i = 0, 3 do
		for j = 0, 3 do
			local index = j * 4 + i + 1
			tiles[index] = Tile(
				50 + (tileWidth / 2) + (i * tileWidth),
				-15 + (j * tileWidth) + (tileWidth / 2),
				tileWidth,
				tileImages[index],
				tileIds[index]
			)
			tiles[index]:add()
		end
	end

	mirroredStartTile = Tile(0, 0, tileWidth, tiles[1]:getImage())
	mirroredStartTile:add()
	mirroredEndTile = Tile(0, 0, tileWidth, tiles[1]:getImage())
	mirroredEndTile:add()
	updateMirroredTiles(tiles[5], tiles[8])
end

local function deinitTiles()
	for i = 1, 16 do
		local t = tiles[i]
		if t == nil then
			return
		end
		tiles[i]:remove()
	end
	mirroredStartTile:remove()
	mirroredEndTile:remove()
end

local function updateAxis(isCurrentVertical, isTargetVertical, delta)
	PlayDpad()
	if isCurrentVertical == isTargetVertical then
		return isTargetVertical, delta
	else
		return isTargetVertical, 0
	end
end

local function rearrangeRow(rowIndex, direction)
	local rowStart = 1 + (rowIndex * 4)
	local rowTiles = {}

	-- Get current offset before rearranging
	local firstTile = tiles[rowStart]
	local currentX = firstTile:getPosition()
	local offset = currentX - firstTile.homeX

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

	-- Update home positions
	for i = 0, 3 do
		local t = tiles[rowStart + i]
		t.homeX = 50 + (tileWidth / 2) + (i * tileWidth)
	end

	-- Only move the wrapping tile to the opposite side
	local wrapIndex = direction > 0 and 0 or 3
	local wrapTile = tiles[rowStart + wrapIndex]
	wrapTile:moveTo(wrapTile.homeX + offset - (direction * tileWidth), wrapTile.homeY)
end

local function rearrangeColumn(colIndex, direction)
	local colTiles = {}

	-- Get current offset before rearranging
	local firstTile = tiles[colIndex + 1]
	local _, currentY = firstTile:getPosition()
	local offset = currentY - firstTile.homeY

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

	-- Update home positions
	for i = 0, 3 do
		local t = tiles[colIndex + 1 + (i * 4)]
		t.homeY = -15 + (i * tileWidth) + (tileWidth / 2)
	end

	-- Only move the wrapping tile to the opposite side
	local wrapIndex = direction > 0 and 0 or 3
	local wrapTile = tiles[colIndex + 1 + (wrapIndex * 4)]
	wrapTile:moveTo(wrapTile.homeX, wrapTile.homeY + offset - (direction * tileWidth))
end

local function checkAndLerpTiles()
	for i = 1, 16 do
		local t = tiles[i]
		if t == nil then
			return
		end
		local tx, ty = t:getPosition()
		if tx ~= t.homeX or ty ~= t.homeY then
			t:lerpToHome()
		end
	end
end

local function checkWin()
	if IsGameStateWon(currentLevel, tiles[6], tiles[7], tiles[10], tiles[11]) then
		currentLevel = currentLevel + 1
		checkAndLerpTiles()
		acceptCrankInput = false

		pd.timer.performAfterDelay(PlayWinAnimation(tileWidth), function()
			pd.timer.performAfterDelay(ScreenWipe(), function()
				SetLevelData(currentLevel)
				deinitTiles()
				initClassTiles()
				acceptCrankInput = true
			end)
		end)
	end
end

function pd.update()
	-- gfx.clear()

	gfx.sprite.update()
	pd.timer.updateTimers()

	if currentLevel == 0 then
		checkWin()
		return
	elseif tiles[1] == nil then
		return
	end

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

	-- Darken all tiles then lighten selected tiles
	for i = 1, 16 do
		tiles[i]:darken()
	end
	for i = 1, 4 do
		tilesToMove[i]:lighten()
	end

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

		checkAndLerpTiles()

		acceptCrankInput = false
		pd.timer.performAfterDelay(200, function()
			acceptCrankInput = true
		end)
	end

	-- Move tiles on crank change
	if acceptCrankInput then
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
		if crankChange ~= 0 then
			if crankChange < 0 then
				crankChange = -1 * crankChange
			end
			PlayCrank(crankChange)
		end
	end

	-- Check if tiles moved far enough to rearrange indices
	if not isVertical then
		local startTile = tiles[1 + (row * 4)]
		local currentX = startTile:getPosition()
		local offset = currentX - startTile.homeX
		if offset >= tileWidth / 2 then
			rearrangeRow(row, 1)
			updateMirroredTiles(tiles[1 + (row * 4)], tiles[4 + (row * 4)])
		elseif offset <= -tileWidth / 2 then
			rearrangeRow(row, -1)
			updateMirroredTiles(tiles[1 + (row * 4)], tiles[4 + (row * 4)])
		end
	else
		local startTile = tiles[1 + column]
		local _, currentY = startTile:getPosition()
		local offset = currentY - startTile.homeY
		if offset >= tileWidth / 2 then
			rearrangeColumn(column, 1)
			updateMirroredTiles(tiles[1 + column], tiles[1 + column + 12])
		elseif offset <= -tileWidth / 2 then
			rearrangeColumn(column, -1)
			updateMirroredTiles(tiles[1 + column], tiles[1 + column + 12])
		end
	end

	checkWin()
end

SetLevelData(currentLevel)
DrawTopBar()
