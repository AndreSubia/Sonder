local Scene = require("lib.scene")
local ep = require("Advice.allep")
local MM    = Scene:derive("message1")
local img   = love.graphics.newImage("Advice/invierno.png")

function MM:new(scene_mngr) 
    self.super.new(self,scene_mngr)
    self.ep_ = ep()
    self.em:add(self.ep_)
end

local entered = false
function MM:enter()
    MM.super.enter(self)
end
function MM:exit()
    MM.super.exit(self)
end

function MM:update(dt)
    self.super.update(self,dt)
    --self.ep_.spr:animation("ep4")
end

function MM:draw()
    love.graphics.draw(img,0,0)
    --love.graphics.setColor(1, 0, 0,1)
end

return MM
