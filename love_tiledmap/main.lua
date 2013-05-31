-- sTiledMap loader
loader = require("AdvTiledLoader/loader.lua")




gKeyPressed = {}
gCamX,gCamY = 100,100

function love.load()
	 -- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
loader.path = "maps/"

 -- Loads the map file and returns it
map = loader.load("level1.tmx")


end

function love.keyreleased( key )
	gKeyPressed[key] = nil
end

function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true 
	if (key == "escape") then os.exit(0) end
	if (key == " ") then -- space = next mal
		gMapNum = (gMapNum or 1) + 1
		if (gMapNum > 10) then gMapNum = 1 end
		TiledMap_Load(string.format("map/map%02d.tmx",gMapNum))
		gCamX,gCamY = 100,100
	end
end

function love.update( dt )
	local s = 500*dt
	if (gKeyPressed.up) then gCamY = gCamY - s end
	if (gKeyPressed.down) then gCamY = gCamY + s end
	if (gKeyPressed.left) then gCamX = gCamX - s end
	if (gKeyPressed.right) then gCamX = gCamX + s end
end

function love.draw()
    love.graphics.print('arrow-keys=scroll, space=next map', 50, 50)
	love.graphics.setBackgroundColor(0x80,0x80,0x80)
	-- Draws the map
	map:draw()
end
