package extras.states;

import flixel.util.FlxSpriteUtil;
import flixel.addons.transition.FlxTransitionableState;

import haxe.Json;
import haxe.ds.ArraySort;

import sys.thread.Thread;
import sys.thread.Mutex;

import openfl.filters.BlurFilter;
import openfl.filters.GlowFilter;

import WeekData;
import Highscore;
import Song;

import HealthIcon;
import objects.shape.ShapeEX;
import objects.shape.FreeplayShape;
import FreeplayState.SongMetadata;

import GameplayChangersSubstate;
import ResetScoreSubState;

import MainMenuState;
import PlayState;
import LoadingState;
import editors.ChartingState;
import options.OptionsState;

/*
    Note: This backport only supports Psych Extended
    Backported by KralOyuncu 2010x
*/

class FreeplayStateNOVA extends MusicBeatState
{
	static public var instance:FreeplayStateNOVA;

	var selector:FlxText;
	static public var curSelected:Int = 0;
	private static var position:Float = 360 - 45;
	private static var lerpPosition:Float = 360 - 45;
	private static var diffPosition:Float = 0;
	private static var diffLerpPosition:Float = 0;
	static public var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	public var grpSongs:Array<SongRect> = [];
	public var saveGrpSongs:Array<SongRect> = [];
	public var songs:Array<SongMetadata> = [];
	public var saveSongs:Array<SongMetadata> = [];
	public var sortSongs:Array<SongMetadata> = [];

	var camGame:FlxCamera;
	var camAudio:FlxCamera;
	var camUI:FlxCamera;
	var camHS:FlxCamera;

	var magenta:FlxSprite;
	var intendedColor:Int;

	var smallMag:SpecRect;

	var extraAudio:ExtraTopRect;
	var extraHS:ExtraTopRect;

	var instDis:ExtraAudio;
	var voiceDis:ExtraAudio;
	var voiceLine:MusicLine;

	var infoRating:InfoText;
	var infoNote:InfoText;
	var infoSpeed:InfoText;

	var optionEvent:EventRect;
	var modsEvent:EventRect;
	var randomEvent:EventRect;
	var resetEvent:EventRect;
	var editorEvent:EventRect;
	var eventArray:Array<EventRect> = [];

	var playButton:PlayRect;
	var backButton:BackRect;

	var disLine:Rect;

	public static var vocals:FlxSound = null;

