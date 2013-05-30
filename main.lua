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
local layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
layer:setClearColor (0.53, 0.53, 0.53, 1)
 
-- 5.
local partition = MOAIPartition.new ()
layer:setPartition ( partition )
 
-- 6.
MOAIRenderMgr.setRenderTable ( { layer } )
local quad = MOAIGfxQuad2D.new ()
quad:setTexture ( "prosdata_small.png" )
quad:setRect ( -84/2, -98/2, 84/2, 98/2 )
 
local prop = MOAIProp2D.new()
prop:setDeck ( quad )
 
layer:insertProp ( prop )