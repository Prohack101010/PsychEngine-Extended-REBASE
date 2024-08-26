package options;

import MainMenuState;
import FreeplayState;

class OptionsState extends MusicBeatState
{
	public static var instance:OptionsState;
	public static var isFreeplay:Bool = false;

	var optionName:Array<String> = ['General', 'Gameplay', 'Game Backend', 'Game UI', 'Skin', 'Input', 'User Interface', 'Watermark'];
	var optionArray:Array<OptionCata> = [];

	var bgArray:Array<OptionBG> = [];
    
	override function create()
	{     
		persistentUpdate = persistentDraw = true;

		instance = this;
		
		var bg = new Rect(0,0, FlxG.width, FlxG.height, 0, 0, 0x302E3A);
		add(bg);

		var bg = new Rect(0,0, 250, FlxG.height, 0, 0, 0x24232C);
		add(bg);

		for (i in 0...optionName.length)
		{
			var option = new OptionCata(0, 80.625 * i, optionName[i]);
			add(option);
			optionArray.push(option);
		}

		var back = new BackButton(0,0, 250, 75, 'back', 0x53b7ff, backMenu);
		back.y = FlxG.height - 75;
		add(back);

		for (i in 0...optionArray.length)
		{
			var bg:OptionBG = new OptionBG(250, 0);
			add(bg);
			switch (i)
			{
				case 0:
					GeneralGroup.add(bg);
			}
		}
		
		super.create();
	}

	var pressCheck:Bool = false;
	function backMenu() {
	    if (isFreeplay){
	        MusicBeatState.switchState(new FreeplayState());
			OptionsState.isFreeplay = false;
		}
		if (!pressCheck){
			pressCheck = true;
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}