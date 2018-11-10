local Class = require("lib.class")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local m_bat = Class:derive("message_bat")

local mss_b
function m_bat:new()
    if mss_b == nil then
        mss_b = love.graphics.newImage("Advice/aviso_bat2.png")
    end
    --self.spr = Sprite(mss_b,156,166,300,300)
    self.spr = Sprite(mss_b,182,165,2880,300)
end 
function m_bat:update(dt)
    self.spr:update(dt) 
end

function m_bat:draw()
    self.spr:draw()
end

return m_bat