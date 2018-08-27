--[[Class = require "lib.class"
local Animal = Class:derive("Animal")

function Animal:SoundOff()
    print("uh?")
end

local a = Animal()
a:SoundOff()
print(a:get_type())

local Cat = Animal:derive("Cat")

function Cat:SoundOff()
     print("Meow!")
end

local c = Cat()
c:SoundOff()
print(c:get_type())

local Minx = Cat:derive("Minx")
local m = Minx()
print(m:get_type(), m.super:get_type(), m.super.super:get_type())

local Player = Class:derive("Player")

function Player:new(name)
    print("hello".. name)
end

function Player:SoundOff()
    print("GG")
end

local player1 = Player("Andre")
player1:SoundOff()
print(player1:get_type())]]

require("Scenes.level_1")

local b = health 

print(b)

 --[[
    if U.CirclesCollide(self.c1, self.c2,0.5) then
        self.c1.c = U.color(0,0.2,0.2,1)
    else
        self.c1.c = U.color(1)
    end
    
    if Key:key("a") then
        self.c1.x = self.c1.x - 115 * dt
    elseif Key:key("d") then
        self.c1.x = self.c1.x + 115 * dt
    end

    ]]----------
    