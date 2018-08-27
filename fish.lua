local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local F = Class:derive("fish")

local fish

local idle = Anim(0,0,42,23,3,3,6)

function F:new()
    if fish == nil then
        fish = love.graphics.newImage("Sprite/fish.png")
    end
    self.spr = Sprite(fish,42,23,300,480)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
end

function F:idle_enter(dt)
    self.spr:animation("idle")
end

function F:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function F:draw()
    self.spr:draw()
end

return F