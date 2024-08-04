package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import CopyState;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // WINDOW width
	var gameHeight:Int = 720; // WINDOW height
	var initialState:Class<FlxState> = TitleState; // initial game state
	var zoom:Float = -1.0; // game state bounds
	var framerate:Int = 60; // default framerate
	var skipSplash:Bool = true; // if the default flixel splash screen should be skipped
	var startFullscreen:Bool = true; // if the game should start at fullscreen mode

	public static var fpsVar:FPS;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
		cpp.NativeGc.enable(true);
		#elseif hl
		hl.Gc.enable(true);
		#end
	}

	public function new()
	{
	    #if mobile
	    #if android
		SUtil.doPermissionsShit();
		#end
		Sys.setCwd(SUtil.getStorageDirectory());
		#end
		
		CrashHandler.init();

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end
	
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			Lib.current.stage.addEventListener(Event.RESIZE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (Lib.current.stage.hasEventListener(Event.RESIZE))
		{
			Lib.current.stage.removeEventListener(Event.RESIZE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1.0)
		{
			var ratioX:Float = stageWidth / width;
			var ratioY:Float = stageHeight / height;
			zoom = Math.min(ratioX, ratioY);
			width = Math.ceil(stageWidth / zoom);
			height = Math.ceil(stageHeight / zoom);
		}
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(width, height, #if (mobile && MODS_ALLOWED) !CopyState.checkExistingFiles() ? CopyState : #end initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if android
		FlxG.android.preventDefaultKeys = [BACK]; 
		#end

		#if desktop
		if (!DiscordClient.isInitialized) {
			DiscordClient.initialize();
			Application.current.window.onClose.add(function() {
				DiscordClient.shutdown();
			});
		}
		#end
	}
}
