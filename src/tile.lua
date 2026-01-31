local pd = playdate
local gfx = pd.graphics

class("Tile").extends(gfx.sprite)

function Tile:init(x, y, tileWidth, img)
	gfx.pushContext(img)
	self:moveTo(x, y)
	self:setImage(img)
end

function Tile:update()
	Tile.super.update(self)
end

