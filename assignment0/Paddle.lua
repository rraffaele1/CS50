--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
	self.inertia = 0
	self.prevPos = 0
	self.MovedAdvanced = false
	self.timeToStartMove = 0
	self.myTime = 0
end

function Paddle:getTimeToY(y, speed, dt, enemy, centerOfScreen)
	originaly = self.y
	Time = 0
	while true do
		Time = Time + dt
		self.y = self.y + (self:SpeedToDY(speed, y) * dt)
		if self:isReachedIntelligent(y, enemy, centerOfScreen) then
			break
		end
	end
	self.y = originaly
	return Time
end

function Paddle:SpeedToDY(speed, y)
	if math.floor(self.y) + 10 < math.floor(y) then
		return speed
	else
		return -speed
	end
end

function Paddle:isReachedIntelligent(y, enemy, centerOfScreen)
	minX = 0
	maxX = 0
	if enemy.y < centerOfScreen then --up
		minX = 0
		maxX = 10
	else --down
		minX = 10
		maxX = 20
	end
	if self.y + minX < y and self.y + maxX > y then
		return true
	else
		return false
	end
end

function Paddle:isReached(y)
	if self.y + 5 < y and self.y + 15 > y then
		return true
	else
		return false
	end
end

function Paddle:moveToAdvanced(y, speed, timeToReachPaddle, dt, enemy, centerOfScreen)
	if timeToReachPaddle == 0 then
		self.MovedAdvanced = false
		self.myTime = 0
		self:moveTo(y, speed)
		return
	end
	if not self.MovedAdvanced then
		self.MovedAdvanced = true
		local distance = math.abs(self.y - y)
		self.timeToStartMove = timeToReachPaddle - self:getTimeToY(y, speed, dt, enemy, centerOfScreen)
	end
	self.myTime = self.myTime + dt
	if self.myTime >= self.timeToStartMove then
		self:moveTo(y, speed)
	end
end

function Paddle:moveTo(y, speed)
	if math.floor(self.y) + 10 < math.floor(y) then
		self.dy = speed
		self.inertia = self.inertia + 1
	elseif math.floor(self.y) + 10 > math.floor(y) then
		self.dy = -speed
		self.inertia = self.inertia + 1
	else
		self.dy = 0
	end
end

function Paddle:update(dt)
	-- print(self.prevPos, self.y)
	if self.prevPos ~= self.y then
		self.prevPos = self.y
	else
		self.inertia = 0
	end
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end