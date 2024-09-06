package objects.shape;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import flixel.util.FlxSpriteUtil;
import CheckboxThingie;

class Triangle extends FlxSprite
{
	public function new(X:Float, Y:Float, Size:Float, Inner:Float)
    {
        super(X, Y);
		
        loadGraphic(drawHollowTriangle(Size, Inner));
        antialiasing = ClientPrefs.globalAntialiasing;
	}

	function drawHollowTriangle(sideLength:Float, innerSide:Float):BitmapData {
        var shape:Shape = new Shape();
    
        // Width and height of the image to ensure that the triangle is centered in the image
        var imageSize:Float = sideLength * Math.sqrt(3); // The height of an equilateral triangle is sqrt(3)/2 of the side lengths, multiplied by 2 to get the image size
        // image center point
        var centerX:Float = imageSize / 2;
        var centerY:Float = imageSize / 2 + 5; // +5 is a bug fix
    
        // Calculate the positions of the three vertices of the equilateral triangle, making sure that the center is in the center of the image
        var angleStep:Float = Math.PI * 2 / 3; // The angle difference between the vertices is 120 degrees, or 2π/3
        var p1:Point = new Point(centerX + sideLength * Math.cos(0), centerY + sideLength * Math.sin(0));
        var p2:Point = new Point(centerX + sideLength * Math.cos(angleStep), centerY + sideLength * Math.sin(angleStep));
        var p3:Point = new Point(centerX + sideLength * Math.cos(angleStep * 2), centerY + sideLength * Math.sin(angleStep * 2));
    
        // Drawing external triangles
        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();
    
        // Drawing internal triangles
        var innerSideLength:Float = sideLength * (1 - innerSide);
        var innerP1:Point = new Point(centerX + innerSideLength * Math.cos(0), centerY + innerSideLength * Math.sin(0));
        var innerP2:Point = new Point(centerX + innerSideLength * Math.cos(angleStep), centerY + innerSideLength * Math.sin(angleStep));
        var innerP3:Point = new Point(centerX + innerSideLength * Math.cos(angleStep * 2), centerY + innerSideLength * Math.sin(angleStep * 2));
    
        shape.graphics.beginFill(0x00); // Set the fill color to transparent
        shape.graphics.moveTo(innerP1.x, innerP1.y);
        shape.graphics.lineTo(innerP2.x, innerP2.y);
        shape.graphics.lineTo(innerP3.x, innerP3.y);
        shape.graphics.lineTo(innerP1.x, innerP1.y);
        shape.graphics.endFill();
    
        var bitmap:BitmapData = new BitmapData(Std.int(imageSize * 1.2), Std.int(imageSize * 1.2), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }
}

class Rect extends FlxSprite
{
    public function new(X:Float = 0, Y:Float = 0, width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0, Color:FlxColor = FlxColor.WHITE, ?Alpha:Float = 1)
    {
        super(X, Y);

        loadGraphic(drawRect(width, height, roundWidth, roundHeight));
        antialiasing = ClientPrefs.globalAntialiasing;
        color = Color;
        alpha = Alpha;
    }

    function drawRect(width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.drawRoundRect(0, 0, width, height, roundWidth, roundHeight);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }
}

class BackButton extends FlxSpriteGroup 
{
    var background:Rect;
    var button:FlxSprite; 
    var text:FlxText;

    public var onClick:Void->Void = null;

    var saveColor:FlxColor = 0;
    var saveColor2:FlxColor = 0;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, texts:String = '', color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        background = new Rect(0, 0, width, height);
        background.color = color;
        add(background); 

        button = new FlxSprite(0,0).loadGraphic(Paths.image('menuExtend/Others/playButton'));
        button.scale.set(0.4, 0.4);
        button.antialiasing = ClientPrefs.globalAntialiasing;
        button.y += background.height / 2 - button.height / 2;
        button.flipX = true;
        add(button);

        text = new FlxText(40, 0, 0, texts, 25);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.globalAntialiasing;	
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
        saveColor2 = color;
        saveColor2.lightness = 0.5;
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
                background.color = saveColor2;
            }
        } else {
            if (focused){
                focused = false;               
                background.color = saveColor;
            }
        }
    }
}