	override function create()
	{
		super.create();

		instance = this;

        #if deskop
		FlxG.mouse.visible = true;
		#end

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = initPsychCamera();

		for (i in 0...WeekData.weeksList.length)
		{
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}

		sortSongs = songs.copy();
		saveSongs = songs.copy();

		ArraySort.sort(sortSongs, function(a:SongMetadata, b:SongMetadata) {
			return Reflect.compare(a.songName.toLowerCase(), b.songName.toLowerCase());
		});

		WeekData.loadTheFirstEnabledMod();
		
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scale.x = FlxG.width * 1.05 / magenta.width;
		magenta.scale.y = FlxG.height * 1.05 / magenta.height;
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		add(magenta);

		var specBG:SpecRectBG = new SpecRectBG(0, 0);
		specBG.alpha = 0.3;
		add(specBG);

		for (i in 0...songs.length)
		{
			Paths.currentModDirectory = songs[i].folder;
			
			var songRect:SongRect = new SongRect(660, 50 + i * 100, songs[i].songName, songs[i].songCharacter, songs[i].color);
			add(songRect);
			songRect.member = i;
			grpSongs.push(songRect);

			if (i == curSelected) songRect.lerpPosX = songRect.posX;
		}

		saveGrpSongs = grpSongs.copy();
			
		WeekData.setDirectoryFromWeek();

		var upBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height * 0.25), FlxColor.BLACK);
		upBG.alpha = 0.7;
		add(upBG);

		var searchMenu:SearchButton = new SearchButton(640, 20, FlxG.width - 640 - 20, 80);
		add(searchMenu);

		smallMag = new SpecRect(0, 0, 'menuDesat');
		add(smallMag);

		var infoBG:Rect = new Rect(12, FlxG.height * 0.42, FlxG.width * 0.45 - 12, FlxG.height * 0.15, 20, 20, FlxColor.BLACK, 0.5);
		add(infoBG);

		infoSpeed = new InfoText(infoBG.x + 15, infoBG.y + 7, "speed", 5);
		add(infoSpeed);
		infoSpeed.data = 5;

		infoNote = new InfoText(infoBG.x + 15, infoBG.y + 38, "note count", 5);
		add(infoNote);
		infoNote.data = 5;

		infoRating = new InfoText(infoBG.x + 15, infoBG.y + 70, "rating", 5);
		add(infoRating);
		infoRating.data = 5;

		var extraBG:Rect = new Rect(12, FlxG.height * 0.585, FlxG.width * 0.45 - 12, FlxG.height * 0.3, 20, 20, FlxColor.BLACK, 0.5);
		add(extraBG);

		extraAudio = new ExtraTopRect(extraBG.x, extraBG.y, extraBG.width / 2, 50, 11, true, 'Audio DisPlay', 0, FlxColor.BLACK, extraChange);
		add(extraAudio);

		extraHS = new ExtraTopRect(extraBG.x + extraAudio.width, extraBG.y, extraBG.width / 2, 50, 11, false, 'History Score', 0, FlxColor.BLACK, extraChange);
		add(extraHS);

		camAudio = new FlxCamera(Std.int(extraAudio.x), Std.int(extraAudio.y + extraAudio.height), Std.int(extraBG.width), Std.int(extraBG.height - extraAudio.height));
		camAudio.bgColor = 0x00;
		camHS = new FlxCamera(Std.int(extraAudio.x), Std.int(extraAudio.y + extraAudio.height), Std.int(extraBG.width), Std.int(extraBG.height - extraAudio.height));
		camHS.bgColor = 0x00;
		FlxG.cameras.add(camAudio, false);
		FlxG.cameras.add(camHS, false);

		voiceDis = new ExtraAudio(10, 10, Std.int(camAudio.width / 2 - 20), 90, FlxG.sound.music);
		add(voiceDis);
		voiceDis.camera = camAudio;
		voiceDis.alpha = 0.7;

		instDis = new ExtraAudio(Std.int(camAudio.width) - 10 - Std.int(camAudio.width / 2 - 20), 10, Std.int(camAudio.width / 2 - 20), 90, FlxG.sound.music);
		add(instDis);
		instDis.camera = camAudio;
		instDis.alpha = 0.7;

		voiceLine = new MusicLine(10, 125, 545);
		voiceLine.camera = camAudio;
		add(voiceLine);

		var bottomBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).makeGraphic(FlxG.width, Std.int(FlxG.height * 0.1));
		bottomBG.color = FlxColor.BLACK;
		bottomBG.alpha = 0.6;
		add(bottomBG);

		optionEvent = new EventRect(270, bottomBG.y, "option", 0x63d6ff, specEvent);
		add(optionEvent);
		modsEvent = new EventRect(optionEvent.x + optionEvent.width - 1, bottomBG.y, "mods", 0xd1fc52, specEvent);
		add(modsEvent);
		randomEvent = new EventRect(modsEvent.x + modsEvent.width - 1, bottomBG.y, "random", 0x6dff6d, specEvent);
		add(randomEvent);
		resetEvent = new EventRect(randomEvent.x + randomEvent.width - 1, bottomBG.y, "reset", 0xfd6dff, specEvent);
		add(resetEvent);
		editorEvent = new EventRect(resetEvent.x + resetEvent.width - 1, bottomBG.y, "editor", 0xff617e, specEvent);
		add(editorEvent);
		eventArray.push(optionEvent);
		eventArray.push(modsEvent);
		eventArray.push(randomEvent);
		eventArray.push(resetEvent);
		eventArray.push(editorEvent);

		disLine = new Rect(0, bottomBG.y - 4, FlxG.width, 4, 0, 0, FlxColor.WHITE, 0);
		add(disLine);

		playButton = new PlayRect(FlxG.width, bottomBG.y, 200, bottomBG.height, "PLAY", 0xFC4EFF, startGame);
		add(playButton);

		backButton = new BackRect(0, bottomBG.y, 200, bottomBG.height, "BACK", 0x41E9FF, backMenu);
		add(backButton);

		changeSelection(0, false, true);
		songsRectPosUpdate(true);
	}

	override function update(elapsed:Float)
	{
		if(controls.BACK) {
			//backMenu();						
		}
		
		super.update(elapsed);

		if (vocals != null && (Math.abs(vocals.time - FlxG.sound.music.time) > 5)) {
			vocals.time = FlxG.sound.music.time;
		}

		var reduceAlpha:Bool = true;
		for (i in 0...eventArray.length){
			if (FlxG.mouse.overlaps(eventArray[i]))
			{
				eventMember = i;
				disLine.color = eventArray[i].background.color;
				disLine.alpha += elapsed * 8;
				reduceAlpha = false;
			}
		}
		if (reduceAlpha) disLine.alpha -= elapsed * 8;

		mouseMove();

		if (FlxG.mouse.x >= 660 && FlxG.mouse.x <= FlxG.width && FlxG.mouse.y >= FlxG.height * 0.25 && FlxG.mouse.y <= FlxG.height * 0.9)
		{
			position -= FlxG.mouse.wheel * 70;
			if (FlxG.mouse.pressed) 
			{
				position += moveData;
				lerpPosition = position;
				songsRectPosUpdate(true);
			}
			if (FlxG.mouse.justReleased)
			{
				position += avgSpeed * 1.5 * (0.0166 / elapsed) * Math.pow(1.1, Math.abs(avgSpeed * 0.8));
				if (Math.abs(avgSpeed * (0.0166 / elapsed)) < 3) {
					for (i in 0...grpSongs.length)
					{
						if (FlxG.mouse.overlaps(grpSongs[i]) && !grpSongs[i].ignoreCheck)
						{
							if (curSelected != i)
							{
								curSelected = i;
								changeSelection();
							}
						}
					}
				}
			}
		}

		if (position > 360 - 45) position = FlxMath.lerp(360 - 45, position, Math.exp(-elapsed * 15));
		if (position < 360 - 45 - 100 * (songs.length - 1) - Difficulty.list.length * 70) position = FlxMath.lerp(360 - 45 - 100 * (songs.length - 1) - Difficulty.list.length * 70, position, Math.exp(-elapsed * 15));

		if (Math.abs(lerpPosition - position) < 0.1) lerpPosition = position;
		else lerpPosition = FlxMath.lerp(position, lerpPosition, Math.exp(-elapsed * 15));
		
		songsRectPosUpdate(false);
	}

	override function closeSubState()
	{				
		super.closeSubState();
		persistentUpdate = true;
	}

	var pressCheck:Bool = false;
	function backMenu() {
		if (!pressCheck){
			pressCheck = true;
			if (ClientPrefs.MainMenuStyle == '0.6.3' || ClientPrefs.MainMenuStyle == 'Extended')
    			MusicBeatState.switchState(new MainMenuStateOld());
    		else
    			MusicBeatState.switchState(new MainMenuState());
		}
	}

	function startGame() {
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
		try
		{
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}
		catch(e:Dynamic)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));

			return;
		}
		destroyFreeplayVocals();
		LoadingState.loadAndSwitchState(new PlayState());
		FlxG.mouse.visible = false;
	}

	function extraChange() {
		if (FlxG.mouse.overlaps(extraHS))
		{

		} else {

		}
	}

	var eventMember:Int = -1;
	var eventPressCheck:Bool = false;
	function specEvent() {
		switch (eventMember)
		{
			case 0:
				LoadingState.loadAndSwitchState(new OptionsState());
				OptionsState.isWIPFreeplay = true;
			case 1:
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			case 2:
				randomSel();
			case 3: 
				persistentUpdate = false;
				openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			case 4:
				LoadingState.loadAndSwitchState(new ChartingState());
		}
	}

	function randomSel() {
		var data = FlxG.random.int(0, songs.length-1);
		if (curSelected != data) {
			curSelected = data;
			changeSelection(0);
		} else {
			randomSel();
		}
	}

	public static function destroyFreeplayVocals() {
		if (vocals != null) vocals.stop();
		vocals = FlxDestroyUtil.destroy(vocals);
	}

	var saveMouseY:Int = 0;
	var moveData:Int = 0;
	var avgSpeed:Float = 0;
	function mouseMove()
	{
		if (FlxG.mouse.justPressed) saveMouseY = FlxG.mouse.y;
		moveData = FlxG.mouse.y - saveMouseY;
		saveMouseY = FlxG.mouse.y;
		avgSpeed = avgSpeed * 0.75 + moveData * 0.25;
	}

	function songsRectPosUpdate(forceUpdate:Bool = false) 
	{
		if (!forceUpdate && lerpPosition == position) return; //优化
		for (i in 0...grpSongs.length){
			grpSongs[i].y = lerpPosition + i * 100 + grpSongs[i].lerpPosY;
			grpSongs[i].x = 660 + Math.abs(grpSongs[i].y + grpSongs[i].background.height / 2 - FlxG.height / 2) / FlxG.height / 2 * 250 + grpSongs[i].lerpPosX;
		}
	}

	public function changeSelection(change:Int = 0, playSound:Bool = true, start:Bool = false)
	{
		if (songs.length < 1) return;

		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length-1);
		position = 315 - 100 - curSelected * 100;
		_updateSongLastDifficulty();

		grpSongs[curSelected].onFocus = true;

		for (i in 0...grpSongs.length)
		{
			if (curSelected != i) grpSongs[i].onFocus = false;			
		}

		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();

		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor)
		{
			intendedColor = newColor;
			FlxTween.cancelTweensOf(magenta);
			FlxTween.color(magenta, 1, magenta.color, intendedColor);
		}

		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(savedDiff != null && !Difficulty.list.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if(lastDiff > -1)
			curDifficulty = lastDiff;
		else if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		updateDiff(start);
		updateRect();
		updateText();
		updateVoice();
		_updateSongLastDifficulty();
	}

	inline private function _updateSongLastDifficulty()
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty);

	function updateDiff(start:Bool = false) 
	{
		for (num in 0...grpSongs.length) 
		{
			grpSongs[num].posY = Difficulty.list.length * 70;
			if (start && num > curSelected) grpSongs[num].lerpPosY = Difficulty.list.length * 70;
		}
		
		grpSongs[curSelected].createDiff(songs[curSelected].color, start);
	}

	var rectMutex:Mutex = new Mutex();
	function updateRect() {
		magenta.loadGraphic(Paths.image('menuDesat'));
		magenta.scale.x = FlxG.width * 1.05 / magenta.width;
		magenta.scale.y = FlxG.height * 1.05 / magenta.height;
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		
		smallMag.updateRect(magenta.pixels);			
	}

	function updateText() {
		
	}

	public function updateSearch(text:String) 
	{
		if (grpSongs.length > 0) 
		{
			grpSongs[curSelected].onFocus = false;
			grpSongs[curSelected].desDiff();
		}

		songs = [];
		grpSongs = [];

		for (i in 0...saveSongs.length){
			if (saveSongs[i].songName.trim().toLowerCase().indexOf(text.trim().toLowerCase()) != -1)
			songs.push(saveSongs[i]);
		}
 
		for (rect in 0...saveGrpSongs.length)
		{
			saveGrpSongs[rect].ignoreCheck = true;
			saveGrpSongs[rect].haveAdd = false;
		}
		
		var data:Int = 0;
		for (song in 0...songs.length){
			var added:Bool = false;
			for (rect in 0...saveGrpSongs.length){
				var rect = saveGrpSongs[rect];
				if (rect.name.trim().toLowerCase() == songs[song].songName.trim().toLowerCase() && !rect.haveAdd && !added)
				{
					added = true;
					
					rect.member = data;
					rect.haveAdd = true;
					data++;
					rect.ignoreCheck = false;		
					grpSongs.push(rect);		
				}
			}
		}

		changeSelection();

		if (grpSongs[curSelected] != null)
		{
			grpSongs[curSelected].onFocus = true;
			grpSongs[curSelected].lerpPosX = grpSongs[curSelected].posX;
			grpSongs[curSelected].createDiff(songs[curSelected].color, true);
		}

		if (grpSongs.length > 0)
		{
			for (num in 0...grpSongs.length)
			{
				if (num > curSelected) grpSongs[num].lerpPosY = grpSongs[num].posY;
				else grpSongs[num].lerpPosY = 0;
			}
		}

		position = 315 - 100 - curSelected * 100;
		songsRectPosUpdate(true);

		if (songs.length > 0) updateVoice();
	}

	var musicMutex:Mutex = new Mutex();
	var timer:FlxTimer = new FlxTimer();
	function updateVoice() {
		if (timer != null) timer.cancel;

		destroyFreeplayVocals();
		FlxG.sound.music.stop();

		timer.start(0.5, function(tmr:FlxTimer){

			if (songs[curSelected] == null) return;		

			Thread.create(() -> {
				if (musicMutex.tryAcquire() == true) musicMutex.release();
				
				musicMutex.acquire();
				
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());

				if (PlayState.SONG.needsVoices)
				{
            		vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
					FlxG.sound.list.add(vocals);
					vocals.persist = vocals.looped = true;
					vocals.volume = 0.8;
				}
				else if (vocals != null)
				{
					vocals.stop();
					vocals.destroy();
					vocals = null;
				}

				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
				if (vocals != null) vocals.play();
				
				voiceDis.audioDis.changeAnalyzer(FlxG.sound.music);
				if (vocals != null) instDis.audioDis.changeAnalyzer(vocals);
				else instDis.audioDis.changeAnalyzer(FlxG.sound.music);

				musicMutex.release();
			});
		});
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}
	
}