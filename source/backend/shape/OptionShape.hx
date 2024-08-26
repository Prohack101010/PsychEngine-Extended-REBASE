package objects.shape;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import flash.geom.Point;
import flash.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import objects.shape.ShapeEX;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;

import options.Option;

class BoolRect extends FlxSpriteGroup {
    var touchFix:Rect;
    var bg:FlxSprite;
    var display:Rect;

    var follow:Option;

    public function new(X:Float, Y:Float, width:Float, height:Float, point:Option = null)
    {
        super(X, Y);

        touchFix = new Rect(0, 0, width, height);
        touchFix.alpha = 0;
        add(touchFix);

        bg = new FlxSprite();
        bg.pixels = drawRect(50, 20);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x53b7ff;
        bg.x += touchFix.width - bg.width - 50;
        bg.y += touchFix.height / 2 - bg.height / 2;
        add(bg);

        display = new Rect(touchFix.width - bg.width - 50 - 15, touchFix.height / 2 - bg.height / 2, 80, 20, 20, 20);
        display.color = 0x53b7ff;
        if (point.defaultValue == true) 
        {
            display.alpha = 0;
            state = true;
        }
        add(display);

        this.follow = point;
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xffffff); 
        shape.graphics.drawRoundRect(0, 0, width, height, height, height);
        shape.graphics.endFill();

        var line:Int = 2;

        shape.graphics.beginFill(0x00); 
        shape.graphics.drawRoundRect(line, line, width - line * 2, height - line * 2, height - line * 2, height - line * 2);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && FlxG.mouse.justReleased)
            onClick();
    }

    var tween:FlxTween;
    var state:Bool = false;
    function onClick() {
        if (tween != null) tween.cancel();
        if (state)
        {
            tween = FlxTween.tween(display, {alpha: 1}, 0.1);
        } else {
            tween = FlxTween.tween(display, {alpha: 0}, 0.1);
        }
        state = !state;

        follow.setValue(state);
    }
}

class FloatRect extends FlxSpriteGroup {
    var bg:FlxSprite;
    var display:FlxSprite;

    var rect:Rect;

    var follow:Option;

    var max:Float;
    var min:Float;

    public function new(X:Float, Y:Float, minData:Float, maxData:Float, point:Option = null)
    {
        super(X, Y);

        bg = new FlxSprite();
        bg.pixels = drawRect(950, 10);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x24232C;
        add(bg);

        display = new FlxSprite();
        display.pixels = drawRect(950, 10);
        display.antialiasing = ClientPrefs.data.antialiasing;
        display.color = 0x0095ff;
        add(display);

        rect = new Rect(0, 0, 80, 20, 20, 20);
        rect.color = 0x53b7ff;
        add(rect);
        rect.y += bg.height / 2 - rect.height / 2;

        this.follow = point;
        this.max = maxData;
        this.min = minData;

        persent = (point.defaultValue - minData) / (maxData - minData);
        onHold();
    }

    function drawRect(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xffffff); 
        shape.graphics.drawRoundRect(0, 0, width, height, height, height);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(rect) && FlxG.mouse.justPressed)
        {
            posX = FlxG.mouse.x - rect.x;
            onFocus = true;
        }

        if (FlxG.mouse.justReleased) onFocus = false;

        if(onFocus && FlxG.mouse.pressed) onHold();
    }

    var posX:Float;
    var persent:Float = 0;
    function onHold() {
        rect.x = FlxG.mouse.x - posX;
        if (rect.x < bg.x) rect.x = bg.x;
        if (rect.x + rect.width > bg.x + bg.width) rect.x = bg.x + bg.width - rect.width;

        persent = (rect.x - bg.x) / (bg.width - rect.width);

        display._frame.frame.width = display.width * persent;
    }
}

class StringRect extends FlxSpriteGroup {
    var bg:Rect;
    var specRect:FlxSprite;
    var disText:FlxText;

    var strArray:Array<String> = [];

    var follow:Option;

    public function new(X:Float, Y:Float, point:Option = null)
    {
        super(X, Y);

        bg = new Rect(0, 0, 950, 50, 15, 15);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x24232C;
        add(bg);

        specRect = new FlxSprite();
        specRect.pixels = drawRect(25);
        specRect.antialiasing = ClientPrefs.data.antialiasing;
        add(specRect);
        specRect.x += bg.width - specRect.width - 20;
        specRect.y += bg.height / 2 - specRect.height / 2;
        
        disText = new FlxText(20, 0, 0, 'texts', 20);
		disText.font = Paths.font('montserrat.ttf');	  
        disText.antialiasing = ClientPrefs.data.antialiasing;  		
        add(disText);
        disText.y += bg.height / 2 - disText.height / 2;

        this.follow = point;
        //strArray = point.options;
    }

