local Class = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local rock2 = Class:derive("rock4")

local enemy

local idle = Anim(0,0,48,32,1,1,1)
local on_idle = Anim(48,0,48,32,1,1,1)

function rock2:new()
    if enemy == nil then
        enemy = love.graphics.newImage("Sprite/rock4.png")
    end

    self.spr = Sprite(enemy,48,32,600,470,1.1,1.1)
    self.spr:add_animations({idle = idle, on_idle = on_idle})
    self.spr:animation("idle")
    self.vx = 1

    self.anim_sm = StateMachine(self, "idle")
end 

function rock2:idle_enter(dt)
    self.spr:animation("idle")
end

function rock2:on_idle_enter(dt)
    self.self:animation("on_idle")
end

function rock2:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function rock2:draw()
    self.spr:draw()
end

return rock2