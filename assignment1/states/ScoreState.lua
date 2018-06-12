--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local ScoreView = {}
--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
	--Score, Medal Path
	table.insert(ScoreView,Medal.new(1, "Medal/bronze.png"))
	table.insert(ScoreView,Medal.new(2, "Medal/silver.png"))
	table.insert(ScoreView,Medal.new(3, "Medal/gold.png"))
	--
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
	
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
	local path = self:getMedalByScore()
	if path ~= nil then
		medalIcon = love.graphics.newImage(path)
		local medalWidth, medalHeight = medalIcon:getDimensions()
		love.graphics.draw(medalIcon, VIRTUAL_WIDTH/2 - medalWidth/2, 36)
	end 
	
end

function ScoreState:getMedalByScore()
	local sizeArray = table.getn(ScoreView)
	for i=1, sizeArray do
		if i < sizeArray then
			if self.score >= ScoreView[i].minScore and self.score < ScoreView[i+1].minScore then
				return ScoreView[i].pathMedal
			end		
		else
			if self.score >= ScoreView[i].minScore then
				return ScoreView[i].pathMedal
			end
		end
	end
	return nil
end

Medal = {}
local Medal_meta = {}
function Medal.new(minScore, pathMedal)
	local info = {}
	info.minScore = minScore
	info.pathMedal = pathMedal
	setmetatable(info,Medal_meta)
	return info
end