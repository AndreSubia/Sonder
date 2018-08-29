local Scene  = require("lib.scene")
local Player = require("../player")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local bat    = require("../bat")
local apple  = require("../apple1")
local apple1 = require("../apple")
local Thorn  = require("../thorn")
local health = require("../global")
local Vector2 = require("lib.vector2")
local Anim   = require("lib.animations")
local Sprite = require("lib.sprite")
local button = require("Advice.buttons")
local button_J = require("Advice.button_jump")
local button_R = require("Advice.button_run")
local button_E = require("Advice.button_eat")
local mess = require("Advice.message")

require("lib.camera")

local Map_test
local T      = Scene:derive("level_1")
local s_pos

game_over = false
level_1_c = false

function T:new(scene_mngr)

    camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    --Add Sonder
    self.p = Player()
    self.em:add(self.p)
    --Add Enemies
    self.b = bat() --create bat
    self.b.spr.pos.y = 450
    self.b.spr.pos.x = 1930
    self.b.distance_init = 1920
    self.b.distance = 2880
    self.em:add(self.b) --add bat to scene
    --
    self.t = Thorn()
    self.t.spr.pos.x = 1500
    self.em:add(self.t)
    --
   
    self.a = apple()
    self.a.spr.pos.x = 1350
    self.em:add(self.a)
    
    self.a1 = apple1()
    self.a1.spr.pos.x = 550
    self.em:add(self.a1)

    self.a3 = apple()
    self.a3.spr.pos.x = 2650
    self.em:add(self.a3)
    --Add health bar
    self.bar = Bar("health",125,35,200, 20, "20%")
    self.em:add(self.bar)
    self.bar_changed = function(bar, value)
    self:on_bar_changed(bar, value) end
    self.bar.percentage = 20 
    self.bar:set(self.bar.percentage)
    --Add background
   -- Map_test = love.graphics.newImage("Map/fondo2.png")
    self.bar_run = Bar("run",125,35,200, 20,"")
    self.em:add(self.bar_run)
    self.bar_changed_ = function(bar_run, value)
    self:on_bar_changed(bar_run, value) end
    self.bar_run.percentage = 100
    self.bar_run:set(self.bar_run.percentage)
    self.bar_run.pos.y = 65
    self.bar_run.fill_color = U.color(0.6,0.8,1,1)

    Map_test = love.graphics.newImage("Map/fondo2.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")

end


--Keep this
local entered = false
function T:enter()
    T.super.enter(self)
    _G.events:hook("onBarChanged", self.bar_changed)
end
function T:exit()
    T.super.exit(self)
    _G.events:unhook("onBarChanged", self.bar_changed)
end

function T:on_bar_changed(bar,value)
    bar.text = tostring(value .. "%")
    if value < 20 then
        bar.fill_color = U.color(1,0,0,1)
    elseif value > 19 and value < 50 then
        bar.fill_color = U.color(1,1,0,1)
    elseif value > 49 then
        bar.fill_color = U.color(0,1,0,1)
    end
end
--Update
function T:update(dt)    
    if pause == false then
    --keep this
        self.super.update(self,dt)
        --health bar & Sonder icon
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/3.5), self.p.fox_sprite.pos.y - (love.graphics.getHeight()))
        self.bar.pos.x = 180 + camera.x
        self.bar_run.pos.x = 180 + camera.x
        s_pos = 5 + camera.x      
        --Run Bar
        if self.p.fox_sprite.current_anim == "run" or self.p.fox_sprite.current_anim == "jump" then
            self.bar_run:set(self.bar_run.percentage - 0.3)
            if self.bar_run.percentage <= 20 then
                self.p.enable = false
                self.bar_run.fill_color = U.color(1,0,0,1)
            else
                self.p.enable = true
                self.bar_run.fill_color = U.color(0.6,0.8,1,1)
            end
        else
            self.bar_run:set(self.bar_run.percentage + 0.7)
        end
        if(self.bar_run.percentage == 100) then
            self.bar_run.fill_color = U.color(0.6,0.8,1,1)
        end
        self.bar_run.text= ""
        --

        --
        local r1 = self.p.fox_sprite:rect_(0,0,-60,-10)
        local r2 = self.b.spr:rect()

        if U.AABBColl(r1, r2) then
            self.p.fox_sprite.tintColor = U.color(1,0,0,1)

            local md = r2:minowski_diff(r1)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
            
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 
        
            self.bar:set(self.bar.percentage - 1)
        end

        --
        if U.AABBColl(r1,self.t.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
        end
        --

        if self.p.fox_sprite.current_anim == "bite" then
            if self.a.remove == nil and self.a and U.AABBColl(r1, self.a.spr:rect() ) then
                self.bar:set(self.bar.percentage + 10)
                self.a.remove = true
            end
            if self.a1.remove == nil and self.a1 and U.AABBColl(r1, self.a1.spr:rect() ) then
                self.bar:set(self.bar.percentage - 15)
                self.a1.remove = true
            end
            if self.a3.remove == nil and self.a3 and U.AABBColl(r1, self.a3.spr:rect() ) then
                self.bar:set(self.bar.percentage + 10)
                self.a3.remove = true
            end
        end

        if (self.bar.percentage <= 0) then
            game_over = true
            if self.a.remove ~= nil then
                self.em:add(self.a)
                self.a.remove = nil
            end
            if self.a1.remove ~= nil then
                self.em:add(self.a1)
                self.a1.remove = nil
            end
            if self.a3.remove ~= nil then
                self.em:add(self.a3)
                self.a3.remove = nil
            end
            self.bar.percentage = 20
            self.bar.text = "20%"
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            
        end

        if (self.p.fox_sprite.pos.x >= (960*3)) then
            self.p.remove = true
            level_1_c = true
            health.val(self.bar.percentage)
        end

        butt:update(dt)
        butt_R:update(dt)
        butt_E:update(dt)
        butt_J:update(dt)
    end
end

local s1 = true
butt = button()
butt_J = button_J()
butt_R = button_R()
butt_E = button_E()

msg = mess()
function T:draw()
    camera:set()
    love.graphics.draw(Map_test,0,0)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test,1920,0)
    love.graphics.draw(Map_test,2880,0)

    if self.p.fox_sprite.pos.x >= 0 and self.p.fox_sprite.pos.x <= 650 and s1 == true then
        butt:draw()
    end
    if self.p.fox_sprite.pos.x >= 500 and self.p.fox_sprite.pos.x <=1000  then
        butt_E:draw()
    end
    if self.p.fox_sprite.pos.x >= 900 and self.p.fox_sprite.pos.x <=1500  then
        butt_J:draw()
    end
    if self.p.fox_sprite.pos.x >= 1200 and self.p.fox_sprite.pos.x <=1800  then
        msg:draw()
    end
    if self.p.fox_sprite.pos.x >= 1500 and self.p.fox_sprite.pos.x <=2500  then
        butt_R:draw()
    end

    self.super.draw(self)
    love.graphics.draw(Sonder,s_pos,15)
    
    

    camera:unset()

end

return T