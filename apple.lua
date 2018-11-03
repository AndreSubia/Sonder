local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local A = Class:derive("apple")

local apple

local idle = Anim(0,0,24,24,15,15,8)

function A:new()
    if apple == nil then
        apple = love.graphics.newImage("Sprite/apple2.png")
    end
    self.spr = Sprite(apple,24,24,200,470,1.3,1.3)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
end

function A:idle_enter(dt)
    self.spr:animation("idle")
end

function A:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function A:draw()
    self.spr:draw()
end

return A