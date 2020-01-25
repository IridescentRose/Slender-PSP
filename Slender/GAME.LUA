amg.init()
amg.quality(__8888)
amg.renderstyle(__TRIANGLES)
amg.perspective(75)

player = cam3d.new()
cam3d.position(player,{180,180,180})

playerRot = {0, 0, 0}
playerPos = {0, 0, 0}
playerUp = {0, 5, 0}

model3d.initphysics(30)

Terrain = model3d.load("assets/model/plane.obj")
model3d.setphysics(Terrain,1,{0,0,0},{0,0,0},0,__CONVEX)
model3d.physics(Terrain)
model3d.position(Terrain, 1, {0, -9, 0})

ambient = sound.load("assets/sounds/ambience.mp3")
ambient:loop()
ambient:play(7)

stage1 = sound.load("assets/sounds/stage1.mp3")
stage1:loop()
stage2 = sound.load("assets/sounds/stage2.mp3")
stage2:loop()
stage3 = sound.load("assets/sounds/stage3.mp3")
stage3:loop()
stage4 = sound.load("assets/sounds/stage4.mp3")
stage4:loop()

currentGameStage = 0
changeStage = false

bgTimer:reset(0)
bgTimer:start()

amg.typelight(1,__DIRECTIONAL)
amg.colorlight(1,color.new(20,20,35),color.new(19, 19, 30),color.new(20,20,35))
amg.poslight(1,{0.5,1,0.5})

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
	model3d.render(Terrain)
	amg.light(1, 0)
	
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
	
	if buttons.analogx > 40 or buttons.analogx < -40 then
		playerPos[1] = playerPos[1] - math.sin(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
		playerPos[3] = playerPos[3] - math.cos(math.rad(playerRot[2] - 270)) * walkSpeed * dt * buttons.analogx / 128
	end
	if buttons.analogy > 40 or buttons.analogy < -40 then
		playerPos[1] = playerPos[1] - math.sin(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
		playerPos[3] = playerPos[3] - math.cos(math.rad(playerRot[2])) * walkSpeed * dt * buttons.analogy / 128
	end
	
	playerEye[1] = playerEye2[1] + playerPos[1]
	playerEye[2] = playerEye2[2] + playerPos[2]
	playerEye[3] = playerEye2[3] + playerPos[3]
	
	cam3d.position(player, playerPos)
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