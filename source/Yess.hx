package;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

import objects.ShapeEX;
import objects.FreePlayShape;

class Yess extends MusicBeatState
{
	public static var leftState:Bool = false;
    var pressed:Bool = false;
	var warnText:FlxText;
	override function create()
	{
		super.create();

		var Triangle:Triangle = new Triangle(50, 50, 100, 1);
		add(Triangle);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
