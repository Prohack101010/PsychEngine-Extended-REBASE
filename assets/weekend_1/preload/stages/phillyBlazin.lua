function onCreate()
	makeLuaAssetSprite('skyAdditive', 'phillyBlazin/skyBlur', -600, -175);
	scaleObject('skyAdditive', 1.75, 1.75);
	setScrollFactor('skyAdditive', 0, 0);
	
	makeAnimatedLuaAssetSprite('lightning', 'phillyBlazin/lightning', 50, -300);
	addAnimationByPrefix('lightning', 'strike', 'lightning0', 24, false);
	setProperty('lightning.flipX', false);
	scaleObject('lightning', 1.75, 1.75);
	setScrollFactor('lightning', 0, 0);
	setProperty('lightning.alpha', 0);
	runTimer('lightningTimer', getRandomInt(7, 15));
	
	makeLuaAssetSprite('phillyForegroundCity', 'phillyBlazin/streetBlur', -600, -175);
	scaleObject('phillyForegroundCity', 1.75, 1.75);
	setScrollFactor('phillyForegroundCity', 0, 0);
	
	makeLuaAssetSprite('foregroundMultiply', 'phillyBlazin/', -600, -175);
	scaleObject('foregroundMultiply', 1, 1);
	setScrollFactor('foregroundMultiply', 1, 1);
	
	makeLuaAssetSprite('additionalLighten', 'empty', -600, -175);
	makeGraphic('additionalLighten', 2500, 2500, 'FFFFFF');
	setScrollFactor('additionalLighten', 0, 0);
	setProperty('additionalLighten.alpha', 0);

	addLuaSprite('skyAdditive', false);
	addLuaSprite('lightning', false);
	addLuaSprite('phillyForegroundCity', false);
	addLuaSprite('foregroundMultiply', false);
	addLuaSprite('additionalLighten', false);
	
    triggerEvent('Set Camera Target', '2,125,-100', '')
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

local usingTween = false

function onEvent(eventName, value1, value2, strumTime)
    if eventName == 'Set Camera Target' then
        if value1 == '' then
            setProperty('isCameraOnForcedPos', false)
        else
            local targetData = stringSplit(value1, ',')
            if targetData[1] == '0' or string.lower(targetData[1]) == 'bf' or string.lower(targetData[1]) == 'boyfriend' then
                targetX = getMidpointX('boyfriend') - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]') - 100
                targetY = getMidpointY('boyfriend') + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]') - 100
            elseif targetData[1] == '1' or string.lower(targetData[1]) == 'dad' or string.lower(targetData[1]) == 'opponent' then
                targetX = getMidpointX('dad') + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]') + 150
                targetY = getMidpointY('dad') + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]') - 100
            elseif targetData[1] == '2' or string.lower(targetData[1]) == 'gf' or string.lower(targetData[1]) == 'girlfriend' then
                targetX = getMidpointX('gf') + getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]')
                targetY = getMidpointY('gf') + getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]')
            else
                targetX = 0
                targetY = 0
            end
            if targetData[2] ~= nil then
                targetX = targetX + tonumber(targetData[2])
                if targetData[3] ~= nil then
                    targetY = targetY + tonumber(targetData[3])
                end
            end

            cancelTween('moveCamera')
            if value2 == '' then
                usingTween = false
                setProperty('camFollow.x', targetX)
                setProperty('camFollow.y', targetY)
                setProperty('isCameraOnForcedPos', true)
            else
                local tweenData = stringSplit(value2, ',')
                if tweenData[1] == '0' then
                    setProperty('camGame.followLerp', 1000)
                    setProperty('camFollow.x', targetX)
                    setProperty('camFollow.y', targetY)
                else
                    usingTween = true
                    local tweenData = stringSplit(value2, ',')
                    local duration = stepCrochet * tonumber(tweenData[1]) / 1000
                    if tweenData[2] == nil then
                        tweenData[2] = 'linear'
                    end
                    startTween('moveCamera', 'camFollow', {x = targetX, y = targetY}, duration, {ease = tweenData[2]})
                end
                setProperty('isCameraOnForcedPos', true)
            end
        end
    end   
end

function onTweenCompleted(tag)
    if tag == 'moveCamera' then
        usingTween = false
    end
end

function onUpdatePost(elapsed)
    if usingTween == true then
        setProperty('camGame.followLerp', 1000)
    end
end