local pd = playdate
local gfx = pd.graphics

class("Particle").extends(gfx.sprite)


local function remove(sprite)
    sprite:remove()
end

local function spawn(sprite, img)
    sprite:add()
end

function Particle:init(x, y, img, delay, lifetime)
    self:setImage(img)
    self:moveTo(x, y)
    pd.timer.new(delay * 1000, spawn, self, img)
    pd.timer.new((delay + lifetime) * 1000, remove, self)
end

local function scaleCallback(startScale, endScale, milisec, sprite, easing)
    local timer = pd.timer.new(milisec, startScale, endScale, easing)
    timer.updateCallback = function (foo)
        sprite:setScale(foo.value)
    end
end

function Particle:scale(startScale, endScale, delay, duration, easing)
    self:setScale(startScale)
    pd.timer.new(delay * 1000, scaleCallback, startScale, endScale, duration * 1000, self, easing)
end

local function moveCallback(startPos, endPos, duration, easing, sprite)
    local timer = pd.timer.new(duration * 1000, 0, 1, easing)
    timer.updateCallback = function (t)
            local x = pd.math.lerp(startPos[1], endPos[1], t.value)
            local y = pd.math.lerp(startPos[2], endPos[2], t.value)
            sprite:moveTo(x,y)
    end
end

function Particle:move(startPos, endPos, delay, duration, easing)
    self:moveTo(startPos[1], startPos[2])
    pd.timer.new(delay * 1000, moveCallback, startPos, endPos, duration, easing, self)
end

