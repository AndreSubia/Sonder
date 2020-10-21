local Scene = require("lib.scene")
local ep = require("Advice.allep")
local MM    = Scene:derive("message3")
local img   = love.graphics.newImage("Advice/invierno3.png")

local time3 = 0 
message3_c = false


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
    time3 = time3 + dt
    if ( time3 > 10 ) then
        message3_c = true
        time3 = 0
    end
    --self.ep_.spr:animation("ep4")
end

function MM:draw()
    love.graphics.draw(img,0,0)
    --love.graphics.setColor(1, 0, 0,1)
end

return MM
