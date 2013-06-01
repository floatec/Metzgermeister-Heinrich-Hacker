require "gameplay"
function love.load()
game.load("level2.tmx");
end

function love.update(dt)
	game.update(dt)
end

function love.draw()
	game.draw()
end
