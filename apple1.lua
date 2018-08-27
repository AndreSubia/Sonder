local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local A = Class:derive("apple")

local apple

local idle = Anim(0,0,19,19,1,1,1)

function A:new()
    if apple == nil then
        apple = love.graphics.newImage("Sprite/apple.png")
    end
    self.spr = Sprite(apple,19,19,400,470)
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