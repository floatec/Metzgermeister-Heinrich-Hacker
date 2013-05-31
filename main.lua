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
		child = love.graphics.newImage("gfx/child.png"),
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
	x, y = 31, 31
	w = images.heinrich:getWidth()
	h = images.heinrich:getHeight()
	speed = 300	

	--child
	spawn_Child()
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
	if(can_move_to(x,newy,32,32)) then
		x,y=x,newy
	end
	if(can_move_to(newx,y,32,32)) then
		x,y=newx,y
	end

	-- update childs
	for i, v in ipairs(childs) do
		print (v.direction)
		newy=v.y
		newx=v.x
		if v.direction%2==0 then
			newx = v.x - speed*0.3 * (v.direction-3) * dt
		else 	
			newy = v.y - speed*0.3 * (v.direction-2) * dt
		end
		-- wall hit
		if can_move_to(newx,newy,32,32) then
			v.x,v.y=newx,newy
		else
			print("change direction")
			v.direction = math.random(1,4)
		end
		print (v.x.." "..v.y)
	end
end

function love.draw()
	
	-- reset color
	love.graphics.setColor(255, 255, 255)
	
	
	-- Draws the map
	map:draw()

	--childs
	for i, v in ipairs(childs) do
		love.graphics.draw(images.child, v.x, v.y, 0 , v.scale, v.scale)
	end
		
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
childs={}
function spawn_Child()

	local t = {}
	
	-- size
	t.scale = 1
	t.w = images.child:getWidth() * t.scale
	t.h = images.child:getHeight() * t.scale
	t.direction = math.random(1,4) 
	-- position
	t.x = 31
	t.y = 31
	
	table.insert(childs, t)
end