local pd = playdate
local gfx = playdate.graphics
LevelX = 
{
    text = "This is the line of dialogue",
    bg = "images/bg1",
    winState = 
    {
        "face1",
        "face2",
        "face3",
        "face4"
    },
    tiles = 
    {
        "face1",
        "face2", 
        "face3",
        "face4",
        "face5",
        "face6",
        "face7",
        "face8",
        "face9",
        "face10",
        "face11",
        "face12",
        "face13",
        "face14",
        "face15",
        "face16"
    }
}

Level1 = 
{
    text = "This is the line of dialogue",
    bg = "images/bg1",
    winState = 
    {
        "face1",
        "face2",
        "face3",
        "face4"
    },
    tiles = 
    {
        "images/dissapointed/LB",
        "images/dissapointed/LT", 
        "images/dissapointed/RB",
        "images/dissapointed/RT",
        "images/dissapointed/LB",
        "images/dissapointed/LT",
        "images/dissapointed/RB",
        "images/dissapointed/RT",
        "images/dissapointed/LB",
        "images/dissapointed/LT",
        "images/dissapointed/RB",
        "images/dissapointed/RT",
        "images/dissapointed/LB",
        "images/dissapointed/LT",
        "images/dissapointed/RB",
        "images/dissapointed/RT"
    }
}

function GetTileImages(levelNum)
    local level
    local tiles = {}
    if levelNum == 1 then
        level = Level1
    end

    for i = 1, 16 do
        local foo = level.tiles[i]
        local image = gfx.image.new(foo)
        tiles[i] = image
    end
    return tiles
end