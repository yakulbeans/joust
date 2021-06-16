PlayState = Class{__includes = BaseState}

function PlayState:init()

end

playerX = VIRTUAL_WIDTH / 2
local GRAVITY = 25
PLAYER_SPEED = 250
playerY = VIRTUAL_HEIGHT - 100
playerDY = 0
grounded = true

function PlayState:update(dt)
	--sounds['playMusic']:setLooping(true)
	--sounds['playMusic']:play()

	playerDY = playerDY + GRAVITY * dt

	if love.keyboard.wasPressed('h') then
		gStateMachine:change('helpState')
	end

	if love.keyboard.isDown('right') then
		playerX = math.min(VIRTUAL_WIDTH - 110, playerX + PLAYER_SPEED * dt)
	end

	if love.keyboard.isDown('left') then
		playerX = math.max(0, playerX - PLAYER_SPEED * dt)
	end

	if love.keyboard.wasPressed('space') and grounded then
		playerDY = -10
	end

	if playerY == 690 then
		grounded = true
	else
		grounded = false
	end


	if love.keyboard.wasPressed('r') then
		--sounds['playMusic']:stop()
		gStateMachine:change('titleState')
		playerX = 0
		playerY = 800 - 110
		playerDY = 0
	end

	playerY = math.min(VIRTUAL_HEIGHT - 110, playerY + playerDY)

end


function PlayState:render()
	love.graphics.clear(0/255, 0/255, 0/255, 255/255)

	love.graphics.setColor(255/255, 193/255, 87/255, 255/255)
	love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 50)

	love.graphics.setColor(255/255, 70/255, 70/255, 255/255)
	love.graphics.rectangle('fill', playerX, playerY, 110, 110)

	--love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	--love.graphics.printf('Hello PlayState', 0, 200, VIRTUAL_HEIGHT / 2, 'center')
end 

