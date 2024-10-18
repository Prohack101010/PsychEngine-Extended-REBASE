package options;

#if desktop
import Discord.DiscordClient;
#end
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
    var noteSkinList:Array<String> = CoolUtil.coolTextFile(StorageUtil.getStorageDirectory() + Paths.getPreloadPath('images/NoteSkin/DataSet/noteSkinList.txt'));
    
	public function new()
	{
		title = 'Visuals and UI Settings';
		rpcTitle = 'Visuals and UI Settings Menu'; //for Discord Rich Presence
		
		var option:Option = new Option('Freeplay Menu Style:',
			"Choose your Freeplay Menu Style",
			'FreeplayStyle',
			'string',
			'Psych',
			['Psych', 'NovaFlare', 'NF']);
		addOption(option);
		
		var option:Option = new Option('Main Menu Style:',
			"Choose your Main Menu Style",
			'MainMenuStyle',
			'string',
			'1.0',
			['1.0', 'NovaFlare', '0.6.3', 'Extended']);
		addOption(option);
		
		var option:Option = new Option('Pause Menu Style:',
			"Choose your Pause Menu Style",
			'PauseMenuStyle',
			'string',
			'Psych',
			['Psych', 'NovaFlare']);
		addOption(option);
		
		var option:Option = new Option('Transition Style:',
			"Choose your Transition Style",
			'TransitionStyle',
			'string',
			'Psych',
			['Psych', 'NovaFlare', 'Extended']);
		addOption(option);
		
		var option:Option = new Option('Note Skin:',
			"Choose Note Skin",
			'NoteSkin',
			'string',
			'original',
			noteSkinList);	
		option.showNote = true;
		addOption(option);
		option.onChange = onChangeNoteSkin;
		
		#if (!INDIECROSS_FORCED && INDIECROSS_ASSETS)
		var option:Option = new Option('Indie Cross Menus',
			'If unchecked, Indie Cross Mods not using Custom Menus (if you have any bug disable this).',
			'IndieCrossMenus',
			'bool',
			true);
		addOption(option);
		option.onChange = changeIndieCrossMenus;
		#end

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		var option:Option = new Option('Main Menu Song:',
			"What song do you prefer for the Main Menu?",
			'FreakyMenu',
			'string',
			'Extended',
			['Extended', 'Psych']);
		addOption(option);
		option.onChange = onChangeMenuMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}
	
	function onChangeMenuMusic()
	{
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}
	
	function changeIndieCrossMenus()
	{
	    if (!TitleState.IndieCrossEnabled && Paths.currentModDirectory.startsWith('Indie Cross'))
            TitleState.IndieCrossEnabled = true;
        else if (TitleState.IndieCrossEnabled)
	        TitleState.IndieCrossEnabled = ClientPrefs.IndieCrossMenus;
	}

	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	
	function onChangeNoteSkin()
	{
		remove(grpNote);

		grpNote = new FlxTypedGroup<FlxSprite>();
		add(grpNote);
		
		for (i in 0...ClientPrefs.arrowHSV.length) {
			var notes:FlxSprite = new FlxSprite((i * 125), 100);
			if (ClientPrefs.NoteSkin == 'original')
			    notes.frames = Paths.getSparrowAtlas('NOTE_assets');
			else
			    notes.frames = Paths.getSparrowAtlas('NoteSkin/' + ClientPrefs.NoteSkin);
			var animations:Array<String> = ['purple0', 'blue0', 'green0', 'red0'];
			notes.animation.addByPrefix('idle', animations[i]);
			notes.animation.play('idle');
			notes.scale.set(0.8, 0.8);
			notes.x += 700;
			notes.antialiasing = ClientPrefs.globalAntialiasing;
			grpNote.add(notes);
			
			var newShader:ColorSwap = new ColorSwap();
			notes.shader = newShader.shader;
			newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
			newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
			newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;	    
		}
	}
}
