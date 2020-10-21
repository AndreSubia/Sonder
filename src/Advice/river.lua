local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("river")

local ep

local ep1 = Anim(0,0,960,540,3,3,10)

function T:new()
    if ep == nil then
        ep = love.graphics.newImage("Sprite/myforest3.png")
    end
    self.spr = Sprite(ep,960,540,3360,270)
    self.spr:add_animations({ep1 = ep1})
    self.spr:animation("ep1")
    self.anim_sm = StateMachine(self, "ep1")
end

function T:idle_enter(dt)
    self.spr:animation("ep1")
end

function T:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt)
end

function T:draw()
    self.spr:draw()
end

return T