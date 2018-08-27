local class = require("lib.class")
local Vec2  = require("lib.vector2")

local Anim  = class:derive("animations")

function Anim:new(xoffset,yoffset,w,h,num_frames,colum_size,fps,loop)
    self.fps = fps
    self.num_frames = num_frames
    self.colum_size = colum_size
    self.start_offset = Vec2(xoffset,yoffset) 
    self.offset = Vec2()
    self.size = Vec2(w,h)
    self.loop = loop == nil or loop
    self:reset()
end

function Anim:reset()
    self.timer = 1 / self.fps
    self.frame = 0
    self.done = false
    self.offset.x = self.start_offset.x
    self.offset.y = self.start_offset.y
end

function Anim:set_quad(quad)
    quad:setViewport(self.offset.x,self.offset.y,self.size.x,self.size.y)
end

function Anim:update(dt,quad)
    if(self.num_frames <= 1) then return

    elseif self.timer > 0 then
        self.timer = self.timer - dt
        if(self.timer <= 0) then
            self.timer = 1 / self.fps
            self.frame =self.frame + 1
            if self.frame >= self.num_frames then 
                if self.loop then
                    self.frame = 0
                else
                    self.frame = self.num_frames-1
                    self.timer = 0
                    self.done = true
                end
            end
            self.offset.x = self.start_offset.x + (self.size.x*((self.frame)%(self.colum_size)))
            self.offset.y = self.start_offset.y + (self.size.y*math.floor(self.frame / self.colum_size))
            self:set_quad(quad)
        end
    end
end 

return Anim