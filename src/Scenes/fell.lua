local Scene  = require("lib.scene")
local ep = require("Advice.river_f")
local Player = require("../player")
require("lib.camera")
local health = require("../global")
local Map_test
local T      = Scene:derive("level_1")
local s_pos
local rock3 = require("../rock3")
local Bar    = require("lib.ui.bar")
local U      = require("lib.utils")
local Vector2 = require("lib.vector2")

local health = require("../global")

game_over = false
fell_c = false

camera:setBounds(0,0,2880,540*2)

function T:new(scene_mngr)
    --camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    
    
    self.ep_ = ep()
    self.ep_.spr.pos.x = 480
    self.ep_.spr.pos.y = 540
    self.em:add(self.ep_)

    self.r1 = rock3()
    self.r1.spr:flip_h(true)
    self.r1.spr.pos.x = 600
    self.em:add(self.r1)

    self.r2 = rock3()
    self.r2.spr.pos.x = 150
    self.r2.spr.pos.y = 600
    self.em:add(self.r2)

    self.r3 = rock3()
    self.r3.spr:flip_h(true)
    self.r3.spr.pos.x = 590
    self.r3.spr.pos.y = 900
    self.em:add(self.r3)

    self.r4 = rock3()
    self.r4.spr.pos.x = 150
    self.r4.spr.pos.y = 1200
    self.em:add(self.r4)

    self.r5 = rock3()
    self.r5.spr:flip_h(true)
    self.r5.spr.pos.x = 590
    self.r5.spr.pos.y = 1450
    self.em:add(self.r5)
    
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

    self.p = Player()
    self.p.fox_sprite.pos.x = 300   
    self.p.fox_sprite.pos.y = 20
    self.em:add(self.p)

    Map_test = love.graphics.newImage("Map/fell1.png")
    Sonder   = love.graphics.newImage("Map/sonder1.png")
    winter_bar = love.graphics.newImage("Advice/winter_life_bar_.png")
    snd1_ = love.audio.newSource("Sound/waterfall.wav","stream")
    snd1_:setLooping(true)
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

local it = false
--Update
function T:update(dt)    
    if(pause == false) then
        self.super.update(self,dt)
        love.audio.play(snd1_)
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/2), self.p.fox_sprite.pos.y - (love.graphics.getHeight())/4 )
        self.p.fox_sprite:animation("run")
          

        self.bar.pos.x = 180 + camera.x
        self.bar.pos.y = 35 + camera.y
        self.bar_run.pos.x = 205 + camera.x
        self.bar_run.pos.y = 65 + camera.y
        s_posx = 5 + camera.x
        s_posy = 15 + camera.y

        if (it == false) then
            self.bar:set(health.get()) --
            self.bar.text = health.get().."%" --
            it = true
        end
        --
        self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + 350*dt
        --
        local sonder = self.p.fox_sprite:rect_(0,0,-60,-10)
        local r1_ = self.r1.spr:rect_(60,0,-150 ,-10)
        local r2_ = self.r2.spr:rect_(-60,0,-150 ,-10)
        local r3_ = self.r3.spr:rect_(60,0,-150 ,-10)
        local r4_ = self.r4.spr:rect_(-60,0,-150 ,-10)
        local r5_ = self.r5.spr:rect_(60,0,-150 ,-10)
        local r1_1 = self.r1.spr:rect_(0,0,-50 ,-120)
        local r2_1 = self.r2.spr:rect_(0,0,-50 ,-120)
        local r3_1 = self.r3.spr:rect_(0,0,-50 ,-120)
        local r4_1 = self.r4.spr:rect_(0,0,-50 ,-120)
        local r5_1 = self.r5.spr:rect_(0,0,-50 ,-120)

        if U.AABBColl(sonder,r1_) or U.AABBColl(sonder,r1_1) then
            self.bar:set(self.bar.percentage - 2)
        end
        if U.AABBColl(sonder,r2_) or U.AABBColl(sonder,r2_1) then
            self.bar:set(self.bar.percentage - 2)
        end
        if U.AABBColl(sonder,r3_) or U.AABBColl(sonder,r3_1)then
            self.bar:set(self.bar.percentage - 2)
        end
        if U.AABBColl(sonder,r4_) or U.AABBColl(sonder,r4_1)then
            self.bar:set(self.bar.percentage - 2)
        end
        if U.AABBColl(sonder,r5_) or U.AABBColl(sonder,r5_1)then
            self.bar:set(self.bar.percentage - 2)
        end
        --
        if self.p.fox_sprite.pos.y >= 1770 or self.p.fox_sprite.pos.x >= 800 then
            love.audio.stop(snd1_)
            if self.bar.percentage <= 20  or self.p.fox_sprite.pos.x >= 800 then
                self.p.fox_sprite.pos.x = 300
                self.p.fox_sprite.pos.y = 20
                it = false
                game_over = true
            else 
                health.val(5)
                self.p.fox_sprite.pos.x = 300
                self.p.fox_sprite.pos.y = 20
                it = false 
                fell_c = true 
            end
        end
    end
    if pause == true then
        love.audio.pause(snd1_)
    end
end

function T:draw()
    camera:set()
    love.graphics.draw(Map_test,960,0)
    love.graphics.draw(Map_test,960,540)
    love.graphics.draw(Map_test,960,540*2)
  --  love.graphics.draw(Map_test,960,540*3)
    self.super.draw(self)
    love.graphics.draw(Sonder,s_posx+6,s_posy+8)
    love.graphics.draw(winter_bar,s_posx-10,s_posy-3) 
    camera:unset()
end

return T