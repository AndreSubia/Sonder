local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local F = Class:derive("fish2")

local fish

local idle = Anim(0,0,42,23,3,3,6)
--bul = true si queres que el pescado salte 
--h   = altura que saltara
--bul2  = true si quieres que se mueva horizontalmente
--d_b  = desde donde quieres que empiece a moverse 
-- d_e = hasta donde quieres que se mueva , luego de llegar a este punto regresara al punto inicial (d_b)
function F:new(bul,h,bul2,d_b,d_e)
    if fish == nil then
        fish = love.graphics.newImage("Sprite/fish2.png")
    end
    self.spr = Sprite(fish,42,23,300,480)
    self.spr:add_animations({idle = idle})
    self.spr:animation("idle")
    self.anim_sm = StateMachine(self, "idle")
    self.jump = bul or false
    self.h = h or 0
    self.vx = 1
    self.move = bul2 or false 
    self.d_b  = d_b or self.spr.pos.x
    self.d_e  = d_e or self.spr.pos.y
    --velocidad del pez
    self.vel  = 100


    self.y_vel = 0
    self.y_gravity = 1000
    self.var = true
end

function F:idle_enter(dt)
    self.spr:animation("idle")
end

function F:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt)     
    
    if self.var == true then
        self.y_before_jump = self.spr.pos.y
        self.y_vel = self.h -- max hight jump
        self.var = false
    end

    --Pez Saltando
    if self.jump == true then
        self.y_vel = self.y_vel + self.y_gravity * dt
        self.spr.pos.y = self.spr.pos.y + self.y_vel * dt
        if self.spr.pos.y >= self.y_before_jump then    
            self.spr.pos.y = self.y_before_jump
            self.y_before_jump = nil
            self.var = true
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