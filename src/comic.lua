import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/ui")

local pd = playdate
local gfx = playdate.graphics

class("Comic").extends(gfx.sprite)

local SCREEN_HEIGHT = pd.display.getHeight()
local titleCardShowing = true;
local titleCardSprite
local initialLock = true


function Comic:init(imagePath)
	Comic.super.init(self)

	self.comicImage = gfx.image.new(imagePath)
	if self.comicImage == nil then
		print("Could not load comic image at " .. imagePath)
		return
	end

	self.imageWidth, self.imageHeight = self.comicImage:getSize()
	self.isLocked = false

	self:setImage(self.comicImage)
	self:moveTo(self.imageWidth / 2, self.imageHeight / 2)
	self:setZIndex(20)
	self:add()

	local titlecard = gfx.image.new("images/titlecard")
	titleCardSprite = gfx.sprite.new(titlecard)
	titleCardSprite:moveTo(pd.display.getWidth()/2, pd.display.getHeight()/2)
	titleCardSprite:setZIndex(21)
	titleCardSprite:add()

	pd.timer.performAfterDelay(1000, function () 
		initialLock = false 

		end)

end


function Comic:update()
	Comic.super.update(self)

	if initialLock then return end

	if titleCardShowing then
		if pd.buttonIsPressed(pd.kButtonA) or
			pd.buttonIsPressed(pd.kButtonB) or
			pd.getCrankChange() ~= 0 then
			titleCardShowing = false
			self.isLocked = false

			local halfX = pd.display.getWidth()/2
			local startY = pd.display.getHeight()/2
			local endY = -pd.display.getHeight()

			local timer = pd.timer.new(750, 0, 1, pd.easingFunctions.linear)
    		timer.updateCallback = 
			function (t)
            	local y = pd.math.lerp(startY, endY, t.value)
            	titleCardSprite:moveTo(halfX,y)
    		end
		else
			return
		end
	end




	if self.isLocked then
		return
	end

	local crankChange = pd.getCrankChange()
	--if crankChange ~= 0 then
		self:scroll(crankChange)
	--end
end

function Comic:scroll(amount)
	self:moveBy(0, -amount)

	-- Clamp y position
	local min = self.imageHeight / 2
	local max = (-self.imageHeight / 2) + SCREEN_HEIGHT
	local _, y = self:getPosition()
	if y > min then
		self:moveTo(self.imageWidth / 2, min)
	elseif y < max then
		self:moveTo(self.imageWidth / 2, max)
	end
end

function Comic:isAtBottom()
	local max = (-self.imageHeight / 2) + SCREEN_HEIGHT
	local _, y = self:getPosition()
	return y < (max + 10)
end

function Comic:lock()
	self.isLocked = true
end
