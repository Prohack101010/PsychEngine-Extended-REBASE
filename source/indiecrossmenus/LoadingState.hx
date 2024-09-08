package indiecrossmenus;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if sys
import sys.thread.Thread;
#end
import PlayState;


using StringTools;

class LoadingState extends MusicBeatState
{
	public static var target:FlxState;
	public static var stopMusic = false;

	static var imagesToCache:Array<String> = [];
	static var soundsToCache:Array<String> = [];
	static var library:String = "";

	var screen:LoadingScreen;

	public function new()
	{
		super();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
	}

	override function create()
	{
		super.create();

		// Hardcoded, aaaaahhhh
		if((FreeplaySelectStateCROSS.curSelected == 0 && !PlayState.isStoryMode) || PlayState.isStoryMode)
		switch (PlayState.storyWeek)
		{
			case 0:
				library = "cup";
		
				soundsToCache = ["parry", "knockout"];

				imagesToCache = ['knock', 'ready_wallop', 'bull/Roundabout', 'bull/GreenShit', 'bull/Cupheadshoot', 'bull/Cuphead Hadoken','mozo'];
				
				FlxTransitionableState.skipNextTransIn = true;
			
			case 1:
				library = "sans";
			
				soundsToCache = ["notice", "sansattack", "dodge", "readygas", "shootgas"];

				imagesToCache = ["DodgeMechs"];

				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'bad-time':
						imagesToCache = imagesToCache.concat([	
							'Gaster_blasterss',
							'DodgeMechsBS-Shader'
						]);
				}
			
			case 2:
				library = "bendy";
			
				soundsToCache = ['inked'];

				imagesToCache = ['Damage01', 'Damage02', 'Damage03', 'Damage04'];
		}
	
		// Hardcoded for now
		if (PlayState.SONG.song.toLowerCase() == 'ritual')
			FlxTransitionableState.skipNextTransIn = true;

		screen = new LoadingScreen();
		add(screen);

		screen.max = soundsToCache.length + imagesToCache.length;

		FlxG.camera.fade(FlxG.camera.bgColor, 0.5, true);

		FlxGraphic.defaultPersist = true;
		#if sys
		Thread.create(() ->
		{
		#end
			screen.setLoadingText("Loading sounds...");
			for (sound in soundsToCache)
			{
				trace("Caching sound " + sound);
				FlxG.sound.cache(Paths.returnSoundString('sounds', sound, library));
				screen.progress += 1;
			}

			screen.setLoadingText("Loading images...");
			for (image in imagesToCache)
			{
				trace("Caching image " + image);
				FlxG.bitmap.add(Paths.image(image, library));
				screen.progress += 1;
			}

			FlxGraphic.defaultPersist = false;

			screen.setLoadingText("Done!");
			trace("Done caching");
			
			FlxG.camera.fade(FlxColor.BLACK, 1, false);
			new FlxTimer().start(1, function(_:FlxTimer)
			{
				screen.kill();
				screen.destroy();
				loadAndSwitchState(target, false);
			});
		#if sys		
		});
		#end
	}

	public static function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		MusicBeatState.switchState(target);
	}

	public static function dumpAdditionalAssets()
	{
		for (image in 0...Paths.localTrackedAssets.length)
		{
			trace("Dumping image " + image);
			FlxG.bitmap.removeByKey(Paths.localTrackedAssets[image]);
		}
		soundsToCache = [];
		imagesToCache = [];
	}
}
class LoadingScreen extends FlxTypedGroup<FlxSprite>
{
    public var progress:Int = 0;
	public var max:Int = 10;
    
    var loadingImage:FlxSprite;
    var loadTxtBg:FlxSprite;
	var loadTxtProgress:FlxSprite;
    var loadTxt:FlxText;
    
    public function new()
    {
        super();

		loadingImage = new FlxSprite(0, 0);

		if (PlayState.SONG != null)
		{
				if(PlayState.SONG.song.toLowerCase() == "devils-gambit")
					loadingImage.loadGraphic(Paths.image('sourcethings/nm/1', 'preload'));
				else if(PlayState.SONG.song.toLowerCase() == "bad-time")
					loadingImage.loadGraphic(Paths.image('sourcethings/nm/2', 'preload'));
				else if(PlayState.SONG.song.toLowerCase() == "despair")
					loadingImage.loadGraphic(Paths.image('sourcethings/nm/3', 'preload'));
				else
					loadingImage.loadGraphic(Paths.image('sourcethings/Loading_screen', 'preload'));
			}
		
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		add(loadingImage);

		loadTxtBg = new FlxSprite();
		add(loadTxtBg);

		loadTxtProgress = new FlxSprite();
		add(loadTxtProgress);

		loadTxt = new FlxText(0, 0, 0, "Loading...", 30);
		loadTxt.setFormat(Paths.font("Bronx.otf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		loadTxt.x = 5;
		loadTxt.y = FlxG.height - loadTxt.height - 5;
		add(loadTxt);

		loadTxtBg.makeGraphic(1, 1, 0xFF000000);
        loadTxtBg.updateHitbox();
        loadTxtBg.origin.set();
		loadTxtBg.scale.set(1280, loadTxt.height + 5);
		loadTxtBg.alpha = 0.8;
		loadTxtBg.y = loadTxt.y;

		loadTxtProgress.makeGraphic(1, 1, 0xFFFFFFFF);
		loadTxtProgress.updateHitbox();
		loadTxtProgress.origin.set();
		loadTxtProgress.scale.set(0, loadTxt.height + 5);
		loadTxtProgress.alpha = 0.3;
		loadTxtProgress.y = loadTxt.y;

		loadTxt.y += 2;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		var lerpTarget:Float = 1280.0 * (progress / max);
		loadTxtProgress.scale.x = FlxMath.lerp(loadTxtProgress.scale.x, lerpTarget, elapsed * 5);
    }

    public function setLoadingText(text:String)
    {
        loadTxt.text = text;
    }
}
