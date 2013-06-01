require "gameplay"
require "startScreen"
level=2
START=0
GAME=1
GAMEOVER=2
WIN=3
screen=0
function love.load()
	startScreen.load("startscreen")
end

function love.update(dt)
	if screen==START or screen==GAMEOVER or screen==WIN then
		startScreen.update(dt)
		if startScreen.state==1 then
			screen=GAME 
			game.load("level"..level..".tmx")
		end
	elseif screen == GAME then
		game.update(dt)
		if game.state==1 then
			level=level+1
			if level <4 then
				game.load("level"..level..".tmx")
			else
				startScreen.state=0
				screen=WIN
				startScreen.load("Win")
				level=2
			end
		end
		if game.state==2 then
			screen=GAMEOVER
		    startScreen.state=0
			startScreen.load("Loose")
		end
	end
end

function love.draw()
	if screen==START or screen==WIN or screen==GAMEOVER then
		startScreen.draw()
	elseif screen == GAME then
		game.draw()
	end
end
