require 'class'
require 'main_game'

if os.getenv("LUA_TEST") then
   require "lunatest.lunatest"

   lunatest.suite("tests.main_test")
   lunatest.suite("tests.ninja_test")
   lunatest.suite("tests.ninja_animations_test")

   lunatest.run()
   os.exit()
end

local main_game = MainGame()

function love.load()
	 main_game:load()
end

function love.draw()
	 main_game:draw()
end

function love.update()
	 main_game:update()
end

function love.keypressed(key, unicode)
   if key == 'right' then
			main_game:pressRight()
	 elseif key == 'left' then
			main_game:pressLeft()
	 elseif key == 'down' then
			main_game:pressDown()
	 elseif key == 'q' then
			main_game:pressJump()
   end
end

function love.keyreleased(key, unicode)
   if key == 'right' then
			main_game:releaseRight()
	 elseif key == 'left' then
			main_game:releaseLeft()
	 elseif key == 'down' then
			main_game:releaseDown()
   end
end