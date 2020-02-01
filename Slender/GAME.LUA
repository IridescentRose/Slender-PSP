amg.init()
amg.quality(__8888)
amg.renderstyle(__TRIANGLES)
amg.perspective(75)
fovChange = 0
player = cam3d.new()
cam3d.position(player,{180,180,180})

playerRot = {0, 0, 0}
playerPos = {0, 9, 0}
playerUp = {0, 5, 0}

model3d.initphysics(30)

Terrain = model3d.load("assets/model/plane.obj")
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


function render ()
	buttons.read()
	amg.begin()
	amg.gravity(0,-9.8,0)
	cam3d.set(player)

	amg.mode2d(1)
	screen.clear(color.new(0, 0, 0, 255))
	amg.mode2d(0)

	amg.light(1, 1)
	
	if currentGameStage == 1 then
		amg.fog(0.8, 240, color.new(0, 0, 0, 255))
	elseif currentGameStage == 2 then
		amg.fog(0.8, 120, color.new(0, 0, 0, 255))
	elseif currentGameStage == 3 then
		amg.fog(0.8, 60, color.new(0, 0, 0, 255))
	elseif currentGameStage == 4 then
		amg.fog(0.8, 30, color.new(0, 0, 0, 255))
	else
		amg.fog(0.8, 480, color.new(0, 0, 0, 255))
	end
	
	if bgTimer:time() < 945000 then 
		amg.light(2, flashLightEnabled)
		amg.light(3, flashLightEnabled)
		amg.light(4, flashLightEnabled)
	end
	
	model3d.render(Terrain)
	amg.light(1, 0)
	amg.light(2, 0)
	amg.light(3, 0)
	amg.light(4, 0)
	amg.fog()
	
	--On screen stuff here!
	amg.mode2d(1)
	amg.mode2d(0)

	amg.update()
	model3d.updatephysics()
	screen.flip()
end

function update ()

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
		changeStage = false
	end

	if buttons.cross or buttons.held.cross then
		playerRot[1] = playerRot[1] - 1
	end
	if buttons.square or buttons.held.square then
		playerRot[2] = playerRot[2] + 1
	end
	if buttons.circle or buttons.held.circle then
		playerRot[2] = playerRot[2] - 1
	end
	if buttons.triangle or buttons.held.triangle then
		playerRot[1] = playerRot[1] + 1
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
	
	if buttons.held.left or buttons.left or buttons.right or buttons.held.right then
		
		if not zoomPlay then
			zoomNoise:play(4)
			zoomPlay = true
		end
		
		if buttons.held.left or buttons.left then
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
	
	walkSpeed = 0.0043
	
	if isSprinting then
		walkSpeed = 0.0043 * 2.5
	end
	
	if buttons.analogx > 40 or buttons.analogx < -40 then
		playerPos[1] = playerPos[1] - math.sin(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
		playerPos[3] = playerPos[3] - math.cos(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
		
	end
	if buttons.analogy > 40 or buttons.analogy < -40 then
		playerPos[1] = playerPos[1] - math.sin(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
		playerPos[3] = playerPos[3] - math.cos(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
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
end

while true do
	update()
	render()
	
	dt = deltaTimer:time()
	deltaTimer:reset(0)
	deltaTimer:start()
end

amg.finish()
ambient:stop()