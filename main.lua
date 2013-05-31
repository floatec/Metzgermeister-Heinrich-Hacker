require("AnAL")
loader = require("AdvTiledLoader/loader")

 

function love.load()
	-- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
	loader.path = "maps/"

	 -- Loads the map file and returns it
	map = loader.load("level1.tmx")


	-- load images
	images = {
		heinrich = love.graphics.newImage("gfx/bucher.png"),
	}
	
	-- sound effect
	-- sound = love.audio.newSource("crash.ogg", "static")
	
	-- music
	music = love.audio.newSource("alley.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	love.audio.play(music)
	
	-- game
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	-- player
	x, y = 32, 32
	w = images.heinrich:getWidth()
	h = images.heinrich:getHeight()
	speed = 300	
end

function love.update(dt)
	newx,newy=x,y
	-- update x
	if love.keyboard.isDown("left")   then
		newx = x - speed * dt
	elseif love.keyboard.isDown("right") then
		newx = x + speed * dt
	end

	-- update y
	if love.keyboard.isDown("up")  then
		newy = y - speed * dt
	elseif love.keyboard.isDown("down") then
		newy = y + speed * dt
	end
	if(can_move_to(newx,newy,32,32)) then
		x,y=newx,newy
	end
end

function love.draw()
	
	-- reset color
	love.graphics.setColor(255, 255, 255)
	
	
	-- Draws the map
	map:draw()

		
	-- player
	love.graphics.draw(images.heinrich, x, y)
	
	-- text
	love.graphics.setColor(255, 0, 0)
    love.graphics.printf("Metzgermeister Heinrich Hacker", 0, 10, width, "center")	
end


function can_move_to( x,y ,w,h)
	 if is_colliding_with_wall(x,y) or  is_colliding_with_wall(x+w,y) or  is_colliding_with_wall(x,y+h) or  is_colliding_with_wall(x+w,y+h) then
	 	return false
	 end
	 	return true
end

function is_colliding_with_wall(x,y)
	local tile=map("buildings")(math.floor(x/16),math.floor(y/16))
	if tile and tile.properties["wall"] then
		return true
	end
	
	return false
end

