package objects.shape;

import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import objects.shape.ShapeEX;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil; 

import FreeplayState;

class SpecRect extends FlxSprite //freeplay bg rect
{
    var mask:FlxSprite;
    var sprite:FlxSprite;

	public function new(X:Float, Y:Float, Path:String)
    {
        super(X, Y);
        
        sprite = new FlxSprite(X, Y).loadGraphic(Paths.image(Path));

        updateRect(sprite.pixels);
	}

	function drawRect():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.492, 0);
        var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
        var p4:Point = new Point(0, FlxG.height * 0.4);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    function drawLine():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.492, 0);
        var p3:Point = new Point(FlxG.width * 0.45, FlxG.height * 0.4);
        var p4:Point = new Point(0, FlxG.height * 0.4);

        shape.graphics.beginFill(0xFFFFFF); 
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1, true, NONE, NONE, ROUND, 1);
        shape.graphics.moveTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(2, 0xFFFFFF, 1);
        shape.graphics.moveTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x + 5), Std.int(p3.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public function updateRect(sprite:BitmapData) {
        mask = new FlxSprite(0, 0).loadGraphic(drawRect());
        var matrix:Matrix = new Matrix();
        var data:Float = mask.width / sprite.width;
        if (mask.height / sprite.height > data) data = mask.height / sprite.height;
        matrix.scale(data, data);
        matrix.translate(-(sprite.width * data - mask.width) / 2, -(sprite.height * data - mask.height) / 2);

		var bitmap:BitmapData = sprite;

        var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
        resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

        var lineBitmap:BitmapData = drawLine();
        resizedBitmapData.draw(lineBitmap);

        pixels = resizedBitmapData;
        antialiasing = ClientPrefs.globalAntialiasing;
    }
}

class SpecRectBG extends FlxSprite //freeplay bg rect
{
	public function new(X:Float, Y:Float)
    {
        super(X, Y);
		
        loadGraphic(drawRect());
        antialiasing = ClientPrefs.globalAntialiasing;
	}

	function drawRect():BitmapData {
        var shape:Shape = new Shape();
    
        var p1:Point = new Point(0, 0);
        var p2:Point = new Point(FlxG.width * 0.55, 0);
        var p3:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
        var p4:Point = new Point(0, FlxG.height * 0.5);

        var p5:Point = new Point(0, FlxG.height * 0.5);
        var p6:Point = new Point(FlxG.width * 0.5, FlxG.height * 0.5);
        var p7:Point = new Point(FlxG.width * 0.55, FlxG.height * 1);
        var p8:Point = new Point(0, FlxG.height * 1);

        shape.graphics.beginFill(0x000000); 
        shape.graphics.lineStyle(1, 0x000000, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        shape.graphics.beginFill(0x000000); 
        shape.graphics.lineStyle(1, 0x000000, 1);
        shape.graphics.moveTo(p5.x, p5.y);
        shape.graphics.lineTo(p6.x, p6.y);
        shape.graphics.lineTo(p7.x, p7.y);
        shape.graphics.lineTo(p8.x, p8.y);
        shape.graphics.lineTo(p5.x, p5.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), Std.int(p8.y), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }
}

class InfoText extends FlxSpriteGroup //freeplay info
{
    public var data(default, set):Float = -9999;
    public var maxData:Float = 0;
    
    var BlackBG:Rect;
    var WhiteBG:Rect;
    var dataText:FlxText;

    public function new(X:Float, Y:Float, texts:String, maxData:Float)
    {
        super(X, Y);
        
        this.maxData = maxData;

        var text:FlxText = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf');	    		
        add(text);
        
        BlackBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5, FlxColor.WHITE, 0.6);
        add(BlackBG);

        WhiteBG = new Rect(130, text.height / 2 - 3, FlxG.width * 0.26, 5, 5, 5);
        add(WhiteBG);    

        dataText = new FlxText(515, 0, 0, Std.string(data), 18);
		dataText.font = Paths.font('montserrat.ttf');	    		
        add(dataText);

        data = 0;
        antialiasing = ClientPrefs.globalAntialiasing;
    }

    private function set_data(value:Float):Float
    {
        if (data == value) return data;
        data = value;
        dataText.text = Std.string(data);
        return value;
    }

