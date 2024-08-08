function onCreatePost()
if not lowQuality then
makeLuaAssetsSprite("overlay", "shaders/street", -1000, -1250)
setProperty("overlay.alpha", 0.45)
scaleObject('overlay', 1.5, 1.5);
setBlendMode('overlay', 'normal')
addLuaSprite("overlay", true)
	end
end

function onCreate()
	makeLuaAssetsSprite('skyAdditive', 'phillyBlazin/skyBlur', -600, -175);
	scaleObject('skyAdditive', 1.75, 1.75);
	setScrollFactor('skyAdditive', 0, 0);

	makeAnimatedLuaAssetsSprite('lightning', 'phillyBlazin/lightning', 50, -300);
	addAnimationByPrefix('lightning', 'strike', 'lightning0', 24, false);
	setProperty('lightning.flipX', false);
	scaleObject('lightning', 1.75, 1.75);
	setScrollFactor('lightning', 0, 0);
	setProperty('lightning.alpha', 0);
	runTimer('lightningTimer', getRandomInt(7, 15));

	makeLuaAssetsSprite('phillyForegroundCity', 'phillyBlazin/streetBlur', -600, -175);
	scaleObject('phillyForegroundCity', 1.75, 1.75);
	setScrollFactor('phillyForegroundCity', 0, 0);

	makeLuaAssetsSprite('foregroundMultiply', 'phillyBlazin/', -600, -175);
	scaleObject('foregroundMultiply', 1, 1);
	setScrollFactor('foregroundMultiply', 1, 1);

	makeLuaAssetsSprite('additionalLighten', 'empty', -600, -175);
	makeGraphic('additionalLighten', 2500, 2500, 'FFFFFF');
	setScrollFactor('additionalLighten', 0, 0);
	setProperty('additionalLighten.alpha', 0);

	addLuaSprite('skyAdditive', false);
	addLuaSprite('lightning', false);
	addLuaSprite('phillyForegroundCity', false);
	addLuaSprite('foregroundMultiply', false);
	addLuaSprite('additionalLighten', false);
end

function onSongStart()
	setProperty('lightning.alpha', 1);
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'lightningTimer' then
		playAnim('lightning', 'strike', false);
		playSound('Lightning'..getRandomInt(1, 3), 1)
		runTimer('lightningTimer', getRandomInt(7, 15));
		setProperty('additionalLighten.alpha', 0.3);
		doTweenAlpha('additionalLighten', 'additionalLighten', 0, 1, 'linear')
	end
end

function onStartCountdown()
	setProperty('dad.scale.x', 1.75);
	setProperty('dad.scale.y', 1.75);
	setProperty('boyfriend.scale.x', 1.75);
	setProperty('boyfriend.scale.y', 1.75);
	doTweenColor('1','gf','8a8a8a', 0.1)
	doTweenColor('2','abotEyeBack','8a8a8a', 0.1)
	doTweenColor('3','abotEyes','8a8a8a', 0.1)
	doTweenColor('4','abotBG','8a8a8a', 0.1)
	doTweenColor('5','abot','8a8a8a', 0.1)
	doTweenColor('6','dad','e3e3e3', 0.1)
	doTweenColor('7','boyfriend','e3e3e3', 0.1)
end
