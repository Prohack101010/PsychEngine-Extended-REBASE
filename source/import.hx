// Psych
#if !macro
import Paths;
import flixel.addons.ui.*; //Flixel-UI
#end

//Stage Objects
import stages.objects.*;

//Shaders
import shaders.*;
import shaders.flixel.system.FlxShader;

// Extra
import extras.*; //For CustomSwitchState
import extras.states.*; //Extra States
import extras.substates.*; //Extra Substates
import indiecrossmenus.*; //Indie Cross Menus
import ModsMenuState; //I'm adding Indie Cross Support because Lily's Psych 0.6.3 port is very weird and sucks (crashes and bugs)

// 0.7x Support
import objects.AudioDisplay;
import objects.shape.ShapeEX;
import psychlua.*; //Psych-LUA
import backend.ui.*; //Psych-UI
import mobile.psychlua.Functions;
import objects.Alphabet as AlphabetNew;
import extras.options.BaseSettingsMenu;
import extras.options.Option as OptionNew;
import objects.AttachedText as AttachedTextNew;
import backend.animation.PsychAnimationController; //Psych Animation Controller

//New Lua System
#if ACHIEVEMENTS_ALLOWED
import Achievements;
#end

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

// Desktop
#if desktop
import Discord;
#end

// Mobile Things
import mobile.flixel.*;
import mobile.input.*;
import mobile.states.*;
import mobile.objects.*;
import mobile.options.*;
import mobile.backend.*;
import mobile.psychlua.*;
import mobile.substates.*;
import mobile.backend.Data;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
import mobile.flixel.FlxNewHitbox;

// Android
#if android
import android.Tools as AndroidTools;
import android.Settings as AndroidSettings;
import android.widget.Toast as AndroidToast;
import android.content.Context as AndroidContext;
import android.Permissions as AndroidPermissions;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Environment as AndroidEnvironment;
import android.os.BatteryManager as AndroidBatteryManager;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

// Lua
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

//Flixel
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;
