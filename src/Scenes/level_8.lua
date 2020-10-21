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
local Thorn  = require("../rock4")


local health = require("../global")

require("lib.camera")
--Scene
local T      = Scene:derive("level_8")
local Map_test
local Sonder
local s_pos
--local fox_sprite

level_8_c = false

--health = 20

function T:new(scene_mngr)
    camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    self.p = Player()
    self.em:add(self.p)

    self.t = Thorn()
    self.em:add(self.t)
    self.t1 = Thorn()
    self.t1.spr.pos.x = 950
    self.em:add(self.t1)
    self.t2 = Thorn()
    self.t2.spr.pos.x = 1250
    self.em:add(self.t2)
    self.t3 = Thorn()
    self.t3.spr.pos.x = 1750
    self.em:add(self.t3)
    self.t4 = Thorn()
    self.t4.spr.pos.x = 2650
    self.em:add(self.t4)
    self.t5 = Thorn()
    self.t5.spr.pos.x = 3300
    self.em:add(self.t5)
    
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

    Map_test  = love.graphics.newImage("Map/myforest5.png")
    --Map_test2 = love.graphics.newImage("Map/myforest.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")
    winter_bar = love.graphics.newImage("Advice/winter_life_bar_.png")

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
        self.bar_run.pos.x = 205 + camera.x
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
        if  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t1.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t1.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t2.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t2.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t3.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t3.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t4.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t4.spr:animation("on_idle")
        elseif  U.AABBColl(self.p.fox_sprite:rect_(0,0,-60,-10), self.t5.spr:rect()) then
            self.bar:set(self.bar.percentage - 3)
            self.t4.spr:animation("on_idle")
        end
        -- si hay cosas que comer
        if self.p.fox_sprite.current_anim == "bite" then
            
        end

        if self.p.fox_sprite.pos.x > 100 and self.p.fox_sprite.pos.x < 1200 then
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + 300*dt
        end

        if self.p.fox_sprite.pos.x >= 1200 and self.p.fox_sprite.pos.x < 2100 then
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + 400*dt
        end

        if self.p.fox_sprite.pos.x >= 2100 then
            self.p.fox_sprite.pos.x = self.p.fox_sprite.pos.x + 600*dt
        end

        --condiciones para acabar el nivel
        
        if (self.p.fox_sprite.pos.x >= 2720+960) then
            health.val(self.bar.percentage)
            self.p.fox_sprite.pos.x = 80
            self.p.fox_sprite.pos.y = 450
            it = false
            love.audio.stop(snd1)
            level_8_c = true
            
        end

        if (self.bar.percentage <= 0) then
            self.p.fox_sprite.pos.x = 0
            it = false
            love.audio.stop(snd1)
            game_over = true
        end

    end
    --pausa del juego
    if pause == true then
        love.audio.pause(snd1)
    end
end

function T:draw()
    camera:set()
    love.graphics.clear(0.34,0.38,1)
    love.graphics.draw(Map_test,0,0)
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test,1920,0)
    love.graphics.draw(Map_test,2880,0)
    self.super.draw(self)   
    
    love.graphics.draw(Sonder,s_pos+6,24)
    love.graphics.draw(winter_bar,s_pos-10,12) 
    camera:unset()

end


return T