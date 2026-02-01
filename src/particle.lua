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
