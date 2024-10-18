package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import options.OptionsState;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Mobile Options'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var stateType:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool;

	function openSelectedSubstate(label:String) {
	    if (label != "Adjust Delay and Combo"){
			removeVirtualPad();
			persistentUpdate = false;
		}
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Mobile Controls':
    			FlxTransitionableState.skipNextTransIn = true;
    			FlxTransitionableState.skipNextTransOut = true;
    			openSubState(new MobileControlSelectSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Mobile Options':
			    openSubState(new MobileOptionsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end
		
		if (ClientPrefs.data.VirtualPadAlpha != 0) { options = ['Note Colors', 'Mobile Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Mobile Options']; }

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.globalAntialiasing;
		add(bg);
		
		var tipText:FlxText = new FlxText(10, 12, 0, 'Press E to Go In Extra Key Return Menu', 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		changeSelection();
		ClientPrefs.saveSettings();

		addVirtualPad(UP_DOWN, A_B_E);

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		removeVirtualPad();
		addVirtualPad(UP_DOWN, A_B_E);
		persistentUpdate = true;
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}
		
		if (controls.BACK) {
	     	if (OptionsState.onPlayState) {
	     	    if (TitleState.IndieCrossEnabled) {
    	     	    StageData.loadDirectory(PlayState.SONG);
    				LoadingState.loadAndSwitchState(new PlayState());
    				FlxG.sound.music.volume = 0;
	     	    }
	     	    else {
				MusicBeatState.switchState(new PlayState());
				OptionsState.onPlayState = false;
				}
			}
			else if (OptionsState.stateType == 2) {
			    MusicBeatState.switchState(new FreeplayStateNF());
			    OptionsState.stateType = 0;
			} else if (OptionsState.stateType == 1) {
			    MusicBeatState.switchState(new FreeplayStateNOVA());
			    OptionsState.stateType = 0;
			} else {
    			if (TitleState.IndieCrossEnabled)
    			    FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
    			CustomSwitchState.switchMenus('MainMenu');
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		
		if (_virtualpad.buttonE.justPressed) {
			removeVirtualPad();
			persistentUpdate = false;
			openSubState(new MobileExtraControl());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
