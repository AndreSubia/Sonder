local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local w = Class:derive("wood")

local obstacle

function w:new()
    if obstacle == nil then
        obstacle = love.graphics.newImage("Sprite/wood.png")
    end

    self.spr = Sprite(obstacle,45,36,800,468)
end 
function w:update(dt)
    self.spr:update(dt) 
end

function w:draw()
    self.spr:draw()
end

return w