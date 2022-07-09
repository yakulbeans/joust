PlayState = Class{__includes = BaseState}

function PlayState:init()
	player1 = Ostrich(VIRTUAL_WIDTH / 3 - 8, VIRTUAL_HEIGHT - 90, 16, 24)
	platform1 = Platform(VIRTUAL_WIDTH / 3, VIRTUAL_HEIGHT / 2, 80, 4)
	groundPlatform = Platform(-player1.width, VIRTUAL_HEIGHT - GROUND_OFFSET, VIRTUAL_WIDTH + (player1.width * 2), 36)
	collidablePlatforms = {platform1, groundPlatform}
	--ground = Platform('name', 1, 1, 1, 1)

end

function PlayState:update(dt)

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.wasPressed('r') then
		player1.x = VIRTUAL_WIDTH / 3 - 8
		player1.y = VIRTUAL_HEIGHT - 90
		player1.skid = false
		player1.grounded = false
		player1.facingRight = true
		player1.dx = 0
		player1.dy = 0
		sounds['leftStep']:stop()
		sounds['rightStep']:stop()
		sounds['skid']:stop()
	end

	player1:update(dt)

end

function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	--lava stand-in
	love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 13, VIRTUAL_WIDTH, 13)


	--draw ground top level **to be made retractable
	love.graphics.setColor(133/255, 70/255, 15/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 36, VIRTUAL_WIDTH, 4)

	--ground bottom stand-in
	love.graphics.setColor(219/255, 164/255, 0/255, 255/255)
	love.graphics.rectangle('fill', 53, VIRTUAL_HEIGHT - 36, 186, 32)

	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

	love.graphics.setFont(smallFont)
	love.graphics.print(table.concat({
		'',
		'',
		'',
		'PLAYER1.X: '..math.floor(player1.x),
		'PLAYER1.Y: '..math.floor(player1.y),
		--'PLAYER1.facingRight: '..tostring(player1.facingRight),
		--'ANIMATION TIMER: ' ..tostring(animationTimer),
		--'PLAYER1.speedTier: '..math.floor(player1.speedTier),
		'PLAYER1.DY: ' ..tostring(string.format("%.2f", player1.dy)),
		--'PLAYER1.skid: ' ..tostring(player1.skid),
		'PLAYER1.DX: ' ..tostring(string.format("%.2f", player1.dx)),
		--'justStoppedTimer: ' ..tostring(string.format("%.3f", player1.justStoppedTimer)),
		--'justTurnedTimer: ' ..tostring(string.format("%.3f", player1.justTurnedTimer)),
		--'justStopped = ' ..tostring(player1.justStopped),
		--'justTurned = ' ..tostring(player1.justTurned),
		--'love.keyboard.isDown(left) =' ..tostring(love.keyboard.isDown('left')),
		'self.skid = ' ..tostring(player1.skid),
		--'lastInputLocked = ' ..lastInput[1],
		'PLAYER1.grounded: ' ..tostring(player1.grounded),
		--'TOP COLL: ' .. tostring(player1:topCollides(platform1)),
		'platform1 BotCol: ' .. tostring(player1:bottomCollides(platform1)),
		'groundPlat BotCol: ' .. tostring(player1:bottomCollides(groundPlatform)),
		--'topcheckGrounded: ' .. tostring(player1:checkGrounded(groundPlatform)),
 		--'RIGHT COLL: ' .. tostring(player1:rightCollides(platform1)),
		--'LEFT COLL: ' .. tostring(player1:leftCollides(platform1)),
		--'jumpTimer: ' ..tostring(player1.jumpTimer),
		--'flapped: ' ..tostring(player1.flapped),
	}, '\n'))

	player1:render()
	platform1:render()

	--KEYLOGGER
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.draw(keyloggerPlate, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)

	if love.keyboard.isDown('left') then
		love.graphics.draw(keylogger1, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end
	
	if love.keyboard.isDown('a') then
		love.graphics.draw(keylogger2, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end

	if love.keyboard.isDown('right') then
		love.graphics.draw(keylogger3, VIRTUAL_WIDTH - 200, VIRTUAL_HEIGHT - 35, 0, .6, .6)
	end

end