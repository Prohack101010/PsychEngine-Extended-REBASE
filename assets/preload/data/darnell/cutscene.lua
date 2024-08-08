local cutscene = true
local neneIdle = true
local video = true
local cutscene1 = true

function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'pico-dead')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pico')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameplay/gameover/gameOver-pico')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameplay/gameover/gameOverEnd-pico')
	setPropertyFromClass('PauseSubState', 'songName', 'breakfast-pico/breakfast-pico')

	makeAnimatedLuaSprite('PicoBullet', 'PicoBullet', 2100, 850);
	addAnimationByPrefix('PicoBullet', 'Pop', 'Pop', 24, false);
	setProperty('PicoBullet.flipX', false);
	scaleObject('PicoBullet', 1, 1);
	setScrollFactor('PicoBullet', 1, 1);
	setProperty('PicoBullet.alpha', 1);

	makeAnimatedLuaSprite('spraypaintExplosionEZ', 'spraypaintExplosionEZ', 1000, 150);
	addAnimationByPrefix('spraypaintExplosionEZ', 'explosion', 'explosion round 1 short', 24, false);
	setProperty('spraypaintExplosionEZ.flipX', false);
	scaleObject('spraypaintExplosionEZ', 1, 1);
	setScrollFactor('spraypaintExplosionEZ', 1, 1);
	setProperty('spraypaintExplosionEZ.alpha', 0);
	addLuaSprite('spraypaintExplosionEZ', true);

	makeLuaSprite('cutsceneShootBlack', 'empty', 0, 0);
	makeGraphic('cutsceneShootBlack', 3000, 2000, '000000');
	setProperty('cutsceneShootBlack.alpha', 0);
	addLuaSprite('cutsceneShootBlack', false);

	makeLuaSprite('cutsceneOpenBlack', 'empty', 0, 0);
	makeGraphic('cutsceneOpenBlack', 1280, 720, '000000');
	setObjectCamera('cutsceneOpenBlack', 'other');
	setProperty('cutsceneOpenBlack.alpha', 1);

	makeLuaText('cutText', '[SPACE] to Start', 300, 500, 700)
	setTextSize('cutText', 17);
	setTextFont('cutText', 'vcr2.ttf')
	addLuaText('cutText')

	if isStoryMode then
	setProperty('skipText.visible', false)
	end

	if not isStoryMode then
	setProperty('cutText.visible', false)
	end

	if cutscene and isStoryMode and not seenCutscene then
		addLuaSprite('cutsceneOpenBlack', true);
	else
		triggerEvent("Change Character", 'bf', 'pico-playable')
	end
end

function onUpdate()
if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and isStoryMode and cutscene1 or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and cutscene1 and isStoryMode then
runTimer('videoWait', 2);
setProperty('cutText.visible', false)
cutscene1 = false
return Function_Continue;
end
end

function onStartCountdown()
if isStoryMode then
	if cutscene and not seenCutscene then
		doTweenAlpha('GUItween', 'camHUD', 0, 0.1, 'linear');
		triggerEvent('Camera Follow Pos', 1500, 900)
		if video then
			startVideo('darnellCutscene');
			runTimer('video', 87); --86
			video = false
		end
		return Function_Stop;
	end
	if not cutscene then
		doTweenAlpha('GUItween', 'camHUD', 1, 0.5, 'linear');
		playAnim('boyfriend', 'return', false);
	runHaxeCode([[
	var cameraTwn:FlxTween;
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 0.77}, 2, {ease: FlxEase.sineInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		]])
		return Function_Continue;
	end
end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'video' and cutscene then
		triggerEvent('Camera Follow Pos', 1500, 900)
		runTimer('videoWait', 2);
	end
	if tag == 'videoWait' and cutscene then
		playMusic('darnellCanCutscene/darnellCanCutscene', 1, false)
		doTweenAlpha('GUItween', 'camHUD', 0, 0.1, 'linear');
		triggerEvent('Camera Follow Pos', 1500, 900)
		runTimer('startSong', 9.2);
		runTimer('darnellAnim1', 4.2);
		runTimer('cameraTween', 1);
		runTimer('neneIdle1', 0.6);
		playAnim('gf', 'danceRight', false);
		playAnim('boyfriend', 'pissed', false);
		doTweenAlpha('cutsceneOpenBlack', 'cutsceneOpenBlack', 0, 1, 'linear')
		runHaxeCode([[
			FlxG.camera.zoom = 0.7
		]])
	end
	if tag == 'cameraTween' and cutscene and isStoryMode then
	triggerEvent('Camera Follow Pos', 1500, 900)
		runHaxeCode([[
	var cameraTwn:FlxTween;
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 0.7}, 3, {ease: FlxEase.sineInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		]])
	end
	if tag == 'neneIdle1' and cutscene and neneIdle == true then
		playAnim('gf', 'danceLeft', false);
		runTimer('neneIdle2', 0.6);
	end
	if tag == 'neneIdle2' and cutscene and neneIdle == true then
		playAnim('gf', 'danceRight', false);
		runTimer('neneIdle1', 0.6);
	end
	if tag == 'darnellAnim1' and cutscene then
		playAnim('dad', 'lightCan', false);
		playSound('Darnell_Lighter', 1)
		runTimer('picoAnim1', 1);
	end
	if tag == 'picoAnim1' and cutscene then
		triggerEvent('Camera Follow Pos', 1700, 900)
		setProperty('cutText.visible', false)
		playAnim('boyfriend', 'cock', false);
		playSound('Gun_Prep', 1)
		addLuaSprite('PicoBullet', true);
		runTimer('darnellAnim2', 0.3);
	end
	if tag == 'darnellAnim2' and cutscene then
		playAnim('dad', 'kickCan', false);
		playSound('Kick_Can_UP', 1)
		playAnim('cutsceneSpraycan', 'i', false);
		setProperty('cutsceneSpraycan.alpha', 1);
		runTimer('darnellAnim3', 0.3);
	end
	if tag == 'darnellAnim3' and cutscene then
		playAnim('dad', 'kneeCan', false);
		playSound('Kick_Can_FORWARD', 1)
		runTimer('picoAnim2', 0.3);
	end
	if tag == 'picoAnim2' and cutscene then
		triggerEvent('Camera Follow Pos', 1500, 900)
		setProperty('spraypaintExplosionEZ.alpha', 1);
		playAnim('spraypaintExplosionEZ', 'explosion', true);
		playAnim('boyfriend', 'shoot');
		setProperty('cutsceneShootBlack.alpha', 1);
		doTweenAlpha('cutsceneShootBlack', 'cutsceneShootBlack', 0, 1, 'linear')
		playAnim('boyfriend', 'return', false);
		playSound('shot'..getRandomInt(1, 3), 1)
		runTimer('cutsceneLaugh', 0.5);
		runTimer('picoReturn', (1/24)*139);
	end
	if tag == 'cutsceneLaugh' and cutscene then
		neneIdle = false
		playAnim('dad', 'laughCutscene', false);
		playAnim('gf', 'laughCutscene', false);
		playSound('cutscene/darnell_laugh', 1)
		playSound('cutscene/nene_laugh', 1)
	end
	if tag == 'startSong' and cutscene then
		cutscene = false
		doTweenAlpha('GUItween', 'camHUD', 1, 0.5, 'linear');
		setProperty('skipText.visible', true)
		startCountdown()
	end
	if tag == 'picoReturn' then
		triggerEvent("Change Character", 'bf', 'pico-playable')
		doTweenAlpha('GUItween', 'camHUD', 1, 0.5, 'linear');
	end
end
