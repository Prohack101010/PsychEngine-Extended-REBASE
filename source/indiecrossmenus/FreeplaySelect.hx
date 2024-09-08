package indiecrossmenus;

import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;

using StringTools;

class FreeplaySelect extends MusicBeatState
{
	//so u can play when in debug mode
	public static var Debug:Bool = false;

	//sprites
	var bg:FlxSprite;
	var story:FlxSprite;
	var extras:FlxSprite;
	var nightmare:FlxSprite;
	var nightmarelocked:FlxSprite;

	var SelectionWeek:Int = 0;
	var NoSpam:Bool = false;
	var NightmareUnlocked:Bool = false;

    override function create()
	{
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('BG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		add(bg);

		story = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplayselect/story'));
		story.antialiasing = ClientPrefs.globalAntialiasing;
		story.screenCenter(Y);
		story.scale.set(0.7, 0.7);
		add(story);

		extras = new FlxSprite(350, 0).loadGraphic(Paths.image('freeplayselect/bonus'));
		extras.antialiasing = ClientPrefs.globalAntialiasing;
		extras.screenCenter(Y);
		extras.scale.set(0.7, 0.7);
		add(extras);

		nightmare = new FlxSprite(700, 0).loadGraphic(Paths.image('freeplayselect/nightmare'));
		nightmare.antialiasing = ClientPrefs.globalAntialiasing;
	    nightmare.screenCenter(Y);
		nightmare.scale.set(0.7, 0.7);
		nightmare.visible = false; //keep it like the original.
		add(nightmare);

		nightmarelocked = new FlxSprite(700, 0).loadGraphic(Paths.image('freeplayselect/locked'));
		nightmarelocked.antialiasing = ClientPrefs.globalAntialiasing;
	    nightmarelocked.screenCenter(Y);
		nightmarelocked.scale.set(0.7, 0.7);
		add(nightmarelocked);

		#if debug
		Debug = true;
		#end

		//changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		NightmareUnlocked = FlxG.save.data.NightmareUnlocked;

		if (FlxG.save.data.CupBeaten || FlxG.save.data.SansBeaten2 || FlxG.save.data.BendyBeaten)
		{
			FlxG.save.data.NightmareUnlocked = true;
		}

		if (NightmareUnlocked || Debug )
		{
			nightmare.visible = true;
		}
		else
		{
		    nightmarelocked.visible = true;
		}

		if (SelectionWeek == 0)
		{
			story.alpha = 1.0;
			extras.alpha = 0.6;
			if (!NightmareUnlocked && !Debug)
			{
				nightmare.alpha = 0.0;
				nightmarelocked.alpha = 0.6;
			}
			else
			{
				nightmare.alpha = 0.6;
				nightmarelocked.alpha = 0.0;
			}
		}
		else if (SelectionWeek == 1)
		{
			story.alpha = 0.6;
			extras.alpha = 1.0;
			if (!NightmareUnlocked && !Debug)
			{
				nightmare.alpha = 0.0;
				nightmarelocked.alpha = 0.6;
			}
			else
			{
				nightmare.alpha = 0.6;
				nightmarelocked.alpha = 0.0;
			}
		}
		else if (SelectionWeek == 2)// && !NightmareUnlocked)
		{
			story.alpha = 0.6;
			extras.alpha = 0.6;
			if (!NightmareUnlocked && !Debug)
			{
				nightmare.alpha = 0.0;
				nightmarelocked.alpha = 1.0;
			}
			else
			{
				nightmare.alpha = 1.0;
				nightmarelocked.alpha = 0.0;
			}
		}
		/*
		else if (SelectionWeek == 2 && NightmareUnlocked)
		{
			story.alpha = 0.6;
			extras.alpha = 0.6;
			nightmare.alpha = 1.0;
			nightmarelocked.alpha = 0.6;
		}
		*/

		if (controls.ACCEPT)
		{
			Entered();
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.UI_LEFT_P)
		{
			changeSelection(-1);
			trace('left pressed');
		}

		else if (controls.UI_RIGHT_P)
		{
			changeSelection(1);
			trace('right pressed');
		}

		super.update(elapsed);
	}

	function Entered():Void
	{
        //if (NoSpam = false)
		//{
		//	NoSpam = true;
		//}

		if (SelectionWeek == 0)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			MusicBeatState.switchState(new FreeplayMain());
			//NoSpam = false;
		}
		else if (SelectionWeek == 1)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
            MusicBeatState.switchState(new FreeplayBonus());
			//NoSpam = false;
		}
		else if (SelectionWeek == 2 && NightmareUnlocked || Debug || FlxG.save.data.CupBeaten || FlxG.save.data.SansBeaten || FlxG.save.data.SansBeaten2 || FlxG.save.data.BendyBeaten)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			MusicBeatState.switchState(new FreeplayNightmare());
			//NoSpam = false;
		}
		else
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			//NoSpam = false;
		}
	}

	function changeSelection(Selection:Int = 0):Void
	{
		SelectionWeek += Selection;
	
		if (SelectionWeek < -1)
		{
			//SelectionWeek = Difficulty.list.length;
			SelectionWeek = -1;
		}
		//the code below adds to the number of options, the code above removes the amount of options -thatblockboi
		if (SelectionWeek < 1)
		{
			SelectionWeek = Difficulty.list.length;
		}
	}
}