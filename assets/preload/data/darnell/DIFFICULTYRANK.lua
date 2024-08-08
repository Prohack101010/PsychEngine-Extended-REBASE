-- RANK ONLY UP TILL 20, 0 MINIMUM, CHANGE THIS TO SUGGEST HOW HARD THE SONG IS, BY MARKEDAMAN

function onCreate()
if difficulty == 0 then -- easy
rank = 4
elseif difficulty == 1 then -- normal
rank = 5
elseif difficulty == 2 then -- hard
rank = 6
elseif difficulty == 3 then -- erect
rank = 0
elseif difficulty == 4 then -- nightmare
rank = 0
end
end



function onCreatePost()
if not hideHud then
if rank > 10 then
    makeLuaSprite('star', 'star2', 1070, 590)
    makeAnimatedLuaSprite('starFlame', 'starFlame', 1030, 440)
    addAnimationByPrefix('starFlame', 'starFlame', 'fire loop full instance', 24, true)
    setProperty('starFlame.alpha', 0)
    scaleObject('starFlame', 1.5, 1.5)
    setObjectCamera('starFlame', 'hud')
    addLuaSprite('starFlame', true)
    elseif rank <= 10 then
    makeLuaSprite('star', 'star1', 1070, 590)
    end

    scaleObject('star', 0.9, 0.9)
    setObjectCamera('star', 'hud')
    setObjectOrder('star', getObjectOrder('starFlame') + 1)
    setProperty('star.alpha', 0)
    addLuaSprite('star')

makeLuaText('difficulty', ''.. rank ..'', 2230 , 0, 620)
setTextSize('difficulty', 37)
setTextFont('difficulty', 'combo.ttf')
setProperty('difficulty.alpha', 0)
addLuaText('difficulty', false)
setObjectOrder('difficulty', getObjectOrder('star') + 1)

if downscroll then
    setProperty('difficulty.y', 70)
    setProperty('star.y', 40)
    setProperty('starFlame.y', -5)
    setProperty('starFlame.angle', 190)
  end



if rank > 10 then
    setTextColor('difficulty', 'ffffff')
    setTextBorder('difficulty', 2, '00AEFF')
    elseif rank <= 10 then
    setTextColor('difficulty', '000000')
    setTextBorder('difficulty', 3, 'FFFFFF')
    end


runTimer('ready', 0.5) -- star fade in
runTimer('wait', 8) -- star fade out
runTimer('wait2', 7.5) -- difficulty fade out

if rank > 10 then
runTimer('pausefire', 2) -- difficulty fade in
elseif rank <=10 then
runTimer('pause', 2)
end
end
end

function onTimerCompleted(tag)
if not hideHud then
if tag == 'ready' then
doTweenAlpha('hi', 'star', 1, 0.5,'linear')
end
if tag == 'wait' then
doTweenAlpha('gone', 'star', 0, 0.5,'linear')
doTweenAlpha('fireout', 'starFlame', 0, 0.5,'linear')
end
if tag == 'wait2' then
doTweenAlpha('bye', 'difficulty', 0, 0.5,'linear')
end
if tag == 'pause' then
doTweenAlpha('hi2', 'difficulty', 1, 0.5,'linear')
end
if tag == 'pausefire' then
setProperty('difficulty.alpha', 1)
setProperty('starFlame.alpha', 1)
playSound('light', 0.7)
end
end
end
