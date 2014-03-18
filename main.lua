--	
--	main.lua
--	
--	Ian Powell 11-3-2014	
--	Plat-former Game Test 
--	Used Advanced Tiled Map Loader and Tiled to set-up Level
--

local AdvTiledLoader = require("AdvTiledLoader.Loader")
require("camera")

function love.load()

	AdvTiledLoader.path = "maps/"
	map =AdvTiledLoader.load("level.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
end

function love.draw()
	map:draw()
end

function love.update(dt) -- dt mean delta time which is check for the time between frames. this will will handle physics
end

