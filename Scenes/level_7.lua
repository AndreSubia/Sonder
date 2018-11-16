--libs
local Scene  = require("lib.scene")
local Player = require("../player")

local Bat  = require("../bat")
--
local Thorn  = require("../thorn")

local Apple  = require("../apple")
local Apple1 = require("../apple1")

local Fish   = require("../fish")
local Fish2   = require("../fish2")
local Bunny  = require("../bunny")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local Vector2 = require("lib.vector2")

local health = require("../global")
local ep = require("Advice.river_f2")

require("lib.camera")
--Scene
local T      = Scene:derive("level_7")
local Map_test
local Sonder
local s_pos
--local fox_sprite

level_7_c = false

--health = 20

function T:new(scene_mngr)
    camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    
    self.ep_ = ep()
    self.ep_.spr.pos.x = 480
    self.ep_.spr.pos.y = 270
    self.em:add(self.ep_)
    
    self.p = Player()
    self.em:add(self.p)

    self.f = Fish(true,-400)
    self.em:add(self.f)
    self.f1 = Fish(true,-400,true,200)
    self.em:add(self.f1)
    self.f2 = Fish(true,-600,true,100,400)
    self.em:add(self.f2)

    self.f3 = Fish(true,-300,true,50,700)
    self.f3.spr.pos.x = 200 
    self.em:add(self.f3)

    self.f4 = Fish2(true,-500,true,500)
    self.em:add(self.f4)

    self.f5 = Fish2(true,-700,true,100)
    self.em:add(self.f5)

    self.bar = Bar("health",125,35,200, 20,"")
    self.em:add(self.bar)
    self.bar_changed = function(bar, value)
    self:on_bar_changed(bar, value) end
    
    self.bar_run = Bar("run",500,35,250, 20,"")
    self.em:add(self.bar_run)
    self.bar_changed_ = function(bar_run, value)
    self:on_bar_changed(bar_run, value) end
    self.bar_run.percentage = 100
    self.bar_run:set(self.bar_run.percentage)
    self.bar_run.pos.y = 65
    self.bar_run.fill_color = U.color(0.6,0.8,1,1)

    Map_test  = love.graphics.newImage("Map/myforest4.png")
    Map_test2 = love.graphics.newImage("Map/myforest4.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")
    winter_bar = love.graphics.newImage("Advice/winter_life_bar_.png")

    snd1 = love.audio.newSource("Sound/Snowfall.ogg","stream")
    snd1:setLooping(true)

    self.fishes = {}
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
local it2 = false




function T:update(dt)    
    if pause == false then
        self.super.update(self,dt)
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/3.5), self.p.fox_sprite.pos.y - (love.graphics.getHeight()))
        love.audio.play(snd1)
        love.audio.play(snd1_)
        self.bar.pos.x = 180 + camera.x
        self.bar_run.pos.x = 205 + camera.x
        s_pos = 5 + camera.x
        --
        if (it == false) then
            self.bar:set(health.get()) --100)--
            self.bar.text = health.get().."%" --"100%"--
            it = true
        end
        --eat
        --Run Bar
        if self.p.fox_sprite.current_anim == "run" or self.p.fox_sprite.current_anim == "jump" then
            
            if self.p.fox_sprite.current_anim == "jump" and love.keyboard.isDown("z") then
                self.bar_run:set(self.bar_run.percentage - 0.7)
            else 
                self.bar_run:set(self.bar_run.percentage - 0.3)
            end
            
            if self.bar_run.percentage <= 20 then
                self.p.enable = false
                self.bar_run.fill_color = U.color(1,0,0,1)
            else
                self.p.enable = true
                self.bar_run.fill_color = U.color(0.6,0.8,1,1)
            end
        else
            self.bar_run:set(self.bar_run.percentage + 0.8)
        end
        if(self.bar_run.percentage == 100) then
            self.bar_run.fill_color = U.color(0.6,0.8,1,1)
        end
        self.bar_run.text= ""
        --
        --
        local r1 = self.p.fox_sprite:rect_(0,0,-60,-10)

        --
        local eat 
        if ( self.p.fox_sprite.flip.x == 1) then
            eat = self.p.fox_sprite:rect_(55,0,-110,-10)
        elseif self.p.fox_sprite.flip.x == -1 then
            eat = self.p.fox_sprite:rect_(-55,0,-110,-10)
        end

        if self.p.fox_sprite.current_anim == "bite" then
            if self.f.remove == nil and self.f and U.AABBColl(eat,self.f.spr:rect()) then
                self.bar:set(self.bar.percentage + 20)
                self.f.remove = true
            end
            if self.f1.remove == nil and self.f1 and U.AABBColl(eat,self.f1.spr:rect()) then
                self.bar:set(self.bar.percentage + 20)
                self.f1.remove = true
            end
            if self.f2.remove == nil and self.f2 and U.AABBColl(eat,self.f2.spr:rect()) then
                self.bar:set(self.bar.percentage + 20)
                self.f2.remove = true
            end
            if self.f3.remove == nil and self.f3 and U.AABBColl(eat,self.f3.spr:rect()) then
                self.bar:set(self.bar.percentage + 20)
                self.f3.remove = true
            end 
        end

        --[[then
            local md = r2:minowski_diff(r1)
            local sep = md:closest_point_on_bounds(Vector2())
            --tell the player on which side it has a collision
            self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))
            
            it2 = true
             
            self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + sep.y 
        
--            self.bar:set(self.bar.percentage - 1)
        end

        if it2 == true then
    --        self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + 300*dt
        end
        ]]--

        
        if (self.p.fox_sprite.pos.x >= 1000) then
            health.val(self.bar.percentage)
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            it = false
            love.audio.stop(snd1)
            level_7_c = true
            if self.f1.remove ~= nil then
                self.em:add(self.f1)
                self.f1.remove = nil
            end
            if self.f2.remove ~= nil then
                self.em:add(self.f2)
                self.f2.remove = nil
            end
            if self.f3.remove ~= nil then
                self.em:add(self.f3)
                self.f3.remove = nil
            end
            if self.f.remove ~= nil then
                self.em:add(self.f)
                self.f.remove = nil
            end
            
        end
    end

    if pause == true then
        love.audio.pause(snd1)
    end
    
end

function T:draw()
    camera:set()
    love.graphics.clear(0.34,0.38,1)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test,1920,0)
    love.graphics.draw(Map_test,2880,0)
    self.super.draw(self)   
    
    love.graphics.draw(Sonder,s_pos+6,24)
    love.graphics.draw(winter_bar,s_pos-10,12) 
    camera:unset()

end


return T