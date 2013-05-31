----------------------------------------------------------------
-- Textures and sprites creation
----------------------------------------------------------------
local textureCache = {}
 
local function textureFromCache ( name, width, height )
  if textureCache [ name ] == nil then
    textureCache[name] = MOAIGfxQuad2D.new ()
    textureCache[name]:setTexture ( name )
    textureCache[name]:setRect ( -width/2, -height/2, width/2, height/2 )
  end
  return textureCache [ name ]
end
 
local function newSprite ( filename, width, height ) 
	if width == nil or height == nil then
		-- read width/height from the image
		local img = MOAIImage.new ()
		img:load ( filename )
		width, height = img:getSize ()
		img = nil
	end
 
	local gfxQuad = textureFromCache ( filename, width, height )
	local prop = MOAIProp2D.new ()
	prop:setDeck ( gfxQuad )
	prop.filename = filename
	return prop
end


----------------------------------------------------------------
-- various utilities
----------------------------------------------------------------
local rand = math.random
math.randomseed ( os.time ())
-- The multiple rand below is due to OSX/BSD problem with rand implementation
-- http://lua-users.org/lists/lua-l/2007-03/msg00564.html
rand (); rand (); rand ();
local function randomArrayElement ( array )
	return array [ rand ( #array ) ]
end

----------------------------------------------------------------
-- Input (touches and mouse) handling
----------------------------------------------------------------
-- location of the mouse cursor (or touch point)
local mouseX, mouseY
-- this is to keep reference to what's being dragged
local currentlyTouchedProp 
 
local function dragObject ( object, x, y )
	print ("Dragging")
end
local function pointerCallback ( x, y )
	-- this function is called when the touch is registered (before clickCallback)
	-- or when the mouse cursor is moved
	mouseX, mouseY = layer:wndToWorld ( x, y )
	print ("mouse moved")
end
 
function clickCallback ( down )
	-- this function is called when touch/click 
	-- is registered
	print ("Click!")
	local x,y = heinrich:getLoc()
	print(x.." "..y)
	print(mouseX.."xxx"..mouseY)
	if down then
		heinrich:moveLoc (mouseX-x,mouseY-y,1 )
	end
end


----------------------------------------------------------------
-- screen (window) initialization
----------------------------------------------------------------
-- 1.
local STAGE_WIDTH = 960
local STAGE_HEIGHT = 640
local SCREEN_WIDTH = 960
local SCREEN_HEIGHT = 640
print ( "System: ", MOAIEnvironment.osBrand )
print ( "Resolution: " .. SCREEN_WIDTH .. "x" .. SCREEN_HEIGHT )
 
-- 2.
MOAISim.openWindow ( "Heinrich Hackers Mätzgerei", SCREEN_WIDTH, SCREEN_HEIGHT ) -- window/device size
 
-- 3.
local viewport = MOAIViewport.new ()
viewport:setSize ( SCREEN_WIDTH, SCREEN_HEIGHT ) -- window/device size
viewport:setScale ( STAGE_WIDTH, STAGE_HEIGHT ) -- size of the "app"
 
-- 4. 
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
layer:setClearColor (0.53, 0.53, 0.53, 1)
 
-- 5.
local partition = MOAIPartition.new ()
layer:setPartition ( partition )
 
-- 6.
MOAIRenderMgr.setRenderTable ( { layer } )


heinrich = newSprite ( "prosdata_small.png", 84, 98 ) -- here we supply width and height
heinrich:setLoc( -100, -230 ) -- set location - we move the sprite to the left and down
layer:insertProp ( heinrich )
layer:insertProp ( prop )


-- Here we register callback functions for input - both mouse and touch
if MOAIInputMgr.device.pointer then
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )
else
	-- touch input
	MOAIInputMgr.device.touch:setCallback ( 
		-- this is called on every touch event
		function ( eventType, idx, x, y, tapCount )
			pointerCallback ( x, y ) -- first set location of the touch
			if eventType == MOAITouchSensor.TOUCH_DOWN then
				clickCallback ( true )
			elseif eventType == MOAITouchSensor.TOUCH_UP then
				clickCallback ( false )
			end
		end
	)
end
