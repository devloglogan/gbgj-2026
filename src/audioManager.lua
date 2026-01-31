local pd = playdate
local sfx = pd.sound


local music = sfx.fileplayer.new()

--Immediately stops previous audio and plays the new audio 
function PlayAudio(path)
    if music:isPlaying() then 
        music:stop()
    end
    music:load(path)
    music:play(0)
end