package extras.states;

import flixel.addons.transition.FlxTransitionableState;
import Highscore;
import Song;
import WeekData;
import lime.utils.Assets;
import HealthIcon;
import openfl.Lib;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import GameplayChangersSubstate;
import ResetScoreSubState;
import flixel.effects.FlxFlicker;
#if MODS_ALLOWED
import sys.FileSystem;
#end

class FreeplayStateCROSS extends MusicBeatState
{
	public static var instance:FreeplayStateCROSS;

	var songs:Array<SongMetadata> = [];
	public var selectedSong:Bool = false;
	var lockDiff:Bool = false;
	var selector:FlxText;

	var waitshit:FlxTimer = new FlxTimer();
	var cupTea:FlxSprite;
	var jbugWatermark:FlxSprite;

	private static var curSelected:Int = 0;

	var lerpSelected:Float = 0;
	var curDifficulty:Int = -1;

	public static var curMechDifficulty:Int = 1;
	private static var lastDifficultyName:String = Difficulty.getDefault();
	private static var lastMechDifficultyName:String = Difficulty.getDefaultMech();

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var intendedMulti:Float = 1.25 - (0.25 * curMechDifficulty);
	var multiTween:FlxTween;

	var scoreMultiplier:Float = 1.25 - (0.25 * curMechDifficulty);
	var lerpMulti:Float;
	var mechDiffText:FlxText;
	var mechDiffMult:FlxText;
	var mechDiffBG:FlxSprite;
	var mechDiffTextinfo:FlxText;

	private var grpSongs:FlxTypedSpriteGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var chromVal:Float = 0;
	var camZoom:FlxTween;

	public var camGame:FlxCamera;
	public var scoreCam:FlxCamera;

	var fuckme:Bool;

