local pd = playdate
local gfx = pd.graphics

class("Tile").extends(gfx.sprite)

function Tile:init(x, y, tileWidth, img, id)
	self:moveTo(x, y)

	self.normalImage = img
	local overlay = gfx.image.new("images/halftone_transparent.png")
	self.darkImage = gfx.image.new(self.normalImage:getSize())
	gfx.pushContext(self.darkImage)
	self.normalImage:draw(0, 0)
	overlay:draw(0, 0, gfx.kDrawModeNXOR)
	gfx.popContext()

	self:setImage(self.normalImage)
	self.id = id
	self.homeX = x
	self.homeY = y
end

function Tile:update()
	Tile.super.update(self)
end

function Tile:lighten()
	self:setImage(self.normalImage)
end

function Tile:darken()
	self:setImage(self.darkImage)
end