    override function update(elapsed:Float)
    {
        if (FreeplayState.instance.ignoreCheck) return;
        
        if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) > 0.01)
        {
            if (Math.abs((WhiteBG._frame.frame.width / WhiteBG.width) - (data / maxData)) < 0.005) WhiteBG._frame.frame.width = Std.int(WhiteBG.width * (data / maxData));
            else WhiteBG._frame.frame.width = Std.int(WhiteBG.width * FlxMath.lerp((data / maxData), (WhiteBG._frame.frame.width / WhiteBG.width), Math.exp(-elapsed * 15)));
            WhiteBG.updateHitbox();
        }
        super.update(elapsed);
    }
}

class ExtraAudio extends FlxSpriteGroup
{
    var leftLine:FlxSprite;
    var downLine:FlxSprite;
    public var audioDis:AudioDisplay;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, snd:FlxSound = null)
    {
        super(X, Y);
		
        leftLine = new FlxSprite().makeGraphic(3, Std.int(height - 3));
        add(leftLine);

        downLine = new FlxSprite(0, Std.int(height) - 3).makeGraphic(Std.int(width), 3);
        add(downLine);

        audioDis = new AudioDisplay(snd, 5, height - 5, Std.int(width - 5), Std.int(height - 5), 40, 2, FlxColor.WHITE);
        add(audioDis);
	}
}

class MusicLine extends FlxSpriteGroup
{
    var blackLine:FlxSprite;
    var whiteLine:FlxSprite;

    var timeDis:FlxText;
    var timeMaxDis:FlxText;
    var playRate:FlxText;

	public function new(X:Float, Y:Float, width:Float = 0)
    {
        super(X, Y);
		
        blackLine = new FlxSprite().makeGraphic(Std.int(width), 5);
        blackLine.color = 0xffffff;
        blackLine.alpha = 0.5;
        add(blackLine);

        whiteLine = new FlxSprite().makeGraphic(1, 5);
        add(whiteLine);

        timeDis = new FlxText(0, 20, 0, '0', 18);
		timeDis.font = Paths.font('montserrat.ttf');	
        timeDis.alignment = LEFT;  	    		
        timeDis.antialiasing = ClientPrefs.globalAntialiasing;
        add(timeDis);

        timeMaxDis = new FlxText(0, 20, 0, '0', 18);
		timeMaxDis.font = Paths.font('montserrat.ttf');	  
        timeMaxDis.alignment = RIGHT;  	
        timeMaxDis.antialiasing = ClientPrefs.globalAntialiasing;	
        add(timeMaxDis);

        playRate = new FlxText(0, 20, 0, '1.00', 18);
		playRate.font = Paths.font('montserrat.ttf');	
        timeDis.alignment = CENTER;    		
        playRate.antialiasing = ClientPrefs.globalAntialiasing;
        add(playRate);
        playRate.x += width / 2 - playRate.width / 2;

        updateData();
	}

    public function updateData() {
        playRate.text = '1.00';

        timeDis.text = '0:00';
    }

    override function update(e:Float) {
        timeMaxDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2)));
        timeMaxDis.x = width - timeMaxDis.width;

        timeDis.text = Std.string(FlxStringUtil.formatTime(FlxMath.roundDecimal(FlxG.sound.music.time / 1000, 2)));

        whiteLine.scale.x = FlxG.sound.music.time / FlxG.sound.music.length * blackLine.width;
        whiteLine.x = blackLine.x + whiteLine.scale.x / 2;
    }
}

class ExtraTopRect extends FlxSpriteGroup //play/back button
{
    var background:FlxSprite;
    var text:FlxText;

    var saveColor:FlxColor;

