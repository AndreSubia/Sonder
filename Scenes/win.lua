local Scene = require("lib.scene")

local MM    = Scene:derive("win")
local img   = love.graphics.newImage("Map/Sr_gato_y_su_pandilla.jpg")

function MM:draw()
    love.graphics.draw(img,180,65,0,0.5,0.5)
end

return MM
