package mobile.options;

#if desktop
import Discord.DiscordClient;
#end
import openfl.text.TextField;
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
import options.BaseOptionsMenu;
import options.Option;
import openfl.Lib;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import mobile.backend.StorageUtil;
import mobile.options.MobileOptionsSubState;

using StringTools;

class MobileOptionsSubState extends BaseOptionsMenu
{
    #if android
	var storageTypes:Array<String> = ["EXTERNAL_DATA", "EXTERNAL", "EXTERNAL_EX", "EXTERNAL_NF", "EXTERNAL_OBB", "EXTERNAL_MEDIA", "EXTERNAL_ONLINE"];
	var externalPaths:Array<String> = StorageUtil.checkExternalPaths(true);
	final lastStorageType:String = ClientPrefs.data.storageType;
	#end
	
	var virtualpadTypes:Array<String> = ["New", "Old"];
	var virtualpadSkinList:Array<String> = CoolUtil.coolTextFile(Paths.getPreloadPath('images/mobilecontrols/virtualpad/virtualpadSkinList.txt'));
	var virtualpadSkinListModsFolder:Array<String> = CoolUtil.coolTextFile(Paths.modsImages('virtualpad/virtualpadSkinList.txt'));
	
	public function new()
	{
		title = 'Mobile Options';
		rpcTitle = 'Mobile Options Menu'; //hi, you can ask what is that, i will answer it's all what you needed lol.
		
		if (ClientPrefs.data.virtualpadType == 'New')
		    virtualpadSkinList = CoolUtil.coolTextFile(Paths.getSharedPath('images/virtualpad/virtualpadSkinList.txt'));
		    
		#if MODS_ALLOWED
		final modsPath:String = Paths.mods('virtualpad/virtualpadSkinList');
		final modsPathExtra:String = Paths.mods('virtualpad/virtualpadSkinList.txt');
		if((sys.FileSystem.exists(modsPath) || sys.FileSystem.exists(modsPathExtra)) && ClientPrefs.data.virtualpadType == 'New')
		    virtualpadSkinList = CoolUtil.coolTextFile(Paths.mods('virtualpad/virtualpadSkinList.txt'));
		#end
		
	if (ClientPrefs.data.VirtualPadAlpha != 0) {
		var option:Option = new Option('VirtualPad Skin',
			"Choose VirtualPad Skin",
			'VirtualPadSkin',
			'string',
			'original',
			virtualpadSkinList);

		addOption(option);
		option.onChange = resetVirtualPad;
	}
		
		var option:Option = new Option('VirtualPad Alpha:', //mariomaster was here again
			'Changes VirtualPad Alpha -cool feature',
			'VirtualPadAlpha',
			'float',
			#if mobile 0.75 #else 0 #end);
		option.scrollSpeed = 1.6;
		option.minValue = 0;
		option.maxValue = 1;
		option.changeValue = 0.01;
		option.decimals = 2;
		addOption(option);
        option.onChange = onChangePadAlpha;
		super();
		
	if (ClientPrefs.data.VirtualPadAlpha != 0) {
		var option:Option = new Option('Colored VirtualPad',
			'If unchecked, disables VirtualPad colors\n(can be used to make custom colored VirtualPad)',
			'coloredvpad',
			'bool',
			true);
		addOption(option);
		option.onChange = resetVirtualPad;
		
		var option:Option = new Option('VirtualPad Type',
			'Which VirtualPad should use??',
			'virtualpadType',
			'string',
			null,
			virtualpadTypes);
		addOption(option);
		
		var option:Option = new Option('Extra Controls',
			"Allow Extra Controls",
			'extraKeys',
			'float',
			2);
		option.scrollSpeed = 1.6;
		option.minValue = 0;
		option.maxValue = 4;
		option.changeValue = 1;
		option.decimals = 1;
		addOption(option);
	}
		
	#if mobile //only Mobile Because You Can't Change Mobile Controls, Technically You Cant use Hitbox into the PC Build	
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
			'Gradient',
			['Gradient', 'No Gradient' , 'No Gradient (Old)']);
		addOption(option);

		var option:Option = new Option('Hitbox Hint',
			'Hitbox Hint -I hate this',
			'hitboxhint',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Hitbox Opacity', //mariomaster was here again
			'Changes hitbox opacity -omg',
			'hitboxalpha',
			'float',
			0.7);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if mobile
		var option:Option = new Option('Wide Screen Mode',
			'If checked, The game will stetch to fill your whole screen. (WARNING: Can result in bad visuals & break some mods that resizes the game/cameras)',
			'wideScreen',
			'bool',
			true);
		option.onChange = () -> FlxG.scaleMode = new MobileScaleMode();
		addOption(option);
		#end
		
		#if android
		var option:Option = new Option('Storage Type',
			'Which folder Psych Engine should use?',
			'storageType',
			'string',
			null,
			storageTypes);
			addOption(option);
		#end
	#end

		super();
	}

	#if android
	function onStorageChange():Void
	{
		File.saveContent(lime.system.System.applicationStorageDirectory + 'storagetype.txt', ClientPrefs.data.storageType);
	
		var lastStoragePath:String = StorageType.fromStrForce(lastStorageType) + '/';
	}
	#end

	override public function destroy() {
		super.destroy();
		#if android
		if (ClientPrefs.data.storageType != lastStorageType) {
			onStorageChange();
			ClientPrefs.saveSettings();
			CoolUtil.showPopUp('Storage Type has been changed and you needed restart the game!!\nPress OK to close the game.', 'Notice!');
			lime.system.System.exit(0);
		}
		#end
	}
	
	function onChangePadAlpha()
	{
    	ClientPrefs.saveSettings();
    	_virtualpad.alpha = ClientPrefs.data.VirtualPadAlpha;
	}
	
	function resetVirtualPad()
	{
	    removeVirtualPad();
	    addVirtualPad(FULL, A_B_C);
	}
}
