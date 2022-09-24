local push = require 'utils/push'
Class = require 'utils/class'

require 'helpers'
require 'constants'
require 'Paddle'
require 'Ball'

local ball, player1, player2
local gameState, playerSide
local smallFont, bigFont, sounds

function love.load()
    -- set default scaling filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialise the random generator
    math.randomseed(os.time())

    -- intialise font variables
    smallFont = love.graphics.newFont(FONT_PATH, SMALL_FONT_SIZE)
    bigFont = love.graphics.newFont(FONT_PATH, LARGE_FONT_SIZE)

    -- intialise sounds
    sounds = {
        [SOUND_PADDLE_HIT] = love.audio.newSource(SOUND_PADDLE_HIT_PATH, 'static'),
        [SOUND_WALL_HIT] = love.audio.newSource(SOUND_WALL_HIT_PATH, 'static'),
        [SOUND_SCORE] = love.audio.newSource(SOUND_SCORE_PATH, 'static')
    }

    -- setup heading
    love.window.setTitle("Shourya's Pong")

    -- setup the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- initialise the player positions, score, width and height
    player1 = Paddle(PADDLE_PADDING_X, PADDLE_PADDING_Y, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - PADDLE_PADDING_X - PADDLE_WIDTH, VIRTUAL_HEIGHT - PADDLE_PADDING_Y - PADDLE_HEIGHT,
        PADDLE_WIDTH, PADDLE_HEIGHT)

    -- initialise the ball position (center of screen), width and height
    ball = Ball((VIRTUAL_WIDTH / 2) - (BALL_SIZE / 2), (VIRTUAL_HEIGHT / 2) - (BALL_SIZE / 2), BALL_SIZE, BALL_SIZE)

    -- set the initial game state
    gameState = GAME_STATE_START
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- quit the game
    elseif key == 'enter' or key == 'return' then
        if gameState == GAME_STATE_START or gameState == GAME_STATE_PAUSE then
            gameState = GAME_STATE_PLAY
        elseif gameState == GAME_STATE_PLAY then
            gameState = GAME_STATE_PAUSE
        elseif gameState == GAME_STATE_SERVE then
            gameState = GAME_STATE_PLAY
        elseif gameState == GAME_STATE_WINNER then
            player1:reset()
            player2:reset()
            gameState = GAME_STATE_PLAY
        end
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if gameState == GAME_STATE_SERVE then
        if playerSide == P1 then
            ball.dx = math.abs(ball.dx) -- move towards right
        elseif playerSide == P2 then
            ball.dx = -math.abs(ball.dx) -- move towards left
        end
    end

    -- allow rest of code only if game state is play
    if gameState ~= GAME_STATE_PLAY then
        return
    end

    -- player 1 controls
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED -- move up
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED -- move down
    else
        player1.dy = 0 -- stop if no / different button pressed
    end

    -- player 2 controls
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED -- move up
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED -- move down
    else
        player2.dy = 0 -- stop if no / different button pressed
    end

    -- collision of ball with top and bottom screen => bounce back with same angle and no speed changes
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds[SOUND_WALL_HIT]:play()
    elseif ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
        ball.y = VIRTUAL_HEIGHT - BALL_SIZE
        ball.dy = -ball.dy
        sounds[SOUND_WALL_HIT]:play()
    end

    -- collision of ball with left and right screen => update scores
    if ball.x < 0 then
        player2:incScore()
        playerSide = P1
        gameState = GAME_STATE_SERVE
        ball:reset()
        sounds[SOUND_SCORE]:play()
    elseif ball.x > VIRTUAL_WIDTH then
        player1:incScore()
        playerSide = P2
        gameState = GAME_STATE_SERVE
        ball:reset()
        sounds[SOUND_SCORE]:play()
    end

    if gameState == GAME_STATE_SERVE then -- check for winner
        if player1:won() then
            gameState = GAME_STATE_WINNER
            playerSide = P1
        elseif player2:won() then
            gameState = GAME_STATE_WINNER
            playerSide = P2
        end
        return -- don't update object states after this
    end

    -- handle collisions with players
    if ball:collides(player1) then
        ball.dx = -ball.dx * BALL_SPEED_HIT_INC_X -- reverse and slightly increase
        ball.x = player1.x + PADDLE_WIDTH
        sounds[SOUND_PADDLE_HIT]:play()
        -- reverse the y direction, but random speed
        if ball.dy < 0 then
            ball.dy = -math.random(BALL_SPEED_HIT_MIN_Y, BALL_SPEED_HIT_MAX_Y)
        else
            ball.dy = math.random(BALL_SPEED_HIT_MIN_Y, BALL_SPEED_HIT_MAX_Y)
        end
    elseif ball:collides(player2) then
        ball.dx = -ball.dx * BALL_SPEED_HIT_INC_X -- reverse and slightly increase
        ball.x = player2.x - PADDLE_WIDTH
        sounds[SOUND_PADDLE_HIT]:play()
        -- reverse the y direction, but random speed
        if ball.dy < 0 then
            ball.dy = -math.random(BALL_SPEED_HIT_MIN_Y, BALL_SPEED_HIT_MAX_Y)
        else
            ball.dy = math.random(BALL_SPEED_HIT_MIN_Y, BALL_SPEED_HIT_MAX_Y)
        end
    end

    -- update states of objects
    ball:update(dt)
    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:apply('start')

    -- set black background
    love.graphics.clear(0, 0, 0, 1)

    -- render dotted line in middle
    DrawVerticalDottedLine(VIRTUAL_WIDTH / 2, 0, VIRTUAL_HEIGHT, DOTTED_WIDTH, DOTTED_HEIGHT, DOTTED_INTERVAL)

    -- render components
    player1:render()
    player2:render()
    ball:render()

    -- render message
    ShowMessage(smallFont, gameState, playerSide)

    -- render score on screen
    love.graphics.setFont(bigFont)
    RenderScore(player1, player2, gameState, playerSide)

    push:apply('end')
end
