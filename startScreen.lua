
require("global")

startScreen={}
startScreen.state=0
function startScreen.load(map_file)
	
	-- load images
	images = {
		background = love.graphics.newImage("gfx/startscreen.png")
	}
	countdown=300
	-- sound effect
	sound={
	
	}
	-- music
	music = love.audio.newSource("sfx/Dark_Side_Theme_V01.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	love.audio.play(music)
	
	-- game
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
end

function startScreen.update(dt)
	
	if love.keyboard.isDown(" ")  then
		startScreen.state=1
	end

	
end

function startScreen.draw()
	
	love.graphics.setBackgroundColor(80,80,80)
	-- reset color
	love.graphics.setBackgroundColor(80, 80, 80)
	love.graphics.setColor(255, 255, 255)
	
	-- Draws the map
	
	
	love.graphics.draw(images.background, 0,0)
end
