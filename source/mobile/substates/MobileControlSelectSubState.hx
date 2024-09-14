package mobile.substates;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import mobile.objects.MobileControls.Config;
import flixel.ui.FlxButton as UIButtonOld;
import mobile.flixel.FlxButton as UIButton;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;

using StringTools;

class MobileControlSelectSubState extends MusicBeatSubstate
{
    var vpad:FlxVirtualPad;
    var hbox:FlxHitbox;
    var newhbox:FlxNewHitbox;
    public static var upPozition:FlxText;
    public static var downPozition:FlxText;
    public static var leftPozition:FlxText;
    public static var rightPozition:FlxText;
    public static var shiftPozition:FlxText;
    public static var spacePozition:FlxText;
    var inputvari:PsychAlphabet;
    public static var leftArrow:FlxSprite;
    public static var rightArrow:FlxSprite;
    public static var controlitems:Array<String> = ['Pad-Right','Pad-Left','Pad-Custom','Duo','Hitbox','Keyboard'];
    var curSelected:Int = 0;
    var buttonistouched:Bool = false;
    var bindbutton:FlxButton;
    var config:Config;
    var extendConfig:Config;
    
    var bg:FlxBackdrop;
    var ui:FlxCamera;
    public static var exit:UIButton;
    public static var reset:UIButton;
    public static var keyboard:UIButton;
    public static var inControlsSubstate:Bool = false;

