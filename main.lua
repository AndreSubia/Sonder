--libs
local SM    = require("lib.scene_mngr")
local Event = require("lib.event")
Key 		= require("lib.keyboard")
local escene = require("lib.scene")
local Bar    = require("lib.ui.bar")
local health = require("../global")
local sm

local snd_bear
game_over = false
n_d       = 0

function love.load()
	icon = love.image.newImageData("Sprite/Sonder_icono.png")
	love.window.setIcon(icon)

	go_snd = love.audio.newSource("Sound/PianoTheme.mp3","stream")
	
	love.graphics.setDefaultFilter('nearest','nearest')

	local font = love.graphics.newFont("Font/babyblue.ttf",20)
	love.graphics.setFont(font)

	_G.events = Event(false)
	Key:hook_love_events()

	sm = SM("Scenes",{"intro","main_menu","level_1","level_3","level_4","level_5",
					  "level_6","level_7","level_8","level_9","game_over","win","fell"})	

	--Cambiar Nivel 

	local level = "level_3"
	if ( level ~= ( "intro" or "main_menu" or "game_over" ) ) then
		health.val(100)
	end
	sm:switch(level)
	--
	pause = false

end


function love.update(dt)
	if dt>0.035 then return end

	if Key:key_down("return") and (sm.current_scene_name == "level_1" or 
								  sm.current_scene_name == "level_3" or
								  sm.current_scene_name == "level_4" or
								  sm.current_scene_name == "level_5" or 
								  sm.current_scene_name == "level_6" or
								  sm.current_scene_name == "level_7" or
								  sm.current_scene_name == "fell") then
		pause = not pause
		
	end

	if sm.current_scene_name == "intro" and intro_c == true then 
		sm:switch("main_menu")
	end

	if (sm.current_scene_name == "level_1" and level_1_c == true ) then
		sm:switch("level_3")
	end

	if (sm.current_scene_name == "level_3" and level_3_c == true ) then
		sm:switch("level_4")
	end

	if (sm.current_scene_name == "level_4" and level_4_c == true ) then
		sm:switch("level_5")
	end

	if (sm.current_scene_name == "level_5" and level_5_c == true ) then
		sm:switch("level_6")
	end

	if (sm.current_scene_name == "level_6" and level_6_c == true ) then
		sm:switch("fell")
	end

	if (sm.current_scene_name == "fell" and fell_c == true ) then
		sm:switch("level_7")
	end

	if game_over == true then
		love.audio.stop(snd_forest)
		love.audio.stop(snd_night)
		love.audio.play(go_snd)
		sm:switch("game_over")
	end

	if (sm.current_scene_name == "game_over" and Key:key_down("return") and game_over == true) then
		level_1_c = false
		level_3_c = false
		level_4_c = false
		level_5_c = false
		level_6_c = false
		game_over = false
		pause = false
		love.audio.stop(go_snd)
		n_d = n_d + 1
		sm:switch("main_menu")
	end

	if (sm.current_scene_name == "main_menu" and Key:key_down("return") and game_over == false) then
		sm:switch("level_1")
	end

	if Key:key_down("escape") then
		love.event.quit()
	end
	sm:update(dt)			
	Key:update(dt)
end

function love.draw()
	sm:draw()
	if pause == true then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("PAUSA",750,15,0,3,3)
		love.graphics.print("Muertes: "..n_d,750,530,0,2,2)
		love.graphics.setColor(0.4,0.4,0.4,1)
	else
		love.graphics.setColor(1,1,1,1)
	end

end
