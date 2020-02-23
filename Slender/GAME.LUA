amg.init()
amg.quality(__8888)
amg.renderstyle(__TRIANGLES)
amg.perspective(55)
fovChange = 0
player = cam3d.new()
cam3d.position(player,{180,180,180})

slendy = model3d.load("assets/model/slendy.obj")
slendy:scaling(1, {10, 10, 10})
slendy:position(1, {-50000, -20, -50000})
slendPos = {-50000, -20, -50000}

pageModelPositions = { {795, 52.681 ,-1432}}

pages1 = model3d.load("assets/model/pages/page1.obj")
pages2 = model3d.load("assets/model/pages/page2.obj")
pages3 = model3d.load("assets/model/pages/page3.obj")
pages4 = model3d.load("assets/model/pages/page4.obj")
pages5 = model3d.load("assets/model/pages/page5.obj")
pages6 = model3d.load("assets/model/pages/page6.obj")
pages7 = model3d.load("assets/model/pages/page7.obj")
pages8 = model3d.load("assets/model/pages/page8.obj")

pages1:scaling(1, {6, 6, 6})
pages1:rotation(1, {90, 0, 0})
pages2:scaling(1, {6, 6, 6})
pages2:rotation(1, {90, 0, 0})
pages3:scaling(1, {6, 6, 6})
pages3:rotation(1, {90, 0, 0})
pages4:scaling(1, {6, 6, 6})
pages4:rotation(1, {90, 0, 0})
pages5:scaling(1, {6, 6, 6})
pages5:rotation(1, {90, 0, 0})
pages6:scaling(1, {6, 6, 6})
pages6:rotation(1, {90, 0, 0})
pages7:scaling(1, {6, 6, 6})
pages7:rotation(1, {90, 0, 0})
pages8:scaling(1, {6, 6, 6})
pages8:rotation(1, {90, 0, 0})

pages1:position(1, {-795, 34.681, -1433})
pages2:position(1, {677, 34.681, -1514})
pages3:position(1, {1507, 34.681, -1050})
pages4:position(1, {-1627, 34.681, -660})
pages5:position(1, {-706, 34.681, 482})
pages6:position(1, {400, 34.681, -60})
pages7:position(1, {-450, 34.681, -208})
pages8:position(1, {-15, 34.681, 980})   

page1collect = false
page2collect = false
page3collect = false
page4collect = false
page5collect = false
page6collect = false
page7collect = false
page8collect = false

endAnim = false



pagesCollected = 0
pageCollectEvent = true
pageCollectTime = 3000

playerRot = {0, 0, 0}
playerPos = {0, 36, -2000}
playerUp = {0, 5, 0}

model3d.initphysics(30)

Terrain = model3d.load("assets/model/map.obj")

model3d.setphysics(Terrain,1,{0,0,0},{0,0,0},0,__CONVEX)
model3d.physics(Terrain)
model3d.position(Terrain, 1, {0, 0, 0})
Terrain:scaling(1, {2, 1, 2})

ambient = sound.load("assets/sounds/ambience.mp3")
ambient:loop()
ambient:play(7)

clickfx = sound.load("assets/sounds/flashlight.mp3")

stage1 = sound.load("assets/sounds/stage1.mp3")
stage1:loop()
stage2 = sound.load("assets/sounds/stage2.mp3")
stage2:loop()
stage3 = sound.load("assets/sounds/stage3.mp3")
stage3:loop()
stage4 = sound.load("assets/sounds/stage4.mp3")
stage4:loop()

zoomNoise = sound.load("assets/sounds/zoom.mp3")
zoomNoise:loop()
zoomPlay = false

step = {}

for i=1, 12 do
	step[i] = sound.load("assets/sounds/step/step"..i..".mp3")
end

stepTimeNeeded = 800
stepTimeCurrent = 0
stepTimer = timer.new()
stepTimer:reset(0)
stepTimer:start()

isWalking = false

currentGameStage = 0
changeStage = false

