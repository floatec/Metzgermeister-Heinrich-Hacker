require("global")

function move(entity, newx, newy)

	oldx, oldy = entity.x, entity.y

	if(can_move_to(entity.x, newy, 32, 32)) then
		entity.x, entity.y = entity.x, newy
	end
	if(can_move_to(newx, entity.y, 32, 32)) then
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
		if can_move_to(newx,newy,32,32) then
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


function can_move_to( x,y ,w,h)
	 if is_colliding_with_wall(x,y) or  is_colliding_with_wall(x+w,y) or  is_colliding_with_wall(x,y+h) or  is_colliding_with_wall(x+w,y+h) or
	 	is_colliding_with_wall(x+w/3,y) or  is_colliding_with_wall(x+w/3*2,y) or  is_colliding_with_wall(x+w/3,y+h) or  is_colliding_with_wall(x+w/3*2,y+h) or
	 	is_colliding_with_wall(x,y+h/3) or  is_colliding_with_wall(x+w,y+h/3) or  is_colliding_with_wall(x,y+h/3*2) or  is_colliding_with_wall(x+w,y+h/3*2) then
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

function is_colliding(obj1, obj2)
	
	if obj1.x <= obj2.x + obj2.w and obj1.x + obj1.w >= obj2.x and 
		obj1.y <= obj2.y + obj2.h and obj1.y + obj1.h >= obj2.y then
		return true
	end
	
	return false
end