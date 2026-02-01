local pd = playdate
local gfx = pd.graphics

local bodyFont = gfx.font.new("fonts/Pedallica/font-pedallica-fun-16")
local yPos = 15

class("ScrollText").extends(gfx.sprite)

function ScrollText:updateText(text)
	gfx.setFont(bodyFont)

	local x, y = gfx.getTextSize(text, bodyFont)
	local image = gfx.imageWithText(text, x, 30, gfx.kColorWhite)
	self:setImage(image)
	self:setImageDrawMode(gfx.kDrawModeInverted)
	self.width = x
end

function ScrollText:init(text, isSecond)
	self.offset = 0
	self.width = 0
	self.scrollSpeed = 1
	self:updateText(text)
	self:setZIndex(11)

	if self.width > pd.display.getWidth() then
		self.offset = self.width
	else
		self.offset = pd.display.getWidth()
	end

	--Start with left edge of text on right edge of screen
	local startPos = pd.display.getWidth() + (self.width / 2)

	self.resetPos = startPos + self.offset
	if isSecond then
		startPos = self.resetPos
	end

	if self.width > pd.display.getWidth() then
		self.resetPos = self.resetPos - pd.display.getWidth()
	end
	self:moveTo(startPos, yPos, -1)
end

function ScrollText:update()
	ScrollText.super.update()
	self:moveBy(-self.scrollSpeed, 0)

	if self:getPosition() < -self.width / 2 then
		self:moveBy(self.offset * 2, 0)
	end
end

