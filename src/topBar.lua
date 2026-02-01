local pd = playdate
local gfx = pd.graphics

import("scrollText")

local barHeight = 30
local txt = "Foo"

local img = gfx.image.new(pd.display.getWidth(), barHeight)
gfx.pushContext(img)
gfx.setColor(gfx.kColorBlack)
for x = 0, pd.display.getWidth() - 1 do
	for y = 0, barHeight - 1 do
		gfx.drawPixel(x, y)
	end
end
gfx.popContext()

local topBar = gfx.sprite.new(img)
topBar:setZIndex(10)
topBar:moveTo(pd.display.getWidth() / 2, barHeight / 2)

local displayText = ScrollText(txt)
local displayTextWrap = ScrollText(txt, true)

function DrawTopBar()
	topBar:add()
	displayText:add()
	displayTextWrap:add()
end

function SetTopText(text)
	displayText:updateText(text)
	displayTextWrap:updateText(text)
end
