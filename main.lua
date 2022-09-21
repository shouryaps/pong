local push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

local ball, player1, player2, gameState

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    
    SmallFont = love.graphics.newFont('retro.ttf', 8)
    BigFont = love.graphics.newFont('retro.ttf', 20)

    love.graphics.setFont(SmallFont)
    love.window.setTitle("Shourya's Pong")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    Player1Score = 0
    Player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

function love.update(dt)

    -- collision with top and bottom screen => bounce back with same angle and speed
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    elseif ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
    end

    -- collision with left and right screen => update scores
    if ball.x < 0 then
        Player2Score = Player2Score + 1
        ball:reset()
    elseif ball.x > VIRTUAL_WIDTH then
        Player1Score = Player1Score + 1
        ball:reset()
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        -- collision with players
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03 -- reverse and slightly increase
            ball.x = player1.x + 5
            -- randomise the y direction, but random
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        elseif ball:collides(player2) then
            ball.dx = -ball.dx * 1.03 -- reverse and slightly increase
            ball.x = player2.x - 4
            -- randomise the y direction, but random
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

       ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

local function showFPS()
    love.graphics.setFont(SmallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf(tostring(love.timer.getFPS()).." fps", 0, 20, VIRTUAL_WIDTH-20, 'right')
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    love.graphics.printf("PONG", 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(BigFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH/2+35, VIRTUAL_HEIGHT/3)

    player1:render()
    player2:render()

    ball:render()

    -- print fps
    showFPS()
   

    push:apply('end')
end