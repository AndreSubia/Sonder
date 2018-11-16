local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local w = Class:derive("grape")

local fruit

function w:new()
    if fruit == nil then
        fruit = love.graphics.newImage("Sprite/uva.png")
    end

    self.spr = Sprite(fruit,14,22,870,450)
end 
function w:update(dt)
    self.spr:update(dt) 
end

function w:draw()
    self.spr:draw()
end

return w