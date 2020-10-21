local class = require("lib.class")
local Scene = require("lib.scene")

local SM    = class:derive("scene_mngr")

function SM:new(scene_dir,scenes)
    self.scenes = {}
    self.scene_dir = scene_dir

    if not scene_dir then scene_dir = "" end

    if scenes ~= nil then
        assert(type(scenes) == "table","parameter table")
        for i=1 , #scenes do
            local M = require(scene_dir .. "." .. scenes[i])
            self.scenes[scenes[i]] = M(self)
        end
    end

    self.prev_scene_name = nil
    self.current_scene_name = nil
    self.current = nil
end

function SM:add(scene)
    if scene then
        assert(scene_name ~= nil, "parameter must be specified")
        assert(type(scene_name) == "string", "parameter string")
        assert(type(scene) == "table", "parameter table")
        assert(scene:is(scene_name),"cannot add non scene")
        
        self.scenes[scene_name] = scene
    end
end

function SM:remove(scene_name)
    if scene_name then
        for k,v in pairs(self.scenes) do
            if k == scene_name then
                self.scenes[k]:destroy()
                self.scenes[k] = nil
                if scene_name == self.current_scene_name then
                    self.current = nil
                end 
                break     
            end
        end
    end
end

function SM:switch(next_scene)
    if self.current then
        self.current:exit()
    end

    if next_scene then
        assert(self.scenes[next_scene] ~= nil , "Unable to find: " .. next_scene)
        self.prev_scene_name = self.current_scene_name
        self.current_scene_name = next_scene
        self.current = self.scenes[next_scene]
        self.current:enter()
    end
end

function SM:pop()
    if self.prev_scene_name then
        self.switch(self.prev_scene_name)
        self.prev_scene_name = nil
    end
end

function SM:list_scenes()
    local scene_names = {}
    for k,v in pairs(self.scenes) do
        scene_names[#scene_names + 1] = k
    end
    return scene_names
end

function SM:update(dt)
    if self.current then
        self.current:update(dt)
    end
end

function SM:draw()
    if self.current then
        self.current:draw(dt)
    end
end

return SM