    override public function create():Void
    {
        super.create();

        // Transparent background and UI
        bg = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true,
            FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)),
            FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255))));
        bg.velocity.set(40, 40);
        bg.alpha = 0;
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        FlxTween.tween(bg, {alpha: 0.45}, 0.3, {
            ease: FlxEase.quadOut,
            onComplete: (twn:FlxTween) ->
            {
                FlxTween.tween(ui, {alpha: 1}, 0.2, {ease: FlxEase.circOut});
            }
        });
        add(bg);

        ui = new FlxCamera();
        ui.bgColor.alpha = 0;
        ui.alpha = 0;
        FlxG.cameras.add(ui, false);

        config = new Config('saved-controls');
        curSelected = config.getcontrolmode();

        extendConfig = new Config('saved-extendControls');

        var titleText:Alphabet = new Alphabet(75, 60, " Mobile Controls", true);
        titleText.scaleX = 0.6;
        titleText.scaleY = 0.6;
        titleText.alpha = 0.4;
        titleText.cameras = [ui];
        add(titleText);

        vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.globalAntialiasing);
        vpad.alpha = 0;
        vpad.cameras = [ui];
        add(vpad);

        hbox = new FlxHitbox(0.75, ClientPrefs.globalAntialiasing);
        hbox.visible = false;
        hbox.cameras = [ui];
        add(hbox);

        newhbox = new FlxNewHitbox();
        newhbox.visible = false;
        newhbox.cameras = [ui];
        add(newhbox);

        inputvari = new PsychAlphabet(0, 50, controlitems[curSelected], false, false, 0.05, 0.8);
        inputvari.screenCenter(X);
        inputvari.cameras = [ui];
        add(inputvari);

        var ui_tex = Paths.getSparrowAtlas('mobilecontrols/menu/arrows');

        leftArrow = new FlxSprite(inputvari.x - 60, inputvari.y + 50);
        leftArrow.frames = ui_tex;
        leftArrow.animation.addByPrefix('idle', "arrow left");
        leftArrow.animation.addByPrefix('press', "arrow push left");
        leftArrow.animation.play('idle');
        leftArrow.cameras = [ui];
        add(leftArrow);

        rightArrow = new FlxSprite(inputvari.x + inputvari.width + 10, leftArrow.y);
        rightArrow.frames = ui_tex;
        rightArrow.animation.addByPrefix('idle', 'arrow right');
        rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
        rightArrow.animation.play('idle');
        rightArrow.cameras = [ui];
        add(rightArrow);

        upPozition = new FlxText(10, FlxG.height - 164, 0,"Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y, 16);
        upPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        upPozition.borderSize = 2;
        upPozition.cameras = [ui];
        add(upPozition);

        downPozition = new FlxText(10, FlxG.height - 144, 0,"Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y, 16);
        downPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        downPozition.borderSize = 2;
        downPozition.cameras = [ui];
        add(downPozition);

        leftPozition = new FlxText(10, FlxG.height - 124, 0,"Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y, 16);
        leftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        leftPozition.borderSize = 2;
        leftPozition.cameras = [ui];
        add(leftPozition);

        rightPozition = new FlxText(10, FlxG.height - 104, 0,"Button RIght x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y, 16);
        rightPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        rightPozition.borderSize = 2;
        rightPozition.cameras = [ui];
        add(rightPozition);

        spacePozition = new FlxText(10, FlxG.height - 84, 0,"Button Space X:" + vpad.buttonG.x +" Y:" + vpad.buttonG.y, 16);
        spacePozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        spacePozition.borderSize = 2;
        spacePozition.cameras = [ui];
        add(spacePozition);

        shiftPozition = new FlxText(10, FlxG.height - 64, 0,"Button Shift X:" + vpad.buttonF.x +" Y:" + vpad.buttonF.y, 16);
        shiftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        shiftPozition.borderSize = 2;
        shiftPozition.cameras = [ui];
        add(shiftPozition);

        var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press Exit & Save to Go Back to Options Menu', 16);
        tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        tipText.borderSize = 2;
        tipText.scrollFactor.set();
        tipText.cameras = [ui];
        add(tipText);

        exit = new UIButton(0, 35, "Exit & Save", () ->
        {
            save();
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;
            FlxG.sound.play(Paths.sound('cancelMenu'));
            close();
        });
        exit.color = FlxColor.LIME;
        exit.setGraphicSize(Std.int(exit.width) * 3);
        exit.updateHitbox();
        exit.x = FlxG.width - exit.width - 70;
        exit.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
        exit.label.fieldWidth = exit.width;
        exit.label.x = ((exit.width - exit.label.width) / 2) + exit.x;
        exit.label.offset.y = -10;
        exit.cameras = [ui];
        add(exit);
        
        reset = new UIButton(exit.x, exit.height + exit.y + 20, "Reset", () ->
		{
			changeSelection(0); // realods the current control mode ig?
			FlxG.sound.play(Paths.sound('cancelMenu'));
		});
		reset.color = FlxColor.RED;
		reset.setGraphicSize(Std.int(reset.width) * 3);
		reset.updateHitbox();
		reset.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		reset.label.fieldWidth = reset.width;
		reset.label.x = ((reset.width - reset.label.width) / 2) + reset.x;
		reset.label.offset.y = -10;
		reset.cameras = [ui];
		add(reset);
		
		keyboard = new UIButton(exit.x, exit.height + exit.y + 20, "Keyboard", () ->
		{
			save();
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			removeVirtualPad();
			leftArrow.visible = leftArrow.visible = inputvari.visible = exit.visible = reset.visible = keyboard.visible = upPozition.visible = downPozition.visible = leftPozition.visible = rightPozition.visible = shiftPozition.visible = spacePozition.visible = false;
			inControlsSubstate = true;
			openSubState(new options.ControlsSubState());
		});
		keyboard.color = FlxColor.GRAY;
		keyboard.setGraphicSize(Std.int(keyboard.width) * 3);
		keyboard.updateHitbox();
		keyboard.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		keyboard.label.fieldWidth = keyboard.width;
		keyboard.label.x = ((keyboard.width - keyboard.label.width) / 2) + keyboard.x;
		keyboard.label.offset.y = -10;
		keyboard.cameras = [ui];
		add(keyboard);

        changeSelection(0);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        leftArrow.x = inputvari.x - 60;
        rightArrow.x = inputvari.x + inputvari.width + 10;
        inputvari.screenCenter(X);

        for (touch in FlxG.touches.list)
        {		
            if(touch.overlaps(leftArrow) && touch.justPressed)
            {
                changeSelection(-1);
            }
            else if (touch.overlaps(rightArrow) && touch.justPressed)
            {
                changeSelection(1);
            }
            trackbutton(touch);
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = controlitems.length - 1;
        if (curSelected >= controlitems.length)
            curSelected = 0;

        inputvari.changeText(controlitems[curSelected]);

        buttonistouched = false;

        var daChoice:String = controlitems[Math.floor(curSelected)];

        switch (daChoice)
        {
            case 'Pad-Right':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.globalAntialiasing);
                add(vpad);
                loadcustom(false);
            case 'Pad-Left':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(FULL, controlExtend, 0.75, ClientPrefs.globalAntialiasing);
                add(vpad);
                loadcustom(false);
            case 'Pad-Custom':
                reset.visible = true;
                keyboard.visible = false;
                remove(vpad);
                vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, ClientPrefs.globalAntialiasing);
                add(vpad);
                loadcustom(true);
            case 'Duo':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(DUO, controlExtend, 0.75, ClientPrefs.globalAntialiasing);
                add(vpad);
                loadcustom(false);
            case 'Hitbox':
                reset.visible = false;
                keyboard.visible = true;
                vpad.alpha = 0;
            case 'Keyboard':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad.alpha = 0;
        }

        if (daChoice != "Hitbox")
        {
            hbox.visible = false;
            newhbox.visible = false;
        }
        else
        {
            if(ClientPrefs.hitboxmode != 'New'){
                hbox.visible = true;
            }else{
                newhbox.visible = true;
            }
        }

        if (daChoice != "Hitbox" && daChoice != "Keyboard")
        {
            spacePozition.visible = true;
            shiftPozition.visible = true;
        }
        else
        {
            spacePozition.visible = false;
            shiftPozition.visible = false;
        }

        if (daChoice != "Pad-Custom")
        {
            upPozition.visible = false;
            downPozition.visible = false;
            leftPozition.visible = false;
            rightPozition.visible = false;
        }
        else
        {
            upPozition.visible = true;
            downPozition.visible = true;
            leftPozition.visible = true;
            rightPozition.visible = true;
        }
    }

    function trackbutton(touch:flixel.input.touch.FlxTouch)
    {
        var daChoice:String = controlitems[Math.floor(curSelected)];

        if (daChoice == 'Pad-Custom')
        {
            if (buttonistouched)
            {
                if (bindbutton.justReleased && touch.justReleased)
                {
                    bindbutton = null;
                    buttonistouched = false;
                }
                else 
                {
                    movebutton(touch, bindbutton);
                    setbuttontexts();
                }
            }
            else 
            {
                if (vpad.buttonUp.justPressed) {
                    movebutton(touch, vpad.buttonUp);
                }

                if (vpad.buttonDown.justPressed) {
                    movebutton(touch, vpad.buttonDown);
                }

                if (vpad.buttonRight.justPressed) {
                    movebutton(touch, vpad.buttonRight);
                }

                if (vpad.buttonLeft.justPressed) {
                    movebutton(touch, vpad.buttonLeft);
                }
            }
        }
        if (daChoice != 'Hitbox')
        {
            if (buttonistouched)
            {
                if (bindbutton.justReleased && touch.justReleased)
                {
                    bindbutton = null;
                    buttonistouched = false;
                }
                else 
                {
                    movebutton(touch, bindbutton);
                    setbuttontexts();
                }
            }
            else 
            {
                if (vpad.buttonG.justPressed) {
                    movebutton(touch, vpad.buttonG);
                }

                if (vpad.buttonF.justPressed) {
                    movebutton(touch, vpad.buttonF);
                }
            }
        }
    }

    function movebutton(touch:flixel.input.touch.FlxTouch, button:FlxButton)
    {
        button.x = touch.x - vpad.buttonUp.width / 2;
        button.y = touch.y - vpad.buttonUp.height / 2;
        bindbutton = button;
        buttonistouched = true;
    }

    function setbuttontexts()
    {
        upPozition.text = "Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y;
        downPozition.text = "Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y;
        leftPozition.text = "Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y;
        rightPozition.text = "Button RIght x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y;
        spacePozition.text = "Button Space X:" + vpad.buttonG.x +" Y:" + vpad.buttonG.y;
        shiftPozition.text = "Button Shift X:" + vpad.buttonF.x +" Y:" + vpad.buttonF.y;
    }

    function save()
    {
        config.setcontrolmode(curSelected);
        var daChoice:String = controlitems[Math.floor(curSelected)];

        if (daChoice == 'Pad-Custom')
        {
            config.savecustom(vpad);
        }
        if (daChoice != 'Hitbox')
        {
            extendConfig.savecustom(vpad);
        }
    }

    function loadcustom(needFix:Bool):Void
    {
        if (needFix)
        {
            vpad = config.loadcustom(vpad);	
            vpad = extendConfig.loadcustom(vpad);
        }
        else
        {
            vpad = extendConfig.loadcustom(vpad);
        }
    }
}