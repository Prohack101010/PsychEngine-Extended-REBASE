package mobile.psychlua;

import FunkinLua;
import lime.ui.Haptic;
import mobile.backend.TouchFunctions;
#if android
import android.widget.Toast as AndroidToast;
import android.Tools as AndroidTools;
#end

#if mobile
class MobileFunctions
{
	public static function implement(funk:FunkinLua)
	{
	    var lua:State = funk.lua;
		
		Lua_helper.add_callback(lua, "changeHitboxControls", function(mode:String):Void
		{
			PlayState.instance.changeHitboxControls(mode);
		});
		
		Lua_helper.add_callback(lua, "addHitboxControls", function(mode:String):Void
		{
			PlayState.instance.addHitboxControls(mode);
		});
		
		Lua_helper.add_callback(lua, "addMobileControls", function():Void
		{
			PlayState.instance.addPlayStateMobileControls();
		});
		
		Lua_helper.add_callback(lua, "removeMobileControls", function():Void
		{
			PlayState.instance.removePlayStateMobileControls();
		});

		Lua_helper.add_callback(lua, "vibrate", function(duration:Null<Int>, ?period:Null<Int>)
		{
			if (period == null)
				period = 0;
			if (duration == null)
				return FunkinLua.luaTrace('vibrate: No duration specified.');
			return Haptic.vibrate(period, duration);
		});
		
		Lua_helper.add_callback(lua, "addVirtualPad", function(DPadMode:String, ActionMode:String):Void
		{
			PlayState.instance.makeLuaVirtualPad(DPadMode, ActionMode);
			PlayState.instance.addLuaVirtualPad();
		});
		
		Lua_helper.add_callback(lua, "removeVirtualPad", function():Void
		{
			PlayState.instance.removeLuaVirtualPad();
		});
		
		Lua_helper.add_callback(lua, "addVirtualPadCamera", function():Void
		{
			if (PlayState.instance.luaVirtualPad == null)
			{
				FunkinLua.luaTrace('addVirtualPadCamera: VPAD does not exist.');
				return;
			}
			PlayState.instance.addLuaVirtualPadCamera();
		});

		Lua_helper.add_callback(lua, "touchJustPressed", TouchFunctions.touchJustPressed);
		Lua_helper.add_callback(lua, "touchPressed", TouchFunctions.touchPressed);
		Lua_helper.add_callback(lua, "touchJustReleased", TouchFunctions.touchJustReleased);
		Lua_helper.add_callback(lua, "touchPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchPressed;
		});

