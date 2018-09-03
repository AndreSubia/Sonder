local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("river_f")

local ep

local ep1 = Anim(0,0,960,540,4,4,20)

function T:new()
    if ep == nil then
        ep = love.graphics.newImage("Map/fell.png")
    end
    self.spr = Sprite(ep,960,540,0,0)
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