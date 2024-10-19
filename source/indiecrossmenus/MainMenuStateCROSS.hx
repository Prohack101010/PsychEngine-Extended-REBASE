package indiecrossmenus;

import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import shaders.WhiteOverlayShader;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuStateCROSS extends MusicBeatState
{
	public function new()
	{
		super();
	}

	public static var psychExtendedVersion:String = 'Psych Extended v1.0.0';
	public static var psychEngineVersion:String = 'Psych Engine v0.6.3';
	public static var curSelected:Int = 0;

	// var buttonsFlash:FlxSprite = new FlxSprite();
	var optionShit:Array<String> = ['storymode', 'freeplay', 'options', 'credits', 'achievements'];
	var menuString:FlxTypedGroup<FlxSprite>;
	var motherfucker:Array<FlxTween>;
	var menuSketch:FlxSprite;
	var bg:FlxSprite;

	static final pussy:Float = 50;
	public static final fuckersScale:Float = 0.675;
	static final fuckersTweenShitcifbidbfgis:TweenOptions = {ease: FlxEase.circOut};

	override function create()
	{
		FlxG.mouse.visible = true;
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();
		#if (desktop && !hl)
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var indieLogo:FlxSprite = new FlxSprite(-310, -170).loadGraphic(Paths.image('mainmenucross/LOGO'));
		indieLogo.updateHitbox();
		indieLogo.setGraphicSize(Std.int(indieLogo.width * 0.7));
		indieLogo.antialiasing = ClientPrefs.globalAntialiasing;
		add(indieLogo);

		var sketch:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenucross/sketch/sketch'));
		sketch.frames = Paths.getSparrowAtlas('mainmenucross/sketch/sketch');
		sketch.animation.addByPrefix('bump', 'menu bru', 3);
		sketch.animation.play('bump');
		sketch.setGraphicSize(Std.int(sketch.width * 0.7));
		sketch.antialiasing = ClientPrefs.globalAntialiasing;
		sketch.x -= 300;
		sketch.y -= 200;
		add(sketch);

		menuString = new FlxTypedGroup<FlxSprite>();
		add(menuString);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "INDIE CROSS V1.5", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, psychExtendedVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("Bronx.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		addBitches(270, 100);
		changeItem(curSelected);
		// NG.core.calls.event.logEvent('swag').send();

		#if ACHIEVEMENTS_ALLOWED
    	// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
    		var leDate = Date.now();
    	    if (leDate.getDay() == 5 && leDate.getHours() >= 18)
    			Achievements.unlock('friday_night_play');
    
    		#if MODS_ALLOWED
    		Achievements.reloadList();
    		#end
    	#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var selectedButton:FlxSprite = menuString.members[curSelected];
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && !selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(curSelected - 1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(curSelected + 1);
			}

			if (controls.BACK || FlxG.mouse.justReleasedRight)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			if (#if desktop FlxG.mouse.justMoved #else FlxG.mouse.justReleased #end)
			{
				for (i in 0...menuString.length)
				{
					if (i != curSelected && FlxG.mouse.overlaps(menuString.members[i]))
						changeItem(i);
				}
			}
			if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(menuString.members[curSelected]))
				{
					enterBitches();
				}
			}
			if (controls.ACCEPT)
			{
				enterBitches();
			}
			else if (FlxG.keys.justPressed.E)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);
	}

	public function changeItem(selection:Int = 0)
	{
		if (selection != curSelected)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if (selection < 0)
			selection = optionShit.length - 1;
		if (selection >= optionShit.length)
			selection = 0;

		for (i in 0...optionShit.length)
		{
			var str:String = optionShit[i];
			var menuItem:FlxSprite = menuString.members[i];
			if (i == selection)
			{
				menuItem.alpha = 1.0;
				if (motherfucker[i] != null)
				{
					motherfucker[i].cancelChain();
					motherfucker[i].destroy();
					motherfucker[i] = null;
				}
				if (str == "achievements")
				{
					motherfucker[i] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width}, 0.2, fuckersTweenShitcifbidbfgis);
				}
				else
				{
					motherfucker[i] = FlxTween.tween(menuItem, {x: 0}, 0.2, fuckersTweenShitcifbidbfgis);
				}
			}
			else
			{
				if (menuItem.alpha == 1.0)
				{
					if (motherfucker[i] != null)
					{
						motherfucker[i].cancelChain();
						motherfucker[i].destroy();
						motherfucker[i] = null;
					}
				}

				if (str == "achievements")
				{
					motherfucker[i] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width + pussy}, 0.35, fuckersTweenShitcifbidbfgis);
				}
				else
				{
					motherfucker[i] = FlxTween.tween(menuItem, {x: -pussy}, 0.35, fuckersTweenShitcifbidbfgis);
				}
				menuItem.alpha = 0.5;
			}
		}

		curSelected = selection;
	}

	function addBitches(yPos:Float, sep:Float)
	{
		if (menuString == null)
			return;

		if (menuString.members != null && menuString.members.length > 0)
			menuString.forEach(function(_:FlxSprite)
			{
				menuString.remove(_);
				_.destroy();
			});

		motherfucker = new Array<FlxTween>();

		for (i in 0...optionShit.length)
		{
			motherfucker.push(null);

			var str:String = optionShit[i];

			var menuItem:FlxSprite = new FlxSprite();
			if (str != null && str.length > 0)
			{
				menuItem.loadGraphic(Paths.image("mainmenucross/Buttons/" + str));
			}
			menuItem.origin.set();
			menuItem.scale.set(fuckersScale, fuckersScale);
			menuItem.updateHitbox();
			menuItem.alpha = 0.5;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;

			menuItem.shader = new WhiteOverlayShader();

			if (str == "achievements")
			{
				menuItem.setPosition(1280 - menuItem.width + pussy, 630);
			}
			else
			{
				menuItem.setPosition(-pussy, yPos + (i * sep));
			}

			menuString.add(menuItem);
		}
	}

	function enterBitches()
	{
		selectedSomethin = true;

		var str:String = optionShit[curSelected];
		var menuItem:FlxSprite = menuString.members[curSelected];

		if (motherfucker[curSelected] != null)
			motherfucker[curSelected].cancel();
		if (str == "achievements")
		{
			menuItem.x = 1280 - menuItem.width + pussy;
			motherfucker[curSelected] = FlxTween.tween(menuItem, {x: 1280 - menuItem.width}, 0.4, fuckersTweenShitcifbidbfgis);
		}
		else
		{
			menuItem.x = -pussy;
			motherfucker[curSelected] = FlxTween.tween(menuItem, {x: 0}, 0.4, fuckersTweenShitcifbidbfgis);
		}

		menuItem.shader.data.progress.value = [1.0];
		FlxTween.num(1.0, 0.0, 1.0, {ease: FlxEase.cubeOut}, function(num:Float)
		{
			menuItem.shader.data.progress.value = [num];
		});

		for (i in 0...menuString.members.length)
		{
			if (i != curSelected)
			{
				FlxTween.tween(menuString.members[i], {alpha: 0}, 1, {ease: FlxEase.cubeOut});
			}
		}

		if (str == 'options')
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.fadeOut(1, 0);
			}
		}
		FlxG.sound.play(Paths.sound('confirmMenu'));

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			switch (str)
			{
				case "storymode":
					CustomSwitchState.switchMenus('StoryMenu');
				case "freeplay":
					CustomSwitchState.switchMenus('Freeplay');
				case "options":
					CustomSwitchState.switchMenus('Options');
					options.OptionsState.onPlayState = false;
					if (PlayState.SONG != null)
					{
						PlayState.SONG.arrowSkin = null;
						PlayState.SONG.splashSkin = null;
					}
					FlxG.sound.playMusic(Paths.music('settin'), 1, true);
					FlxG.sound.music.fadeIn(2, 0, 1);
				case "credits":
					CustomSwitchState.switchMenus('Credits');
				case "achievements":
					LoadingState.loadAndSwitchState(new AchievementsMenuState());
			}
		});
	}

	override function destroy()
	{
		#if HIDE_CURSOR FlxG.mouse.visible = false; #end
		super.destroy();
	}
}