		Lua_helper.add_callback(lua, "touchJustPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustPressed;
		});

		Lua_helper.add_callback(lua, "touchJustReleasedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustReleased;
		});

		Lua_helper.add_callback(lua, "touchOverlapsObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchOverlapsObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj);
		});
	}
	
	public static function getExtraControlsVarInArray(instance:Dynamic, variable:String):Any
	{
		#if mobile //Extend for check control for mobile, you can try to extend other key at same way but I'm so lazy. --Write by NF|beihu(北狐丶逐梦)
	        var pressCheck:Dynamic;
	        if (MusicBeatState.mobilec.newhbox != null){ //check for android control and dont check for keyboard
			    if (variable == 'keys.justPressed.SPACE' && MusicBeatState.mobilec.newhbox.buttonSpace.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.SPACE' && MusicBeatState.mobilec.newhbox.buttonSpace.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.SPACE' && MusicBeatState.mobilec.newhbox.buttonSpace.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
                
                if (variable == 'keys.justPressed.SHIFT' && MusicBeatState.mobilec.newhbox.buttonShift.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.SHIFT' && MusicBeatState.mobilec.newhbox.buttonShift.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.SHIFT' && MusicBeatState.mobilec.newhbox.buttonShift.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
                
                if (variable == 'keys.justPressed.Q' && MusicBeatState.mobilec.newhbox.buttonQ.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.Q' && MusicBeatState.mobilec.newhbox.buttonQ.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.Q' && MusicBeatState.mobilec.newhbox.buttonQ.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
                
                if (variable == 'keys.justPressed.E' && MusicBeatState.mobilec.newhbox.buttonE.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.E' && MusicBeatState.mobilec.newhbox.buttonE.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.E' && MusicBeatState.mobilec.newhbox.buttonE.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
            }
            
            if (MusicBeatState.mobilec.vpad != null){ //check for android control and dont check for keyboard
			    if (variable == 'keys.justPressed.SPACE' && MusicBeatState.mobilec.vpad.buttonG.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.SPACE' && MusicBeatState.mobilec.vpad.buttonG.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.SPACE' && MusicBeatState.mobilec.vpad.buttonG.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
                
                if (variable == 'keys.justPressed.SHIFT' && MusicBeatState.mobilec.vpad.buttonF.justPressed){
    			    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.pressed.SHIFT' && MusicBeatState.mobilec.vpad.buttonF.pressed){
                    pressCheck = true;
                    return pressCheck;
                }
                else if (variable == 'keys.justReleased.SHIFT' && MusicBeatState.mobilec.vpad.buttonF.justReleased){
                    pressCheck = true;
                    return pressCheck;
                }
            }
        #end
        
		var shit:Array<String> = variable.split('[');
		if(shit.length > 1)
		{
			var blah:Dynamic = null;
			if(PlayState.instance.variables.exists(shit[0]))
			{
				var retVal:Dynamic = PlayState.instance.variables.get(shit[0]);
				if(retVal != null)
					blah = retVal;
			}
			else
				blah = Reflect.getProperty(instance, shit[0]);

			for (i in 1...shit.length)
			{
				var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
				blah = blah[leNum];
			}
			return blah;
		}

		if(PlayState.instance.variables.exists(variable))
		{
			var retVal:Dynamic = PlayState.instance.variables.get(variable);
			if(retVal != null)
				return retVal;
		}

		return Reflect.getProperty(instance, variable);
	}
}
#end

#if android
class AndroidFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua:State = funk.lua;
		
		#if android
		Lua_helper.add_callback(lua, "isDolbyAtmos", AndroidTools.isDolbyAtmos());
		Lua_helper.add_callback(lua, "isAndroidTV", AndroidTools.isAndroidTV());
		Lua_helper.add_callback(lua, "isTablet", AndroidTools.isTablet());
		Lua_helper.add_callback(lua, "isChromebook", AndroidTools.isChromebook());
		Lua_helper.add_callback(lua, "isDeXMode", AndroidTools.isDeXMode());
		Lua_helper.add_callback(lua, "backJustPressed", FlxG.android.justPressed.BACK);
		Lua_helper.add_callback(lua, "backPressed", FlxG.android.pressed.BACK);
		Lua_helper.add_callback(lua, "backJustReleased", FlxG.android.justReleased.BACK);
		Lua_helper.add_callback(lua, "menuJustPressed", FlxG.android.justPressed.MENU);
		Lua_helper.add_callback(lua, "menuPressed", FlxG.android.pressed.MENU);
		Lua_helper.add_callback(lua, "menuJustReleased", FlxG.android.justReleased.MENU);
		Lua_helper.add_callback(lua, "getCurrentOrientation", () -> PsychJNI.getCurrentOrientationAsString());
		Lua_helper.add_callback(lua, "setOrientation", function(hint:Null<String>):Void
		{
			switch (hint.toLowerCase())
			{
				case 'portrait':
					hint = 'Portrait';
				case 'portraitupsidedown' | 'upsidedownportrait' | 'upsidedown':
					hint = 'PortraitUpsideDown';
				case 'landscapeleft' | 'leftlandscape':
					hint = 'LandscapeLeft';
				case 'landscaperight' | 'rightlandscape' | 'landscape':
					hint = 'LandscapeRight';
				default:
					hint = null;
			}
			if (hint == null)
				return FunkinLua.luaTrace('setOrientation: No orientation specified.');
			PsychJNI.setOrientation(FlxG.stage.stageWidth, FlxG.stage.stageHeight, false, hint);
		});
		Lua_helper.add_callback(lua, "minimizeWindow", () -> AndroidTools.minimizeWindow());
		Lua_helper.add_callback(lua, "showToast", function(text:String, duration:Null<Int>, ?xOffset:Null<Int>, ?yOffset:Null<Int>)
		{
			if (text == null)
				return FunkinLua.luaTrace('showToast: No text specified.');
			else if (duration == null)
				return FunkinLua.luaTrace('showToast: No duration specified.');

			if (xOffset == null)
				xOffset = 0;
			if (yOffset == null)
				yOffset = 0;

			AndroidToast.makeText(text, duration, -1, xOffset, yOffset);
		});
		Lua_helper.add_callback(lua, "isScreenKeyboardShown", () -> PsychJNI.isScreenKeyboardShown());

		Lua_helper.add_callback(lua, "clipboardHasText", () -> PsychJNI.clipboardHasText());
		Lua_helper.add_callback(lua, "clipboardGetText", () -> PsychJNI.clipboardGetText());
		Lua_helper.add_callback(lua, "clipboardSetText", function(text:Null<String>):Void
		{
			if (text != null) return FunkinLua.luaTrace('clipboardSetText: No text specified.');
			PsychJNI.clipboardSetText(text);
		});

		Lua_helper.add_callback(lua, "manualBackButton", () -> PsychJNI.manualBackButton());

		Lua_helper.add_callback(lua, "setActivityTitle", function(text:Null<String>):Void
		{
			if (text != null) return FunkinLua.luaTrace('setActivityTitle: No text specified.');
			PsychJNI.setActivityTitle(text);
		});
		#end	
	}
}
#end