    public var onClick:Void->Void = null;

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundSize:Float = 0, roundLeft:Bool = true, texts:String = '', textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);
		
        text = new FlxText(textOffset, 0, 0, texts, 17);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.globalAntialiasing;	

        background = new FlxSprite(0, 0);
        background.pixels = drawRect(width, height, roundSize, roundLeft);
        background.alpha = 0.4;
        background.color = color;
        background.antialiasing = ClientPrefs.globalAntialiasing;
        add(background);
        add(text);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        this.onClick = onClick;
        this.saveColor = color;
	}

    function drawRect(width:Float, height:Float, roundSize:Float, roundLeft:Bool):BitmapData {
        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        if (roundLeft) shape.graphics.drawRoundRectComplex(0, 0, width, height, roundSize, 0, 0, 0);
        else shape.graphics.drawRoundRectComplex(0, 0, width, height, 0, roundSize, 0, 0);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	var needFocusCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if(!ignoreCheck)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            text.color = FlxColor.BLACK;     
            background.color = FlxColor.WHITE;
            background.alpha = 0.4;
            needFocusCheck = true;
        } else {
            if (needFocusCheck)
            {
                text.color = FlxColor.WHITE;
                background.alpha = 0.4;
                background.color = saveColor;
                needFocusCheck = false;
            }
        }
    }
}

class EventRect extends FlxSpriteGroup //freeplay bottom bg rect
{
    public var background:FlxSprite;
    var text:FlxText;

    public var onClick:Void->Void = null;
    var _y:Float = 0;

	public function new(X:Float, Y:Float, texts:String, color:FlxColor, onClick:Void->Void = null)
    {
        super(X, Y);
		
        text = new FlxText(0, 0, 0, texts, 18);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.globalAntialiasing;	

        background = new FlxSprite().loadGraphic(drawRect(text.width + 60));
        background.color = color;
        background.alpha = 0.5;
        background.antialiasing = ClientPrefs.globalAntialiasing;
        add(background);
        add(text);

        var touchFix:Rect = new Rect(0, 0, (text.width + 60), FlxG.height * 0.1, 0, 0, FlxColor.WHITE, 0);
        add(touchFix);

        text.x += background.width / 2 - text.width / 2;
        text.y += FlxG.height * 0.1 / 2 - text.height / 2;

        _y = Y;
        this.onClick = onClick;
	}

    function drawRect(width:Float):BitmapData {
        var shape:Shape = new Shape();

        var p1:Point = new Point(2, 0);
        var p2:Point = new Point(width + 2, 0);
        var p3:Point = new Point(width, 5);
        var p4:Point = new Point(0, 5);

        shape.graphics.beginFill(0xFFFFFFFF); 
        shape.graphics.lineStyle(1, 0xFFFFFFFF, 1);
        shape.graphics.moveTo(p1.x, p1.y);
        shape.graphics.lineTo(p2.x, p2.y);
        shape.graphics.lineTo(p3.x, p3.y);
        shape.graphics.lineTo(p4.x, p4.y);
        shape.graphics.lineTo(p1.x, p1.y);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(p2.x), 5, true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	private var _needACheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if(!ignoreCheck)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            onClick();

        if (onFocus)
        {
            background.alpha += elapsed * 8;
            if (background.scale.y < 2) background.scale.y += elapsed * 8;
        } else {
            if (background.alpha > 0.5) background.alpha -= elapsed * 8;
            if (background.scale.y > 1) background.scale.y -= elapsed * 8;
        }

        if (background.scale.y < 1) background.scale.y = 1;
        background.y = _y + (background.scale.y - 1) * 2.5;
    }
}

class SongRect extends FlxSpriteGroup //songs member for freeplay
{
    public var diffRectGroup:FlxSpriteGroup; //我只是懒的整图层了
    public var diffRectArray:Array<DiffRect> = []; //获取DiffRect，因为FlxSpriteGroup识别为flxSprite（粑粑haxe我服了）
    public var background:FlxSprite;
    var icon:HealthIcon;
    var songName:FlxText;
    var muscan:FlxText;

    public var member:Int;
    public var name:String;
    public var haveAdd:Bool = false;

