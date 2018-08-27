local Class = require("lib.class")
-- local Vector2 = require("lib.Vector2")
local SM    = Class:derive("state_machine")

local transition = {
    enter = "_enter",
    none = "",
    exit = "_exit"
}

function SM:new(state_table, start_state_name)
    self:reset()
    self.state_table = state_table
    self:change(start_state_name)
end

function SM:reset()
    self.state = nil
    --self.prev = nil
    self.state_name = nil
    self.prev_name = nil
    self.transition = transition.none
end

--[[function SM:change_immediate(state)
    assert(type(state) == "string" or type(state) == "nil", "parameter state must be of type string or nil!")
    assert(state == nil or self[state] ~= nil, "Can't find state: " .. state .. " as a state function!")

    self.prev = self.state
    self.state = state
    if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
        self.transition = transition.enter
    else
        self.transition = transition.none
    end
end]]

function SM:set_transition_function(new_state_name, transition_type)
    if new_state_name == nil or self.state_table[new_state_name .. transition_type] == nil then
        self.state = nil
        self.transition = transition.none
        return false
    else
        self.state = self.state_table[new_state_name .. transition_type]
        self.transition = transition_type
        return true
    end
end

--[[function SM:change(state)
    --TODO allow forcing a state to change to itself
    if state == self.state then return end
    self:change_immediate(state)
    if self.prev ~= nil and self[self.prev .. transition.exit] ~= nil then
        self.transition = transition.exit
    end    
end ]]

function SM:change(new_state_name, immediate)
    if new_state_name == self.state then return end
    if not immediate and self:set_transition_function(self.state_name, transition.exit) then
    elseif self:set_transition_function(new_state_name, transition.enter) then
    else self:set_transition_function(new_state_name, transition.none) 
    end
    self.prev_name = self.state_name
    self.state_name = new_state_name    
end

--[[function SM:update(dt)
    -- if self.prev ~=nil then
    --     print("prev: " .. self.prev .. " cur: " .. self.state .. self.transition )
    -- end

    if self.transition == transition.exit then
        self[self.prev .. self.transition](self, dt) --previous_state_exit(dt)

        if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
            self.transition = transition.enter
        else
            self.transition = transition.none
        end

    elseif self.transition == transition.enter then
        self[self.state .. self.transition](self,dt)  --state_enter(dt)
        self.transition = transition.none
    elseif self.state ~= nil then 
        self[self.state](self, dt)  --state(dt)
    end
end ]]

function SM:update(dt)
    if self.transition == transition.exit then
        self.state(self.state_table, dt)
        if self:set_transition_function(self.state_name, transition.enter) then 
        else self:set_transition_function(self.state_name, transition.none) 
        end
    elseif self.transition == transition.enter then
        self.state(self.state_table, dt)
        self:set_transition_function(self.state_name, transition.none)
    elseif self.state ~= nil then
        self.state(self.state_table, dt)
    end
end

return SM