	public function new(?cupIntro=false){
		fuckme = cupIntro;
		super();
	}
	override function create()
	{
		instance = this;
		camGame = new FlxCamera();
		scoreCam = new FlxCamera();

		scoreCam.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(scoreCam, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		if(FlxG.save.data.instPrev == null){
			FlxG.save.data.instPrev = true;
			FlxG.save.flush();
		}
		if(FlxG.save.data.instPrev)
			FlxG.sound.music.stop();

		multiTween = FlxTween.tween(this, {}, 0);

		persistentUpdate = persistentDraw = true;
		WeekData.reloadWeekFiles(false);

		#if (desktop && !hl)
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

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
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedSpriteGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var isAnimated:Bool = false;
			if(songs[i].songCharacter == 'sansn')
				isAnimated = true;
			else
				isAnimated = false;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false, isAnimated);
			icon.sprTracker = songText;
			icon.playNormalAnim(true);
			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("Bronx.otf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		mechDiffBG = new FlxSprite(scoreBG.x, 67).makeGraphic(1, 66, 0xFF000000);
		mechDiffBG.alpha = 0.6;
		add(mechDiffBG);

		mechDiffTextinfo = new FlxText(mechDiffBG.x, 70, 0, "Mechanics Difficulty", 24);
		mechDiffTextinfo.font = Paths.font("Bronx.otf");
		add(mechDiffTextinfo);

		mechDiffText = new FlxText(scoreText.x, mechDiffTextinfo.y + mechDiffTextinfo.height + 2, 0, "Standrad", 24);
		mechDiffText.font = Paths.font("Bronx.otf");
		add(mechDiffText);

		mechDiffMult = new FlxText(scoreText.x + 150, mechDiffTextinfo.y + mechDiffTextinfo.height + 2, 0, "Multiplier: ", 24);
		mechDiffMult.alignment = LEFT;
		mechDiffMult.font = Paths.font("Bronx.otf");
		add(mechDiffMult);

		jbugWatermark = new FlxSprite().loadGraphic(Paths.image('J-BugWatermark', 'sans'));
		jbugWatermark.x = 930;
		jbugWatermark.y = 500;
		jbugWatermark.antialiasing = ClientPrefs.globalAntialiasing;
		jbugWatermark.setGraphicSize(Std.int(jbugWatermark.width * 0.6));
		jbugWatermark.scrollFactor.set();
		jbugWatermark.alpha = 0;
		add(jbugWatermark);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);

		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("Bronx.otf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if (curSelected >= songs.length)
			curSelected = 0;
		if (songs.length > 0)
			bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		changeSelection();

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		if(FreeplaySelectState.curSelected == 2){
		FlxG.game.filtersEnabled = ClientPrefs.shaders;
		camGame.filtersEnabled = false;
		scoreCam.filtersEnabled = false;
		
		camGame.setFilters([chromaticAberration]);
		scoreCam.setFilters([chromaticAberration]);

		FlxG.game.setFilters([chromaticAberration]);
		}

		#if PRELOAD_ALL
		#if mobile
		var leText:String = "Press X to toggel song preview - Press C to open the Gameplay Changers Menu - Press Y to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press SPACE to toggel song preview - Press CTRL to open the Gameplay Changers Menu - Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#end
		#else
		var leText:String = "Press SPACE to toggel song preview - Press CTRL to open the Gameplay Changers Menu - Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("Bronx.otf"), size, FlxColor.WHITE, LEFT);
		text.scrollFactor.set();
		text.cameras = [scoreCam];
		textBG.cameras = [scoreCam];
		add(text);

		updateTexts();

		#if mobile
		addVirtualPad(FULL, A_B_C_X_Y_Z);
		#end
		cupTea = new FlxSprite();
		cupTea.frames = Paths.getSparrowAtlas('sourcethings/the_thing2.0');
		cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
		cupTea.setGraphicSize(Std.int((FlxG.width / FlxG.camera.zoom) * 1.1), Std.int((FlxG.height / FlxG.camera.zoom) * 1.1));
		cupTea.updateHitbox();
		cupTea.screenCenter();
		cupTea.antialiasing = ClientPrefs.globalAntialiasing;
		if (PlayState.storyWeek == 0 && !PlayState.isStoryMode)
		{
			cupTea.alpha = 1;
			cupTea.animation.play('start', true);
			cupTea.animation.finishCallback = function(name)
			{
				cupTea.alpha = 0.00001;
			}
		}
		else
		{
			cupTea.alpha = 0.00001;
		}
		add(cupTea);

		scoreText.cameras = [scoreCam];
		scoreBG.cameras = [scoreCam];
		diffText.cameras = [scoreCam];
		//comboText.cameras = [scoreCam];
		jbugWatermark.cameras = [scoreCam];
		mechDiffBG.cameras = [scoreCam];
		mechDiffText.cameras = [scoreCam];
		mechDiffMult.cameras = [scoreCam];
		mechDiffTextinfo.cameras = [scoreCam];
		cupTea.cameras = [scoreCam];
		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return
			/*(!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuStateCROSS.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuStateCROSS.weekCompleted.get(leWeek.weekBefore)));*/
			false;
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
		{
			if (songCharacters == null)
				songCharacters = ['bf'];

			var num:Int = 0;
			for (song in songs)
			{
				addSong(song, weekNum, songCharacters[num]);
				this.songs[this.songs.length-1].color = weekColor;

				if (songCharacters.length != 1)
					num++;
			}
	}*/
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		//Conductor.bpm = Std.parseFloat(CoolUtil.getSongData(songs[curSelected].songName.toLowerCase(), 'bpm'));
		setChrome(chromVal);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		// intendedMulti = (1.25 - (0.25 * curMechDifficulty));
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));
		// lerpMulti = Math.floor(FlxMath.lerp(lerpMulti, intendedMulti, FlxMath.bound(elapsed * 15, 0, 1.25)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;
		/*if (Math.abs(lerpMulti - intendedMulti) <= 0.01)
				lerpMulti = intendedMulti;

			mechDiffMult.text = "Multiplier: " + lerpMulti; */

		mechDiffMult.text = "Multiplier: " + intendedMulti;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if (ratingSplit.length < 2)
		{ // No decimals, add an empty space
			ratingSplit.push('');
		}

