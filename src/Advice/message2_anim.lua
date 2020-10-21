local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("allep")

local ep
intro_c = false

local ep1 = Anim(0,0,960,540,22,1,1)

local time = 0

function T:new()
    if ep == nil then
        ep = love.graphics.newImage("Advice/message2.png")
    end
    self.spr = Sprite(ep,120,60,480,270,8,8)
    self.spr:add_animations({ep1 = ep1,ep2 = ep2,ep3 = ep3,ep4 = ep4})
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
    
    if time <= 3 then
        love.graphics.draw(message1,0,0)
    else
    
        self.spr:draw()
    end
end

return T