--libs
local Scene  = require("lib.scene")
local Player = require("../player")

local Bat  = require("../bat")
--
local Thorn  = require("../thorn")

local Apple  = require("../apple")
local Apple1 = require("../apple1")

local Fish   = require("../fish")
local Bunny  = require("../bunny")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local Vector2 = require("lib.vector2")

local health = require("../global")

require("lib.camera")
--Scene
local T      = Scene:derive("level_3")
local Map_test
local Sonder
local s_pos
--local fox_sprite

level_3_c = false

--health = 20

function T:new(scene_mngr)
    camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    self.p = Player()
    self.em:add(self.p)

    self.e = Bat()
    self.e.spr.pos.y = 450
    self.em:add(self.e)

    self.e1 = Bat()
    self.e1.spr.pos.x = 700
    self.e1.spr.pos.y = 400
    self.e1.distance = self.e1.distance * 2
    self.em:add(self.e1)

    self.e2 = Bat()
    self.e2.spr.pos.x = 650
    self.e2.spr.pos.y = 450
    self.e2.vel = 200
    self.e2.distance = self.e2.distance * 3
    self.em:add(self.e2)
    
    self.a = Apple()
    self.em:add(self.a)
    self.a1= Apple1()
    self.em:add(self.a1)
    self.a2= Apple1()
    self.a2.spr.pos.x = 780
    self.em:add(self.a2)
    self.a3= Apple1()
    self.a3.spr.pos.x = 1200
    self.em:add(self.a3)
    
    --[[self.f = Fish()
    self.em:add(self.f)
]]
    self.bn = Bunny()
    self.em:add(self.bn)

    self.t = Thorn()
    self.em:add(self.t)
    self.t1 = Thorn()
    self.t1.spr.pos.x = 750
    self.em:add(self.t1)
    self.t2 = Thorn()
    self.t2.spr.pos.x = 950
    self.em:add(self.t2)
    self.t3 = Thorn()
    self.t3.spr.pos.x = 1300
    self.em:add(self.t3)
    self.t4 = Thorn()
    self.t4.spr.pos.x = 1600
    self.em:add(self.t4)

    self.bar = Bar("health",125,35,200, 20,"")
    self.em:add(self.bar)
    self.bar_changed = function(bar, value)
    self:on_bar_changed(bar, value) end
    
    self.bar_run = Bar("run",125,35,200, 20,"")
    self.em:add(self.bar_run)
    self.bar_changed_ = function(bar_run, value)
    self:on_bar_changed(bar_run, value) end
    self.bar_run.percentage = 100
    self.bar_run:set(self.bar_run.percentage)
    self.bar_run.pos.y = 65
    self.bar_run.fill_color = U.color(0.6,0.8,1,1)


    Map_test  = love.graphics.newImage("Map/myforest.png")
    Map_test2 = love.graphics.newImage("Map/myforest2.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")

    snd1 = love.audio.newSource("Sound/Snowfall.ogg","stream")
    snd1:setLooping(true)
end

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

local it = false

function T:update(dt)    
    if pause == false then
        self.super.update(self,dt)
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/3.5), self.p.fox_sprite.pos.y - (love.graphics.getHeight()))
        love.audio.play(snd1)
        self.bar.pos.x = 180 + camera.x
        self.bar_run.pos.x = 180 + camera.x
        s_pos = 5 + camera.x
        --
        if (it == false) then
            self.bar:set(health.get())
            self.bar.text = health.get().."%"
            it = true
        end
        --eat
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

        if self.p.fox_sprite.current_anim == "bite" then
            if self.a.remove == nil and self.a and U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10),self.a.spr:rect() ) then
                self.bar:set(self.bar.percentage - 15)
                self.a.remove = true
            elseif self.a1.remove == nil and self.a1 and U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.a1.spr:rect() ) then
                self.bar:set(self.bar.percentage + 10)
                self.a1.remove = true
            elseif self.a2.remove == nil and self.a2 and U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.a2.spr:rect() ) then
                self.bar:set(self.bar.percentage + 10)
                self.a2.remove = true
            elseif self.a3.remove == nil and self.a3 and U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.a3.spr:rect() ) then
                self.bar:set(self.bar.percentage + 10)
                self.a3.remove = true
            end
            
        end
        
        --enemies

        if  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
            self.t.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t1.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
            self.t1.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t2.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
            self.t2.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t3.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
            self.t3.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t4.spr:rect()) then
            self.bar:set(self.bar.percentage - 1)
            self.t4.spr:animation("on_idle")
        end
        
    
        local r1 = self.p.fox_sprite:rect_(0,0,-60,-10)
        local r2 = self.e.spr:rect()
        local r3 = self.e1.spr:rect()
        local r4 = self.e2.spr:rect()
        
        if U.AABBColl(r1, r2) then
            self.p.fox_sprite.tintColor = U.color(1,0,0,1)

            local md = r2:minowski_diff(r1)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
            
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 
        
            self.bar:set(self.bar.percentage - 1)

        elseif U.AABBColl(r1, r3) then
            self.p.fox_sprite.tintColor = U.color(1,0,0,1)

            local md = r3:minowski_diff(r1)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 

            self.bar:set(self.bar.percentage - 1)

        elseif U.AABBColl(r1, r4) then
            self.p.fox_sprite.tintColor = U.color(1,0,0,1)

            local md = r4:minowski_diff(r1)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 
            
            self.bar:set(self.bar.percentage - 2)
        end

        --bunny
        if U.AABBColl(r1,self.bn:rect_(0,0,250,100)) then
            self.bn.vel = 300
        else
            self.bn.vel = 50
        end

        if self.bn.spr.pos.x >= (2718) then
            self.bn.remove = true
        end
        --
        if (self.bar.percentage <= 0 or (self.bn.spr.pos.x - self.p.fox_sprite.pos.x) >= 800 ) then
            --love.event.quit()
            self.bar:set(health.get())
            self.bar.text = health.get().."%"
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            if self.bn.remove ~= nil then
                self.em:add(self.bn)
                self.bn.remove = nil
            end
            self.bn.spr.pos.x = 400
            self.bn.spr.pos.y = 470
            self.e.spr.pos.x = 500
            self.e.spr.pos.y = 450
            self.e1.spr.pos.x = 700
            self.e1.spr.pos.y = 400
            self.e2.spr.pos.x = 650
            self.e2.spr.pos.y = 450
            self.e.vx = 1
            self.e1.vx = 1
            self.e2.vx = 1
            it = false
            love.audio.stop(snd1)
            game_over = true
        end

        if (self.p.fox_sprite.pos.x >= 2720) then
            health.val(self.bar.percentage)
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            if self.bn.remove ~= nil then
                self.em:add(self.bn)
                self.bn.remove = nil
            end
            self.bn.spr.pos.x = 400
            self.bn.spr.pos.y = 470
            self.e.spr.pos.x = 500
            self.e.spr.pos.y = 450
            self.e.vx = 1
            self.e1.vx = 1
            self.e2.vx = 1
            self.e1.spr.pos.x = 700
            self.e1.spr.pos.y = 400
            self.e2.spr.pos.x = 650
            self.e2.spr.pos.y = 450
            it = false
            love.audio.stop(snd1)
            level_3_c = true
            
        end
    end
    if pause == true then
        love.audio.pause(snd1)
    end
end

function T:draw()
    camera:set()
    love.graphics.clear(0.34,0.38,1)
    love.graphics.draw(Map_test,0,0)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test2,1920,0)
    love.graphics.draw(Map_test,2880,0)
    self.super.draw(self)   
    
    love.graphics.draw(Sonder,s_pos,15)
    camera:unset()

end


return T