	public function new(X:Float, Y:Float, songNameS:String, songChar:String, songColor:FlxColor)
    {
        super(X, Y);

        diffRectGroup = new FlxSpriteGroup(0, 0);
        add(diffRectGroup);

        var mask:Rect = new Rect(0, 0, 700, 90, 25, 25);
        background = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
        
        var matrix:Matrix = new Matrix();
        var data:Float = mask.width / background.width;
        if (mask.height / background.height > data) data = mask.height / background.height;
        matrix.scale(data, data);
        matrix.translate(-(background.width * data - mask.width) / 2, -(background.height * data - mask.height) / 2);

		var bitmap:BitmapData = background.pixels;

        var resizedBitmapData:BitmapData = new BitmapData(Std.int(mask.width), Std.int(mask.height), true, 0x00000000);
        resizedBitmapData.draw(bitmap, matrix);
		resizedBitmapData.copyChannel(mask.pixels, new Rectangle(0, 0, mask.width, mask.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

        background.pixels = resizedBitmapData;
        background.color = songColor;
        background.antialiasing = ClientPrefs.globalAntialiasing;
        add(background);

        var lineBitmap:BitmapData = drawLine(resizedBitmapData.width, resizedBitmapData.height);
        var lineSprite = new FlxSprite();
        lineSprite.pixels = lineBitmap;
        add(lineSprite); //只能拆分不然会被着色

        icon = new HealthIcon(songChar);
        icon.setGraphicSize(Std.int(background.height * 0.8));
        icon.x += 60 - icon.width / 2;
        icon.y += background.height / 2 - icon.height / 2;
		icon.updateHitbox();
        add(icon);

        songName = new FlxText(100, 5, 0, songNameS, 25);
		songName.font = Paths.font('montserrat.ttf'); 	
        songName.antialiasing = ClientPrefs.globalAntialiasing;	
        add(songName);

        this.name = songNameS;
	}

    function drawLine(width:Float, height:Float):BitmapData {
        var shape:Shape = new Shape();
        var lineSize:Int = 3;
        shape.graphics.beginFill(0xFFFFFF);
        shape.graphics.lineStyle(1, 0xFFFFFF, 1);
        shape.graphics.drawRoundRect(0, 0, width, height, 25, 25);
        shape.graphics.lineStyle(0, 0, 0);
        shape.graphics.drawRoundRect(lineSize, lineSize, width - lineSize * 2, height - lineSize * 2, 20, 20);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    public var posX:Float = -70;
    public var lerpPosX:Float = 0;
    public var posY:Float = 0;
    public var lerpPosY:Float = 0;
    public var onFocus(default, set):Bool = true;
    public var ignoreCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FreeplayState.instance.ignoreCheck) return;

        if (onFocus)
        {
            if (Math.abs(lerpPosX - posX) < 0.1) lerpPosX = posX;
            else lerpPosX = FlxMath.lerp(posX, lerpPosX, Math.exp(-elapsed * 15));
        } else {
            if (Math.abs(lerpPosX - 0) < 0.1) {
                lerpPosX = 0; 
                if (haveDiffDis) desDiff();
            }
            else lerpPosX = FlxMath.lerp(0, lerpPosX, Math.exp(-elapsed * 15));
        }

        if (member > FreeplayState.curSelected)
        {
            if (Math.abs(lerpPosY - posY) < 0.1) lerpPosY = posY;
            else lerpPosY = FlxMath.lerp(posY, lerpPosY, Math.exp(-elapsed * 15));
        } else {
            if (Math.abs(lerpPosY - 0) < 0.1) lerpPosY = 0;
            else lerpPosY = FlxMath.lerp(0, lerpPosY, Math.exp(-elapsed * 15));
        }

        if (FlxG.mouse.justReleased)
        {
            for (num in 0...diffRectArray.length)
            {
                if (FlxG.mouse.overlaps(diffRectArray[num]))
                {
                    diffRectArray[num].onFocus = true;
                    FreeplayState.curDifficulty = diffRectArray[num].member;
                } 
            }
            for (num in 0...diffRectArray.length)
            {
                if (num != FreeplayState.curDifficulty) diffRectArray[num].onFocus = false;
            }
        }

        if (ignoreCheck) {
            if (alpha - 0 < 0.05) alpha = 0;
            else alpha = FlxMath.lerp(0, alpha, Math.exp(-elapsed * 15));
        } else {
            var maxAlpha = onFocus ? 1 : 0.6;
            if (Math.abs(maxAlpha - alpha) < 0.05) alpha = maxAlpha;
            else alpha = FlxMath.lerp(1, alpha, Math.exp(-elapsed * 15));
        }
    }

    var tween:FlxTween;
    private function set_onFocus(value:Bool):Bo