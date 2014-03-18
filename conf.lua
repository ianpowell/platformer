--	
--	conf.lua
--	
--	Ian Powell 11-3-2014	
--	Plat-former Game Test 
--	Names window, sets the size of the window
--

function love.conf(t)--t stands for table
	t.modules.joystick = true
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.thread = true
	t.modules.physics = true
	
	t.modules.console = true
	
	t.title = "Platformer"
	t.author =  "Ian Powell"
	t.screen.fullscreen = false
	t.screen.vsync = false --not for debugging
	t.screen.faaa = 0 --i think this may be anti aliassing
	t.screen.height = 600
	t.screen.width = 800
	
end