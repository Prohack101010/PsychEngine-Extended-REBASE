package mobile.flixel;

import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton as FlxButtonOld;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;

import haxe.io.Path;
import openfl.utils.AssetType;

// Lua VirtualPad
import haxe.ds.StringMap;

class FlxVirtualPad extends FlxSpriteGroup {
	//Actions
	public var buttonA:VirtualPadButton;
	public var buttonB:VirtualPadButton;
	public var buttonC:VirtualPadButton;
	public var buttonD:VirtualPadButton;
	public var buttonE:VirtualPadButton;
	public var buttonM:VirtualPadButton;
	public var buttonP:VirtualPadButton;
	public var buttonV:VirtualPadButton;
	public var buttonX:VirtualPadButton;
	public var buttonY:VirtualPadButton;
	public var buttonZ:VirtualPadButton;
	public var buttonF:VirtualPadButton;
	public var buttonG:VirtualPadButton;
	
	//Extra
    public var buttonExtra1:VirtualPadButton;
	public var buttonExtra2:VirtualPadButton;
	public var buttonExtra3:VirtualPadButton;
	public var buttonExtra4:VirtualPadButton;
    
	//DPad
	public var buttonLeft:VirtualPadButton;
	public var buttonUp:VirtualPadButton;
	public var buttonRight:VirtualPadButton;
	public var buttonDown:VirtualPadButton;

	//PAD DUO MODE
	public var buttonLeft2:VirtualPadButton;
	public var buttonUp2:VirtualPadButton;
	public var buttonRight2:VirtualPadButton;
	public var buttonDown2:VirtualPadButton;
    
    public var buttonCELeft:VirtualPadButton;
	public var buttonCEUp:VirtualPadButton;
	public var buttonCERight:VirtualPadButton;
	public var buttonCEDown:VirtualPadButton;
	public var buttonCEG:VirtualPadButton;
	
	public var buttonCEUp_M:VirtualPadButton;
	public var buttonCEDown_M:VirtualPadButton;
	
	public var dPad:FlxSpriteGroup;
	public var actions:FlxSpriteGroup;

	public var orgAlpha:Float = 0.75;
	public var orgAntialiasing:Bool = true;
	
	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */

