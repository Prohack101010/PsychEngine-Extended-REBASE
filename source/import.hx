// Psych
#if !macro
import Paths;
import flixel.addons.ui.*; //Flixel-UI
#end

// Extra
import extras.states.*; //Extra Menus
import FreeplayState; //Idk Why

// 0.7x Support
import psychlua.*; //Psych-LUA
import backend.ui.*; //Psych-UI
import backend.animation.PsychAnimationController; //Psych Animation Controller
import Difficulty;

// FlxAnimate
#if flxanimate
import flxanimate.*;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Mobile
#if mobile
import mobile.backend.*;
import mobile.flixel.*;
import mobile.objects.*;
import mobile.options.*;
import mobile.states.*;
import mobile.substates.*;
#end

// Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.BatteryManager as AndroidBatteryManager;
#end

// Lua
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

// Openfl
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;

//Flixel
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;