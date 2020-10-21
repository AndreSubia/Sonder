local Class = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local rock3 = Class:derive("rock3")

local enemy

local idle = Anim(0,0,247,165,1,1,1)

function rock3:new()
    if enemy == nil then
        enemy = love.graphics.newImage("Sprite/rock3.png")
    end

    self.spr = Sprite(enemy,247,165,300,470,1.3,1.3)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.vx = 1

    self.anim_sm = StateMachine(self, "idle")
end 

function rock3:idle_enter(dt)
    self.spr:animation("idle")
end

function rock3:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
end

function rock3:draw()
    self.spr:draw()
end

return rock3