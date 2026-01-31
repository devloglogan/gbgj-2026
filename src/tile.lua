local pd <const> = playdate
local gfx <const> = pd.graphics

class('Tile').extends(gfx.sprite)

local tileWidth = 75

function Tile:init(x, y, zOffset)
    self:moveTo(x,y)
    gfx.pushContext(img)
    local img = gfx.image.new(tileWidth, tileWidth)

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
    self:setImage(img)
end

function Tile:update()
    Player.super.update(self)
end 