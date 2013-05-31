require("global")

function move(entity, dt)	
		print (entity.direction)
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
		else
			print("change direction")
			entity.direction = math.random(1,4)
		end
		print (entity.x.." "..entity.y)
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