	public function new(DPad:FlxDPadMode, Action:FlxActionMode, ?alphaAlt:Float = 0.75, ?antialiasingAlt:Bool = true) {
		super();

		orgAntialiasing = antialiasingAlt;
		orgAlpha = ClientPrefs.data.VirtualPadAlpha;

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();

		buttonA = new VirtualPadButton(0, 0);
		buttonB = new VirtualPadButton(0, 0);
		buttonC = new VirtualPadButton(0, 0);
		buttonD = new VirtualPadButton(0, 0);
		buttonE = new VirtualPadButton(0, 0);
		buttonM = new VirtualPadButton(0, 0);
		buttonP = new VirtualPadButton(0, 0);
		buttonV = new VirtualPadButton(0, 0);
		buttonX = new VirtualPadButton(0, 0);
		buttonY = new VirtualPadButton(0, 0);
		buttonZ = new VirtualPadButton(0, 0);

		buttonLeft = new VirtualPadButton(0, 0);
		buttonUp = new VirtualPadButton(0, 0);
		buttonRight = new VirtualPadButton(0, 0);
		buttonDown = new VirtualPadButton(0, 0);

		buttonLeft2 = new VirtualPadButton(0, 0);
		buttonUp2 = new VirtualPadButton(0, 0);
		buttonRight2 = new VirtualPadButton(0, 0);
		buttonDown2 = new VirtualPadButton(0, 0);
        
        buttonCELeft = new VirtualPadButton(0, 0);
		buttonCEUp = new VirtualPadButton(0, 0);
		buttonCERight = new VirtualPadButton(0, 0);
		buttonCEDown = new VirtualPadButton(0, 0);
		buttonCEG = new VirtualPadButton(0, 0);
		
		buttonCEUp_M = new VirtualPadButton(0, 0);
		buttonCEDown_M = new VirtualPadButton(0, 0);
		
		switch (DPad){
			case UP_DOWN:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 127, "down", 0x00FFFF)));
			case LEFT_RIGHT:
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, "right", 0xFF0000)));
			case UP_LEFT_RIGHT:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, "right", 0xFF0000)));
			case FULL:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, "down", 0x00FFFF)));
			case ALL:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, "right", 0xFF0000)));
			case OptionsC:
			    add(buttonUp = createButton(0, FlxG.height - 85 * 3, "up", 0x00FF00));
				add(buttonDown = createButton(0, FlxG.height - 45 * 3, "down", 0x00FFFF));	
			case RIGHT_FULL:
				dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, "down", 0x00FFFF)));
			case DUO:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, "right", 0xFF0000)));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, "down", 0x00FFFF)));
				dPad.add(add(buttonUp2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonLeft2 = createButton(FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight2 = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, "right", 0xFF0000)));
				dPad.add(add(buttonDown2 = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, "down", 0x00FFFF)));
			case PAUSE:	
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 45 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(84 * 3, FlxG.height - 45 * 3, "right", 0xFF0000)));
			case CHART_EDITOR:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, "down", 0x00FFFF)));
				dPad.add(add(buttonLeft = createButton(42 * 3, FlxG.height - 85 * 3, "left", 0xFF00FF)));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, "right", 0xFF0000)));
				
				//dPad.add(add(buttonCEUp_M = createButton(0, FlxG.height - 127 * 3, "up", 0xFF00FF)));
				//dPad.add(add(buttonCEDown_M = createButton(42 * 3, FlxG.height - 127 * 3, "down", 0xFF0000)));
			case NONE:
		}

		switch (Action){
		    case E:
		        orgAlpha = 1;
				actions.add(add(buttonE = createButton(FlxG.width - 44 * 3, FlxG.height - 125 * 3, "modding", 0xFF7D00, false)));
			case A:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));
			case B:
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));
			case D:
				actions.add(add(buttonD = createButton(FlxG.width - 44 * 3, FlxG.height - 127 * 3, "d", 0x0078FF)));						
			case P:
				actions.add(add(buttonP = createButton(FlxG.width - 44 * 3, FlxG.height - 127 * 3, "d", 0x0078FF)));						
		    case X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "x", 0x99062D)));
			case A_B:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));
			case A_C:
				actions.add(add(buttonC = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));				
			case A_B_C:
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));				
			case A_B_E:
				actions.add(add(buttonE = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "e", 0xFF7D00)));   
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));
			case A_B_E_C_M:
			    actions.add(add(buttonM = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "m", 0xFFCB00)));
				actions.add(add(buttonE = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "e", 0xFF7D00)));   
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));
			    actions.add(add(buttonC = createButton(FlxG.width - 44 * 3, FlxG.height - 125 * 3, "c", 0x44FF00)));
 			case A_B_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "x", 0x99062D)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));	 			               
		    case A_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "x", 0x99062D)));
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));								
			case B_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "x", 0x99062D)));
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
			case A_B_C_X_Y:		
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "x", 0x99062D)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));				
			case A_B_C_X_Y_Z:
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));	
			case FULL:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));
		    case OptionsC:
			    add(buttonLeft = createButton(FlxG.width - 258, FlxG.height - 85 * 3, "left", 0xFF00FF));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 85 * 3, "right", 0xFF0000));
			    add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
			    add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case ALL:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));				
				
				dPad.add(add(buttonCEUp = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonCEDown = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 45 * 3, "down", 0x00FFFF)));		
				dPad.add(add(buttonCEG = createButton(FlxG.width - (44 + 42 * 1) * 3, 25, "g", 0x00FF00)));
				
			case controlExtend:
			    if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 1) actions.add(add(buttonExtra1 = createButton(FlxG.width * 0.5 - 44 * 3, FlxG.height * 0.5 - 127 * 0.5, "f", 0xFF0000)));
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 2) actions.add(add(buttonExtra2 = createButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "g", 0xFFFF00)));	
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 3) actions.add(add(buttonExtra3 = createButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "x", 0x99062D)));	
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 4) actions.add(add(buttonExtra4 = createButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "y", 0x4A35B9)));	
				
			case CHART_EDITOR:
				actions.add(add(buttonV = createButton(FlxG.width - 170 * 3, FlxG.height - 85 * 3, "v", 0x49A9B2)));            
				actions.add(add(buttonX = createButton(FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D)));
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9)));
				actions.add(add(buttonZ = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E)));
				actions.add(add(buttonD = createButton(FlxG.width - 170 * 3, FlxG.height - 45 * 3, "d", 0x0078FF)));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00)));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));								
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000)));				
				
				dPad.add(add(buttonCEUp = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 85 * 3, "up", 0x00FF00)));
				dPad.add(add(buttonCEDown = createButton(FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 45 * 3, "down", 0x00FFFF)));		
				dPad.add(add(buttonCEG = createButton(FlxG.width - (44 + 42 * 1) * 3, 25, "g", 0x00FF00)));
			case B_E:
				actions.add(add(buttonE = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, "e", 0xFF7D00)));  
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00)));					
			case NONE:
		}
	}

	public function createButton(X:Float, Y:Float, Frames:String, ColorS:Int, ?colored:Bool = true):VirtualPadButton {
	    var button = new VirtualPadButton(X, Y, Graphic.toUpperCase());
		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();
		button.color = Color;
		button.parentAlpha = this.orgAlpha;
		return button;
	}

	public static function getFrames():FlxAtlasFrames {
	    try
	    {
		    return Paths.getPackerAtlas('mobilecontrols/virtualpad/' + ClientPrefs.data.VirtualPadSkin);
		}
		catch(e:Dynamic)
		{
		    return Paths.getPackerAtlas('mobilecontrols/virtualpad/original');
		}
	}
	
	override public function destroy():Void
	{
		super.destroy();
		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), VirtualPadButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}
}

class VirtualPadButton extends FlxButton
{
	public function new(X:Float = 0, Y:Float = 0, ?labelGraphic:String){
		super(X, Y);
		if(labelGraphic != null){
			label = new FlxSprite();
			loadGraphic(Paths.image('virtualpad/newest/bg', "mobile"));
			label.loadGraphic(Paths.image('virtualpad/newest/$labelGraphic', "mobile"));
			scale.set(0.243, 0.243);
			updateHitbox();
			updateLabelPosition();
			statusAlphas = [parentAlpha, parentAlpha - 0.05, (parentAlpha - 0.45 == 0 && parentAlpha > 0) ? 0.25 : parentAlpha - 0.45];
			statusBrightness = [1, 0.9, 0.75];
			statusIndicatorType = BRIGHTNESS;
			labelStatusDiff = 0.08;
			indicateStatus();
			solid = false;
			immovable = true;
			moves = false;
			antialiasing = ClientPrefs.data.antialiasing;
			label.antialiasing = ClientPrefs.data.antialiasing;
			tag = labelGraphic.toUpperCase();
		}
	}
}