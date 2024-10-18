package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.utils.Assets;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;
	var LoadBF:FlxSprite;
	
	var loadLeft:FlxSprite;
	var loadRight:FlxSprite;
	var WaterMark:FlxText;
	var EventText:FlxText;
	
	var loadLeftTween:FlxTween;
	var loadRightTween:FlxTween;
	var EventTextTween:FlxTween;
	var loadTextTween:FlxTween;

	public function new(duration:Float, isTransIn:Bool) {
		super();
		
		//I hate vars
		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
    	var width:Int = Std.int(FlxG.width / zoom);
    	var height:Int = Std.int(FlxG.height / zoom);
		
		if (ClientPrefs.data.TransitionStyle == 'NovaFlare')
		{
    		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/Loading/loadingL'));
    		loadLeft.scrollFactor.set();
    		loadLeft.antialiasing = ClientPrefs.data.globalAntialiasing;
    		add(loadLeft);
    		
    		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/Loading/loadingR'));
    		loadRight.scrollFactor.set();
    		loadRight.antialiasing = ClientPrefs.data.globalAntialiasing;
    		add(loadRight);
    		
    		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50 * 2, 0, 'PSYCH EXTENDED V1.0.0', 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Paths.font("loadText.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.globalAntialiasing;
    		add(WaterMark);
            
            EventText= new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Paths.font("loadText.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.globalAntialiasing;
    		add(EventText);
    		
    		if(!isTransIn) {
    			FlxG.sound.play(Paths.sound('loading_close'));
    			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
    				onComplete: function(twn:FlxTween) {
    					if(finishCallback != null) {
    						finishCallback();
    					}
    				},
    			ease: FlxEase.quintInOut});
    			
    			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
    				onComplete: function(twn:FlxTween) {
    					if(finishCallback != null) {
    						finishCallback();
    					}
    				},
    			ease: FlxEase.quintInOut});
    			
    			loadTextTween = FlxTween.tween(WaterMark, {x: 50}, duration, {
    				onComplete: function(twn:FlxTween) {
    					if(finishCallback != null) {
    						finishCallback();
    					}
    				},
    			ease: FlxEase.quintInOut});
    			
    			EventTextTween = FlxTween.tween(EventText, {x: 50}, duration, {
    				onComplete: function(twn:FlxTween) {
    					if(finishCallback != null) {
    						finishCallback();
    					}
    				},
    			ease: FlxEase.quintInOut});
    			
    		} else {
    			FlxG.sound.play(Paths.sound('loading_open'));
    			EventText.text = 'COMPLETED !';
    			
    			loadLeftTween = FlxTween.tween(loadLeft, {x: -1280}, duration, {
    				onComplete: function(twn:FlxTween) {
    					close();
    				},
    			ease: FlxEase.quintInOut});
    			
    			loadRightTween = FlxTween.tween(loadRight, {x: 1280}, duration, {
    				onComplete: function(twn:FlxTween) {
    					close();
    				},
    			ease: FlxEase.quintInOut});
    			
    			loadTextTween = FlxTween.tween(WaterMark, {x: -1230}, duration, {
    				onComplete: function(twn:FlxTween) {
    					close();
    				},
    			ease: FlxEase.quintInOut});
    			
    			EventTextTween = FlxTween.tween(EventText, {x: -1230}, duration, {
    				onComplete: function(twn:FlxTween) {
    					close();
    				},
    			ease: FlxEase.quintInOut});
    			
    			
    		}
    
    		if(nextCamera != null) {
    			loadRight.cameras = [nextCamera];
    			loadLeft.cameras = [nextCamera];
    			WaterMark.cameras = [nextCamera];
    			EventText.cameras = [nextCamera];
    		}
    		nextCamera = null;
    	}
		else
		{
    		transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
    		transGradient.scrollFactor.set();
    		add(transGradient);
    
    		transBlack = new FlxSprite().makeGraphic(width, height + 400, FlxColor.BLACK);
    		transBlack.scrollFactor.set();
    		add(transBlack);
    
    		transGradient.x -= (width - FlxG.width) / 2;
    		transBlack.x = transGradient.x;
    
    		if(isTransIn) {
    			transGradient.y = transBlack.y - transBlack.height;
    			FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
    				onComplete: function(twn:FlxTween) {
    					close();
    				},
    			ease: FlxEase.linear});
    		} else {
    			transGradient.y = -transGradient.height;
    			transBlack.y = transGradient.y - transBlack.height + 50;
    			leTween = FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
    				onComplete: function(twn:FlxTween) {
    					if(finishCallback != null) {
    						finishCallback();
    					}
    				},
    			ease: FlxEase.linear});
    		}
    		
    		if (ClientPrefs.data.TransitionStyle == 'Extended')
    		{
        		LoadBF = new FlxSprite(-150, 250);
        		LoadBF.frames = Paths.getSparrowAtlas('bf running');
        		LoadBF.animation.addByPrefix('bf running', 'bf running');
        		LoadBF.animation.play('bf running');
        		LoadBF.scale.x = 0.3;
        		LoadBF.scale.y = 0.3;
        		LoadBF.scrollFactor.set();
        		LoadBF.antialiasing = ClientPrefs.data.globalAntialiasing;
        		add(LoadBF);
    		}
    
    		if(nextCamera != null) {
    			transBlack.cameras = [nextCamera];
    			transGradient.cameras = [nextCamera];
    			if (ClientPrefs.data.TransitionStyle == 'Extended')
    			    LoadBF.cameras = [nextCamera];
    		}
    		nextCamera = null;
    	}
	}
	
	override function create()
	{
	    var cam:FlxCamera = new FlxCamera();
	    cam.bgColor = 0x00;
    	FlxG.cameras.add(cam, false);
    	cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
	}

	override function update(elapsed:Float) {
	    if (ClientPrefs.data.TransitionStyle != 'NovaFlare')
	    {
    		if(isTransIn) {
    			transBlack.y = transGradient.y + transGradient.height;
    		} else {
    			transBlack.y = transGradient.y - transBlack.height;
    		}
    		super.update(elapsed);
    		if(isTransIn) {
    			transBlack.y = transGradient.y + transGradient.height;
    		} else {
    			transBlack.y = transGradient.y - transBlack.height;
    		}
		}
	}

	override function destroy() {
	    if(leTween != null && ClientPrefs.data.TransitionStyle == 'NovaFlare') {
			finishCallback();
			leTween.cancel();
			loadLeftTween.cancel();
			loadRightTween.cancel();
			loadTextTween.cancel();
			EventTextTween.cancel();
		}
		else if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}