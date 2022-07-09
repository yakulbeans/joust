Ostrich = Class{}

function Ostrich:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.atlas = playerAtlas
	self.dy = 0
	self.dx = 0
	self.justStoppedTimer = STOPTURNTIMER
	self.justTurnedTimer = STOPTURNTIMER
	self.grounded = false
	self.skid = false
	self.facingRight = true
	self.flapped = false
	self.justStopped = false
	self.justTurned = false
	self.lastInputLocked = false
	self.alternate = false
	speedScale = 0
	fps = 1
	animationTimer = 2 / fps
	self.jumpTimer = 0
	self.frame = 1
	totalFrames = 4
	self.xoffset = self.width
	ostrichSprite = love.graphics.newQuad(0, 0, self.width, self.height, self.atlas:getDimensions())
end

function Ostrich:checkGrounded(collidablePlatforms)
	if self.y == collidablePlatforms.y - 24 then
		if self.x < collidablePlatforms.x + collidablePlatforms.width - PLATFORMBUFFER and self.x + self.width > collidablePlatforms.x + PLATFORMBUFFER then
			return true
		else
			return false
		end
	end
	return false	
end

function Ostrich:topCollides(collidable)
	if (self.y < collidable.y + collidable.height and self.y > collidable.y) then
		if (self.x < collidable.x + collidable.width and self.x + self.width > collidable.x) then
			return true
		end
	end

	return false
end

function Ostrich:bottomCollides(collidable)
	if (self.y + self.height > collidable.y and self.y + self.height < collidable.y + collidable.height) then
		if (self.x < collidable.x + collidable.width - PLATFORMBUFFER and self.x + self.width > collidable.x + PLATFORMBUFFER) then
			ground = collidable
			return true
		end
	end

	return false
end

function Ostrich:rightCollides(collidable)
	if (self.x + self.width > collidable.x + PLATFORMBUFFER / 2 and self.x + self.width < collidable.x + collidable.width) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			if self.facingRight then
				self.x = collidable.x - self.width
				return true
			end
		end
	end

	return false
end

function Ostrich:leftCollides(collidable)
	if (self.x < collidable.x + collidable.width - PLATFORMBUFFER / 2 and self.x > collidable.x) then
		if (self.y < collidable.y + collidable.height and self.y + self.height > collidable.y) then
			if not self.facingRight then
				self.x = collidable.x + collidable.width
				return true
			end
		end
	end

	return false
end

lastInput = {"right"}


function Ostrich:update(dt)
	

	---[[

	--CYCLE THROUGH PLATFORMS FOR COLLISION
	for index, platform in pairs(collidablePlatforms) do
			--BOTTOM COLLIDES
		if self:bottomCollides(platform) then
			self.height = 24
			self.y = platform.y - self.height
			self.dy = 0
			self.grounded = true
			self.platform = platform
		end

		if self:topCollides(platform) then
			self.y = platform.y + platform.height
			self.dy = (self.dy * - 1)
		end

		--LEFT COLLIDES SETS POSITIVE DX
		if self:leftCollides(platform) then
			sounds['collide']:play()
			self.x = platform.x + platform.width
			self.dx = math.abs(self.dx)
		end

		--RIGHT COLLIDES SETS POSITIVE DX
		if self:rightCollides(platform) then
			sounds['collide']:play()
			self.x = platform.x - self.width
			self.dx = -self.dx
		end
	end
	--]]










	--]]

	--APPLY GRAVITY WHEN IN AIR
	if not self.grounded then
		self.dy =  self.dy + GRAVITY * dt
	end

	--UPDATES OSTRICH Y
	self.y = self.y + self.dy


	--ENSURES OSTRICH FACING DIRECTION OF DX - SKID LOGIC FOR > SPEED 2
	if self.grounded and self.dx > 0 then
		self.facingRight = true
--OLD SKID WHILE IN AIR LOGIC PLACE
	elseif self.grounded and self.dx < 0 then
		self.facingRight = false
