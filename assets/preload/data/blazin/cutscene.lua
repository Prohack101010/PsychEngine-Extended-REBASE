

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('2hotCutscene');
		seenCutscene = true
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onEndSong()
    if isStoryMode and not seenCutscene1 then
        startVideo('blazinCutscene')
        seenCutscene1 = true
        return Function_Stop
    end
    return Function_Continue
end
