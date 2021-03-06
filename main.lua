--	
--	main.lua
--	
--	Ian Powell 11-3-2014	
--	Plat-former Game Test 
--	Used Advanced Tiled Map Loader and Tiled to set-up Level
--

local AdvTiledLoader = require("AdvTiledLoader.Loader")
local background = love.graphics.newImage("assets/sky1.png")

local player = love.graphics.newImage("assets/fullSpriteSheet.png")
local sprite = love.graphics.newSpriteBatch(player, 9)

require("camera")
require("AnAL")

function love.load()
	love.graphics.setBackgroundColor( 220, 220, 255)
	AdvTiledLoader.path = "maps/"
	map = AdvTiledLoader.load("level.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	print(map)
  
  anim = newAnimation(player, 64, 64, 0.1, 0)
  
	camera:setBounds(0, 0, map.width * map.tileWidth - love.graphics.getWidth(), map.height * map.tileHeight - love.graphics.getHeight())

	world =		{
						gravity = 1536,
						ground = 512,
						}
	
	player =		{
						x = 256,
						y = 256,
						
						x_vel = 0,
						y_vel = 0,
						jump_vel = -1024,
						
						speed = 512,
						flySpeed = 700,
						state = "",
						h = 64,
						w = 64,
						
						standing = false,
						}	
	
	function player:jump()
		if self.standing then
			self.y_vel = self.jump_vel
			self.standing = false
		end
	end
		
	function player:right()
			self.x_vel = self.speed
	end
		
	function player:left()
			self.x_vel = self.speed * -1 
	end
		
	function player:stop()
			self.x_vel = 0
	end
    function math.clamp(n, low, high) return math.min(math.max(n, low), high) end 
		
		function player:collide(event)
			if event == "floor" then
				self.y_vel = 0
				self.standing = true
			end
			if event == "cieling" then
				self.y_vel = 0
			end
		end
		
		function player:update(dt)
      
      anim:update(dt)
      
			local halfX = self.w / 2
			local halfY = self.h / 2
			
			self.y_vel = self.y_vel + (world.gravity * dt)
			
			self.x_vel = math.clamp(self.x_vel, - self.speed, self.speed)
			self.y_vel = math.clamp(self.y_vel, - self.flySpeed, self.flySpeed)
			
			local nextY = self.y + (self.y_vel * dt)
			if self.y_vel < 0 then
				if not (self:isColliding(map, self.x + halfX, nextY - halfY))
					and not (self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
					self.y = nextY
					self.standing = false
				else
					self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
					self:collide("cieling")
				end
			end
			if self.y_vel > 0 then
				if not (self:isColliding(map, self.x - halfX, nextY + halfY)) then
					self.y = nextY
					self.standing = false
				else
					self.y = nextY - ((nextY + halfY) % map.tileHeight)
					self:collide("floor")
				end
			end
		
		
			local nextX = self.x + (self.x_vel * dt)
			if self.x_vel > 0 then
				if not(self:isColliding(map, nextX + halfX, self.y - halfY)) 
					and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1))then
				self.x = nextX
				else
					self.x = nextX - ((nextX + halfX) % map.tileHeight)
				end
			elseif self.x_vel < 0 then
				if not(self:isColliding(map, nextX - halfX, self.y - halfY))
					and not(self:isColliding(map, nextX - halfX, self.y + halfY -1)) then
					self.x = nextX
				else
					self.x = nextX - ((nextX + halfX) % map.tileHeight)
				end
			end
			
			self.state = self:getState()
		end	

		function player:isColliding(map, x, y)
			local layer = map.layers["Solid"]
			local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
			local tile = layer:get(tileX, tileY)
			return not(tile == nil)
		end
		
		function player:getState()
			local tempState = ""
			if self.standing then
				if self.x_vel > 0 then
					tempState = "right"
				elseif self.x_vel < 0 then
					tempState = "left"
				else
					tempState = "stand"
				end
			end
			
			if self.y_vel > 0 then
					tempState = "fall"
				elseif self.y_vel < 0 then
					tempState = "jump"
			end	
				return tempState
		end
end
function love.draw()
  
  anim:draw(player.x - player.w / 2, player.y - player.h / 2, player.w, player.h)
  
  for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
	camera:set()
	
	love.graphics.setColor(0, 0, 0)
  
  
  
	love.graphics.rectangle("fill", player.x - player.w / 2, player.y - player.h / 2, player.w, player.h)
	
	love.graphics.setColor(225, 255, 255)
	map:draw()
	
	camera:unset()
end

function love.update(dt) -- dt mean delta time which is check for the time between frames. this will will handle physics
	if dt > 0.05 then
		dt = 0.05
	end
	
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		player:left()
  end
	
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		player:right()
  end

	if love.keyboard.isDown(" ") and not (hasJumped) then
		player:jump()
	end
	
  function love.keyreleased(key)
    if key == "a" or key == "d" or key == "left" or key == "right" then
      player:stop()
    end
    
    if key == "escape" then
      love.event.quit()
    end
  end
  
	player:update(dt)
	
	camera:setPostion( player.x - (love.graphics.getWidth ()/2), player.y - (love.graphics.getHeight ()/2))
	
	
end

