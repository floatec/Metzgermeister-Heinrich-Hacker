require("AnAL")
require("global")
require("collision")
loader = require("AdvTiledLoader/loader")
game={}
game.state=0

function game.load(map_file, countChildren, countEnemies)
	love.graphics.setNewFont(14)
	-- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
	loader.path = "maps/"
	game.state=0
	children={}
	enemies={}
	blood=1
	 -- Loads the map file and returns it
	map = loader.load(map_file)

	-- load images
	images = {
		heinrich1 = love.graphics.newImage("gfx/heinrich1.png"),
		girl1 = love.graphics.newImage("gfx/girl1.png"),
		enemy1 = love.graphics.newImage("gfx/enemy1.png"),
		enemy2 = love.graphics.newImage("gfx/enemy2.png"),
		blood = love.graphics.newImage("gfx/blood.png")
	}
	countdown=90
	-- sound effect
	sound={
		scream = love.audio.newSource("sfx/scream.wav", "static"),
		slay  = love.audio.newSource("sfx/slay.mp3", "static"),
		hallo_meine_liebe  = love.audio.newSource("sfx/hallo_meine_liebe.ogg", "static")

	}
	-- music
	love.audio.stop(music)
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
	p.direction = 1
	p.speed = speed
	p.anim = newAnimation(p.animImage, p.w, p.h, animDelay, animFrames)

	for x, y, tile in map("buildings"):iterate() do
  		if tile and tile.properties["spawn"] then
  			spawnx,spawny=x,y
  			p.x,p.y=x*16,y*16
  		break
  		end
	end

	for i=1,countChildren do
		spawn_Child()
	end

	for i=1,countEnemies do
		spawn_Enemy()
	end
end

function game.update(dt)
	blood=blood+dt
	countdown=countdown-dt
	if gewicht>=100 then 
			game.state=1
	elseif countdown<0 then
		
			game.state=2
		
	end
	oldx, oldy = p.x, p.y
	newx, newy = p.x, p.y

	--calculate speed
	grabCount = 0
	for i, v in ipairs(children) do
		if (v.isGrabbed) then
			grabCount = grabCount + 1
		end
	end
	p.speed = 1 / (math.exp (grabCount, 1.25) + 1) * speed + 50 

	-- update x
	if love.keyboard.isDown("left")   then
		newx = p.x - p.speed * dt
		p.direction = 4
	elseif love.keyboard.isDown("right") then
		newx = p.x + p.speed * dt
		p.direction = 2
	end

	-- update y
	if love.keyboard.isDown("up")  then
		newy = p.y - p.speed * dt
		p.direction = 3
	elseif love.keyboard.isDown("down") then
		newy = p.y + p.speed * dt
		p.direction = 1
	end

	-- actual movement
	dx, dy = move(p, newx, newy)

	if (math.abs(dx) > 0 or math.abs(dy) > 0) then
		p.anim:update(dt)
	end

	-- update children
	for i, v in ipairs(children) do
		if(hits_spawn(v.x,v.y,32,32)) then
			blood=0
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

		-- reset speed to max
		p.speed = speed

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
			p.speed = 1
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
		v.anim:draw(v.x, v.y, -v.direction * math.pi / 2 - math.pi / 2, 1, 1, v.w / 2, v.h / 2)
	end

	--enemies
	for i, v in ipairs(enemies) do
		v.anim:draw(v.x, v.y, -v.direction * math.pi / 2 - math.pi / 2, 1, 1, v.w / 2, v.h / 2)
	end
		
	-- player
	p.anim:draw(p.x, p.y, -p.direction * math.pi / 2 - math.pi / 2, 1, 1, p.w / 2, p.h / 2)

	--map
	map("buildings").visible=false
	map:draw()
	map("buildings").visible=true

 	-- text
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.printf("Zeit: "..(math.floor(countdown/60))..":"..(math.floor(countdown)%60), 0, 0, width, "left")	
    love.graphics.printf("Fleisch: "..gewicht.."kg", 0, 0, width, "right")	
    if blood<0.12 then
    	love.graphics.draw(images.blood, 0,0)
    end

end

children={}
function spawn_Child()

	local t = {}
	t.animImage = images.girl1
	t.w = t.animImage:getWidth() / animFrames
	t.h = t.animImage:getHeight()
	t.x, t.y = spawn_entity()

	t.anim = newAnimation(t.animImage, t.w, t.h, animDelay, animFrames)
	t.direction = math.random(1,4)	
	t.isGrabbed = false
	
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