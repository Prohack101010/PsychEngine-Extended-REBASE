package mobile.backend;

import flixel.FlxG;
import flixel.system.scaleModes.BaseScaleMode;

/**
 * ...
 * @author: Karim Akra
 */
class MobileScaleMode extends BaseScaleMode
{
    public static var allowWideScreen(default, set):Bool = true;
    public static var MobileScreenEvent(default, set):Bool = false; // I don't have a Funkin Horror source code right now but I can add a simple support

    override function updateGameSize(Width:Int, Height:Int):Void
	{
        if(ClientPrefs.data.wideScreen && allowWideScreen)
        {
            super.updateGameSize(Width, Height);
        }
        else
        {
            var ratio:Float = FlxG.width / FlxG.height;
            var realRatio:Float = Width / Height;
    
            var scaleY:Bool = realRatio < ratio;
    
            if (scaleY)
            {
                gameSize.x = Width;
                if(!MobileScreenEvent)
                    gameSize.y = Math.floor(gameSize.x / ratio);
                else
                    gameSize.y = Math.floor(gameSize.x);
            }
            else
            {
                gameSize.y = Height;
                if(!MobileScreenEvent)
                    gameSize.x = Math.floor(gameSize.y * ratio);
                else
                    gameSize.x = Math.floor(gameSize.y);
            }
        }
	}

    override function updateGamePosition():Void
	{
        if(ClientPrefs.data.wideScreen && allowWideScreen)
		    FlxG.game.x = FlxG.game.y = 0;
        else
            super.updateGamePosition();
	}

    @:noCompletion
    private static function set_allowWideScreen(value:Bool):Bool
    {
        allowWideScreen = value;
        FlxG.scaleMode = new MobileScaleMode();
        return value;
    }
    private static function set_MobileScreenEvent(value:Bool):Bool
    {
        MobileScreenEvent = value;
        FlxG.scaleMode = new MobileScaleMode();
        return value;
    }
}