isSprinting = false
stamina = 2500
isPanting = false
pant = sound.load("assets/sounds/breath.mp3")
pant:loop()


flashLightEnabled = 1

bgTimer:reset(0)
bgTimer:start()

amg.typelight(1,__DIRECTIONAL)
amg.colorlight(1,color.new(6,6,12),color.new(5, 5, 7),color.new(6,6,12))
amg.poslight(1,{0,3,0})

amg.typelight(2, __POINT)
amg.colorlight(2, white, white, white)
amg.poslight(2,{0,2,0})

amg.typelight(3, __POINT)
amg.colorlight(3, white, white, white)
amg.poslight(3,{0,2,0})

amg.typelight(4, __POINT)
amg.colorlight(4, white, white, white)
amg.poslight(4,{0,2,0})

deltaTimer = timer.new()
deltaTimer:start()
dt = 0

scareNoise = sound.load("assets/sounds/crash.mp3")

scareTimer = timer.new()
scareTimer:reset(0)
scareTimer:start()

pageTimer = timer.new()
pageTimer:reset(0)
pageTimer:start()

scareCooldown = 7500
scareBuffLength = 3750
scareBuff = 2.0
scared = false

scareEvent = false

currentBuff = 1

won = false

slenderTPTimer = timer.new()
slenderTPTimer:reset(0)
deathTimer = timer.new()
deathTimer:reset(0)

slenderTPRemaining = 5000


sanity = 100.0

staticImage = image.load("assets/tex/tv_static_by_tbh_1138_d3jmbjq-sharedassets0.assets-69.png")
staticImage:center()
staticImage:scale(300)

if not meme then
	static = sound.load("assets/sounds/static2.mp3")
	deathSound = sound.load("assets/sounds/static3.mp3")
else
	static = sound.load("assets/sounds/meme.mp3")
	deathSound = sound.load("assets/sounds/meme.mp3")
end

deathSound:loop()
function render ()
	buttons.read()
	amg.begin()
	amg.gravity(0,-9.8,0)
	cam3d.set(player)

	amg.mode2d(1)
	screen.clear(color.new(0, 0, 0, 255))
	amg.mode2d(0)

	
	if currentGameStage == 1 then
		amg.fog(0.8, 400, color.new(0, 0, 0, 255))
	elseif currentGameStage == 2 then
		amg.fog(0.8, 370, color.new(0, 0, 0, 255))
	elseif currentGameStage == 3 then
		amg.fog(0.8, 340, color.new(0, 0, 0, 255))
	elseif currentGameStage == 4 then
		amg.fog(0.8, 310, color.new(0, 0, 0, 255))
	else
		amg.fog(0.8, 360, color.new(0, 0, 0, 255))
	end

	for i=1,8 do
		if not page1collect then pages1:render(2,1) end
		if not page2collect then pages2:render(2,1) end
		if not page3collect then pages3:render(2,1) end
		if not page4collect then pages4:render(2,1) end
		if not page5collect then pages5:render(2,1) end
		if not page6collect then pages6:render(2,1) end
		if not page7collect then pages7:render(2,1) end
		if not page8collect then pages8:render(2,1) end
	end
	
	
	for i=1,164 do
		Terrain:render(2, i)
	end
	
	slendy:render(2, 1)
	
	amg.fog()
	
	--On screen stuff here!
	amg.mode2d(1)
	
	
	if sanity < 100 then
		-- Draw static
		math.randomseed(bgTimer:time())
		staticImage:blit(240, math.random(100, 172), 192 * (100.0 - sanity) / 100.0)
		math.randomseed(bgTimer:time())
		staticImage:blit(240, math.random(100, 172), 192 * (100.0 - sanity) / 100.0)
		math.randomseed(bgTimer:time())
		staticImage:blit(240, math.random(100, 172), 192 * (100.0 - sanity) / 100.0)
		
		math.randomseed(bgTimer:time())
		num = math.random(0, 2)
		if num == 0 then
			staticImage:fliph()
		else
			staticImage:flipv()
		end
	end
	
	--screen.print(0, 20, "POS: "..playerPos[1].." "..playerPos[3])

	if pageCollectEvent then
	
		if pageTimer:time() < pageCollectTime then
			if pagesCollected == 0 then
				screen.print(240, 136, "Collect all 8 pages", 1, white, gray, __ACENTER)
			else
				screen.print(240, 136, pagesCollected.."/8 pages collected", 1, white, gray, __ACENTER)
			end
		else
			pageCollectEvent = false
			pageTimer:reset(0)
			
			if pagesCollected == 1 then
				changeStage = true
				currentGameStage = 1
			elseif pagesCollected == 3 then
				changeStage = true
				currentGameStage = 2
			elseif pagesCollected == 5 then
				changeStage = true
				currentGameStage = 3
			elseif pagesCollected == 7 then
				changeStage = true
				currentGameStage = 4
			end
			
			if pagesCollected == 8 then
				won = true
			end
			
		end
	end

	amg.mode2d(0)

	amg.update()
	model3d.updatephysics()
	screen.flip()
