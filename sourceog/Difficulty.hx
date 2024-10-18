package;

class Difficulty
{
	public static var defaultList(default, never):Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultIndieCrossList(default, never):Array<String> = [
		'No-mechanics',
		'Hard',
		'Hell'
	];
	public static var list:Array<String> = [];
	private static var defaultDifficulty(default, never):String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode
	private static var defaultIndieCrossDifficulty(default, never):String = 'Hard'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode for indie cross

	inline public static function getFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;
            
		var fileSuffix:String = list[num];
		if (TitleState.IndieCrossEnabled)
		    fileSuffix = defaultIndieCrossList[num]; // TOOK ME A WHOLE FUCKING DAY TO FIX THIS PEICE OF SHIT -KarimAkra
		 
        if(fileSuffix != defaultDifficulty)
    	{
    		fileSuffix = '-' + fileSuffix;
    	}
    	else
    	{
    		fileSuffix = '';
    	}
		return Paths.formatToSongPath(fileSuffix);
	}
	
	inline public static function loadFromWeek(week:WeekData = null)
	{
		if(week == null) week = WeekData.getCurrentWeek();

		var diffStr:String = week.difficulties;
		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.trim().split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
				list = diffs;
		}
		else resetList();
	}

	inline public static function resetList()
	{
		list = defaultList.copy();
	}

	inline public static function copyFrom(diffs:Array<String>)
	{
		list = diffs.copy();
	}

	inline public static function getString(num:Null<Int> = null):String
	{
	    if (TitleState.IndieCrossEnabled)
		    return defaultIndieCrossList[num == null ? PlayState.storyDifficulty : num];
		else
		    return list[num == null ? PlayState.storyDifficulty : num];
	}

	inline public static function getDefault():String
	{
	    if (TitleState.IndieCrossEnabled)
		    return defaultIndieCrossDifficulty;
		else
		    return defaultDifficulty;
	}
}
