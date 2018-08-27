local Scene = require("lib.scene")

local MM    = Scene:derive("main_manu")
local img   = love.graphics.newImage("Map/sonder.png")

function MM:draw()
    love.graphics.draw(img,0,0)
    --love.graphics.setColor(1, 0, 0,1)
    love.graphics.print({{0,1,1,1},"Presiona 'ENTER' para JUGAR"}, love.graphics.getWidth()/2 -30 , love.graphics.getHeight()-325,0,2,2)
    love.graphics.print({{0,1,1,1},"Presiona 'ESCAPE' para SALIR"}, love.graphics.getWidth()/2 -30, love.graphics.getHeight()-275,0,2,2)
end

return MM
