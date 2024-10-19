package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
    //Psych Extended
	public static var NoteSkin:String = 'original';
    public static var FreeplayStyle:String = 'Psych';
    public static var PauseMenuStyle:String = 'Psych';
    public static var FreakyMenu:String = 'Extended';
    public static var TransitionStyle:String = 'Psych';
    public static var MainMenuStyle:String = '1.0';
	public static var Modpack:Bool = false;
	public static var IndieCrossMenus:Bool = #if (INDIECROSS_FORCED || INDIECROSS_ASSETS) true #else false #end;
	
	public static var wideScreen:Bool = false;
	public static var mobileC:Bool = true; //better than using if mobile
	
	public static var virtualpadType:String = "New";
	public static var VirtualPadSkin:String = 'original';
	public static var VirtualPadAlpha:Float = #if mobile 0.75 #else 0 #end;
	public static var coloredvpad:Bool = true;
	
	public static var extraKeyReturn1:String = 'SHIFT';
    public static var extraKeyReturn2:String = 'SPACE';
    public static var extraKeyReturn3:String = 'Q';
    public static var extraKeyReturn4:String = 'E';
	public static var hitboxhint:Bool = false;
	public static var hitboxmode:String = 'New';
	public static var hitboxtype:String = 'Gradient';
	public static var extraKeys:Int = 2;
	public static var hitboxLocation:String = 'Bottom';
	public static var hitboxalpha:Float = #if mobile 0.7 #else 0 #end;
	public static var antialiasing:Bool = true;
	#if android
	public static var storageType:String = "EXTERNAL_DATA";
	#end
    
    //Psych Engine
	public static var downScroll:Bool = false;
	public static var marvelousRating:Bool = true;	
	public static var marvelousSprite:Bool = true;	
    public static var marvelousWindow:Int = 15;
	public static var middleScroll:Bool = false;
	public static var opponentStrums:Bool = true;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var vibration:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = #if mobile true #else false #end;
	public static var hitsoundVolume:Float = 0;
	public static var pauseMusic:String = 'Tea Time';
	public static var checkForUpdates:Bool = true;
	public static var comboStacking:Bool = true;
	
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
	    //Psych Extended
	    FlxG.save.data.mobileC = mobileC;
	    FlxG.save.data.wideScreen = wideScreen;
	    FlxG.save.data.VirtualPadSkin = VirtualPadSkin;
		FlxG.save.data.FreeplayStyle = FreeplayStyle;
		FlxG.save.data.MainMenuStyle = MainMenuStyle;
		FlxG.save.data.extraKeyReturn1 = extraKeyReturn1;
		FlxG.save.data.extraKeyReturn2 = extraKeyReturn2;
		FlxG.save.data.extraKeyReturn3 = extraKeyReturn3;
		FlxG.save.data.extraKeyReturn4 = extraKeyReturn4;
		FlxG.save.data.PauseMenuStyle = PauseMenuStyle;
		FlxG.save.data.FreakyMenu = FreakyMenu;
		FlxG.save.data.TransitionStyle = TransitionStyle;
		FlxG.save.data.Modpack = Modpack;
		FlxG.save.data.IndieCrossMenus = IndieCrossMenus;
		FlxG.save.data.coloredvpad = coloredvpad;
		FlxG.save.data.NoteSkin = NoteSkin;
		FlxG.save.data.virtualpadType = virtualpadType;
		FlxG.save.data.extraKeys = extraKeys;
	    FlxG.save.data.hitboxLocation = hitboxLocation;
		FlxG.save.data.hitboxmode = hitboxmode;
		FlxG.save.data.hitboxtype = hitboxtype;
        FlxG.save.data.hitboxhint = hitboxhint;
		FlxG.save.data.hitboxalpha = hitboxalpha;
		FlxG.save.data.VirtualPadAlpha = VirtualPadAlpha;
		#if android
		FlxG.save.data.storageType = storageType;
		#end
	    
	    //Psych Engine
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.marvelousRating = marvelousRating;
		FlxG.save.data.marvelousSprite = marvelousSprite;
		FlxG.save.data.marvelousWindow = marvelousWindow;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.vibration = vibration;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.comboStacking = comboStacking;
	
	    #if ACHIEVEMENTS_ALLOWED Achievements.save(); #end
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2' , CoolUtil.getSavePath()); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
	    //Psych Extended
	    if(FlxG.save.data.NoteSkin != null)
			NoteSkin = FlxG.save.data.NoteSkin;
		if(FlxG.save.data.wideScreen != null)
			wideScreen = FlxG.save.data.wideScreen;
		if(FlxG.save.data.mobileC != null)
			mobileC = FlxG.save.data.mobileC;
		if(FlxG.save.data.VirtualPadSkin != null)
			VirtualPadSkin = FlxG.save.data.VirtualPadSkin;
		if(FlxG.save.data.FreeplayStyle != null)
			FreeplayStyle = FlxG.save.data.FreeplayStyle;
		if(FlxG.save.data.MainMenuStyle != null)
			MainMenuStyle = FlxG.save.data.MainMenuStyle;
		if(FlxG.save.data.extraKeyReturn1 != null)
			extraKeyReturn1 = FlxG.save.data.extraKeyReturn1;
		if(FlxG.save.data.extraKeyReturn2 != null)
			extraKeyReturn2 = FlxG.save.data.extraKeyReturn2;
		if(FlxG.save.data.extraKeyReturn3 != null)
			extraKeyReturn3 = FlxG.save.data.extraKeyReturn3;
		if(FlxG.save.data.extraKeyReturn4 != null)
			extraKeyReturn4 = FlxG.save.data.extraKeyReturn4;
		if(FlxG.save.data.PauseMenuStyle != null)
			PauseMenuStyle = FlxG.save.data.PauseMenuStyle;
		if(FlxG.save.data.FreakyMenu != null)
			FreakyMenu = FlxG.save.data.FreakyMenu;
		if(FlxG.save.data.TransitionStyle != null)
			TransitionStyle = FlxG.save.data.TransitionStyle;
		if(FlxG.save.data.Modpack != null)
			Modpack = FlxG.save.data.Modpack;
		if(FlxG.save.data.IndieCrossMenus != null)
			IndieCrossMenus = FlxG.save.data.IndieCrossMenus;
		if(FlxG.save.data.coloredvpad != null)
			coloredvpad = FlxG.save.data.coloredvpad;
		if(FlxG.save.data.virtualpadType != null)
			virtualpadType = FlxG.save.data.virtualpadType;
		if(FlxG.save.data.hitboxmode != null)
			hitboxmode = FlxG.save.data.hitboxmode;
		if(FlxG.save.data.hitboxtype != null)
			hitboxtype = FlxG.save.data.hitboxtype;
		if(FlxG.save.data.hitboxhint != null)
			hitboxhint = FlxG.save.data.hitboxhint;
		if(FlxG.save.data.hitboxLocation != null)
			hitboxLocation = FlxG.save.data.hitboxLocation;
		if(FlxG.save.data.extraKeys != null)
			extraKeys = FlxG.save.data.extraKeys;
		if(FlxG.save.data.hitboxalpha != null)
			hitboxalpha = FlxG.save.data.hitboxalpha;
		if(FlxG.save.data.VirtualPadAlpha != null)
			VirtualPadAlpha = FlxG.save.data.VirtualPadAlpha;
		if(FlxG.save.data.globalAntialiasing != null)
			antialiasing = FlxG.save.data.globalAntialiasing;
		#if android
		if(FlxG.save.data.storageType != null)
			storageType = FlxG.save.data.storageType;
		#end
			
		//Psych Engine
		if(FlxG.save.data.downScroll != null)
			downScroll = FlxG.save.data.downScroll;
		if(FlxG.save.data.marvelousRating != null)
			marvelousRating = FlxG.save.data.marvelousRating;
		if(FlxG.save.data.marvelousSprite != null)
			marvelousSprite = FlxG.save.data.marvelousSprite;
		if(FlxG.save.data.marvelousWindow != null)
			marvelousWindow = FlxG.save.data.marvelousWindow;
		if(FlxG.save.data.middleScroll != null)
			middleScroll = FlxG.save.data.middleScroll;
		if(FlxG.save.data.opponentStrums != null)
			opponentStrums = FlxG.save.data.opponentStrums;
			
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null)
			flashing = FlxG.save.data.flashing;
		if(FlxG.save.data.globalAntialiasing != null)
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		if(FlxG.save.data.noteSplashes != null)
			noteSplashes = FlxG.save.data.noteSplashes;
		if(FlxG.save.data.lowQuality != null)
			lowQuality = FlxG.save.data.lowQuality;
		if(FlxG.save.data.shaders != null)
			shaders = FlxG.save.data.shaders;
			
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		if(FlxG.save.data.camZooms != null)
			camZooms = FlxG.save.data.camZooms;
		if(FlxG.save.data.hideHud != null)
			hideHud = FlxG.save.data.hideHud;
		if(FlxG.save.data.noteOffset != null)
			noteOffset = FlxG.save.data.noteOffset;
		if(FlxG.save.data.arrowHSV != null)
			arrowHSV = FlxG.save.data.arrowHSV;
		if(FlxG.save.data.vibration != null)
			vibration = FlxG.save.data.vibration;
		if(FlxG.save.data.ghostTapping != null)
			ghostTapping = FlxG.save.data.ghostTapping;
		if(FlxG.save.data.timeBarType != null)
			timeBarType = FlxG.save.data.timeBarType;
		if(FlxG.save.data.scoreZoom != null)
			scoreZoom = FlxG.save.data.scoreZoom;
		if(FlxG.save.data.noReset != null)
			noReset = FlxG.save.data.noReset;
		if(FlxG.save.data.healthBarAlpha != null)
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		if(FlxG.save.data.comboOffset != null)
			comboOffset = FlxG.save.data.comboOffset;
		
		if(FlxG.save.data.ratingOffset != null)
			ratingOffset = FlxG.save.data.ratingOffset;
		if(FlxG.save.data.sickWindow != null)
			sickWindow = FlxG.save.data.sickWindow;
		if(FlxG.save.data.goodWindow != null)
			goodWindow = FlxG.save.data.goodWindow;
		if(FlxG.save.data.badWindow != null)
			badWindow = FlxG.save.data.badWindow;
		if(FlxG.save.data.safeFrames != null)
			safeFrames = FlxG.save.data.safeFrames;
		if(FlxG.save.data.controllerMode != null)
			controllerMode = FlxG.save.data.controllerMode;
		if(FlxG.save.data.hitsoundVolume != null)
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		if(FlxG.save.data.pauseMusic != null)
			pauseMusic = FlxG.save.data.pauseMusic;
			
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
			
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
		if (FlxG.save.data.checkForUpdates != null)
			checkForUpdates = FlxG.save.data.checkForUpdates;
		if (FlxG.save.data.comboStacking != null)
			comboStacking = FlxG.save.data.comboStacking;

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2' , CoolUtil.getSavePath());
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}