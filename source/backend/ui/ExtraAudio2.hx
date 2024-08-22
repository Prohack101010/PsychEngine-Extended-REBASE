package backend.ui;

class ExtraAudio2 extends FlxSpriteGroup
{
    var leftLine:FlxSprite;
    var downLine:FlxSprite;
    // public var audioDis:AudioDisplay;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, snd:FlxSound = null)
    {
        super(X, Y);
		
        leftLine = new FlxSprite().makeGraphic(3, Std.int(height - 3));
        add(leftLine);

        downLine = new FlxSprite(0, Std.int(height) - 3).makeGraphic(Std.int(width), 3);
        add(downLine);

        // audioDis = new AudioDisplay(snd, 5, height - 5, Std.int(width - 5), Std.int(height - 5), 40, 2, FlxColor.WHITE);
        // add(audioDis);
	}
}
