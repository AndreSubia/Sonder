local Scene = require("lib.scene")
local ep = require("Advice.allep")
local MM    = Scene:derive("main_manu")
local img   = love.graphics.newImage("Map/sonder.png")

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
    love.graphics.print({{0,1,1,1},"GAME OVER"}, love.graphics.getWidth()/2 +30 , love.graphics.getHeight()-325,0,2,2)
    love.graphics.print({{0,1,1,1},"Press 'ENTER'to CONTINUE"}, love.graphics.getWidth()/2 +30 , love.graphics.getHeight()-225,0,2,2)
    love.graphics.print({{0,1,1,1},"Press 'ESCAPE'to EXIT"}, love.graphics.getWidth()/2 +30 , love.graphics.getHeight()-275,0,2,2)
end

return MM
