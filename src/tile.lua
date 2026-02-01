local pd = playdate
local gfx = pd.graphics

class("Tile").extends(gfx.sprite)

function Tile:init(x, y, tileWidth, img, id)
	self:setZIndex(0)
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

	self.isLerpingHome = false
end

function Tile:update()
	Tile.super.update(self)

	if self.isLerpingHome then
		local x, y = self:getPosition()
		self:moveTo(pd.math.lerp(x, self.homeX, 0.3), pd.math.lerp(y, self.homeY, 0.3))
		x, y = self:getPosition()
		if ((x - self.homeX) < 2 and (x - self.homeX) > -2) and ((y - self.homeY) < 2 and (y - self.homeY) > -2) then
			self:moveTo(self.homeX, self.homeY)
			self.isLerpingHome = false
		end
	end
end

function Tile:lighten()
	self:setImage(self.normalImage)
end

function Tile:darken()
	self:setImage(self.darkImage)
end

function Tile:lerpToHome()
	self.isLerpingHome = true
end