		while (ratingSplit[1].length < 2)
		{ // Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();
		if(!selectedSong){
		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT #if mobile || virtualPad.buttonZ.pressed #end)
			shiftMult = 3;
		if (songs.length > 1)
		{
			if (FlxG.keys.justPressed.HOME)
			{
				curSelected = 0;
				changeSelection();
				holdTime = 0;
			}
			else if (FlxG.keys.justPressed.END)
			{
				curSelected = songs.length - 1;
				changeSelection();
				holdTime = 0;
			}
			if (controls.UI_UP_P)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if (controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
			}
		}
		if (!FlxG.keys.pressed.SHIFT)
		{
			if (controls.UI_LEFT_P)
			{
				changeDiff(-1);
				_updateSongLastDifficulty();
			}
			else if (controls.UI_RIGHT_P)
			{
				changeDiff(1);
				_updateSongLastDifficulty();
			}
		}
		else
		{
			if (controls.UI_LEFT_P)
				changeMechDiff(1);
			else if (controls.UI_RIGHT_P)
				changeMechDiff(-1);
		}
		if (controls.BACK #if mobile && !virtualPad.buttonC.justPressed #end)
		{
			//selectedSong = true;
			persistentUpdate = false;
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			backOut();
		}

		if (FlxG.keys.justPressed.CONTROL #if mobile || virtualPad.buttonC.justPressed #end)
		{
			#if mobile
			virtualPad.visible = false;
			#end
			FlxG.game.filtersEnabled = false;
			camGame.filtersEnabled = ClientPrefs.shaders;
			scoreCam.filtersEnabled = ClientPrefs.shaders;
			selectedSong = true;
			openSubState(new GameplayChangersSubstate());
		}
		if(FlxG.keys.justPressed.SPACE #if mobile || virtualPad.buttonX.justPressed #end){
			FlxG.save.data.instPrev = !FlxG.save.data.instPrev;
			FlxG.save.flush();
		if(FlxG.save.data.instPrev)
			changeSelection();
		 else {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 1);
		 }
		
		}
		else if (controls.ACCEPT)
		{
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
				if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
				#else
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				#end
					poop = songLowercase;
					curDifficulty = 1;
					trace('Couldnt find file');
			}*/
			//trace(poop);

			try
			{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if (colorTween != null)
				{
					colorTween.cancel();
				}
			}
			catch (e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if (errorStr.startsWith('[file_contents,assets/data/'))
					errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length - 1); // Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				updateTexts(elapsed);
				super.update(elapsed);
				return;
			}

			if (FlxG.keys.pressed.SHIFT #if mobile || virtualPad.buttonZ.pressed #end)
			{
				LoadingState.loadAndSwitchState(new ChartingState());
			}
			else
			{
				accept();
			}
			// LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
			#if (MODS_ALLOWED && cpp && !mobile)
			DiscordClient.loadModRPC();
			#end
		}
		else if (controls.RESET #if mobile || virtualPad.buttonY.justPressed #end)
		{
			#if mobile
			virtualPad.visible = false;
			#end
			FlxG.game.filtersEnabled = false;
			camGame.filtersEnabled = ClientPrefs.shaders;
			scoreCam.filtersEnabled = ClientPrefs.shaders;
			selectedSong = true;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
	}
		updateTexts(elapsed);
		super.update(elapsed);
	}

	function changeDiff(change:Int = 0)
	{
		if (!selectedSong && !lockDiff)
		{
			curDifficulty += change;

			if (curDifficulty < 0)
				curDifficulty = Difficulty.list.length - 1;
			if (curDifficulty >= Difficulty.list.length)
				curDifficulty = 0;

			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
			#end

			lastDifficultyName = Difficulty.getString(curDifficulty);
			if (Difficulty.list.length > 1)
				diffText.text = '< ' + lastDifficultyName.toUpperCase() + ' >';
			else
				diffText.text = lastDifficultyName.toUpperCase();

			positionHighscore();
			missingText.visible = false;
			missingTextBG.visible = false;
		}
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (!selectedSong)
		{
			_updateSongLastDifficulty();
			if (playSound)
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

			var lastList:Array<String> = Difficulty.list;
			curSelected += change;

			if (curSelected < 0)
				curSelected = songs.length - 1;
			if (curSelected >= songs.length)
				curSelected = 0;

			var newColor:Int = (songs.length > 0) ? songs[curSelected].color : 0xFFFFFFFF;
			if (newColor != intendedColor)
			{
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				intendedColor = newColor;
				colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
					onComplete: function(twn:FlxTween)
					{
						colorTween = null;
					}
				});
			}

			// selector.y = (70 * curSelected) + 30;

			var bullShit:Int = 0;

			for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}

			if (iconArray.length > 0)
				iconArray[curSelected].alpha = 1;

			for (item in grpSongs.members)
			{
				bullShit++;
				item.alpha = 0.6;
				if (item.targetY == curSelected)
					item.alpha = 1;
			}

			Paths.currentModDirectory = songs[curSelected].folder;
			PlayState.storyWeek = songs[curSelected].week;
			trace('current week int: ' + PlayState.storyWeek);
			Difficulty.loadFromWeek();

			var savedDiff:String = songs[curSelected].lastDifficulty;
			var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
			if (savedDiff != null && !lastList.contains(savedDiff) && Difficulty.list.contains(savedDiff))
				curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
			else if (lastDiff > -1)
				curDifficulty = lastDiff;
			else if (Difficulty.list.contains(Difficulty.getDefault()))
				curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
			else
				curDifficulty = 0;

			if (songs[curSelected].songName.toLowerCase() == "bad-to-the-bone")
				{
					jbugWatermark.alpha = 1;
				}
				else
				{
					jbugWatermark.alpha = 0;
				}
			changeMechDiff();
			changeDiff();
			checkCustom();
			_updateSongLastDifficulty();
			if(FlxG.save.data.instPrev){
			Conductor.bpm = Std.parseFloat(CoolUtil.getSongData(songs[curSelected].songName.toLowerCase(), 'bpm'));
			trace('song name:' + songs[curSelected].songName.toLowerCase()
				  +'\n bpm: ' + Conductor.bpm);
				  FlxG.sound.music.stop();
				waitshit.cancel();
				waitshit.start(0.4, function(tmr:FlxTimer)
				{
					FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1);
					FlxG.sound.music.resume();
				});
			}

		}
	}

	inline private function _updateSongLastDifficulty()
	{
		if (songs.length > 0)
			songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty);
	}

	private function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;

		mechDiffText.x = scoreText.x;
		mechDiffTextinfo.x = scoreText.x;
		mechDiffBG.scale.x = scoreBG.scale.x;
		mechDiffBG.x = scoreBG.x;
		/*intendedMulti.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		intendedMulti.x -= diffText.width / 2;*/
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];

	public function updateTexts(elapsed:Float = 0.0)
	{
		if(!selectedSong){
		lerpSelected = FlxMath.lerp(lerpSelected, curSelected, FlxMath.bound(elapsed * 9.6, 0, 1));
		for (i in _lastVisibles)
		{
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
			iconArray[i].visible = iconArray[i].active = false;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max)
		{
			var item:Alphabet = grpSongs.members[i];
			item.visible = item.active = true;
			item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
			item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = true;
			_lastVisibles.push(i);
			}
		}
	}

	function changeMechDiff(?change:Int = 0)
	{
		var oldShit = 1.25 - (0.25 * curMechDifficulty);
		if (!selectedSong)
		{
			mechDiffBG.visible = true;
			mechDiffTextinfo.visible = true;
			mechDiffText.visible = true;
			mechDiffMult.visible = true;

			curMechDifficulty += change;

			if (FreeplaySelectState.curSelected == 2) // enforce hard and hell only
			{
				if (curMechDifficulty < 0)
					curMechDifficulty = 1;
				if (curMechDifficulty > 1)
					curMechDifficulty = 0;
			}
			else
			{
				if (curMechDifficulty < 0)
					curMechDifficulty = 2;
				if (curMechDifficulty > 2)
					curMechDifficulty = 0;
			}

			if (CoolUtil.getSongData(songs[curSelected].songName.toLowerCase(), 'hasmech') == "false")
			{
				mechDiffBG.visible = false;
				mechDiffTextinfo.visible = false;
				mechDiffText.visible = false;
				mechDiffMult.visible = false;
			}

			switch (curMechDifficulty)
			{
				case 2:
					mechDiffText.text = Difficulty.mechanicsList[0];
					mechDiffText.color = FlxColor.GRAY;
					mechDiffText.borderStyle = SHADOW;
				case 1:
					mechDiffText.text = Difficulty.mechanicsList[1];
					mechDiffText.color = 0xFFFB195F;
					mechDiffText.borderStyle = OUTLINE_FAST;
				case 0:
					mechDiffText.text = Difficulty.mechanicsList[2];
					mechDiffText.color = 0xFFC708FE;
					mechDiffText.borderStyle = OUTLINE;

			}
			multiTween.cancel();
			multiTween = FlxTween.num(intendedMulti, 1.25 - (0.25 * curMechDifficulty), 0.3, {ease: FlxEase.cubeInOut}, function(v:Float)
			{
				intendedMulti = CoolUtil.floorDecimal(v, 2);
			});
		}
	}

	override function beatHit() {
		super.beatHit();
		if(FlxG.save.data.instPrev && !selectedSong)
		bopOnBeat();
	}

	public function bopOnBeat()
		{
			if(curBeat % 1 == 0){
				// camZoom.cancel();
				FlxG.camera.zoom += 0.030;
				camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2);
			}
			if(curBeat % 2 == 0){
				camZoom.cancel();
				FlxG.camera.zoom += 0.045;
				camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2);
			if (songs[curSelected].songName.toLowerCase() == 'bad-time' && ClientPrefs.flashing)
				FlxG.camera.shake(0.015 * 1.3, 0.2);
				}	
	
				if (FreeplaySelectState.curSelected == 2)
				{
					if (chromVal == 0)
					{
						chromVal = (FlxG.random.float(0.03, 0.10) * 2);
						FlxTween.tween(this, {chromVal: 0}, (FlxG.random.float(0.05, 0.2) * 2), {ease: FlxEase.expoOut}); // added easing to it, dunno if it looks better
					}
				}
		}

	function backOut()
		{
			if (!selectedSong)
			{
				selectedSong = true;
				if(FlxG.save.data.instPrev)
				FlxG.sound.music.stop();
				waitshit.cancel();		
				FlxTween.tween(scoreCam, {alpha: 0}, 0.5);	
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false);
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new FreeplaySelectState(FlxG.save.data.instPrev));
				});
			}
		}
	function accept()
		{
			persistentUpdate = true;
			if (!selectedSong)
			{
				selectedSong = true;
		
				FlxG.sound.music.stop();
				waitshit.cancel();
	
				var waitDuration:Float = 1;
	
				if (iconArray[curSelected].getCharacter().contains('cup')
					|| iconArray[curSelected].getCharacter().contains('devil'))
				{
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					waitDuration = 1.1;
					cupTea.alpha = 1;
					cupTea.animation.play('start', true, true);
					FlxG.sound.play(Paths.sound('boing', 'cup'), 1);
				}
				else
					{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					scoreCam.alpha = 0;
					for (i in 0...grpSongs.members.length)
					{
						if (i == curSelected)
						{
							FlxFlicker.flicker(grpSongs.members[i], 1, 0.06, false, false);
							FlxFlicker.flicker(iconArray[i], 1, 0.06, false, false);
						}
						else
						{
							FlxTween.tween(grpSongs.members[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
							FlxTween.tween(iconArray[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
						}
					}
				}
	
				var poop:String = Highscore.formatSong(songs[curSelected].songName, curDifficulty);
				trace(poop);
		
				//HelperFunctions.checkExistingChart(songs[curSelected].songName, poop);
	
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				if(curMechDifficulty == 0) {
					PlayState.mechsDifficulty = 2;
					PlayState.scoreMuti = 1.25 - (0.25 * 2);
				} else if(curMechDifficulty == 2) {
					PlayState.mechsDifficulty = 0;
					PlayState.scoreMuti = 1.25 - (0.25 * 0);
				} else {
					PlayState.mechsDifficulty = curMechDifficulty;
					PlayState.scoreMuti = 1.25 - (0.25 * curMechDifficulty);
				}
		
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.target = new PlayState();
				LoadingState.stopMusic = true;
				
				//PlayState.playCutscene = false;
				StoryMenuStateCROSS.leftDuringWeek = false;
	
				new FlxTimer().start(waitDuration, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new LoadingState());
				});
		}
	}

	function checkCustom()
		{
			switch (songs[curSelected].songName.toLowerCase())
			{
				case 'nightmare-run' | 'final-stretch' | 'burning-in-hell':
					lockDiff = true;
					if(songs[curSelected].songName.toLowerCase() == 'nightmare-run')
						curDifficulty = 2;
					diffText.color = 0xfc0303;	
					diffText.borderStyle = OUTLINE_FAST;
				case 'bad-time':
					lockDiff = true;
					diffText.text = 'genocidal';
					diffText.color = 0x66ffff;
					diffText.borderStyle = OUTLINE;
				case 'devils-gambit':
					lockDiff = true;
					diffText.text = 'devilish';
					diffText.color = 0xe4fc2981;
					diffText.borderStyle = OUTLINE;
				case 'despair':
					lockDiff = true;
					diffText.text = 'demonic';
					diffText.color = 0xE9EDD223;
					diffText.borderStyle = OUTLINE;
				default:
					lockDiff = false;
					changeDiff();
					diffText.color = FlxColor.WHITE;
					diffText.borderStyle = NONE;
			}
		}
}