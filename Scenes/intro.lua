local Scene  = require("lib.scene")
local ep = require("Advice.allep")

require("lib.camera")

local Map_test
local T      = Scene:derive("level_1")
local s_pos

game_over = false
level_1_c = false

function T:new(scene_mngr)
    --camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    self.ep_ = ep()
    self.em:add(self.ep_)
end


--Keep this
local entered = false
function T:enter()
    T.super.enter(self)
end
function T:exit()
    T.super.exit(self)
end

--Update
function T:update(dt)    
    self.super.update(self,dt) 
end

function T:draw()
    self.super.draw(self)
end

return T