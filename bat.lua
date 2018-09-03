local Class = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim = require("lib.animations")
local Sprite = require("lib.sprite")

local E = Class:derive("enemy")

local enemy

local idle = Anim(0,0,32,32,5,5,9)

function E:new()
    if enemy == nil then
        enemy = love.graphics.newImage("Sprite/enemy.png")
    end

    self.spr = Sprite(enemy,32,32,500,300,1,1)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.vx = 1
    self.vel = 110
    self.anim_sm = StateMachine(self, "idle")
    self.distance = love.graphics.getWidth()
    self.distance_init = 0
end 

function E:idle_enter(dt)
    self.spr:animation("idle")
end

function E:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 

    if self.spr.pos.x >= self.distance then
        self.vx = -1
    elseif self.spr.pos.x < self.distance_init then
        self.vx = 1        
    end

    if(self.vx == 1) then
        self.spr:flip_h(false)
    else
        self.spr:flip_h(true)
    end

    self.spr.pos.x = self.spr.pos.x + self.vx * self.vel * dt
end

function E:draw()
    self.spr:draw()
end

return E