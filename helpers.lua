-- function to show fps on top right of screen
function ShowFPS(font)
    love.graphics.setFont(font)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf(tostring(love.timer.getFPS()).." fps", 0, 20, VIRTUAL_WIDTH-20, 'right')
end

-- function to draw vertical dotted line
-- takes fixed x coordinate, top and bottom coordinates y1, y2
-- width, height and interval gap between dotted lines
function DrawVerticalDottedLine(x, y1, y2, width, height, interval)
    for y = y1, y2, height+interval do
        love.graphics.rectangle('fill', x - (width / 2), y - (height / 2), width, height)
    end
end