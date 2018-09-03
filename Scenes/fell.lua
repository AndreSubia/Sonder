local Scene  = require("lib.scene")
local ep = require("Advice.river_f")
local Player = require("../player")
require("lib.camera")
local health = require("../global")
local Map_test
local T      = Scene:derive("level_1")
local s_pos

game_over = false
fell_c = false

camera:setBounds(0,0,2880,540*2)

function T:new(scene_mngr)
    --camera:setBounds(0,0,1920,540)
    self.super.new(self,scene_mngr)
    self.ep_ = ep()
    self.ep_.spr.pos.x = 480
    self.ep_.spr.pos.y = 270
    self.em:add(self.ep_)
    self.ep_1 = ep()
    self.ep_1.spr.pos.x = 480
    self.ep_1.spr.pos.y = 540+270
    self.em:add(self.ep_1)
    self.ep_2 = ep()
    self.ep_2.spr.pos.x = 480
    self.ep_2.spr.pos.y = 540+270+540
    self.em:add(self.ep_2)

    self.p = Player()
    self.p.fox_sprite.pos.x = 600
    self.p.fox_sprite.pos.y = 20
    self.em:add(self.p)

    Map_test = love.graphics.newImage("Map/fell1.png")
    snd1_ = love.audio.newSource("Sound/waterfall.wav","stream")
    snd1_:setLooping(true)
end


--Keep this
local entered = false
function T:enter()
    T.super.enter(self)
end
function T:exit()
    T.super.exit(self)
end

--Update
function T:update(dt)    
    if(pause == false) then
        self.super.update(self,dt)
        love.audio.play(snd1_)
        camera:setPosition( self.p.fox_sprite.pos.x - (love.graphics.getWidth()/2), self.p.fox_sprite.pos.y - (love.graphics.getHeight()/2))
        self.p.fox_sprite:animation("run")
        self.p.fox_sprite.pos.y = self.p.fox_sprite.pos.y + 350*dt  

        if self.p.fox_sprite.pos.y >= 1670 then
            love.audio.stop(snd1_)
            if health.get() <= 20 then
                self.p.fox_sprite.pos.x = 600
                self.p.fox_sprite.pos.y = 20
                game_over = true
            else  
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
    love.graphics.draw(Map_test,960,540+540)
    self.super.draw(self)
    camera:unset()
end

return T