local pd = playdate
local gfx = pd.graphics

import("particle")

local function particleBurst(x, y, img, delay, lifetime, scaleEasing, distance, slideEasing, amount)
    for i = 1, amount do
        local p = Particle
        (
            x, y, img, delay, lifetime
        )
        p:scale(1, 0, delay, lifetime, scaleEasing)
        local randX = (math.random()*2) - 1
        local randY = (math.random()*2) - 1

        p:moveDir(randX, randY, distance, delay, lifetime, slideEasing)
    end
end


function PlayWinAnimation(offset)
    local totalDuration = 3
    local interval = 1/16
    local scaleDuration = 1
    local burstDelay = 1

	local spark = gfx.image.new("images/vfx/vfx_star_small_01")
    local centerX = pd.display.getWidth()/2
    local centerY = pd.display.getHeight()/2 + 15

    local positions = 
    { 
        {0          , -offset   },
        {offset     , -offset   },
        {offset     , 0         },
        {offset     , offset    },
        {0          , offset    },
        {-offset    , offset    },
        {-offset    , 0         },
        {-offset    , -offset   }
    }
    for i = 1, 8 do
        local delay = (i-1) * interval
	    local p = Particle
        (
            centerX + positions[i][1], 
            centerY + positions[i][2], 
            spark,
            delay,
            burstDelay
        ) 
        p:scale(0,1,delay,scaleDuration, pd.easingFunctions.outElastic)
        --p:moveDir
        --(
        --    positions[i][1],
        --    positions[i][2],
        --    offset * 3,
        --    burstDelay, 
        --    5, 
        --    pd.easingFunctions.outElastic
        --)
        particleBurst
        (
            centerX + positions[i][1], 
            centerY + positions[i][2], 
            spark,
            burstDelay,
            totalDuration - burstDelay,
            pd.easingFunctions.inElastic,
            offset * 3,
            pd.easingFunctions.linear,
            4
        )
    end
    return totalDuration * 1000
end