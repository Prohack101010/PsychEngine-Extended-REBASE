package mobile.backend;

import haxe.ds.StringMap;

class Data
{
	public static var dpadMode:StringMap<FlxDPadMode> = new StringMap<FlxDPadMode>();
	public static var actionMode:StringMap<FlxActionMode> = new StringMap<FlxActionMode>();

	public static function setup()
	{
		for (data in FlxDPadMode.createAll())
			dpadMode.set(data.getName(), data);

		for (data in FlxActionMode.createAll())
			actionMode.set(data.getName(), data);
	}
}


enum FlxDPadMode {
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	FULL;
	ALL;
	OptionsC;
	RIGHT_FULL;
	DUO;
	PAUSE;
	CHART_EDITOR;
	NONE;
}

enum FlxActionMode {
    E;
	A;
	B;
	D;
	P;
	X_Y;
	A_B;
	A_C;
	A_B_C;
	A_B_E;
	A_B_E_C_M;
	A_B_X_Y;	
	A_X_Y;	
	B_X_Y;	
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	FULL;
	OptionsC;
	ALL;
	CHART_EDITOR;
	controlExtend;
	B_E;
	NONE;
}