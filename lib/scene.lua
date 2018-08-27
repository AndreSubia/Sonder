local class = require("lib.class")
local EM    = require("lib.entity_mngr")

local Scene = class:derive("scene")

function Scene:new(scene_mngr)
    self.scene_mngr = scene_mngr
    self.em = EM()
end

function Scene:enter() self.em:on_enter() 
end

function Scene:exit() self.em:on_exit() 
end

function Scene:update(dt) self.em:update(dt) 
end

function Scene:draw() self.em:draw() 
end

function Scene:destroy() 
end

return Scene