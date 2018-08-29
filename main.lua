--libs
local SM    = require("lib.scene_mngr")
local Event = require("lib.event")
Key 		= require("lib.keyboard")
local escene = require("lib.scene")


local sm
local snd1
local snd2
local snd_bear

function love.load()
	icon = love.image.newImageData("Sprite/Sonder_icono.png")
	love.window.setIcon(icon)

	snd1 = love.audio.newSource("Sound/Snowfall.ogg","stream")
	snd2 = love.audio.newSource("Sound/PianoTheme.mp3","stream")
	snd_bear = love.audio.newSource("Sound/Ubermensch.wav","stream")
	snd1:setLooping(true)
	snd2:setLooping(true)
	snd_bear:setLooping(true)

	love.graphics.setDefaultFilter('nearest','nearest')

	local font = love.graphics.newFont("Font/babyblue.ttf",20)
	love.graphics.setFont(font)

	_G.events = Event(false)
	Key:hook_love_events()

	sm = SM("Scenes",{"main_menu","level_1","level_3","level_5","game_over","win"})
	
	sm:switch("main_menu")

	love.audio.play(snd2)

	pause = false
end


function love.update(dt)
	if dt>0.035 then return end

	if Key:key_down("return") and sm.current_scene_name ~= "main_menu" and sm.current_scene_name ~= "win" and sm.current_scene_name ~= "game_over" then
		pause = not pause
		if pause == true then
			love.graphics.setColor(0.4,0.4,0.4,1)
		else
			love.graphics.setColor(1,1,1,1)
		end
	end

	if ( sm.current_scene_name == "main_menu" and Key:key_down("return") and game_over == false ) then
		love.audio.stop(snd2)
		sm:switch("level_1")
		love.audio.play(snd1)
	end
	
	if (sm.current_scene_name == "level_1" and game_over == true) then --Key:key_down("m") then
		love.audio.stop(snd1)
		--sm.remove("level_1")
		sm:switch("game_over")
		love.audio.play(snd2)
	end

	if (sm.current_scene_name == "level_1" and level_1_c == true ) then
		love.audio.stop(snd2)
		sm:switch("level_3")
		love.audio.play(snd1)
	end

	if (sm.current_scene_name == "level_3" and level_3_c == true ) then
		love.audio.stop(snd2)
		love.audio.stop(snd1)
		sm:switch("level_5")
		love.audio.play(snd_bear)
	end

	if (sm.current_scene_name == "level_5" and level_5_c == true ) then
		love.audio.stop(snd2)
		love.audio.stop(snd1)
		sm:switch("win")
		love.audio.play(snd_bear)
	end

	if (sm.current_scene_name == "game_over" and Key:key_down("return")) then
		game_over = false
		sm:switch("main_menu")
	end

	if Key:key_down("escape") then
		love.event.quit()
	end
	sm:update(dt)			
	Key:update(dt)
end

function love.draw()
	sm:draw()
end