// Psych
#if !macro
import Paths;
import flixel.addons.ui.*; //Flixel-UI
#end

// Extra
import extras.states.*; //Extra States
import extras.substates.*; //Extra Substates
import ModsMenuState; //I'm adding Indie Cross Support because Lily's Psych 0.6.3 port is very weird and sucks (crashes and bugs)

// 0.7x Support
import backend.Mods;
import objects.AudioDisplay;
import objects.shape.ShapeEX;
import psychlua.*; //Psych-LUA
import backend.ui.*; //Psych-UI
import backend.animation.PsychAnimationController; //Psych Animation Controller

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
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxNewHitbox;
import mobile.flixel.FlxVirtualPad;
import mobile.backend.*;
import mobile.flixel.*;
import mobile.objects.*;
import mobile.options.*;
import mobile.states.*;
import mobile.substates.*;
import mobile.psychlua.*;
import mobile.backend.Data;
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