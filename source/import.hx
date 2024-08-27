// Psych
#if !macro
import Paths;
#end

// Extra
import extras.states.*; //Extra Menus
import backend.ui.*; //Psych-UI
import backend.animation.PsychAnimationController;
import FreeplayState;
import flixel.addons.ui.*;

// 0.7x Support
import Difficulty;
// import Mods; it brokes TitleState

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
import mobile.SUtil;
import mobile.SwipeUtil;
import mobile.TouchUtil;

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

// openfl
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