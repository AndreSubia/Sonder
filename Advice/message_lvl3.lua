local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local m = Class:derive("message_lvl3")

local mss
function m:new()
    if mss == nil then
        mss = love.graphics.newImage("Advice/aviso_largo.png")
    end

    self.spr = Sprite(mss,198,166,300,200)
end 
function m:update(dt)
    self.spr:update(dt) 
end

function m:draw()
    self.spr:draw()
end

return m