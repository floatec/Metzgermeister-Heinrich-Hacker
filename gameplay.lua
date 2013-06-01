require("AnAL")
require("global")
require("collision")
loader = require("AdvTiledLoader/loader")
game={}
game.state=0

function game.load(map_file)
	love.graphics.setNewFont(14)
	-- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
	loader.path = "maps/"
	game.state=0
	children={}
	enemies={}
	 -- Loads the map file and returns it
	map = loader.load(map_file)

	-- load images
	images = {
		heinrich1 = love.graphics.newImage("gfx/heinrich1.png"),
		girl1 = love.graphics.newImage("gfx/girl1.png"),
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
	p = {}
	p.x = 31
	p.y = 31
	p.animImage = images.heinrich1
	p.w = p.animImage:getWidth() / animFrames
	p.h = p.animImage:getHeight()
	p.anim = newAnimation(p.animImage, p.w, p.h, animDelay, animFrames)

	for x, y, tile in map("buildings"):iterate() do
  		if tile and tile.properties["spawn"] then
  			spawnx,spawny=x,y
  			p.x,p.y=x*16,y*16
  		break
  		end
	end	

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
	if gewicht>50 then 
			game.state=1
	elseif countdown<0 then
		
			game.state=2
		
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

	if (math.abs(dx) > 0 or math.abs(dy) > 0) then
		p.anim:update(dt)
	end

	-- update children
	for i, v in ipairs(children) do
		if(hits_spawn(v.x,v.y,32,32)) then
			gewicht=gewicht+math.random(20,30);
			table.remove(children, i)
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

		--movement & grabbing
		if love.keyboard.isDown(" ") and is_colliding(p, v) then
			for j, k in ipairs(enemies) do
				if(is_colliding(p, k)) then
					game.state=2
				end		
			end
			move(v, v.x + dx, v.y + dy)
			if (v.isGrabbed == false) then
				love.audio.play(sound.hallo_meine_liebe)
			end
			v.isGrabbed = true;
		else
			v.isGrabbed = false;
			automove(v, dt)
		end

		--update animation
		v.anim:update(dt)
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
	--children
	for i, v in ipairs(children) do
		v.anim:draw(v.x, v.y)
	end

	for i, v in ipairs(enemies) do
		v.anim:draw(v.x, v.y)
	end
		
	-- player
	p.anim:draw(p.x, p.y)

	--map
	map("buildings").visible=false
	map:draw()
	map("buildings").visible=true

 	-- text
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.printf("Zeit: "..(math.floor(countdown/60))..":"..(math.floor(countdown)%60), 0, 0, width, "left")	
    love.graphics.printf("Fleisch: "..gewicht.."kg", 0, 0, width, "right")	
end

children={}
function spawn_Child()

	local t = {}
	t.animImage = images.girl1
	t.w = t.animImage:getWidth() / animFrames
	t.h = t.animImage:getHeight()
	t.x, t.y = spawn_entity()

	t.anim = newAnimation(t.animImage, t.w, t.h, animDelay, animFrames)
	t.direction = math.random(1,4)	t.isGrabbed = false
	
	table.insert(children, t)
end

enemies={}
function spawn_Enemy()

	local t = {}

	if (math.random(1,2) == 1) then
		t.animImage = images.enemy1
	else
		t.animImage = images.enemy2
	end

	t.w = t.animImage:getWidth() / animFrames
	t.h = t.animImage:getHeight()
	t.x, t.y = spawn_entity()

	t.anim = newAnimation(t.animImage, t.w, t.h, animDelay, animFrames)
	t.direction = math.random(1,4)
	
	table.insert(enemies, t)
end