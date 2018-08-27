local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("buttons")

local button

local idle = Anim(0,0,142,52,15,15,1.5)

function T:new()
    if button == nil then
        button = love.graphics.newImage("Advice/button_run.png")
    end
    self.spr = Sprite(button,142,52,1800,300)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
end

function T:idle_enter(dt)
    self.spr:animation("idle")
end

function T:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function T:draw()
    self.spr:draw()
end

return T