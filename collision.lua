require("global")

function move(entity, newx, newy)

	oldx, oldy = entity.x, entity.y

	if(can_move_to(entity.x+2, newy+2, 28, 28)) then
		entity.x, entity.y = entity.x, newy
	end
	if(can_move_to(newx+2, entity.y+2, 28, 28)) then
		entity.x, entity.y = newx, entity.y
	end

	return entity.x - oldx, entity.y - oldy
end

function automove(entity, dt)	
		--print (entity.direction)
		newy=entity.y
		newx=entity.x
		local dist=(speed*0.3 * dt)%16
		if entity.direction % 2 == 0 then
			newx = entity.x - dist * (entity.direction-3)
		else 	
			newy = entity.y - dist*(entity.direction-2)
		end
		-- wall hit
		if can_move_to(newx+2,newy+2,28,28) then
			entity.x,entity.y=newx,newy
			if(math.random(0,50)==0) then
				entity.direction = math.random(1,4)
			end
		else
			--print("change direction")
			entity.direction = math.random(1,4)
		end
		--print (entity.x.." "..entity.y)
end

function spawn_entity()
	repeat
		x = math.random(0, 800-32)
		y =  math.random(0, 600-32)
	until can_move_to(x, y, 32, 32)

	return x,y
end

function can_move_to( x,y ,w,h)
	return not hits( x,y ,w,h,"wall");	
end

function hits_spawn( x,y ,w,h)
	return hits( x,y ,w,h,"spawn");	
end

function hits( x,y ,w,h,prop)
	 if is_colliding_with_wall(x,y,prop) or  is_colliding_with_wall(x+w,y,prop) or  is_colliding_with_wall(x,y+h,prop) or  is_colliding_with_wall(x+w,y+h,prop) or
	 	is_colliding_with_wall(x+w/3,y,prop) or  is_colliding_with_wall(x+w/3*2,y,prop) or  is_colliding_with_wall(x+w/3,y+h,prop) or  is_colliding_with_wall(x+w/3*2,y+h,prop) or
	 	is_colliding_with_wall(x,y+h/3,prop) or  is_colliding_with_wall(x+w,y+h/3,prop) or  is_colliding_with_wall(x,y+h/3*2,prop) or  is_colliding_with_wall(x+w,y+h/3*2,prop) then
	 	return true
	 end
	 	return false
end

function is_colliding_with_wall(x,y,prop)
	local tile=map("buildings")(math.floor(x/16),math.floor(y/16))
	if tile and tile.properties[prop] then
		return true
	end
	
	return false
end

function is_colliding(obj1, obj2)
	
	if obj1.x <= obj2.x + obj2.w and obj1.x + obj1.w >= obj2.x and 
		obj1.y <= obj2.y + obj2.h and obj1.y + obj1.h >= obj2.y then
		return true
	end
	
	return false
end