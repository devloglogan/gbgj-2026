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
gfx.popContext();


local topBar = gfx.sprite.new(img)
topBar:moveTo(pd.display.getWidth()/2, barHeight/2)
topBar:add()

local displayText = ScrollText(txt)
local displayTextWrap = ScrollText (txt, true)
displayText:add()
displayTextWrap:add()