    function drawRect(size:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(size * 0.5, size * 0.5);
        var p3:Point = new Point(size, 0);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.moveTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(size), Std.int(size * 0.5 + 2), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    var isOpened:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        onFocus = FlxG.mouse.overlaps(bg);

        if (onFocus) bg.color = 0x53b7ff;
        else bg.color = 0x24232C;

        if(onFocus && FlxG.mouse.justPressed)
            onClick();
    }

    var chooseBG:Rect;
    var chooseCam:FlxCamera;
    var chooseArray:Array<CurRect> = [];
    function onClick() {
        var length:Int = 0;
        if (strArray.length >= 5) length = 5;
        else length = strArray.length;

        if (!isOpened)
        {
            isOpened = true;

            specRect.flipY = true;
            
            chooseBG = new Rect(0, bg.height + 5, bg.width, (bg.height - 20) * length, 15, 15, 0x24232C);
            add(chooseBG);	

            for (num in 0...length)
            {
                var rect:CurRect = new CurRect(0, bg.height + 5 + 30 * num, chooseBG.width, 30, strArray[num], num, length - 1);
                add(rect);
                chooseArray.push(rect);
            }
        } else {
            isOpened = false;

            specRect.flipY = false;

            for (num in 0...length)
            {
                var rect:CurRect = chooseArray[length - 1 - num];
                rect.destroy();
            }
            chooseArray = [];
            chooseBG.destroy();
        }
    }
}

class CurRect extends FlxSpriteGroup {
    var bg:FlxSprite;
    var disText:FlxText;
    public function new(X:Float, Y:Float, Width:Float, Height:Float, text:String, num:Int, max:Int)
    {
        super(X, Y);

        var data = 0;
        if (num == 0) data = 1;
        else if (num == max) data = 2;

        bg = new FlxSprite(0, 0);
        bg.pixels = drawRect(Width, Height, data);
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.color = 0x53b7ff;
        bg.alpha = 0;
        add(bg);
        
        disText = new FlxText(20, 0, 0, text, 15);
		disText.font = Paths.font('montserrat.ttf');	  
        disText.antialiasing = ClientPrefs.data.antialiasing;  		
        add(disText);
        disText.y += bg.height / 2 - disText.height / 2;
    }

    function drawRect(width:Float, height:Float, roundData:Int):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xFFFFFFFF); 
        if (roundData == 1) shape.graphics.drawRoundRectComplex(0, 0, width, height, 12, 12, 0, 0);
        else if (roundData == 2) shape.graphics.drawRoundRectComplex(0, 0, width, height, 0, 0, 12, 12);
        else shape.graphics.drawRoundRectComplex(0, 0, width, height, 0, 0, 0, 0);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        onFocus = FlxG.mouse.overlaps(bg);

        if (onFocus) bg.alpha = 1;
        else bg.alpha = 0;
    }
}

class OptionCata extends FlxSpriteGroup
{
    var bg:Rect;
	var text:FlxText;
    var specRect:Rect;

	public function new(x:Float, y:Float, _title:String)
	{
		super(x, y);

        bg = new Rect(0, 0, 250, 80.625);
        bg.alpha = 0;
        add(bg);

		text = new FlxText(40, 0, 0, _title, 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += bg.height / 2 - text.height / 2;
        add(text);

        specRect = new Rect(20, 20, 5, 40, 5, 5, 0x53b7ff);
        specRect.alpha = 0;
        specRect.scale.y = 0;
        specRect.antialiasing = ClientPrefs.data.antialiasing;	
        add(specRect);
	}

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();
    }

    var bgTween:FlxTween;
    var specAlphaTw:FlxTween;
    var specScaleTw:FlxTween;
    function onClick() 
    {
        bg.alpha = 0.6;
        if (bgTween != null) bgTween.cancel();
        bgTween = FlxTween.tween(bg, {alpha: 0}, 0.3); 

        if (specAlphaTw != null) specAlphaTw.cancel();
        if (specScaleTw != null) specScaleTw.cancel();
    }

    var focused:Bool = false;
    public function forceUpdate()
    {
        if (!focused)
        {
            focused = true;
            specAlphaTw = FlxTween.tween(specRect, {alpha: 1}, 0.15); 
            specScaleTw = FlxTween.tween(specRect.scale, {y: 1}, 0.15); 
        } else {
            focused = false;
            specAlphaTw = FlxTween.tween(specRect, {alpha: 0}, 0.15); 
            specScaleTw = FlxTween.tween(specRect.scale, {y: 0}, 0.15); 
        }
    }
}

class OptionBG extends FlxSpriteGroup
{
    var optionArray:Array<Option> = [];

    var saveHeight:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

    public var onFocus:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        onFocus = FlxG.mouse.overlaps(this);
    }

    public function addOption(mem:Option)
    {
        add(mem);
        optionArray.push(mem);
        mem.y += saveHeight;
        saveHeight += mem.saveHeight;
    }
}