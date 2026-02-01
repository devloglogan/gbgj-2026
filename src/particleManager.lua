local pd = playdate
local gfx = pd.graphics

import("particle")

function PlayWinAnimation(offset)
        local totalDuration = 5
        local interval = 1/16
        local scaleDuration = 1

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
                totalDuration - delay
            ) 
            p:scale(0,1,delay,scaleDuration, pd.easingFunctions.outElastic)
            p:move
            (
                {positions[i][1] + centerX, positions[i][2] + centerY} , 
                {(positions[i][1] * 3) + centerX, (positions[i][2]*3) + centerY}, 
                2, 
                5, 
                pd.easingFunctions.outElastic
            )
            return totalDuration * 1000
        end
end