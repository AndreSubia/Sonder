local class  = require("lib.class")
local Vec2   = require("lib.vector2")
local Anim   = require("lib.animations")
local Rect   = require("lib.rect")

local Sprite = class:derive("sprite")

function Sprite:new(atlas,w,h,x,y,sx,sy,angle)
    self.w = w
    self.h = h
    self.flip = Vec2(1,1)
    self.pos = Vec2(x or 0 ,y or 0)
    self.scale = Vec2(sx or 1,sy or 1)
    self.atlas = atlas
    self.angle = angle or 0
    self.animations = {}
    self.current_anim = ""
    self.quad = love.graphics.newQuad(0,0,w,h,atlas:getDimensions())
end

function Sprite:animation(anim_name)
    if(self.current_anim ~= anim_name and self.animations[anim_name] ~= nil) then
        self.current_anim = anim_name
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set_quad(self.quad)
    end
end

function Sprite:end_animation()
    if self.animations[self.current_anim] ~= nil then
        return self.animations[self.current_anim].done 
    end
    return true
end

function Sprite:flip_h(flip)
    if flip then
        self.flip.x = -1
    else
        self.flip.x = 1
    end
end

function Sprite:add_animation(name,anim)
    self.animations[name] = anim
end

function Sprite:add_animations(animations)
    assert(type(animations) == "table" , "animations parameter")
    for k,v in pairs(animations) do
        self.animations[k] = v
    end
end

function Sprite:update(dt)
    if(self.animations[self.current_anim] ~= nil ) then
        self.animations[self.current_anim]:update(dt,self.quad)
    end
end

--box
function Sprite:rect()
    return Rect.create_centered(self.pos.x, self.pos.y, self.w * self.scale.x, self.h * self.scale.y)
end

function Sprite:rect_(x_,y_,w_,h_)
    return Rect.create_centered(self.pos.x+x_,self.pos.y+y_,(self.w+w_)*self.scale.x,(self.h+h_)*self.scale.y)
end

function Sprite:draw()
    love.graphics.draw(self.atlas,self.quad,self.pos.x,self.pos.y,self.angle,self.scale.x * self.flip.x ,self.scale.y,self.w /2,self.h /2)
    --local r = self:rect()
    --local r1= self:rect_(0,0,-60,-10)
    --love.graphics.rectangle("line",r.x,r.y,r.w,r.h)
    --love.graphics.rectangle("line",r1.x,r1.y,r1.w,r1.h)
end

return Sprite