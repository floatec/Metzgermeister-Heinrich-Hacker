require("AnAL")
require("global")
require("collision")
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
	p = {
		x = 31, 
		y = 31,
		w = images.heinrich:getWidth(),
		h = images.heinrich:getHeight()
	}

	--child
	spawn_Child()
end

function love.update(dt)
	oldx, oldy = p.x, p.y
	newx, newy = p.x, p.y
	-- update x
	if love.keyboard.isDown("left")   then
		newx = p.x - speed * dt
	elseif love.keyboard.isDown("right") then
		newx = p.x + speed * dt
	end

	-- update y
	if love.keyboard.isDown("up")  then
		newy = p.y - speed * dt
	elseif love.keyboard.isDown("down") then
		newy = p.y + speed * dt
	end

	-- actual movement
	dx, dy = move(p, newx, newy)

	-- update children
	for i, v in ipairs(childs) do

		if love.keyboard.isDown(" ") and is_colliding(p, v) then
			v.isGrabbed = true;
			move(v, v.x + dx, v.y + dy)
		else
			v.isGrabbed = false;
			automove(v, dt)
		end
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
	love.graphics.draw(images.heinrich, p.x, p.y)
	
	-- text
	love.graphics.setColor(255, 0, 0)
    love.graphics.printf("Metzgermeister Heinrich Hacker", 0, 10, width, "center")	
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
	-- misc
	t.isGrabbed = false
	
	table.insert(childs, t)
end