---OLD SKID WHILE IN AIR LOGIC PLACE
	end
	
	--BOUNCING OFF TOP
	if self.y < 0 then
		self.y = 0
		self.dy = .8
	end
	
	--LOOPS player to left side of screen
	if self.x > VIRTUAL_WIDTH then
		self.x = -self.width
	end

	--LOOPS player to right side of screen
	if self.x < -self.width then
		self.x = VIRTUAL_WIDTH
	end



	--INPUT HANDLING

	--MULTIPLE DIRECTION INPUT HANDLING
	if love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
		self.rightPriority = false
		lastInput = {}
		table.insert(lastInput, "left")

	elseif love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
		self.rightPriority = true
		lastInput = {}
		table.insert(lastInput, "right")

	elseif love.keyboard.isDown('right') and love.keyboard.isDown('left') and not self.lastInputLocked then
		--assign only one value until a key is released
		if lastInput[1] == "left" then
			lastInput = {}
			table.insert(lastInput, "right")
		elseif lastInput[1] == "right" then
			lastInput = {}
			table.insert(lastInput, "left")
		end

		self.lastInputLocked = true
	end

	if love.keyboard.wasReleased('left') or love.keyboard.wasReleased('right') then
		self.lastInputLocked = false
	end
	--INPUT LAG BOOLEANS AND DECREMENT
	if self.justStopped then
		if self.justStoppedTimer > 0 then
			self.justStoppedTimer = self.justStoppedTimer - dt
		else
			self.justStopped = false
			self.justStoppedTimer = STOPTURNTIMER
		end
	end

	if self.justTurned then
		if self.justTurnedTimer > 0 then
			self.justTurnedTimer = self.justTurnedTimer - dt
		else
			self.justTurned = false
			self.justTurnedTimer = STOPTURNTIMER
		end
	end


	


	if self.grounded then
		self.height = 24
		---[[SKID UPON LANDING
		if love.keyboard.isDown('left') and lastInput[1] == "left" and self.dx > .7 and not self.skid then
			sounds['leftStep']:stop()
			sounds['rightStep']:stop()
			sounds['skid']:play()
			self.skid = true
		end

		if love.keyboard.isDown('right') and lastInput[1] == "right" and self.dx < -.7 and not self.skid then
			sounds['leftStep']:stop()
			sounds['rightStep']:stop()
			sounds['skid']:play()
			self.skid = true
		end
		--]]
		if self.facingRight then
			--MOVE TO THE RIGHT IF NOT JUSTTURNED OR SKIDDING
			if love.keyboard.isDown('right') and lastInput[1] == "right" and not self.skid and not self.justTurned then
				self.dx = math.max(.12, (math.min(self.dx + PLAYERVELOCITY, MAXSPEED)))
			end
	
			if self.dx == 0 then
				--TURNS LEFT WHEN STOPPED
				if love.keyboard.isDown('left') and lastInput[1] == "left" and not self.justStopped then
					self.facingRight = false
					self.justTurned = true
				end

			--IF MOVING TO THE RIGHT IN SPEED1
			elseif (self.dx > 0 and self.dx < SKIDTHRESHOLD) then
				
				--STOPS WHEN FACING RIGHT
				if love.keyboard.isDown('left') and lastInput[1] == "left" then
					self.dx = 0
					self.justStopped = true
				end

			--SKID FLAG
			elseif self.dx >= SKIDTHRESHOLD then
				if love.keyboard.isDown('left') and love.keyboard.wasReleased('right') then
					self.skid = true
					sounds['skid']:play()
				end

				if love.keyboard.wasPressed('left') and not self.skid then
					self.skid = true
					sounds['skid']:play()
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
				end
			end

		elseif not self.facingRight then

			--MOVE TO THE LEFT IF NOT JUSTTURNED OR SKIDDING
			if love.keyboard.isDown('left') and lastInput[1] == "left" and not self.skid and not self.justTurned then
					self.dx = math.min(-.12, (math.max(self.dx - PLAYERVELOCITY, -MAXSPEED)))
			end

			if self.dx == 0 then
				--TURNS RIGHT WHEN STOPPED
				if love.keyboard.isDown('right') and lastInput[1] == "right" and not self.justStopped then
					self.facingRight = true
					self.justTurned = true
				end

			--IF MOVING TO THE LEFT IN SPEED1
			elseif (self.dx < 0 and self.dx > -SKIDTHRESHOLD) then
				--STOPS WHEN FACING LEFT
				if love.keyboard.isDown('right') and lastInput[1] == "right" then
					self.dx = 0
					self.justStopped = true
				end
			--SKID FLAG
			elseif self.dx < -SKIDTHRESHOLD then
				if love.keyboard.isDown('right') and love.keyboard.wasReleased('left') then
						self.skid = true
						sounds['leftStep']:stop()
						sounds['rightStep']:stop()
						sounds['skid']:play()
				end

				if love.keyboard.wasPressed('right') and not self.skid then
					self.skid = true
					sounds['leftStep']:stop()
					sounds['rightStep']:stop()
					sounds['skid']:play()
				end
			end
		end
		
	--AERIAL HANDLING
	elseif not self.grounded then
		self.skid = false
		self.height = 16
		--TURNING LEFT MIDAIR
		if love.keyboard.wasPressed('left') and self.facingRight then
			self.facingRight = false
		end

		if love.keyboard.wasPressed('right') and not self.facingRight then
			self.facingRight = true
		end

		--FLAPPING DX CHANGE TO DO
		if love.keyboard.isDown('left') and lastInput[1] == 'left' and love.keyboard.wasPressed('a') then
			self.dx = math.max(self.dx - PLAYERAERIALVELOCITY, -MAXSPEED)
		end

		if love.keyboard.isDown('right') and lastInput[1] == 'right' and love.keyboard.wasPressed('a') then
			self.dx = math.min(self.dx + PLAYERAERIALVELOCITY, MAXSPEED)
		end
	end

		--PLAYER1 JUMPING
	if love.keyboard.wasPressed('a') then
		--ground = Platform(1, 1, 1, 1)
		self.grounded = false
		sounds['flap']:play()

		--JUMPING DY
		if (self.dy < -.5) then
			self.dy = -1.5
		elseif(self.dy < -.4) then
			self.dy = -.7
		elseif (self.dy < -.2) then
			self.dy = -.6
		else
			self.dy = -.4
		end
	end


	if self.dx == 0 then
		sounds['skid']:stop()
		self.skid = false
		self.justStopped = true
	elseif self.dx > 0 and self.skid and self.grounded then
		self.dx = math.max(0, self.dx - .08)
		self.x = self.x + self.dx
	elseif self.dx < 0 and self.skid and self.grounded then
		self.dx = math.min(0, self.dx + .08)
		self.x = self.x + self.dx
	else
		self.x = self.x + self.dx
	end


