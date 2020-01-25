introA = sound.load("assets/sounds/intro.mp3")
introA:play()

bgTimer:reset(0)
bgTimer:start()

mainScreen = image.load("assets/titleFull.png")
alpha = 0
while true do 
	buttons.read()
	screen.clear(color.new(0, 0, 0, 255))
	if bgTimer:time() < 5000 then
		screen.print(240, 136, "Parsec Productions", 1, white, gray, __ACENTER)
	elseif bgTimer:time() >= 5000 and bgTimer:time() < 10000 then
		screen.print(240, 136, "With Iridescence Technologies", 1, white, gray, __ACENTER)
	elseif bgTimer:time() >= 10000 and bgTimer:time() < 18000 then
		screen.print(240, 136, "Presents", 1, white, gray, __ACENTER)
	elseif bgTimer:time() >= 18000 and bgTimer:time() < 30000 then
		if bgTimer:time() < 21000 then
			alpha = 255 * (bgTimer:time() - 18000) / 3000
		elseif bgTimer:time() >= 21000 and bgTimer:time() < 24000 then
			alpha = 255
		else
			alpha = 255 - 255 * (bgTimer:time() - 24000) / 3000
			if alpha < 0 then
				alpha = 0
			end
		end
		
		mainScreen:blit(0, 0, alpha)
	else break end
	
	screen.flip()
end

introA:stop()