local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local m = Class:derive("message")

local mss
function m:new()
    if mss == nil then
        mss = love.graphics.newImage("Advice/aviso_bat.png")
    end

    self.spr = Sprite(mss,132,166,2100,300)
end 
function m:update(dt)
    self.spr:update(dt) 
end

function m:draw()
    self.spr:draw()
end

return m