local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")
local Rect         = require("lib.rect")
local B = Class:derive("bunny")

local bunny

--local idle = Anim(0,0,42,23,3,3,6)
local idle = Anim(0,0,36,31,4,4,8)

function B:new()
    if bunny == nil then
        bunny = love.graphics.newImage("Sprite/bunny.png")
    end
    self.spr = Sprite(bunny,36,31,400,470)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.vx = 1
    self.anim_sm = StateMachine(self, "idle")
    self.vel = 50
end

function B:idle_enter(dt)
    self.spr:animation("run")
end

function B:rect_(x_,y_,w_,h_)
    return Rect.create_centered(self.spr.pos.x+x_,self.spr.pos.y+y_,(self.spr.w+w_)*self.spr.scale.x,(self.spr.h+h_)*self.spr.scale.y)
end

function B:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt) 

   --[[ if self.spr.pos.x >= (love.graphics.getWidth())*3 then
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

function B:reboot()
    
end

return B