local class = require("lib.class")
local Vec2  = class:derive("vector2")

local pow  = math.pow
local sqrt = math.sqrt

function Vec2:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

function Vec2:mag()
    return sqrt(pow(self.x,2) + pow(self.y,2))
end

function Vec2.add(v1, v2)
    return Vec2(v1.x + v2.x, v1.y + v2.y)
end

function Vec2.sub(v1, v2)
    return Vec2(v1.x - v2.x, v1.y - v2.y)
end

function Vec2.divide(v1, divisor)
    assert(divisor ~= 0, "Error divisor must not be 0!")
    return Vec2(v1.x / divisor, v1.y / divisor)
end

function Vec2.multiply(v1, mult)
    return V(v1.x * mult, v1.y * mult)
end

function Vec2:mul(val)
    self.x = self.x * val
    self.y = self.y * val
end

function Vec2:div(val)
    assert(val ~= 0, "Error val must not be 0!")
    self.x = self.x / val
    self.y = self.y / val
end

--Modifies the vector in-place to have a magnitude of 1
--
function Vec2:normalize()
    local mag = self:mag()
    self.x = self.x / mag
    self.y = self.y / mag
end

--Creates a copy of this Vector2 object
--
function Vec2:copy()
    return V(self.x, self.y)
end

return Vec2