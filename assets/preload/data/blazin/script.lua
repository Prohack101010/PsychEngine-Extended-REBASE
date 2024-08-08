function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'pico-blazin-dead')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameplay/gameover/fnf_loss_sfx-pico-gutpunch')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameplay/gameover/gameOver-pico')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameplay/gameover/gameOverEnd-pico')
	setPropertyFromClass('PauseSubState', 'songName', 'breakfast-pico/breakfast-pico')

	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes',i,'x', -630)
	end
end

function onUpdate()
	noteTweenX("NoteMove1", 0, -150, 0.01, cubeInOut)
	noteTweenX("NoteMove2", 1, -150, 0.01, cubeInOut)
	noteTweenX("NoteMove3", 2, -150, 0.01, cubeInOut)
	noteTweenX("NoteMove4", 3, -150, 0.01, cubeInOut)

	noteTweenX("NoteMove5", 4, 412, 0.01, cubeInOut)
	noteTweenX("NoteMove6", 5, 524, 0.01, cubeInOut)
	noteTweenX("NoteMove7", 6, 636, 0.01, cubeInOut)
	noteTweenX("NoteMove8", 7, 748, 0.01, cubeInOut)

end
