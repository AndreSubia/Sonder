local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local F = Class:derive("fish")

local fish

local idle = Anim(0,0,42,23,3,3,6)
--bul = true si queres que el pescado salte 
--h   = altura que saltara
--bul2  = true si quieres que se mueva horizontalmente
--d_b  = desde donde quieres que empiece a moverse 
-- d_e = hasta donde quieres que se mueva , luego de llegar a este punto regresara al punto inicial (d_b)
function F:new(bul,h,bul2,d_b,d_e)
    if fish == nil then
        fish = love.graphics.newImage("Sprite/fish.png")
    end
    self.spr = Sprite(fish,42,23,300,480)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
    self.jump = bul or false
    self.h = h or 0
    self.vx = 1
    self.move = bul2 or false 
    self.d_b  = d_b or 0
    self.d_e  = d_e or 0 
    --velocidad del pez
    self.vel  = 100
end

function F:idle_enter(dt)
    self.spr:animation("idle")
end

local y_vel = 0
local y_gravity = 1000
local var = true

function F:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt)     
    
    if var == true then
        y_before_jump = self.spr.pos.y
        y_vel = self.h -- max hight jump
        var = false
    end

    --Pez Saltando
    if self.jump == true then
        y_vel = y_vel + y_gravity * dt
        self.spr.pos.y = self.spr.pos.y + y_vel * dt
        if self.spr.pos.y >= y_before_jump then    
            self.spr.pos.y = y_before_jump
            y_before_jump = nil
            var = true
        end
    end

    --Pez Moviendose
    if self.move == true then
        if self.spr.pos.x >= self.d_e then
            self.vx = -1
        elseif self.spr.pos.x < self.d_b then
            self.vx = 1        
        end

        self.spr.pos.x = self.spr.pos.x + self.vx * self.vel * dt
    end

end

function F:draw()
    self.spr:draw()
end

return F