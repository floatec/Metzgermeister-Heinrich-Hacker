
require("global")

startScreen={}
startScreen.state=0
function startScreen.load(screen)
	startScreen.active=0
	startScreen.refrash=true
	-- load images
	startScreen.images = {
		background = love.graphics.newImage("gfx/"..screen..".png")
	}
	countdown=300
	-- sound effect
	sound={
	
	}
	-- music
	love.audio.stop(music)
	music = love.audio.newSource("sfx/Dark_Side_Theme_V01.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	love.audio.play(music)
	
	-- game
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
end

function startScreen.update(dt)
	startScreen.active=startScreen.active+dt
	if love.keyboard.isDown(" ") and startScreen.active>2  then
		startScreen.state=1
		love.audio.stop(music)
	end

	
end

function startScreen.draw()
	love.graphics.setBackgroundColor(80,80,80)
	-- reset color
	love.graphics.setBackgroundColor(80, 80, 80)
	love.graphics.setColor(255, 255, 255)
	
	-- Draws the map
	
	
	love.graphics.draw(startScreen.images.background, 0,0)
	love.graphics.setNewFont(14)
	love.graphics.printf("by Simon, Mariuz, Floatec & Alulein", 0, height-14, width, "right")
		love.graphics.setNewFont(20)
	love.graphics.printf("press [SPACE]", 0, height-20, width, "center")
	startScreen.refrash=false
	
   
end
