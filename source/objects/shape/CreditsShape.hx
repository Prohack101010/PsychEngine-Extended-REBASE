package objects.shape;

import objects.shape.ShapeEX;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import flash.geom.Point;
import flash.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import flixel.util.FlxSpriteUtil;

class CreditsButton extends FlxSpriteGroup //back button
{
    var background:Rect;
    var bg2:FlxSprite;
    var button:FlxSprite; 
    var text:FlxText;

    public var onClick:Void->Void = null;

    var saveColor:FlxColor = 0;
    var saveColor2:FlxColor = 0;

    public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        bg2 = new FlxSprite(-60);
        bg2.pixels = drawRect(width, height);
        bg2.color = color;
        add(bg2);

        background = new Rect(0, 0, height, height);
        background.color = color;
        add(background); 

        var line = new Rect(background.width - 3, 0, 3, height, 0, 0, 0xFFFFFFFF);
        line.alpha = 0.75;
        add(line);

        button = new FlxSprite(0,0).loadGraphic(Paths.image('menuExtend/Others/playButton'));
        button.scale.set(0.4, 0.4);
        button.antialiasing = ClientPrefs.data.antialiasing;
        button.x += background.width / 2 - button.width / 2;
        button.y += background.height / 2 - button.height / 2;
        button.flipX = true;
        add(button);

        text = new FlxText(70, 0, 0, texts, 18);
        text.font = Paths.font('montserrat.ttf');     
        text.antialiasing = ClientPrefs.data.antialiasing;    
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
        saveColor2 = color;
        saveColor2.lightness = 0.5;
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(10, 0);
        var p2:Point = new Point(width + 10, 0);
        var p3:Point = new Point(width, height);
        var p4:Point = new Point(0, height);

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    var bgTween:FlxTween;
    var textTween:FlxTween;
    var focused:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            if (!focused){
                focused = true;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: 0}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: 105}, 0.3, {ease: FlxEase.backInOut});
                var color = 
                background.color = saveColor2;
            }
        } else {
            if (focused){
                focused = false;
                if (bgTween != null) bgTween.cancel();
                bgTween = FlxTween.tween(bg2, {x: -60}, 0.3, {ease: FlxEase.backInOut});

                if (textTween != null) textTween.cancel();
                textTween = FlxTween.tween(text, {x: 77}, 0.3, {ease: FlxEase.backInOut});
                
                background.color = saveColor;
            }
        }
    }
}

class ModsButtonRect extends FlxSpriteGroup //play/back button
{
    var background:Rect;
    var text:FlxText;
    var box:FlxSprite;

    var saveColor:FlxColor;

    public var list:Array<Array<String>> = [];
    public var onClick:Void->Void = null;
    public var folder:String = 'unknownMod';

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0, texts:String = '', textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        box = new FlxSprite();

        this.folder = texts;

        var bmp = Paths.cacheBitmap(Paths.mods('$folder/pack.png'));
		if(bmp == null)
		{
			bmp = Paths.cacheBitmap(Paths.mods('$folder/pack-pixel.png'));
			//isPixel = true;
		}

        if(bmp != null)
        {
            box.loadGraphic(bmp, true, 150, 150);
        }

        else box.loadGraphic(Paths.image('unknownMod'), true, 150, 150);
        box.scale.set(0.5, 0.5);
        box.updateHitbox();
		
        text = new FlxText(0, 0, 0, texts, 22);
        text.color = FlxColor.WHITE;
        text.font = Paths.font('montserrat.ttf');
        text.antialiasing = ClientPrefs.data.antialiasing;

        background = new Rect(0, 0, width, height, roundWidth, roundHeight, color);
        background.color = color;
        background.alpha = 0.6;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);
        add(text);
        add(box);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        box.x += background.width / 32 - box.width / 32;
        box.y += (background.height / 2 - box.height / 2) - 1;

        box.updateHitbox();
        text.updateHitbox();

        this.onClick = onClick;
        this.saveColor = color;
	}

    public var focusChangeCallback:Bool->Void = null;
	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	var needFocusCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!ignoreCheck && !Controls.instance.controllerMode)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            //click();

        if (onFocus)
        {
            background.alpha = 1;
            needFocusCheck = true;
        } else {
            if (needFocusCheck)
            {
                background.alpha = 0.6;
                needFocusCheck = false;
            }
        }
    }
}