Ball = Class {}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = math.random(2) == 1 and -BALL_SPEED_INIT_MAX_X or BALL_SPEED_INIT_MAX_X
    self.dy = math.random(-BALL_SPEED_INIT_MAX_Y, BALL_SPEED_INIT_MAX_Y)
end

function Ball:reset()
    self.x = (VIRTUAL_WIDTH / 2) - (BALL_SIZE / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (BALL_SIZE / 2)
    self.dx = math.random(2) == 1 and -BALL_SPEED_INIT_MAX_X or BALL_SPEED_INIT_MAX_X
    self.dy = math.random(-BALL_SPEED_INIT_MAX_Y, BALL_SPEED_INIT_MAX_Y)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:collides(paddle) -- axis-aligned bounding boxes (AABB)
    -- left edge is farther to the right for either
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    -- bottom edge is higher than top edge of either
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    return true
end
