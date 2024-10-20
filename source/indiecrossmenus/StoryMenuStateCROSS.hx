package indiecrossmenus;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class StoryMenuStateCROSS extends MusicBeatState
{
	static var diffic:String;
	private static var lastDifficultyName:String = Difficulty.getDefault();
	public static var weekData:Array<Dynamic> = [
		['Snake-Eyes', 'technicolor-tussle', 'knockout'],
		['Whoopee', 'Sansational', 'Burning-In-Hell', 'Final-Stretch'],
		['Imminent-Demise', 'Terrible-Sin', 'Last-Reel', 'Nightmare-Run']
	];

	var scoreText:FlxText;

	static var curDifficulty:Int = 1;
	public static var curMechDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, false];

	public static var curWeek:Int = 0;

	var daScaling:Float = 0.675;

	var actualBG:FlxSprite;

	var bendoBG:FlxSprite;

	var diffifSpr:FlxSprite;
	var diffOrigX:Float = 0;
	var diffTween:FlxTween;
	
	var diffmechSpr:FlxSprite;
	var diffmechOrigX:Int = -2;
	var diffmechTween:FlxTween;

	var options:Array<FlxSprite>;
	var optFlashes:Array<FlxSprite>;
	var optionShit:Array<String> = ['Week1', 'Week2', 'Week3'];

	var actualLeft:Float = 0; // doing this only bc the screen zero isn't the real left side

	var gamingCup:FlxSprite;
	var gamingSands:FlxSprite;

	var ismech:Bool = false;

	var cupTea:FlxSprite;

	public static var fromWeek:Int = -1;

	public static var leftDuringWeek:Bool = false;

	var allowTransit:Bool = false;

	var holdshifttext:FlxText;
	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	override function create()
	{
		super.create();
		PlayState.isStoryMode = true;
		persistentUpdate = true;

		#if (desktop && !hl)
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		actualBG = new FlxSprite().loadGraphic(Paths.image('story mode/BG'));
		actualBG.scrollFactor.set();
		actualBG.setGraphicSize(Std.int(actualBG.width * daScaling));
		actualBG.updateHitbox();
		actualBG.screenCenter();
		actualBG.antialiasing = ClientPrefs.data.antialiasing;
		add(actualBG);

		gamingSands = new FlxSprite();
		gamingSands.frames = Paths.getSparrowAtlas('story mode/SansStorymodeMenu');
		gamingSands.animation.addByPrefix('bruh', 'Saness instance 1', 24, true);
		gamingSands.animation.play('bruh');
		gamingSands.scrollFactor.set();
		gamingSands.setGraphicSize(Std.int(gamingSands.width * (daScaling * 1.5)));
		gamingSands.updateHitbox();
		gamingSands.x = -13;
		gamingSands.y = -41;
		gamingSands.antialiasing = ClientPrefs.data.antialiasing;
		add(gamingSands);

		bendoBG = new FlxSprite();
		bendoBG.frames = Paths.getSparrowAtlas('story mode/Bendy_Gaming');
		bendoBG.animation.addByPrefix('bruh', 'Creepy shit instance 1');
		bendoBG.animation.play('bruh');
		bendoBG.scrollFactor.set();
		bendoBG.setGraphicSize(Std.int(bendoBG.width * daScaling));
		bendoBG.updateHitbox();
		bendoBG.screenCenter();
		bendoBG.antialiasing = ClientPrefs.data.antialiasing;
		bendoBG.alpha = 0.00001;
		add(bendoBG);

		var leftpanel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Left-Panel_above BGs'));
		leftpanel.scrollFactor.set();
		leftpanel.updateHitbox();
		leftpanel.screenCenter();
		leftpanel.antialiasing = ClientPrefs.data.antialiasing;
		add(leftpanel);

		gamingCup = new FlxSprite();
		gamingCup.frames = Paths.getSparrowAtlas('story mode/Cuphead_Gaming');
		gamingCup.animation.addByPrefix('bruh', 'Cuphead Gaming instance 1', 24, true);
		gamingCup.animation.play('bruh');
		gamingCup.scrollFactor.set();
		gamingCup.setGraphicSize(Std.int(gamingCup.width * daScaling));
		gamingCup.updateHitbox();
		gamingCup.x = 760;
		gamingCup.y = 233;
		gamingCup.antialiasing = ClientPrefs.data.antialiasing;
		add(gamingCup);

		var bottompannel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Score_bottom panel'));
		bottompannel.scrollFactor.set();
		bottompannel.setGraphicSize(Std.int(bottompannel.width * daScaling));
		bottompannel.updateHitbox();
		bottompannel.screenCenter();
		bottompannel.antialiasing = ClientPrefs.data.antialiasing;
		add(bottompannel);

		diffifSpr = new FlxSprite();
		diffifSpr.frames = Paths.getSparrowAtlas('story mode/Difficulties');
		diffifSpr.animation.addByPrefix('NO-MECHANICS', 'Chart Hard instance 1', 24, true);
		diffifSpr.animation.addByPrefix('HARD', 'Chart Hard instance 1', 24, true);
		diffifSpr.animation.addByPrefix('HELL', 'Chart Hard instance 1', 24, true);
		diffifSpr.animation.play('NORMAL');
		diffifSpr.scrollFactor.set();
		diffifSpr.setGraphicSize(Std.int(diffifSpr.width * 1.0));
		diffifSpr.updateHitbox();
		diffOrigX = -2;
		diffifSpr.y = 128;
		diffifSpr.antialiasing = ClientPrefs.data.antialiasing;
		add(diffifSpr);
		diffifSpr.animation.play('HARD');

		diffTween = FlxTween.tween(this, {}, 0);
		
		diffmechSpr = new FlxSprite(diffmechOrigX, 200);
		diffmechSpr.frames = Paths.getSparrowAtlas('story mode/Difficulties');
		diffmechSpr.animation.addByPrefix('NO-MECHANICS', 'Mechs Dis instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('HARD', 'Mechs Hard instance 1', 24, true);
		diffmechSpr.animation.addByPrefix('HELL', 'Mechs Hell instance 1', 24, true);
		diffmechSpr.animation.play('NORMAL');
		diffmechSpr.scrollFactor.set();
		diffmechSpr.updateHitbox();
		diffmechSpr.antialiasing = ClientPrefs.data.antialiasing;
		add(diffmechSpr);
		
		diffmechTween = FlxTween.tween(this, {}, 0);

		var storyPanel:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Storymode'));
		storyPanel.scrollFactor.set();
		storyPanel.setGraphicSize(Std.int(storyPanel.width * daScaling));
		storyPanel.updateHitbox();
		storyPanel.screenCenter();
		storyPanel.antialiasing = ClientPrefs.data.antialiasing;
		add(storyPanel);

		options = [];
		optFlashes = [];

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image('story mode/Weeks/' + optionShit[i]));
			menuItem.setGraphicSize(Std.int(menuItem.width * daScaling));
			add(menuItem);
			options.push(menuItem);
			menuItem.alpha = 0.5;
			menuItem.scrollFactor.set();
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.updateHitbox();
			menuItem.screenCenter();
			actualLeft = menuItem.x;

			var flash = new FlxSprite().loadGraphic(Paths.image('story mode/Weeks/' + optionShit[i] + '_selected'));
			flash.setGraphicSize(Std.int(flash.width * daScaling));
			add(flash);
			optFlashes.push(flash);
			flash.alpha = 0.00001;
			flash.scrollFactor.set();
			flash.antialiasing = ClientPrefs.data.antialiasing;
			flash.updateHitbox();
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat(Paths.font('Bronx.otf'), 32, FlxColor.WHITE, CENTER);
		scoreText.screenCenter();
		scoreText.borderSize = 2.4;
		scoreText.y += 340;

		trace("Line 124");

		changeDifficulty();
		changeWeek(curWeek);

		add(scoreText);

		cupTea = new FlxSprite();
		cupTea.frames = Paths.getSparrowAtlas('sourcethings/the_thing2.0');
		cupTea.animation.addByPrefix('start', "BOO instance 1", 24, false);
		cupTea.setGraphicSize(Std.int((FlxG.width / FlxG.camera.zoom) * 1.1), Std.int((FlxG.height / FlxG.camera.zoom) * 1.1));
		cupTea.updateHitbox();
		cupTea.screenCenter();
		cupTea.antialiasing = ClientPrefs.data.antialiasing;
		cupTea.scrollFactor.set();
		if (fromWeek == 0)
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

				missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				missingTextBG.alpha = 0.6;
				missingTextBG.visible = false;
				add(missingTextBG);
		
				missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
				missingText.setFormat(Paths.font("Bronx.otf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				missingText.scrollFactor.set();
				missingText.visible = false;
				add(missingText);

				curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
				changeDifficulty(1);

		addVirtualPad(FULL, A_B_C);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			allowTransit = true;
		});
	}

	override function update(elapsed:Float)
	{

		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE: " + lerpScore;
		scoreText.x = FlxG.width / 2 - scoreText.width / 2;

		if (!lockInput)
		{
			if (controls.UI_UP_P)
			{
				changeWeek(curWeek - 1);
			}

			if (controls.UI_DOWN_P)
			{
				changeWeek(curWeek + 1);
			}

			else // not holding shift, change chart diffiuclty
			{
				if (controls.UI_RIGHT_P)
					changeDifficulty(1);
				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}

			if (controls.BACK)
			{
				backOut();
			}
		}

		for (i in 0...options.length)
		{
			if (i != curWeek && options[i].alpha > 0.5)
				options[i].alpha -= 0.01;
			options[i].x += (actualLeft - options[i].x) / 6;

			if (optFlashes[i].alpha > 0)
				optFlashes[i].alpha -= 0.01;
			optFlashes[i].x = options[i].x;
			optFlashes[i].y = options[i].y;
		}

		super.update(elapsed);
	}

	function backOut()
	{
		if (!lockInput && allowTransit)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			lockInput = true;

			CustomSwitchState.switchMenus('MainMenu');
		}
	}

	var stopspamming:Bool = false;
	var lockInput:Bool = false;

	function selectWeek()
	{
					aaaaa();
	}

	function aaaaa()
	{
		var waitDuration:Float = 1;

		switch (curWeek)
		{
			case 0:
				FlxTransitionableState.skipNextTransOut = true;
				waitDuration = 1.1;
				#if android
				removeVirtualPad();
				#end
				cupTea.alpha = 1;
				cupTea.animation.play('start', true, true);
				FlxG.sound.play(Paths.sound('Cup/boing'), 1);
				FlxG.sound.music.volume = 0;
			default:
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.fadeOut(1, 0);
				}
				FlxG.sound.play(Paths.sound('confirmMenu'));

				options[curWeek].x -= 15;
				optFlashes[curWeek].alpha = 1;

				for (i in 0...options.length)
				{
					var spr = options[i];
					if (curWeek != i)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
				}
		}

		if (curWeek == 2 && curDifficulty == 0)
		{
			PlayState.storyPlaylist = ['Imminent-Demise', 'Terrible-Sin', 'Last-Reel'];
		}
		else
		{
			if (curWeek == 1)
			{
				PlayState.storyPlaylist = ['Whoopee', 'Sansational'];
			}
			else
			{
				PlayState.storyPlaylist = weekData[curWeek];
			}
		}
		lockInput = true;

		//var poop:String = Highscore.formatSong(PlayState.storyPlaylist[0], curDifficulty);

		try
			{
				diffic = Difficulty.getFilePath(curDifficulty);
				if(diffic == null) diffic = '';
				trace('current difficulty suffix is ' + diffic);
				PlayState.storyDifficulty = curDifficulty;
				PlayState.isStoryMode = true;
				PlayState.seenCutscene = false;
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

		PlayState.storyWeek = curWeek;
		PlayState.campaignScore = 0;

		new FlxTimer().start(waitDuration, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState());
		});

		stopspamming = true;
	}

	function changeDifficulty(change:Int = 0):Void
	{
		lastDifficultyName = Difficulty.getString(curDifficulty);
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		switch (curDifficulty)
		{
			case 0:
			    diffmechOrigX = -2;
			    diffmechSpr.y = 200;
				diffmechSpr.animation.play('NO-MECHANICS');
			case 1:
			    diffmechOrigX = -2;
			    diffmechSpr.y = 200;
				diffmechSpr.animation.play('HARD');
			case 2:
			    diffmechOrigX = -8;
			    diffmechSpr.y = 170;
				diffmechSpr.animation.play('HELL');
		}

		diffmechSpr.x = diffmechOrigX - 20;

		if (diffTween != null)
			diffTween.cancel();
			
		if (diffmechTween != null)
			diffmechTween.cancel();

		diffmechTween = FlxTween.tween(diffmechSpr, {x: diffmechOrigX}, 0.2, {ease: FlxEase.quadOut});

		intendedScore = Highscore.getWeekScore("week" + curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore("week" + curWeek, curDifficulty);
		#end
	}
	
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		var lSel = curWeek;

		if (change >= weekData.length)
			change = 0;
		if (change < 0)
			change = weekData.length - 1;

		curWeek = change;

		switch (curWeek)
		{
			default:
				actualBG.alpha = 1;
				bendoBG.alpha = 0.00001;
				actualBG.loadGraphic(Paths.image('story mode/BG'));
				gamingCup.alpha = 1;
				gamingSands.alpha = 0.00001;
			case 1:
				actualBG.alpha = 0.00001;
				bendoBG.alpha = 0.00001;
				gamingCup.alpha = 0.00001;
				gamingSands.alpha = 1;
			case 2:
				actualBG.alpha = 0.00001;
				bendoBG.alpha = 1;
				gamingCup.alpha = 0.00001;
				gamingSands.alpha = 0.00001;
			case 3:
				actualBG.alpha = 0.00001;
				bendoBG.alpha = 0.00001;
				gamingCup.alpha = 0.00001;
				gamingSands.alpha = 0.00001;
		}

		if (change != curWeek)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		optionUpdate(lSel, '');
		optionUpdate(curWeek, '_selected');

		options[curWeek].x -= 40;
		options[curWeek].alpha = 1;

		intendedScore = Highscore.getWeekScore('week' + curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore("week" + curWeek, curDifficulty);
		#end
	}

	function optionUpdate(num:Int, type:String)
	{
		options[num].loadGraphic(Paths.image('story mode/Weeks/' + optionShit[num] + type));
		options[num].updateHitbox();
		options[num].screenCenter(X);
	}
}