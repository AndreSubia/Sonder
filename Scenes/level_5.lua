
local Scene  = require("lib.scene")
local Player = require("../player")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local Bear   = require("../bear")
local Vector2 = require("lib.vector2")
local Apple  = require("../apple")
local Apple1 = require("../apple1")
local Wood    = require("../wood")
local health = require("../global")

require("lib.camera")

local Sonder
local s_pos
local sign
local Map_test
local T      = Scene:derive("level_5")


level_5_c = false

camera:setBounds(0,0,2880,540)

function T:new(scene_mngr)
    
    self.super.new(self,scene_mngr)
    --add obstacles
    self.w = Wood()
    self.w.spr.pos.x=1200
    self.em:add(self.w)
    self.w1 = Wood()
    self.w1.spr.pos.x=1620
    self.em:add(self.w1)
    self.w2 = Wood()
    self.w2.spr.pos.x=2300
    self.em:add(self.w2)
    self.w3 = Wood()
    self.w3.spr.pos.x=2550
    self.em:add(self.w3)
    --apples
    self.a = Apple()
    self.em:add(self.a)
    self.a.spr.pos.x = 1700
    self.a1= Apple1()
    self.em:add(self.a1)
    self.a1.spr.pos.x = 1400
    self.a2= Apple1()
    self.a2.spr.pos.x = 1350
    self.em:add(self.a2)
    self.a3= Apple1()
    self.a3.spr.pos.x = 2157
    self.em:add(self.a3)
    --add Player
    self.p = Player()
    self.p.fox_sprite.pos.x= 750
    self.em:add(self.p)
    --add bear
    self.bear= Bear()
    self.em:add(self.bear)
    --bar life
    self.bar = Bar("health",125,35,200, 20, "20%")
    self.em:add(self.bar)
    self.bar_changed = function(bar, value)
    self:on_bar_changed(bar, value) end
    self.bar.percentage = 20 
    self.bar:set(self.bar.percentage)
    
    self.bar_run = Bar("run",125,35,200, 20,"")
    self.em:add(self.bar_run)
    self.bar_changed_ = function(bar_run, value)
    self:on_bar_changed(bar_run, value) end
    self.bar_run.percentage = 100
    self.bar_run:set(self.bar_run.percentage)
    self.bar_run.pos.y = 65
    self.bar_run.fill_color = U.color(0.6,0.8,1,1)
    
    sign     = love.graphics.newImage("Sprite/sign.png")
    Map_test = love.graphics.newImage("Map/myforest.png")
    Map_test3 = love.graphics.newImage("Map/myforest3.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")

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
        self.bar.pos.x = 180 + camera.x
        self.bar_run.pos.x = 180 + camera.x
        s_pos = 5 + camera.x

        if (it == false) then
            self.bar:set(health.get()) --
            self.bar.text = health.get().."%" --
            it = true
        end

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

        local box_sonder = self.p.fox_sprite:rect_(0,0,-60,-10)
        local box_minibear = self.bear.spr:rect()
        local box_bear = self.bear.spr:rect_(0,0,130,50)
        local box_wood = self.w.spr:rect()
        local box_wood_1 = self.w1.spr:rect()
        local box_wood_2 = self.w2.spr:rect_(0,0,18,15)
        local box_wood_3 = self.w3.spr:rect()
        --eat

        if self.p.fox_sprite.current_anim == "bite" then
            if self.a.remove == nil and self.a and U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.a.spr:rect() ) then
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

        if U.AABBColl(box_sonder, box_wood) then
            --self.p.fox_sprite.tintColor = U.color(1,0,0,1)
            local md = box_wood:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 
        elseif U.AABBColl(box_sonder, box_wood_1) then
            --self.p.fox_sprite.tintColor = U.color(1,0,0,1)
            local md = box_wood_1:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y
        elseif U.AABBColl(box_sonder, box_wood_2) then
            --self.p.fox_sprite.tintColor = U.color(1,0,0,1)
            local md = box_wood_2:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y  

        elseif U.AABBColl(box_sonder, box_wood_3) then
            local md = box_wood_3:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
    
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y
        end

        if U.AABBColl(box_minibear,box_wood) then 
            self.w.remove = true
        elseif  U.AABBColl(box_minibear,box_wood_1) then 
            self.w1.remove = true 
        elseif U.AABBColl(box_minibear,box_wood_2) then 
            self.w2.remove = true 
        elseif U.AABBColl(box_minibear,box_wood_3) then
            self.w3.remove = true
        end

        if U.AABBColl(box_sonder,box_bear) then
            --self.p.fox_sprite.tintColor = U.color(1,0,0,1)
            local md = box_bear:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep)) 
            self.bear.vel = 190

        else
            self.bear.vel = 220
        end 
        
        --life
        
        if  U.AABBColl(box_sonder, box_minibear) then
            
            local md = box_minibear:minowski_diff(box_sonder)
            local sep = md:closest_point_on_bounds(Vector2())
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep)) 
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + sep.x 
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y  
            self.bar:set(self.bar.percentage - 1)
        end

        if self.bear.spr.pos.x >= 960*3 then
            self.bear.vel = 0
        end

        if (self.p.fox_sprite.pos.x >= (960*4)) then 
            level_5_c = true
            health.val(self.bar.percentage)    
        end

        if (self.bar.percentage <= 0) then
        
            game_over = true
            self.bar.percentage = health.get()
            self.bar.text = health.get().."%"
            self.p.fox_sprite.pos.x = 750
            self.p.fox_sprite.pos.y = 450
            self.bear.spr.pos.x = 200
            if self.w.remove ~= nil then
                self.em:add(self.w)
                self.w.remove = nil
            end
            if self.w1.remove ~= nil then
                self.em:add(self.w1)
                self.w1.remove = nil
            end
            if self.w2.remove ~= nil then
                self.em:add(self.w2)
                self.w2.remove = nil
            end
            if self.w3.remove ~= nil then
                self.em:add(self.w3)
                self.w3.remove = nil
            end
        end
        
        --bug fixed
        if(self.p.fox_sprite.current_anim ~= "jump" and self.p.fox_sprite.current_anim ~= "bite" and self.p.fox_sprite.pos.y ~= 450 ) then
            self.p.fox_sprite.pos.y = 450
        end
    end
end

function T:draw()
    camera:set()
    love.graphics.draw(Map_test,0,0)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test,1920,0)
    love.graphics.draw(Map_test3,2880,0)
    
    love.graphics.draw(sign,1100,400)
    love.graphics.draw(Sonder,s_pos,15)
    self.super.draw(self)
    
    camera:unset()
end

return T



