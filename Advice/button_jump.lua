local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("buttons")

local button
local message

local idle = Anim(0,0,206,52,13,13,1.8)

function T:new()
    if button == nil then
        button = love.graphics.newImage("Advice/button_jump.png")       
    end
    self.spr = Sprite(button,206,52,1200,300)
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