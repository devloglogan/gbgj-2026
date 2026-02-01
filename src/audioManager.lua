local pd = playdate
local sfx = pd.sound


local music = sfx.fileplayer.new()
local dpad = sfx.sampleplayer.new("audio/Dpad_Sound_01")
local crank1 = sfx.sampleplayer.new("audio/CrankSound_01")
local crank2 = sfx.sampleplayer.new("audio/CrankSound_02")
local win = sfx.sampleplayer.new("audio/WinSound_01")

--Immediately stops previous audio and plays the new audio 
function PlayMusic(path)
    if music:isPlaying() then 
        music:stop()
    end
    music:load(path)
    music:play(0)
end

function PlayDpad()
    dpad:play()
end

local play1 = true
local changeNeeded = 180
local accumulatedChange = 0
function PlayCrank(crankChange)
    accumulatedChange = crankChange + accumulatedChange
    if accumulatedChange < changeNeeded then
        return
    end
        accumulatedChange = accumulatedChange - changeNeeded

    if play1 then
        crank1:play()
    else
        crank2:play()
    end
    play1 = not play1
end

function PlayWinSFX()
    win:play()
end