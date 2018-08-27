--libs
local Class  = require("lib.class")
local SM     = require("lib.state_machine")
local Anim   = require("lib.animations")
local Sprite = require("lib.sprite")
--local camera = require("lib.camera")
local Player = Class:derive("player")
--Data
local fox
local run_sound
local bite_sound
--Animations         
local fox_idle   = Anim(0,138,135,69,3,3,4)
local fox_run    = Anim(0,0,135,69,8,8,16)
local fox_walk   = Anim(0,69,135,69,8,8,12) 
local fox_jump   = Anim(0,0,135,69,8,8,10,false)
local fox_bite   = Anim(0,276,135,69,5,5,16,false)
local fox_bend   = Anim(0,207,135,69,1,1,1)

function Player:new()
    if fox == nil then
        fox = love.graphics.newImage("Sprite/FoxRun.png")
    end
    if bite_sound == nil and run_sound ==nil then
        run_sound = love.audio.newSource("Sound/step.wav","stream")
        bite_sound= love.audio.newSource("Sound/bite.wav","stream")
    end
    self.fox_sprite = Sprite(fox,135,69,80,450)
    --[[fox_sprite:add_animation("idle",fox_idle)
    fox_sprite:add_animation("walk",fox_walk)
    fox_sprite:add_animation("run",fox_run)]]--
    self.fox_sprite:add_animations({idle=fox_idle,
                                    walk=fox_walk,
                                    run=fox_run,
                                    down=fox_down,
                                    jump=fox_jump,
                                    bite=fox_bite,
                                    bend=fox_bend})
    self.fox_sprite:animation("idle")
    self.vx = 0
    self.anim_sm = SM(self,"idle")
    self.enable = true
    --self.super.new(self,state)
end

--player_states
function Player:idle_enter(dt)
    self.fox_sprite:animation("idle")
end

function Player:idle(dt)
    if Key:key("left") or Key:key("right") then
        --self:change("walk")
        self.anim_sm:change("walk")
    elseif Key:key("space") then
        --self:change("idle")
        self.anim_sm:change("jump")
    elseif Key:key_down("x") then
        self.anim_sm:change("bite")
    end

end

local jumping = false
local y_before_jump = nil


function Player:jump_enter(dt)
    jumping = true
    self.fox_sprite:animation("jump")
end

function Player:jump(dt)
    if not jumping then
        self.anim_sm:change("idle")
        y_before_jump = nil
    elseif Key:key("right") and not Key:key("left") and vx ~= 1 then
        self.fox_sprite:flip_h(false)
        self.vx = 1
    elseif Key:key("left") and not Key:key("right") and vx ~= -1 then
        self.fox_sprite:flip_h(true)
        self.vx = -1
    elseif Key:key_down("x") then
        self.anim_sm:change("bite")
    end
end


function Player:walk_enter(dt)
    self.fox_sprite:animation("walk")
end

function Player:walk(dt)
    if Key:key("right") and not Key:key("left") and vx ~= 1 then
        self.fox_sprite:flip_h(false)
        self.vx = 1
    elseif Key:key("left") and not Key:key("right") and vx ~= -1 then
        self.fox_sprite:flip_h(true)
        self.vx = -1
    elseif not Key:key("left") and not Key:key("right") then
        self.vx = 0
        self.anim_sm:change("idle")
    end

    if  Key:key_down("z") then
        self.anim_sm:change("run")
    end
end



function Player:run_enter(dt)
    self.fox_sprite:animation("run")
end

function Player:run(dt)
    if Key:key("right") and not Key:key("left") and vx ~= 1 then
        self.fox_sprite:flip_h(false)
        self.vx = 1
    elseif Key:key("left") and not Key:key("right") and vx ~= -1 then
        self.fox_sprite:flip_h(true)
        self.vx = -1
    elseif not Key:key("left") and not Key:key("right") then
        self.vx = 0
        --self:change("idle")
        self.anim_sm:change("idle")
    end

    if self.enable == false  then
        self.vx = 0
        self.anim_sm:change("idle")
    end
    love.audio.play(run_sound)

end

function Player:bite_enter(dt)
    self.fox_sprite:animation("bite")
    love.audio.stop(bite_sound)
    love.audio.play(bite_sound)
end

function Player:bite(dt)
    if self.fox_sprite:end_animation() then
        self.anim_sm:change("idle")
    end
end

local y_vel = 0
local y_gravity = 1000

function Player:update(dt)
   
    self.anim_sm:update(dt)
    self.fox_sprite:update(dt)    

    if jumping and y_before_jump == nil then
        y_vel = -400 -- max hight jump
        y_before_jump = self.fox_sprite.pos.y
    elseif jumping then
        y_vel = y_vel + y_gravity * dt
        self.fox_sprite.pos.y = self.fox_sprite.pos.y + y_vel * dt
        if self.fox_sprite.pos.y >= y_before_jump then
            jumping = false
            self.fox_sprite.pos.y = y_before_jump
            y_before_jump = nil
            self.vx = 0
            self.anim_sm:change("idle")
        end
    end

    if(self.fox_sprite.current_anim=="walk") then
        self.fox_sprite.pos.x = self.fox_sprite.pos.x + self.vx *120 *dt
        if Key:key_down("space") then 
            self.anim_sm:change("jump")
        end
    end
    
    if self.enable == true then 
        if(self.fox_sprite.current_anim=="run") then
            self.fox_sprite.pos.x = self.fox_sprite.pos.x + self.vx *225 *dt
            if Key:key_down("space") then 
                self.anim_sm:change("jump")
            end
        end
    end

    if jumping == true then
        self.fox_sprite.pos.x = self.fox_sprite.pos.x + self.vx *200 *dt
    end

    if self.fox_sprite.pos.x <= 0 then
        self.fox_sprite.pos.x = 0
    end

end
--This function responds to a collision event on any of the
-- given sides of the player's collision rect
-- top, bottom, left, right are all boolean values
function Player:collided()
    if bottom then
        jumping = false
        y_before_jump = nil
        self.vx = 0
        self.anim_sm:change("idle")
    end
end
--
function Player:draw()
    self.fox_sprite:draw()
end

return Player