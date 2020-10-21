local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")
local Rect         = require("lib.rect")
local B = Class:derive("bear")

local bear
local idle = Anim(0,0,209,108,8,8,16)
local attack = Anim(0,108,209,108,8,8,20)
local sleep = Anim(0,216,209,108,6,6,12)
 -- w=208
 -- h=108

function B:new()
    if bear == nil then 
        bear = love.graphics.newImage("Sprite/bear.png")
    end
    self.spr = Sprite(bear,208,108,100,430,1.2,1.2)
    self.spr:add_animations({idle = idle, attack = attack,sleep = sleep})
    self.spr:animation("idle")
    self.vx = 1
    self.anim_sm = StateMachine(self, "idle")
    self.vel = 170
end
    

function B:idle_enter(dt)
    self.spr:animation("run")
end

function B:attack_enter(dt)
    self.spr:animation("attack")
end

function B:sleep_enter(dt)
    self.spr:animation("sleep")
end

function B:rect_(x_,y_,w_,h_)
    return Rect.create_centered(self.spr.pos.x+x_,self.spr.pos.y+y_,(self.spr.w+w_)*self.spr.scale.x,(self.spr.h+h_)*self.spr.scale.y)
end

function B:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 
    --[[if self.spr.pos.x >= (love.graphics.getWidth())*3 then
        self.spr:flip_h(true)
        self.vx = -1
    elseif self.spr.pos.x < 0 then
        self.spr:flip_h(false)
        self.vx = 1        
    end]]--
    self.spr.pos.x = self.spr.pos.x + self.vx * self.vel * dt
end

function B:draw()
    --local r1= self:rect_(0,0,250,10)
    --love.graphics.rectangle("line",r1.x,r1.y,r1.w,r1.h)
    self.spr:draw()
end

return B