-- OSTRICH1 ANIMATION CYCLE

	fps = (math.abs(self.dx)) * .42 - (math.abs(self.dx) / 20 - .15)

	animationTimer = animationTimer - fps

	--STANDING STILL VIEWPORT
	if self.dx == 0 and self.grounded then
		self.frame = 1
		ostrichSprite:setViewport(1, 0, self.width, self.height)
	end

	--PLAYER WALKING ANIMATION
	if self.dx ~= 0 and self.grounded then 
		animationTimer = animationTimer - dt
		if animationTimer <= 0 then
			animationTimer = 1 / fps
			self.frame = self.frame + 1
			if self.frame == 2 and self.alternate then
				self.alternate = false
				sounds['leftStep']:play()
			elseif self.frame == 2 and not self.alternate then
				self.alternate = true
				sounds['rightStep']:play()
			end
	end
			--LOOP FRAME BACK TO 1
			if self.frame > totalFrames then self.frame = 1 end

		self.xoffset = self.frame + (self.width * (self.frame - 1))
		ostrichSprite:setViewport(self.xoffset, 0, self.width, self.height)
	end

	--PLAYER AERIAL ANIMATION
		if not self.grounded then
			ostrichSprite:setViewport((self.width * 5) + 5, 0, self.width, self.height)
			if love.keyboard.wasPressed('a') then
				self.jumpTimer = 0
				self.flapped = true
			end

			if self.flapped then
				ostrichSprite:setViewport((self.width * 6) + 6, 0, self.width, self.height)				
				self.jumpTimer = self.jumpTimer + dt
				if self.jumpTimer > .1 then
					self.flapped = false
				end
			end
		end
		
	--PLAYER SKID ANIMATION
	if self.skid then
		ostrichSprite:setViewport((self.width * 4) + 4, 0, self.width, self.height)
	end
end



function Ostrich:render()
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.print('topCheckGrounded: ' .. tostring(self:checkGrounded(platform1)))
	--love.graphics.print('groundCheckGrounded: ' .. tostring(self:checkGrounded(groundPlatform)), 0, 10)

	if player1.facingRight then
		love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y) 
	else
		love.graphics.draw(self.atlas, ostrichSprite, self.x, self.y, 0, -1, 1, self.width)
	end
end