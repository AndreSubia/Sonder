local Class        = require("lib.class")
local StateMachine = require("lib.state_machine")
local Anim         = require("lib.animations")
local Sprite       = require("lib.sprite")

local T = Class:derive("allep")

local ep
intro_c = false

local ep1 = Anim(0,0,120,60,1,1,1)
local ep2 = Anim(0,60,120,60,1,1,1)
local ep3 = Anim(0,120,120,60,1,1,1)
local ep4 = Anim(0,180,120,60,7,7,3)

local time = 0

function T:new()
    if ep == nil then
        ep = love.graphics.newImage("Advice/allep.png")
    end
    self.spr = Sprite(ep,120,60,480,270,8,8)
    self.spr:add_animations({ep1 = ep1,ep2 = ep2,ep3 = ep3,ep4 = ep4})
    self.spr:animation("ep4")
    self.anim_sm = StateMachine(self, "ep4")
    bang = love.audio.newSource("Sound/bang.wav","stream")

    message1 = love.graphics.newImage("Advice/message1.png")
end

function T:idle_enter(dt)
    self.spr:animation("ep4")
end

function T:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt)
    time = time + dt
    --[[if time > 0 and time < 2 then
        self.spr:animation("ep1")
    end
    if time > 2 and time < 4 then
        self.spr:animation("ep2")
    end
    if time > 4 and time < 6 then
        self.spr:animation("ep3")
        love.audio.play(bang)
    end]]
    if time > 4 and time <5 then
        love.audio.play(go_snd)
        --love.audio.stop(bang)
        love.graphics.setColor(0.8,0.8,0.8,1)
        --self.spr:animation("ep4")
    end
    
    if (time >= 5 and time < 6) then
        love.graphics.setColor(0.4,0.4,0.4,1)
        
    end
    if (time >= 6 and time < 7) then
        love.graphics.setColor(0.2,0.2,0.2,1)
        
        --self.spr:animation("ep4")
    end
    if (time >= 7 and time < 8) then
        love.graphics.setColor(0.1,0.1,0.1,1)
        intro_c = true
        love.graphics.setColor(1,1,1,1)
        
    end
end

function T:draw()
    
    if time <= 4 then
        love.graphics.draw(message1,0,0)
    else
    
        self.spr:draw()
    end
end

return T