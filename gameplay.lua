require("AnAL")
require("global")
require("collision")
loader = require("AdvTiledLoader/loader")
game={}
game.state=0

function game.load(map_file)
	-- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
	loader.path = "maps/"
	game.state=0
	 -- Loads the map file and returns it
	map = loader.load(map_file)

	-- load images
	images = {
		heinrich = love.graphics.newImage("gfx/bucher.png"),
		child = love.graphics.newImage("gfx/child.png"),
		enemy1 = love.graphics.newImage("gfx/enemy1.png"),
		enemy2 = love.graphics.newImage("gfx/enemy2.png")
	}
	countdown=300
	-- sound effect
	sound={
		scream = love.audio.newSource("sfx/scream.wav", "static"),
		slay  = love.audio.newSource("sfx/slay.mp3", "static"),
		hallo_meine_liebe  = love.audio.newSource("sfx/hallo_meine_liebe.ogg", "static")

	}
	-- music
	music = love.audio.newSource("sfx/Dark_Side_Theme_V03.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	love.audio.play(music)
	
	-- game
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	gewicht = 0	
	-- player
	p = {
		x = 31, 
		y = 31,
		w = images.heinrich:getWidth(),
		h = images.heinrich:getHeight()
	}

for x, y, tile in map("buildings"):iterate() do
  		if tile and tile.properties["spawn"] then
  			spawnx,spawny=x,y
  			p.x,p.y=x*16,y*16
  		break
  	end
	end	--child
	spawn_Child()
	spawn_Child()
	spawn_Child()
	spawn_Child()
	spawn_Child()

	spawn_Enemy()
	spawn_Enemy()
end

function game.update(dt)
	countdown=countdown-dt
	if countdown<0 then
		if game.gewicht>500 then 
			game.state=1
		else 
			game.state=2
		end
	end
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
		if(hits_spawn(v.x,v.y,32,32)) then
			gewicht=gewicht+math.random(20,30);
			table.remove(childs,i)
			spawn_Child();
			-- play/rewind effect
			if sound.scream:isStopped() then
				love.audio.play(sound.scream)
			else
				sound.scream:rewind()
			end
			if sound.slay:isStopped() then

				love.audio.play(sound.slay)
			else
				sound.slay:rewind()
			end
		end
		if love.keyboard.isDown(" ") and is_colliding(p, v) then
			
			move(v, v.x + dx, v.y + dy)
			if v.isGrabbed==false then
				love.audio.play(sound.hallo_meine_liebe)
			end
			v.isGrabbed = true;
		else
			v.isGrabbed = false;
			automove(v, dt)
		end
	end

	-- update enemies
	for i, v in ipairs(enemies) do
		automove(v, dt)
		v.anim:update(dt)
	end
end

function game.draw()
	
	love.graphics.setBackgroundColor(80,80,80)
	-- reset color
	love.graphics.setBackgroundColor(80, 80, 80)
	love.graphics.setColor(255, 255, 255)
	
	-- Draws the map
	
	map:draw()
	--childs
	for i, v in ipairs(childs) do
		love.graphics.draw(images.child, v.x, v.y, 0 , v.scale, v.scale)
	end

	for i, v in ipairs(enemies) do
		v.anim:draw(v.x, v.y)
	end
		
	-- player
	love.graphics.draw(images.heinrich, p.x, p.y)
	map("buildings").visible=false
	map:draw()
	map("buildings").visible=true
	-- text
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Zeit: "..(math.floor(countdown/60))..":"..(math.floor(countdown)%60), 0, 0, width, "left")	
    love.graphics.printf("Fleisch: "..gewicht.."kg", 0, 0, width, "right")	
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
	repeat
	t.x = math.random(0,800-32)
	t.y =  math.random(0,600-32)
	until can_move_to(t.x,t.y,32,32)
	-- misc
	t.isGrabbed = false
	
	table.insert(childs, t)
end

enemies={}
function spawn_Enemy()

	local t = {}

	--TODO
	if (math.random(1,2) == 1) then
		t.animImage = images.enemy1
	else
		t.animImage = images.enemy2
	end

	-- size
	t.scale = 1
	t.frames = 8
	t.w = t.animImage:getWidth() * t.scale / t.frames
	t.h = t.animImage:getHeight() * t.scale
	t.anim = newAnimation(t.animImage, t.w, t.h, 0.06, t.frames)
	t.direction = math.random(1,4) 
	-- position
	t.x = 200
	t.y = 400
	
	table.insert(enemies, t)
end