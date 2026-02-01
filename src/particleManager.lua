local pd = playdate
local gfx = pd.graphics

import("particle")

function PlayWinAnimation(offset)
        local totalDuration = 3
        local interval = .125

		local spark = gfx.image.new("images/vfx/vfx_star_small_01")
        local centerX = pd.display.getWidth()/2
        local centerY = pd.display.getHeight()/2 + 15

        local positions = 
        { 
            {centerX            , centerY - offset},
            {centerX + offset   , centerY - offset},
            {centerX + offset   , centerY},
            {centerX + offset   , centerY + offset},
            {centerX            , centerY + offset},
            {centerX - offset   , centerY + offset},
            {centerX - offset   , centerY},
            {centerX - offset   , centerY - offset}
        }
        for i = 1, 8 do
            local delay = (i-1) * interval
		    Particle(positions[i][1], positions[i][2], spark,
             delay,
             totalDuration - delay) 
        end
end