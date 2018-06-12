--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
	self.live = love.graphics.newImage('live.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8
	self.invincible = 0
	
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
	self.lives = 3
    self.dy = 0
end

function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8
	self.dy = 0
end

function Bird:canRevive()
	if self.lives > 0 then
		self.lives = self.lives - 1
		self.invincible = 2
		self:reset()
		return true
	end
	return false
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)

    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
	if self.invincible > 0 then
		self.invincible = self.invincible - dt
	end
    self.dy = self.dy + GRAVITY * dt

    -- burst of anti-gravity when space or left mouse are pressed
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
	if self.invincible > 0 then
		love.graphics.setColor(255, 255, 255, math.random(20, 200)) -- red, green, blue, opacity (this would be white with 20% opacity)
	end
    love.graphics.draw(self.image, self.x, self.y)
	love.graphics.setColor(255, 255, 255, 255)
	for i=0, self.lives-1 do
		love.graphics.draw(self.live, i * 24 + 8, 36)	
	end
end