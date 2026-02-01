local pd = playdate
local gfx = pd.graphics

local timeWipeIn = 1000
local timeHold = 500
local timeWipeOut = 1000

local function moveCallback(startPos, endPos, duration, easing, sprite)
    
end

function move(startPos, endPos, delay, duration, easing)
    self:moveTo(startPos[1], startPos[2])
    pd.timer.new(delay * 1000, moveCallback, startPos, endPos, duration, easing, self)
end


function ScreenWipe()
    local swipeImage = gfx.image.new("images/wipe_vertical_huge_01")
    local sprite = gfx.sprite.new(swipeImage)

    sprite:setZIndex(20)
    sprite:add()

    
    
    local imageWidth, imageHeight = swipeImage:getSize()
    
    local startX = pd.display.getWidth()/2
    local startY = pd.display.getHeight() + imageHeight/2
    local endY = -imageHeight/2
    local centerX = pd.display.getWidth()/2
    local centerY = pd.display.getHeight()/2


    sprite:moveTo(startX, startY)
    local timer = pd.timer.new(timeWipeIn, 0, 1, pd.easingFunctions.inOutSine)
    timer.updateCallback = function (t)
        local x = pd.math.lerp(startX, centerX, t.value)
        local y = pd.math.lerp(startY, centerY, t.value)
        sprite:moveTo(x,y)
    end

    pd.timer.performAfterDelay(timeWipeIn + timeHold, 
        function()
            local timer2 = pd.timer.new(timeWipeOut, 0, 1, pd.easingFunctions.inOutSine)
            timer2.updateCallback = 
                function (t2)
                    local x = pd.math.lerp(centerX, pd.display.getWidth()/2, t2.value)
                    local y = pd.math.lerp(centerY, endY, t2.value)
                    sprite:moveTo(x,y)
                end
	    end
    )
    return timeWipeIn
end