end

function locationTestCheck(location, center, boundX, boundZ)
	if location[1] >= (center[1] - (boundX / 2)) and location[1] < (center[1] + (boundX / 2)) and location[3] >= (center[2] - (boundZ / 2)) and (location[3] < center[2] + (boundZ / 2)) then
		return false
	else
		return true
	end
end

function update ()
	if not won then
	if sanity <= 0 then
		won = true
	end
	

	slenderTPDistance = 1000
	if currentGameStage == 2 then
		slenderTPDistance = 700
	elseif currentGameStage == 3 then
		slenderTPDistance = 500
	elseif currentGameStage == 4 then
		slenderTPDistance = 300
	end
	
	if slenderTPTimer:time() >= slenderTPRemaining then
		-- TP to random location in radius
		slenderTPRemaining = math.random(8000, 15000)
		
		slenderTPX = math.random(-slenderTPDistance, slenderTPDistance)
		slenderTPZ = math.random(-slenderTPDistance, slenderTPDistance)
		
		slendy:position(1, {slenderTPX + playerPos[1], -20, slenderTPZ + playerPos[3]})
		slendPos = {slenderTPX + playerPos[1], -20, slenderTPZ + playerPos[3]}
		
		
		slenderTPTimer:reset(0)
		slenderTPTimer:start()
	end
	
	if not page1collect then
		-- CHECK
		pos = {-795, -1433}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page1collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	if not page2collect then
		-- CHECK
		pos = {677, -1514}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page2collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	
	if not page3collect then
		-- CHECK
		pos = {1507, -1050}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page3collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	if not page4collect then
		-- CHECK
		pos = {-1627, -660}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page4collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	
	 
	
	if not page5collect then
		-- CHECK
		pos = {-706, 482}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page5collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	if not page6collect then
		-- CHECK
		pos = {400, -60}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page6collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	if not page7collect then
		-- CHECK
		pos = {-450, -208}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page7collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end
	if not page8collect then
		-- CHECK
		pos = {-15, 980}
		check = true
		check = locationTestCheck(playerPos, pos, 75, 75)
		
		if not check then
			page8collect = true
			pageTimer:start()
			pageCollectEvent = true
			pagesCollected = pagesCollected + 1
		end
	end

	if bgTimer:time() >= 300000 and bgTimer:time() < 600000 and currentGameStage == 0 then
		currentGameStage = 1
		changeStage = true
	elseif bgTimer:time() >= 600000 and bgTimer:time() < 900000 and currentGameStage == 1 then
		currentGameStage = 2
		changeStage = true
	elseif bgTimer:time() >= 900000 and bgTimer:time() < 1200000 and currentGameStage == 2 then
		currentGameStage = 3
		changeStage = true
	elseif bgTimer:time() >= 1200000 and bgTimer:time() < 1500000 and currentGameStage == 3 then
		currentGameStage = 4
		changeStage = true
	end

	if changeStage then
		if currentGameStage == 1 then stage1:play(6) end
		if currentGameStage == 2 then stage2:play(6) end
		if currentGameStage == 3 then stage3:play(6) end
		if currentGameStage == 4 then stage4:play(6) end
		
		slenderTPTimer:start()
		changeStage = false
	end

	if buttons.cross or buttons.held.cross then
		playerRot[1] = playerRot[1] - 0.1 * dt
	end
	if buttons.square or buttons.held.square then
		playerRot[2] = playerRot[2] + 0.1 * dt
	end
	if buttons.circle or buttons.held.circle then
		playerRot[2] = playerRot[2] - 0.1 * dt
	end
	if buttons.triangle or buttons.held.triangle then
		playerRot[1] = playerRot[1] + 0.1 * dt
	end
	
	if playerRot[1] < -89 then
		playerRot[1] = -89
	end
	
	if playerRot[1] > 89 then
		playerRot[1] = 89
	end

	if buttons.released.r then
		if flashLightEnabled == 0 then flashLightEnabled = 1 else flashLightEnabled = 0 end
		clickfx:play(4)
	end
	
	if buttons.held.up or buttons.up or buttons.down or buttons.held.down then
		
		if not zoomPlay then
			zoomNoise:play(4)
			zoomPlay = true
		end
		
		if buttons.held.down or buttons.down then
			fovChange += 0.5
		else
			fovChange -= 0.5
		end
		
		if fovChange < -45 then
			fovChange = -45
		end
		
		if fovChange > 0 then
			fovChange = 0
		end
		
		amg.perspective(75 + fovChange)
		
	else
		zoomNoise:stop()
		zoomPlay = false
	end
	
	playerEye = {0, 0, -1}
	
	
	sinTheta = math.sin(math.rad(playerRot[2]))
	cosTheta = math.cos(math.rad(playerRot[2]))
	
	playerEye[1] = sinTheta
	playerEye[3] = cosTheta
	
	x = -playerEye[3]
	y = 0
	z = playerEye[1]
	
	playerEye2 = {0, 0, 0}
	
	sinTheta = math.sin(math.rad(playerRot[1]))
	cosTheta = math.cos(math.rad(playerRot[1]))
	
	playerEye2[1] = (cosTheta + (1 - cosTheta) * x * x)			* playerEye[1];
	playerEye2[1] += ((1 - cosTheta) * x * y - z * sinTheta)	* playerEye[2];
	playerEye2[1] += ((1 - cosTheta) * x * z + y * sinTheta)	* playerEye[3];

	playerEye2[2] = ((1 - cosTheta) * x * y + z * sinTheta)	* playerEye[1];
	playerEye2[2] += (cosTheta + (1 - cosTheta) * y * y)		* playerEye[2];
	playerEye2[2] += ((1 - cosTheta) * y * z - x * sinTheta)	* playerEye[3];

	playerEye2[3] = ((1 - cosTheta) * x * z - y * sinTheta)	* playerEye[1];
	playerEye2[3] += ((1 - cosTheta) * y * z + x * sinTheta)	* playerEye[2];
	playerEye2[3] += (cosTheta + (1 - cosTheta) * z * z)		* playerEye[3];
	
	walkSpeed = 0.02 * currentBuff * 1.3
	
	if isSprinting then
		walkSpeed = walkSpeed * 2.5 
	end
	
	newLocation = {0, 0, 0}
	newLocation[1] = playerPos[1]
	newLocation[3] = playerPos[3]

	if buttons.analogx > 40 or buttons.analogx < -40 then
		newLocation[1] = playerPos[1] - math.sin(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
		newLocation[3] = playerPos[3] - math.cos(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
	end
	if buttons.analogy > 40 or buttons.analogy < -40 then
		newLocation[1] = playerPos[1] - math.sin(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
		newLocation[3] = playerPos[3] - math.cos(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
	end
	
	-- Test Location
	locationTest = true

	if newLocation[1] > 2000 or newLocation[1] < -2000 or newLocation[3] > 2000 or newLocation[3] < -2000 then
		locationTest = false
	end
	
	
	-- Q1
	
	locationTest = locationTest and locationTestCheck(newLocation, { 380, -1770 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 580, -1880 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 790, -2000 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1090, -1910 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1160, -1590 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1400, -1650 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1390, -1840 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1410, -1470 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1610, -1430 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1850, -1430 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1910, -1780 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1690, -1750 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1760, -1970 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1910, -1190 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1780, -1000 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1964, -630 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1770, -80 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 920, -850 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 710, -880 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 705, -1055 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 463, -993 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 30, -990 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 210, -860 }, 32, 32)
	
	--Q2
	locationTest = locationTest and locationTestCheck(newLocation, { 1700, 130 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1890, 1290 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1900, 1680 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1540, 1810 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1680, 1530 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1780, 970 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1830, 480 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1230, 420 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1330, 230 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1400, 1550 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1620, 1310 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 910, 1550 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 830, 1770 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1150, 1710 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 600, 1600 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 230, 1760 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 230, 1760 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 300, 1560 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 880, 960 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1020, 680 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 740, 690 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 960, 470 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 580, 470 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 670, 240 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 1020, 240 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 0, 240 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 0, 1600 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { 120, 600 }, 32, 32)
	
	--Q3
	locationTest = locationTest and locationTestCheck(newLocation, { -80, 540 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -60, 760 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -260, 380 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -330, 690 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -330, 920 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -500, 440 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -710, 230 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -750, 1540 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -680, 1820 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -480, 1710 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -980, 1735 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1290, 1670 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1580, 1580 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1740, 1337 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1810, 1620 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1660, 1800 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1860, 920 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1860, 690 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1600, 760 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1630, 530 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1780, 370 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1740, 100 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1540, 230 }, 32, 32)
	
	--Q4
	locationTest = locationTest and locationTestCheck(newLocation, { -1450, -40 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1890, -65 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1890, -365 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1650, -200 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1900, -770 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1900, -1075 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1440, -920 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -780, -850 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -540, -990 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -290, -1060 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -290, -880 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -60, -850 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1800, -1850 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1040, -1880 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -720, -1940 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -810, -1730 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1290, -1730 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1570, -1730 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -500, -1770 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1510, -1490 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1510, -1280 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1790, -1560 }, 32, 32)
	locationTest = locationTest and locationTestCheck(newLocation, { -1680, -1150 }, 32, 32)
	
	-- LANDMARKS
	
	locationTest = locationTest and locationTestCheck(newLocation, { 680, -1540 }, 48, 48) -- Big tree
	locationTest = locationTest and locationTestCheck(newLocation, { 1505, -1110 }, 64, 128) -- Shed
	locationTest = locationTest and locationTestCheck(newLocation, { 1730, -650 }, 80, 170) -- Cybertruck #1
	locationTest = locationTest and locationTestCheck(newLocation, { -710, 500 }, 16, 16) -- LOGS
	locationTest = locationTest and locationTestCheck(newLocation, { -557, 575 }, 16, 16) -- LOGS
	locationTest = locationTest and locationTestCheck(newLocation, { -640, 770 }, 16, 16) -- LOGS
	locationTest = locationTest and locationTestCheck(newLocation, { -790, 690 }, 16, 16) -- LOGS
	locationTest = locationTest and locationTestCheck(newLocation, { -915, 860 }, 16, 16) -- LOGS
	locationTest = locationTest and locationTestCheck(newLocation, { -765, 940 }, 16, 16) -- LOGS
	
	
	locationTest = locationTest and locationTestCheck(newLocation, { -1440, 1190 }, 8, 160) -- CROSS
	locationTest = locationTest and locationTestCheck(newLocation, { -1440, 1190 }, 160, 8) -- CROSS
	
	
	locationTest = locationTest and locationTestCheck(newLocation, { -1610, 530 }, 100, 100) -- ROCKS
	locationTest = locationTest and locationTestCheck(newLocation, { -800, 1350 }, 90, 90) -- SILO
	
	
	locationTest = locationTest and locationTestCheck(newLocation, { -700, 550 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -700, 370 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -700, 210 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -700, 30 }, 150, 50) -- tanker
	
	locationTest = locationTest and locationTestCheck(newLocation, { -210, 550 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -210, 370 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -210, 210 }, 150, 50) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -210, 30 }, 150, 50) -- tanker
	
	locationTest = locationTest and locationTestCheck(newLocation, { -460, 50 }, 50, 150) -- tanker
	locationTest = locationTest and locationTestCheck(newLocation, { -460, 500 }, 50, 150) -- tanker
	
	--Bathrooms!
	locationTest = locationTest and locationTestCheck(newLocation, { 980, -450 }, 7, 105) -- Wall type 1
	locationTest = locationTest and locationTestCheck(newLocation, { 760, -450 }, 7, 105) -- Wall type 1
	locationTest = locationTest and locationTestCheck(newLocation, { 600, -450 }, 7, 105) -- Wall type 1
	locationTest = locationTest and locationTestCheck(newLocation, { 330, -450 }, 7, 105) -- Wall type 1
	locationTest = locationTest and locationTestCheck(newLocation, { 340, -130 }, 7, 105) -- Wall type 1
	locationTest = locationTest and locationTestCheck(newLocation, { 720, -130 }, 7, 105) -- Wall type 1
	
	locationTest = locationTest and locationTestCheck(newLocation, { 480, -175 }, 7, 70) -- Wall type 2
	locationTest = locationTest and locationTestCheck(newLocation, { 845, -175 }, 7, 70) -- Wall type 2
	locationTest = locationTest and locationTestCheck(newLocation, { 840, -410 }, 7, 70) -- Wall type 2
	locationTest = locationTest and locationTestCheck(newLocation, { 470, -410 }, 7, 70) -- Wall type 2
	
	locationTest = locationTest and locationTestCheck(newLocation, { 410, -560 }, 70, 7) -- Wall type 3
	locationTest = locationTest and locationTestCheck(newLocation, { 410, -340 }, 70, 7) -- Wall type 3
	locationTest = locationTest and locationTestCheck(newLocation, { 410, -250 }, 70, 7) -- Wall type 3
	locationTest = locationTest and locationTestCheck(newLocation, { 915, -250 }, 70, 7) -- Wall type 3
	locationTest = locationTest and locationTestCheck(newLocation, { 910, -340 }, 70, 7) -- Wall type 3
	locationTest = locationTest and locationTestCheck(newLocation, { 910, -30 }, 70, 7) -- Wall type 3
	
	locationTest = locationTest and locationTestCheck(newLocation, { 640, -245 }, 80, 7) -- Wall type 4
	locationTest = locationTest and locationTestCheck(newLocation, { 680, -340 }, 80, 7) -- Wall type 4
	
	locationTest = locationTest and locationTestCheck(newLocation, { 450, -35 }, 110, 7) -- Wall type 5
	locationTest = locationTest and locationTestCheck(newLocation, { 870, -560 }, 110, 7) -- Wall type 5
	
	if locationTest then
		playerPos[1] = newLocation[1]
		playerPos[3] = newLocation[3]
	end
	
	if buttons.analogx > 40 or buttons.analogx < -40 or buttons.analogy > 40 or buttons.analogy < -40 then
		if not isWalking then
			isWalking = true
			step[math.random(1, 12)]:play(5)
			stepTimer:reset(0)
			stepTimer:start()
		end
	else
		isWalking = false
	end
	
	
	if isSprinting then
		stepTimeNeeded = 500
	else
		stepTimeNeeded = 800
	end
	
	if isWalking and stepTimer:time() > stepTimeNeeded then
		step[math.random(1, 12)]:play(5)
		stepTimer:reset(0)
		stepTimer:start()
	end
	
	if buttons.released.start then
		isSprinting = not isSprinting
	end
	
	if isWalking then
		if not isSprinting then
			stamina = stamina + 2
		end
	else
		stamina = stamina + 4
	end
	
	if isSprinting then
		stamina = stamina - 4
		
		if stamina < 500 and not isPanting then
			isPanting = true
			pant:play(2)
		end
		
		if stamina < 0 then
			stamina = 0
			isSprinting = false
		end
	end
	if stamina > 2500 then
		stamina = 2500
	end
	
	if stamina > 500 and isPanting then
		isPanting = false
		pant:stop()
	end
	
	if not scareEvent and sanity < 80.0 and sanity > 70.0 then
		scareEvent = true
	else
		scareEvent = false
	end
	
	if not scared and scareTimer:time() > scareCooldown and scareEvent then
		scareNoise:play(1)
		scared = true
		currentBuff = scareBuff
		scareEvent = false
		
		scareTimer:reset(0)
		scareTimer:start()
		
		stamina = stamina + 500
	end
	
	if scared and scareTimer:time() > scareBuffLength then
		scared = false
		currentBuff = 1
	end
	
	unitEye = {}
	unitEye[1] = playerEye2[1]
	unitEye[2] = playerEye2[2]
	unitEye[3] = playerEye2[3] 

	length = math.sqrt(playerEye2[1] * playerEye2[1] + playerEye2[2] * playerEye2[2] + playerEye2[3] * playerEye2[3])

	unitEye[1] = unitEye[1] / length
	unitEye[2] = unitEye[2] / length
	unitEye[3] = unitEye[3] / length

	playerEye[1] = playerEye2[1] + playerPos[1]
	playerEye[2] = playerEye2[2] + playerPos[2]
	playerEye[3] = playerEye2[3] + playerPos[3]
	
	cam3d.position(player, playerPos)

	flashPos = {}
	flashPos[1] = unitEye[1] + playerPos[1]
	flashPos[2] = unitEye[2] + playerPos[2]
	flashPos[3] = unitEye[3] + playerPos[3]

	amg.poslight(2, flashPos)
	flashPos[1] = unitEye[1]*9 + playerPos[1]
	flashPos[2] = unitEye[2]*9 + playerPos[2]
	flashPos[3] = unitEye[3]*9 + playerPos[3]
	amg.poslight(3, flashPos)
	flashPos[1] = unitEye[1]*18 + playerPos[1]
	flashPos[2] = unitEye[2]*18 + playerPos[2]
	flashPos[3] = unitEye[3]*18 + playerPos[3]
	amg.poslight(4, flashPos)


	cam3d.eye(player, playerEye)
	cam3d.up(player, playerUp)
	
	if sanity < 100.0 and not static:playing() then
		static:play(2)
	elseif sanity == 100.0 then
		static:stop()
	end
	
	static:vol(100 - sanity)
	
	sanity += 0.01 * dt
	
	if sanity > 100 then
		sanity = 100
	end
	
	if math.abs(slendPos[1] - playerPos[1]) < 300 and math.abs(slendPos[3] - playerPos[3]) < 300 then
		sanity -= 0.016 * dt
		if math.abs(slendPos[1] - playerPos[1]) < 50 and math.abs(slendPos[3] - playerPos[3]) < 50 then
			won = true
		end
	end
	
	end
	
	if won and not deathSound:playing() then
		sanity = 0
		static:stop()
		os.delay(100)
		deathSound:play(2)
		deathSound:vol(100)
		deathTimer:start()
	end
	
	if deathTimer:time() >= 4000 then
		endAnim = true
	end
end

while true do
	update()
	render()
	
	dt = deltaTimer:time()
	deltaTimer:reset(0)
	deltaTimer:start()
	
	if won and endAnim then
		os.exit()
	end
	
end

amg.finish()
ambient:stop()
