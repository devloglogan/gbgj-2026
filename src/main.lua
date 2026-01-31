import("CoreLibs/graphics")
import("CoreLibs/ui")

local pd = playdate
local gfx = playdate.graphics

local tileWidth = 75

-- 16 perlin rectangles
local noiseImages = {}
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

function pd.update()
	gfx.clear()

	-- Tiles
	for i = 0, 3 do
		for j = 0, 3 do
			local index = j * 4 + i + 1
			noiseImages[index]:draw(50 + (i * tileWidth), -15 + (j * tileWidth))
		end
	end

	-- Top bar
	gfx.fillRect(0, 0, 400, 30)
end
