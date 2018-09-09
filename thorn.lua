local Class = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local thorn = Class:derive("thorn")

local enemy

local idle = Anim(0,0,48,16,1,1,1)
local on_idle   = Anim(48,0,48,16,1,1,1)

function thorn:new()
    if enemy == nil then
        enemy = love.graphics.newImage("Sprite/thorn.png")
    end

    self.spr = Sprite(enemy,48,16,600,478)
    self.spr:add_animations({idle = idle , on_idle = on_idle})
    self.spr:animation("idle")
    self.vx = 1

    self.anim_sm = StateMachine(self, "idle")
end 

function thorn:idle_enter(dt)
    self.spr:animation("idle")
end

function thorn:on_idle_enter(dt)
    self.spr:animation("on")
end

function thorn:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function thorn:draw()
    self.spr:draw()
end

return thorn