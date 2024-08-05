package mobile;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
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
import options.BaseOptionsMenu;
import options.Option;
import openfl.Lib;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import mobile.HitboxSettingsSubState;

using StringTools;

class HitboxSettingsSubState extends BaseOptionsMenu
{
    #if android
	var storageTypes:Array<String> = ["EXTERNAL", "EXTERNAL_EX", "EXTERNAL_NF", "EXTERNAL_DATA", "EXTERNAL_OBB", "EXTERNAL_MEDIA"];
	var externalPaths:Array<String> = SUtil.checkExternalPaths(true);
	final lastStorageType:String = ClientPrefs.storageType;
	#end
	
	var virtualpadSkinList:Array<String> = CoolUtil.coolTextFile(Sys.getCwd() + Paths.getPreloadPath('images/mobilecontrols/virtualpad/virtualpadSkinList.txt'));
	
	public function new()
	{
		title = 'Hitbox Settings';
		rpcTitle = 'Hitbox Settings Menu'; //hi, you can ask what is that, i will answer it's all what you needed lol.
		
		var option:Option = new Option('VirtualPad Skin',
			"Choose VirtualPad Skin",
			'VirtualPadSkin',
			'string',
			'original',
			virtualpadSkinList);

		addOption(option);
		option.onChange = onChangeVirtualPadSkin;

        var option:Option = new Option('Extra Controls',
			"Allow Extra Controls",
			'hitboxExtend',
			'float',
			2);
		option.scrollSpeed = 1.6;
		option.minValue = 0;
		option.maxValue = 4;
		option.changeValue = 1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('VirtualPad Shift',
			'Allow Extend VirtualPad Shift Control',
			'VPadShiftExtend',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('VirtualPad Space',
			'Allow Extend VirtualPad Space Control',
			'VPadSpaceExtend',
			'bool',
			true);
		addOption(option);
		  
		  var option:Option = new Option('Extra Control Location:',
			"Choose Extra Control Location",
			'hitboxLocation',
			'string',
			'Bottom',
			['Bottom', 'Top', 'Middle']);
		  addOption(option);

		var option:Option = new Option('Hitbox Mode:',
			"Choose your Hitbox Style!  -mariomaster",
			'hitboxmode',
			'string',
			'New',
			['Classic', 'New']);
		  addOption(option);
		  
		var option:Option = new Option('Hitbox Design:',
			"Choose how your hitbox should look like.",
			'hitboxtype',
			'string',
			'No Gradient',
			['Gradient', 'No Gradient', 'No Gradient (Old)']);
		  addOption(option);

		var option:Option = new Option('Hitbox Hint',
			'Hitbox Hint -I hate this',
			'hitboxhint',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Hitbox Opacity', //mariomaster was here again
			'Changes opacity -omg',
			'hitboxalpha',
			'float',
			0.2);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('VirtualPad Alpha:', //mariomaster was here again
			'Changes VirtualPad Alpha',
			'VirtualPadAlpha',
			'float',
			0.75);
		option.scrollSpeed = 1.6;
		option.minValue = 0.1;
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);
        option.onChange = onChangePadAlpha;
		super();
		
		var option:Option = new Option('Colored VirtualPad',
			'If unchecked, disables VirtualPad colors\n(can be used to make custom colored VirtualPad)',
			'coloredvpad',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Modpack Folder',
			'If checked, game uses modpack folder instead of mods folder.',
			'Modpack',
			'bool',
			false);
		addOption(option);
		
		#if android
		var option:Option = new Option('Storage Type',
			'Which folder Psych Engine should use?',
			'storageType',
			'string',
			null,
			storageTypes);
			addOption(option);
		#end

		super();
	}

	#if android
	function onStorageChange():Void
	{
		File.saveContent(lime.system.System.applicationStorageDirectory + 'storagetype.txt', ClientPrefs.storageType);
	
		var lastStoragePath:String = StorageType.fromStrForce(lastStorageType) + '/';
	}
	#end

	override public function destroy() {
		super.destroy();
		#if android
		if (ClientPrefs.storageType != lastStorageType) {
			onStorageChange();
			ClientPrefs.saveSettings();
			SUtil.showPopUp('Storage Type has been changed and you needed restart the game!!\nPress OK to close the game.', 'Notice!');
			lime.system.System.exit(0);
		}
		#end
	}
	
	var OGpadAlpha:Float = ClientPrefs.VirtualPadAlpha;
	function onChangePadAlpha()
	{
	ClientPrefs.saveSettings();
	_virtualpad.alpha = ClientPrefs.VirtualPadAlpha / OGpadAlpha;
	}
	
	function onChangeVirtualPadSkin()
	{
	    ClientPrefs.saveSettings();
	    removeVirtualPad();
		openSubState(new HitboxSettingsSubState());
	}

/*
	override function update(elapsed:Float)
	{
		super.update(elapsed);
			#if android
		if (FlxG.android.justReleased.BACK)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new options.OptionsState());
	}
		#end
		}
	*/ //why this exists?!?¡
}
