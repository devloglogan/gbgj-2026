
import("audioManager")


local pd = playdate
local gfx = playdate.graphics

local levelX = 
{
    text = "This is the line of dialogue",
    bg = "images/bg1",
    music = "audio/FaceSwap_Song1",
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

local level1 = 
{
    text = "This is a dissapointing comment",
    bg = "images/bgs/party",
    music = "audio/FaceSwap_Song1",
    winState = 
    {
        "images/dissapointed/LT",
        "images/dissapointed/RT",
        "images/dissapointed/LB",
        "images/dissapointed/RB"
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

local function getLevel(levelNum)
    if levelNum == 1 then
        return level1
    end
end


function GetTileImages(levelNum)
    local level = getLevel(levelNum)
    local tiles = {}
    for i = 1, 16 do
        local foo = level.tiles[i]
        local image = gfx.image.new(foo)
        tiles[i] = image
    end
    return tiles
end

function GetTileIds(levelNum)
    return getLevel(levelNum).tiles
end

local bgSprite
local function setBg(levelNum)
    local image = gfx.image.new(getLevel(levelNum).bg)

    if bgSprite == nil then
        bgSprite = gfx.sprite.new(image)
        bgSprite:moveTo(pd.display.getWidth()/2, pd.display.getHeight()/2)
        bgSprite:add()
    else
        bgSprite:setImage(image)
    end
end
    
local function setLevelText(levelNum)
    local level = getLevel(levelNum)
    local text = level.text;
    SetTopText(text)
end

local function playAudio(levelNum)
    local level = getLevel(levelNum)
    PlayAudio(level.music)
end

function SetLevelData(levelNum)
    setBg(levelNum)
    setLevelText(levelNum)
    playAudio(levelNum)
end

function IsGameStateWon(levelNum, LT, RT, LB, RB)
    local winningIds = getLevel(levelNum).winState
    if winningIds[1] == LT.id and winningIds[2] == RT.id and winningIds[3] == LB.id and winningIds[4] == RB.id then
        print("YIPPEEE")
        return true
    end
    return false
end
