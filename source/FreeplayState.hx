package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.display.FlxBackdrop;
import WeekData;
import flixel.FlxCamera;
#if MODS_ALLOWED
import sys.FileSystem;
#end

import flixel.addons.ui.FlxInputText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.ui.FlxButton;

    /*
    Song Search extend made by NF|beihu (北狐丶逐梦)
    bilbil: https://b23.tv/SnqG443
    youtube: https://youtube.com/@beihu235?si=NHnWxcUWPS46EqUt
    discord: beihu235
    
    Song Search extend adapted to 0.6.3 (partially) by KralOyuncu (Prohack101010)
    youtube1: https://youtube.com/@KralOyuncuRBX
    discord: kraloyuncuofficial
    
    you can use it but must give me credit(dont forget my icon)
    logic is very easy so I think everyone can understand it
        
    */

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	//var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';
	
	var searchInput:FlxInputText;
	var chooseBG:FlxSprite;
	
	var underline_text_BG:FlxSprite;
	var line_Right_BG:FlxSprite;
    var line_Left_BG:FlxSprite;
    var underline_BG:FlxSprite;
    var searchTextBG:FlxSprite;
    var textIntervals:FlxTypedGroup<FlxSprite>;
    var searchSongNamesTexts:FlxTypedGroup<FlxText>;
    
    var showCaseBG:FlxSprite;
    var showCaseBGLeft:FlxSprite;
    var showCaseBGUp:FlxSprite;
    var showCaseBGDown:FlxSprite;
    var showCaseText:FlxText;
    var addDataBG:FlxSprite;
    var addDataText:FlxText;
    var reduceDataBG:FlxSprite;
    var reduceDataText:FlxText;
    var centerLine:FlxSprite;
    var upLine:FlxSprite;
    var downLine:FlxSprite;
    var leftLine:FlxSprite;
    var showCaseBGTween:FlxTween;
    var addBGTween:FlxTween;
    var reduceBGTween:FlxTween;

    var searchCheck:String = ''; // update check song name change
	var lineText:FlxText;
	var notFoundSongText:FlxText;
    var notFoundSongTextSine:Float = 0;
    
    var CHsize:Int = 0; 
    var showY:Int = 0;
    var showOffset:Int = 5;

    public var lineHeight = 3;

    var songName:Array<String> = [];
	var songNum:Array<Int> = [];
    var maxUP:Int = 0;
    var maxDown:Int = 0;
    var startShow:Int = 0;
    var chooseShow:Int = 0;
    var isStart:Bool = false;
    var isEnd:Bool = false;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	
	var camGame:FlxCamera;
	var camSearch:FlxCamera;
	var camBlackFade:FlxCamera;
	
	var openSearch:Bool = false;
	var SearchTween:Array<FlxTween> = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		camGame = new FlxCamera();
		camSearch = new FlxCamera();
		camBlackFade = new FlxCamera();
		camBlackFade.bgColor.alpha = 0;
		camSearch.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);		
		FlxG.cameras.add(camSearch, false);
		FlxG.cameras.add(camBlackFade, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		camSearch.y = -300 - showOffset;
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
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
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.targetY = i - curSelected;
			//songText.screenCenter(X);
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();
		
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);

		diffText.font = scoreText.font;
		add(diffText);
		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		changeDiff();
		
		if (curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeSelection();
		
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.font = Paths.font("vcr.ttf");

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		
		var showWidth:Int = 500;
        var showHeight:Int = 300;
        var showX:Int = 180;
        showY = -1;
		
        searchTextBG = new FlxSprite(showX, showY).makeGraphic(showWidth, showHeight, FlxColor.BLACK);
		searchTextBG.alpha = 0.6;
		searchTextBG.cameras = [camSearch];

		searchInput = new FlxInputText(showX + 50, showY + 20, showWidth - 100, '', 30, 0x00FFFFFF);
		searchInput.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		searchInput.backgroundColor = FlxColor.TRANSPARENT;
		searchInput.fieldBorderColor = FlxColor.TRANSPARENT;
		searchInput.font = Paths.font("vcr.ttf");
		searchInput.antialiasing = ClientPrefs.globalAntialiasing;
		searchInput.cameras = [camSearch];
		
		lineText = new FlxText(showX + 50, showY + 20, showWidth - 100, 'Song Name For Search', 30);
		lineText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lineText.scrollFactor.set();
		lineText.alpha = 0.6;
		lineText.visible = true;
		lineText.antialiasing = ClientPrefs.globalAntialiasing;
		lineText.cameras = [camSearch];
		
		notFoundSongText = new FlxText(showX, showY + 100 + 40 * 2, showWidth, 'Not Found Song!', 30);
		notFoundSongText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		notFoundSongText.scrollFactor.set();
		notFoundSongText.antialiasing = ClientPrefs.globalAntialiasing;
		notFoundSongText.cameras = [camSearch];

        var lineHeight:Int = 3;
		underline_text_BG = new FlxSprite(showX + 50, showY + 20 + 40).makeGraphic(showWidth - 100, 6, FlxColor.WHITE);
		underline_text_BG.alpha = 0.6;
		underline_text_BG.cameras = [camSearch];
		
		line_Left_BG = new FlxSprite(showX - 3, showY).makeGraphic(lineHeight, showHeight + 3, FlxColor.WHITE);
		line_Left_BG.cameras = [camSearch];

		line_Right_BG = new FlxSprite(showX + showWidth, showY).makeGraphic(lineHeight, showHeight + 3, FlxColor.WHITE);
		line_Right_BG.cameras = [camSearch];
		
		underline_BG = new FlxSprite(showX, showY + 100).makeGraphic(showWidth , lineHeight, 0xFF00FFFF);
		underline_BG.cameras = [camSearch];
		
		chooseBG = new FlxSprite(showX, showY + 100).makeGraphic(showWidth , 40, FlxColor.WHITE);
		chooseBG.alpha = 0;
		chooseBG.cameras = [camSearch];

		textIntervals = new FlxTypedGroup<FlxSprite>();
		textIntervals.cameras = [camSearch];
		searchSongNamesTexts = new FlxTypedGroup<FlxText>();
		searchSongNamesTexts.cameras = [camSearch];

		add(searchTextBG);
		add(searchInput);
		add(chooseBG);
		add(lineText);
		add(underline_text_BG);
		add(line_Left_BG);
		add(line_Right_BG);
		add(notFoundSongText);
		add(underline_BG);
		add(textIntervals);
		add(searchSongNamesTexts);

		for (bgNum in 1...6)
		{
			var textInterval:FlxSprite = new FlxSprite(showX, showY + 100 + 40 * bgNum).makeGraphic(showWidth , lineHeight, FlxColor.WHITE);
			textInterval.ID = bgNum;
			textInterval.cameras = [camSearch];
			textIntervals.add(textInterval);
        }
        
        for (textNum in 1...6)
		{
			var searchSongNamesText:FlxText = new FlxText(showX + 5, showY + 100 + 40 * (textNum-1), 0, '', 30);
		    searchSongNamesText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		    searchSongNamesText.scrollFactor.set();
			searchSongNamesText.ID = textNum;
			searchSongNamesText.antialiasing = ClientPrefs.globalAntialiasing;
			searchSongNamesTexts.add(searchSongNamesText);
			searchSongNamesText.cameras = [camSearch];
        }
        
        CHsize = 100;
        var CH_Y:Int = 150;
        var CH_X:Int = 0;
        var text1size:Int = 50;
        var text2size:Int = 30;

        showCaseBG = new FlxSprite(FlxG.width - CHsize, CH_Y + CHsize * 2 - 50).makeGraphic(CHsize , CHsize, 0xFFFFFFFF);
		showCaseBG.alpha = 0.6;
		showCaseBG.color = 0xFF000000;
		
		showCaseBGLeft = new FlxSprite(FlxG.width - CHsize - 1, CH_Y + CHsize * 2 - 50 - 1).makeGraphic(1 , CHsize + 2, 0xFFFFFFFF);

		showCaseBGUp = new FlxSprite(FlxG.width - CHsize, CH_Y + CHsize * 2 - 50 - 1).makeGraphic(CHsize , 1, 0xFFFFFFFF);

		showCaseBGDown = new FlxSprite(FlxG.width - CHsize, CH_Y + CHsize * 2 - 50 + CHsize).makeGraphic(CHsize , 1, 0xFFFFFFFF);

		showCaseText = new FlxText(FlxG.width - CHsize, CH_Y + CHsize * 2 - 50 + CHsize / 2 - text1size / 2, CHsize, '<<', text1size);
		showCaseText.setFormat(Paths.font("vcr.ttf"), text1size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		showCaseText.scrollFactor.set();
		showCaseText.antialiasing = ClientPrefs.globalAntialiasing;

		reduceDataBG = new FlxSprite(FlxG.width, CH_Y).makeGraphic(CHsize , CHsize, 0xFFFFFFFF);
		reduceDataBG.alpha = 0.6;
		reduceDataBG.color = 0xFF000000;

		reduceDataText = new FlxText(FlxG.width, CH_Y + CHsize / 2 - text2size / 2, CHsize, 'UP', text2size);
		reduceDataText.setFormat(Paths.font("vcr.ttf"), text2size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		reduceDataText.scrollFactor.set();
		reduceDataText.antialiasing = ClientPrefs.globalAntialiasing;

		addDataBG = new FlxSprite(FlxG.width + CHsize, CH_Y).makeGraphic(CHsize , CHsize, 0xFFFFFFFF);
		addDataBG.alpha = 0.6;
		addDataBG.color = 0xFF000000;

		addDataText = new FlxText(FlxG.width + CHsize, CH_Y + CHsize / 2 - text2size / 2, CHsize, 'DOWN', text2size);
		addDataText.setFormat(Paths.font("vcr.ttf"), text2size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		addDataText.scrollFactor.set();
		addDataText.antialiasing = ClientPrefs.globalAntialiasing;
		
		centerLine = new FlxSprite(FlxG.width + CHsize - 0.5, CH_Y).makeGraphic(1 , CHsize, FlxColor.WHITE);
		upLine = new FlxSprite(FlxG.width, CH_Y - 0.5).makeGraphic(CHsize * 2, 1, FlxColor.WHITE);
		downLine = new FlxSprite(FlxG.width, CH_Y + CHsize - 0.5).makeGraphic(CHsize * 2, 1, FlxColor.WHITE);
		leftLine = new FlxSprite(FlxG.width - 0.5 + showOffset, CH_Y).makeGraphic(1 , CHsize, FlxColor.WHITE);

		add(showCaseBG);
		add(showCaseBGLeft);
		add(showCaseBGUp);
		add(showCaseBGDown);
        add(showCaseText);
        add(addDataBG);
        add(addDataText);
        add(reduceDataBG);
        add(reduceDataText);
        add(centerLine);
        add(upLine);
        add(downLine);
        add(leftLine);

		#if PRELOAD_ALL
		#if android
		var leText:String = "Press X to listen to the Song / Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#end
		#else
		var leText:String = "Press C to open the Gameplay Changers Menu / Press Y to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat("VCR OSD Mono", size, FlxColor.WHITE, CENTER);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.screenCenter(X);
		text.scrollFactor.set();
		
		add(text);

        #if android
        addVirtualPad(FULL, A_B_C_X_Y_Z);
        #end

		super.create();
		CustomFadeTransition.nextCamera = camBlackFade;
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
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

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;
			
			checkSearch(elapsed);

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE #if android || _virtualpad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			persistentUpdate = false;
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
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end){
				LoadingState.loadAndSwitchState(new ChartingState());
			}else{
				LoadingState.loadAndSwitchState(new PlayState());
			}

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		else if(controls.RESET #if android || _virtualpad.buttonY.justPressed #end)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
	
	function checkSearch(elapsed:Float)
	{
	    lineText.visible = (searchInput.text == '');		

		if (searchCheck != searchInput.text){
		    searchCheck = searchInput.text;
		    updateSearch();
		}

		if (searchInput.text != '' && songNum.length == 0){
		    notFoundSongTextSine += 180 * elapsed;
			notFoundSongText.alpha = 1 - Math.sin((Math.PI * notFoundSongTextSine) / 180);
		}
		else {
		    notFoundSongText.alpha = 0;
		}

		if (FlxG.mouse.justPressed){
		    if (FlxG.mouse.overlaps(showCaseBG)){
		        openSearchCheck();
		        showCaseBG.color = 0xFFFFFFFF;
		        if (showCaseBGTween != null) showCaseBGTween.cancel();
                showCaseBGTween = FlxTween.color(showCaseBG, 0.5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});                
		    }
		    if (FlxG.mouse.overlaps(addDataBG)){
                ChangeChoose(1);
                addDataBG.color = 0xFFFFFFFF;
                if (addBGTween != null) addBGTween.cancel();
                addBGTween = FlxTween.color(addDataBG, 0.5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});
            }    
		    if (FlxG.mouse.overlaps(reduceDataBG)){
		        ChangeChoose(-1);
		        reduceDataBG.color = 0xFFFFFFFF;
		        if (reduceBGTween != null) reduceBGTween.cancel();
		        reduceBGTween = FlxTween.color(reduceDataBG, 0.5, 0xFFFFFFFF, 0xFF000000, {ease: FlxEase.sineInOut});
		    }
		}    
		addDataBG.alpha = 0.6;
		reduceDataBG.alpha = 0.6;
		showCaseBG.alpha = 0.6;
	}

	function openSearchCheck() 
	{
	    if (!openSearch){
	        openSearch = true;
	        showCaseText.text = '>>';
	        moveSearch('open');
	    }
	    else{
	        openSearch = false;
	        showCaseText.text = '<<';
	        moveSearch('close');
	    }
	}

    function moveSearch(Type:String) 
	{
	for (i in 0...SearchTween.length){
	    if (SearchTween[i] != null) SearchTween[i].cancel();
	    } //close all move

	    var moveTime = 0.25;
	    if (Type == 'open'){
	        SearchTween[1] = FlxTween.tween(addDataBG, {x: FlxG.width - CHsize * 2}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[2] = FlxTween.tween(addDataText, {x: FlxG.width - CHsize * 2}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[3] = FlxTween.tween(reduceDataBG, {x: FlxG.width - CHsize * 1}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[4] = FlxTween.tween(reduceDataText, {x: FlxG.width - CHsize * 1}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[5] = FlxTween.tween(centerLine, {x: FlxG.width - CHsize - 0.5}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[6] = FlxTween.tween(upLine, {x: FlxG.width - CHsize * 2}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[7] = FlxTween.tween(downLine, {x: FlxG.width - CHsize * 2}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[8] = FlxTween.tween(leftLine, {x: FlxG.width - CHsize * 2 - 0.5}, moveTime, {ease: FlxEase.expoInOut});
	        
	        SearchTween[9] = FlxTween.tween(camSearch, {y: -1}, moveTime, {ease: FlxEase.expoInOut});
	        
	    }
	    else{
	        SearchTween[1] = FlxTween.tween(addDataBG, {x: FlxG.width + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[2] = FlxTween.tween(addDataText, {x: FlxG.width + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[3] = FlxTween.tween(reduceDataBG, {x: FlxG.width + CHsize + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[4] = FlxTween.tween(reduceDataText, {x: FlxG.width + CHsize + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[5] = FlxTween.tween(centerLine, {x: FlxG.width + CHsize - 0.5 + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[6] = FlxTween.tween(upLine, {x: FlxG.width + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[7] = FlxTween.tween(downLine, {x: FlxG.width + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        SearchTween[8] = FlxTween.tween(leftLine, {x: FlxG.width - 0.5 + showOffset}, moveTime, {ease: FlxEase.expoInOut});
	        
	        SearchTween[9] = FlxTween.tween(camSearch, {y: -300 - showOffset}, moveTime, {ease: FlxEase.expoInOut});
	    }
	}

	function updateSearch()
	{
	    songName = [];
	    songNum = [];
		var searchString:String = searchInput.text;
		for (i in 0...songs.length)
		{
			var name:String = songs[i].songName.toLowerCase();
			if (name.indexOf(searchString.toLowerCase()) != -1 && searchInput.text != '')
			{
				songName.push(songs[i].songName);
				songNum.push(i);
			}
		}

       if (searchInput.text != ''){
    		for (i in 0...searchSongNamesTexts.length)
    		{
    		    var numFix:Int = i + 1;
    			var songNameText:FlxText = searchSongNamesTexts.members[i];
    			if (songName[i] != null) songNameText.text = numFix + ': ' + songName[i];
    			else songNameText.text = '';
    		}
    	}	
		    else{
    		for (i in 0...searchSongNamesTexts.length)
    		{
    			var songNameText:FlxText = searchSongNamesTexts.members[i];
    			songNameText.text = '';
		    }
		}

		startShow = 0;
        chooseShow = 0;
        
        chooseBG.alpha = 0;
        chooseBG.y = showY + 100;
        
        checkPosition();
        
	}
	
		
	function ChangeChoose(change:Int = 0)
	{
	checkPosition();
	
	if (change > 0 && songNum.length != 0){
            if(!isEnd){
                if (chooseShow < maxDown) chooseShow++;
                else if (chooseShow == maxDown){
                    startShow++;
                    updateSongText();
                }
            }
            else{
                if (chooseShow < maxDown) chooseShow++;
                else if (chooseShow == maxDown){
                    startShow = 0;              
                    chooseShow = 1;
                    updateSongText();
                }
            }
        }
        
        if (change < 0 && songNum.length != 0){
            if (!isStart){
                if (chooseShow > maxUP) chooseShow--;
                else if (chooseShow == maxUP) {                
                    startShow--;
                    updateSongText();
                }
            }
            else{
                if (chooseShow > maxUP) chooseShow--;
                else if (chooseShow == maxUP){
                    if (songNum.length >= 5){
                    startShow = songNum.length - 5;
                        chooseShow = 5;
                        updateSongText();
                    }
                    else{
                        startShow = 0;
                        chooseShow = songNum.length;
                        updateSongText();
                    }               
                }    
            }
        }
        
        if (chooseShow < 0) chooseShow = 0; //fix someone press up at start

	    if (chooseShow >= 1 && chooseShow <= 5){
		    chooseBG.y = showY + 100 + (chooseShow - 1) * 40;
		}
		
		if (searchSongNamesTexts.members[0].text != '' && chooseShow >= 1 && chooseShow <= 5){
            chooseBG.alpha = 0.6;
        }
        else{
            chooseBG.y = showY + 100;
        }
		
		var realChoose:Int = startShow + chooseShow; 
		realChoose -= 1; // -1 is fix code to 0
		if (realChoose >= 0 && realChoose <= songNum.length){
		    curSelected = songNum[realChoose]; //main move freeplay choose
		    SearchChangeSelection(true);
		}
	}

	function updateSongText()
	{
	    var numStart = startShow;
	    var numEnd = startShow + 5;
	    for (num in numStart...numEnd)
    		{
    		    var numFix:Int = num + 1;
    			var songNameText:FlxText = searchSongNamesTexts.members[num - numStart];
    			if (songName[num] != null) songNameText.text = numFix + ': ' + songName[num];
    			else songNameText.text = '';
    		}
	}
	
	function checkPosition()
	{
	    if((startShow + 5) >= songNum.length) isEnd = true;
	    else isEnd = false;
	    if(startShow == 0) isStart = true;
	    else isStart = false;

	    if (songNum.length >= 5){
		    maxDown = 4;
		}
		else {
		    maxDown = songNum.length;
		}

		if (songNum.length <= 5){
		    maxUP = 1;
		}
		else{
		    maxUP = 2;
		}

		if (isStart) maxUP = 1;
		if (isEnd) maxDown = 5;	
		
		if (songNum.length < 5) maxDown = songNum.length; //check again
		if (songNum.length < 2) maxUP = 1; //check again
	}
	
	function SearchChangeSelection(playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
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

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}
	}
	
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];
		if (CoolUtil.difficulties.length > 1)
			diffText.text = '< ' + lastDifficultyName.toUpperCase() + ' >';
		else
			diffText.text = lastDifficultyName.toUpperCase();

		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
