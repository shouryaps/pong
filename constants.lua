-- 720p
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- fixed resolution for ease
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- font details
FONT_PATH = 'resources/bit5x3.ttf'
SMALL_FONT_SIZE = 8
LARGE_FONT_SIZE = 20

-- game states
GAME_STATE_START = 0
GAME_STATE_PLAY = 1
GAME_STATE_PAUSE = 2
GAME_STATE_SERVE = 3
GAME_STATE_WINNER = 4

-- dotted line property
DOTTED_WIDTH = 1
DOTTED_HEIGHT = 3
DOTTED_INTERVAL = 5

-- paddle width and height
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

-- width and height of ball (square)
BALL_SIZE = 4

-- paddle padding for initial position, horizontal and vertical
PADDLE_PADDING_X = 10
PADDLE_PADDING_Y = 30

-- speeds
PADDLE_SPEED = 220 -- paddle speed with which paddle moves using controls in Y axis
BALL_SPEED_INIT_MAX_X = 120 -- initial max value of x speed when game starts
BALL_SPEED_INIT_MAX_Y = 80 -- intial max value of y speed when game starts
BALL_SPEED_HIT_MIN_Y = 30 -- post collision y speed
BALL_SPEED_HIT_MAX_Y = 150 -- post collision y speed

-- increaments
BALL_SPEED_HIT_INC_X = 1.03 -- 1.03 indicates 3% increase in reverse x direction speed, if ball hits paddle

-- scoring
SCORE_INCREAMENT = 1

-- player constants
P1 = 1
P2 = 2

-- winner
WINNER_SCORE = 10
