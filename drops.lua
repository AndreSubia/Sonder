local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local G = Class:derive("drops")

local gota

local idle = Anim(0,0,960,540,23,1,1)

function G:new()
    if gota == nil then
        gota = love.graphics.newImage("Map/gotas.png")
    end
    self.spr = Sprite(gota,23,23,0,0,1.5,1.5)
    --self.spr = Sprite(gotas,23,23,22080,540,1.5,1.5)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
end

function G:idle_enter(dt)
    self.spr:animation("idle")
end

function G:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function G:draw()
    self.spr:draw()
end

return G