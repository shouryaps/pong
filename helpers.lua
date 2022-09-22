-- function to draw vertical dotted line
-- takes fixed x coordinate, top and bottom coordinates y1, y2
-- width, height and interval gap between dotted lines
function DrawVerticalDottedLine(x, y1, y2, width, height, interval)
    for y = y1, y2, height + interval do
        love.graphics.rectangle('fill', x - (width / 2), y - (height / 2), width, height)
    end
end

-- function to show message on top right
function ShowMessage(font, state, serveSide)
    love.graphics.setFont(font)
    if state == GAME_STATE_START then
        love.graphics.setColor(0, 1, 0, 1) -- green color
        love.graphics.printf("Enter: Start  P1: W,S  P2: Up,Down", 0, 20, VIRTUAL_WIDTH - 20, 'right')
    elseif state == GAME_STATE_PAUSE then
        love.graphics.setColor(1, 1, 0, 1) -- yellow color
        love.graphics.printf("Paused, Press Enter to resume", 0, 20, VIRTUAL_WIDTH - 20, 'right')
    elseif state == GAME_STATE_SERVE then
        love.graphics.setColor(0, 1, 0, 1) -- green color
        local message = "+" .. tostring(SCORE_INCREAMENT) .. " for P2, press Enter to serve from P1"
        if serveSide == P2 then
            message = "+" .. tostring(SCORE_INCREAMENT) .. " for P1, press Enter to serve from P2"
        end
        love.graphics.printf(message, 0, 20, VIRTUAL_WIDTH - 20, 'right')
    end

end
