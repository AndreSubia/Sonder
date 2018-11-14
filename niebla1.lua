local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local w = Class:derive("niebla1")

local niebla

function w:new()
    if niebla == nil then
        niebla = love.graphics.newImage("Sprite/neblina.png")
    end

    self.spr = Sprite(niebla,1258,59,900,510)
    self.vx = 2
    self.vel = 5
end 
function w:update(dt)
    self.spr:update(dt) 
    self.spr.pos.x = self.spr.pos.x + self.vx * self.vel * dt
end

function w:draw()
    self.spr:draw()
end

return w