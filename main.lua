require "gameplay"
require "startScreen"
level=2
START=0
GAME=1
GAMEOVER=2
WIN=3
screen=0
function love.load()
	startScreen.load()
end

function love.update(dt)
	if screen==START then
		startScreen.update(dt)
		if startScreen.state==1 then
			screen=GAME 
			game.load("level"..level..".tmx")
		end
	elseif screen == GAME then
		game.update(dt)
	end
end

function love.draw()
	if screen==START then
		startScreen.draw()
	elseif screen == GAME then
		game.draw()
	end
end
