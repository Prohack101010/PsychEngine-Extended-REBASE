package shaders;

import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;
import flixel.FlxG;
import flixel.graphics.tile.FlxGraphicsShader;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;

class ColorblindFilter {
	public static var matrix:Array<Float>;
	public static var colorM:Array<Float>;

	public static function UpdateColors(?input:Array<BitmapFilter> = null):Void
	{

		var a1:Float = 1;
		var a2:Float = 0;
		var a3:Float = 0;

		var b1:Float = 0;
		var b2:Float = 1;
		var b3:Float = 0;

		var c1:Float = 0;
		var c2:Float = 0;
		var c3:Float = 1;

		a1 = 1;
		b1 = 0;
		c1 = 0;
		a2 = 0;
		b2 = 1;
		c2 = 0;
		a3 = 0;
		b3 = 0;
		c3 = 1;

		matrix = [
			a1 * 1, b1 * 1, c1 * 1, 0, 1,
			a2 * 1, b2 * 1, c2 * 1, 0, 1,
			a3 * 1, b3 * 1, c3 * 1, 0, 1,
			                        0,                         0,                         0, 1,                         0,
		];

		if (input != null)
		{
			input.push(new ColorMatrixFilter(matrix));
		}
		else
		{
			var filters:Array<BitmapFilter> = [];
			filters.push(new ColorMatrixFilter(matrix));
			FlxG.game.filtersEnabled = true;
			FlxG.game.setFilters(filters);
		}
	}
}