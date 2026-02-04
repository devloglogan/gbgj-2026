import("audioManager")
import("comic")

local pd = playdate
local gfx = playdate.graphics

local comic

local levelX = {
	text = "This is the line of dialogue",
	bg = "images/bg1",
	music = "audio/FaceSwap_Song1",
	winState = {
		"face1",
		"face2",
		"face3",
		"face4",
	},
	tiles = {
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
		"face16",
	},
}

local level1 = {
	text = "You just got an invite for a 15-minute meeting with HR first thing tomorrow morning.",
	bg1 = "images/bgs/background_party_01",
	bg2 = "images/bgs/background_party_02",
	music = "audio/FaceSwap_Song1",
	winState = {
		"images/worried/LT",
		"images/worried/RT",
		"images/worried/LB",
		"images/worried/RB",
	},
	tiles = {
		"images/content/LB",
		"images/worried/RB",
		"images/content/RT",
		"images/worried/LT",
		"images/worried/RB",
		"images/worried/LB",
		"images/happy/RB",
		"images/content/LB",
		"images/worried/LB",
		"images/doubtful/LT",
		"images/worried/LT",
		"images/worried/RT",
		"images/surprised/RB",
		"images/worried/RT",
		"images/happy/RT",
		"images/surprised/LT",

	},
}

local level2 = {
	text = "You crush asked you out on your birthday!",
	bg1 = "images/bgs/background_party_01",
	bg2 = "images/bgs/background_party_02",
	music = "audio/FaceSwap_Song1",
	winState = {
		"images/happy/LT",
		"images/happy/RT",
		"images/happy/LB",
		"images/happy/RB",
	},
	tiles = {
		"images/happy/RB",
		"images/happy/LB",
		"images/dissapointed/LB",
		"images/content/LT",
		"images/content/LB",
		"images/happy/LT",
		"images/surprised/RT",
		"images/doubtful/RT",
		"images/happy/LB",
		"images/worried/RB",
		"images/worried/LT",
		"images/happy/RB",
		"images/doubtful/RB",
		"images/happy/RT",
		"images/dissapointed/RT",
		"images/happy/LT",

	},
}

local level5 = {
	text = "AI will create a more compassionate world.",
	bg1 = "images/bgs/background_party_01",
	bg2 = "images/bgs/background_party_02",
	music = "audio/FaceSwap_Song1",
	winState = {
		"images/doubtful/LT",
		"images/doubtful/RT",
		"images/doubtful/LB",
		"images/doubtful/RB",
	},
	tiles = {
		"images/surprised/RT",
		"images/happy/LB",
		"images/surprised/LT",
		"images/doubtful/LB",
		"images/doubtful/LB",
		"images/dissapointed/RB",
		"images/doubtful/RT",
		"images/doubtful/LT",
		"images/doubtful/RB",
		"images/happy/RB",
		"images/content/RT",
		"images/content/RB",
		"images/doubtful/LT",
		"images/surprised/LT",
		"images/worried/RT",
		"images/happy/LB",

	},
}

local level4 = {
	text = "Your lazy roommate finally cleaned the dishes on their own.",
	bg1 = "images/bgs/background_party_01",
	bg2 = "images/bgs/background_party_02",
	music = "audio/FaceSwap_Song1",
	winState = {
		"images/surprised/LT",
		"images/surprised/RT",
		"images/surprised/LB",
		"images/surprised/RB",
	},
	tiles = {
		"images/surprised/RB",
		"images/dissapointed/LT",
		"images/surprised/LT",
		"images/content/RT",
		"images/happy/RB",
		"images/doubtful/LB",
		"images/content/RT",
		"images/worried/RB",
		"images/dissapointed/RB",
		"images/surprised/RT",
		"images/worried/LT",
		"images/surprised/LB",
		"images/doubtful/RT",
		"images/dissapointed/LT",
		"images/surprised/LB",
		"images/content/LB",
	},
}
local level3 = {
	text = "Your waiter dropped your avacado toast... face-down.",
	bg1 = "images/bgs/background_party_01",
	bg2 = "images/bgs/background_party_02",
	music = "audio/FaceSwap_Song1",
	winState = {
		"images/dissapointed/LT",
		"images/dissapointed/RT",
		"images/dissapointed/LB",
		"images/dissapointed/RB",
	},
	tiles = {
		"images/happy/RB",
		"images/content/LB",
		"images/content/RB",
		"images/dissapointed/LB",
		"images/dissapointed/LT",
		"images/happy/RT",
		"images/surprised/LT",
		"images/happy/LT",
		"images/dissapointed/RB",
		"images/dissapointed/RT",
		"images/surprised/LT",
		"images/doubtful/RT",
		"images/content/RB",
		"images/content/RT",
		"images/content/RT",
		"images/surprised/LB",
	},
}

local function getLevel(levelNum)
	if levelNum == 1 then return level1
	elseif levelNum == 2 then return level2
	elseif levelNum == 3 then return level3
	elseif levelNum == 4 then return level4
	elseif levelNum == 5 then return level5
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
local bgImage1
local bgImage2
local using1
local swapTime = 500

local function bgSwap()
	if using1 then
		bgSprite:setImage(bgImage1)
	else
		bgSprite:setImage(bgImage2)
	end

	using1 = not using1

	pd.timer.performAfterDelay(swapTime, bgSwap)
end


local function setBg(levelNum)
	bgImage1 = gfx.image.new(getLevel(levelNum).bg1)
	bgImage2 = gfx.image.new(getLevel(levelNum).bg2)
	
	if bgSprite == nil then
		bgSprite = gfx.sprite.new(bgImage1)
		bgSprite:moveTo(pd.display.getWidth() / 2, pd.display.getHeight() / 2)
		bgSprite:setZIndex(5)
		bgSprite:add()
		bgSwap()
	end
end

local function setLevelText(levelNum)
	local level = getLevel(levelNum)
	local text = level.text
	SetTopText(text)
end

local function playAudio(levelNum)
	local level = getLevel(levelNum)
	PlayMusic(level.music)
end


local function ending()
	local image = gfx.image.new("images/comics/EndPanel")
	local sprite = gfx.sprite.new(image)
	sprite:add()
	sprite:moveTo(pd.display.getWidth()/2, pd.display.getHeight()/2)
	sprite:setZIndex(19)
end


function SetLevelData(levelNum)
	if levelNum == 0 then
		comic = Comic("images/comics/IntroComic_v1.png")
		return
	elseif levelNum == 1 then
		comic:remove()
		comic = nil
	elseif levelNum == 6 then
		ending()
		return
	end

	print("LEVEL NUM ", levelNum)
	setBg(levelNum)
	setLevelText(levelNum)
	playAudio(levelNum)
end



function IsGameStateWon(levelNum, LT, RT, LB, RB)
	if comic ~= nil then
		if comic:isAtBottom() and pd.buttonJustPressed(pd.kButtonA) then
			comic:lock()
			return true
		else
			return false
		end
	end

	if levelNum > 5 then 
		return false
	end

	local winningIds = getLevel(levelNum).winState
	if winningIds[1] == LT.id and winningIds[2] == RT.id and winningIds[3] == LB.id and winningIds[4] == RB.id then
		PlayWinSFX()
		return true
	end
	return false
end
