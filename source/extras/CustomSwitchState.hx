package extras;

class CustomSwitchState
{
    public static function switchMenus(Type:String)
	{
		if (ClientPrefs.FreeplayStyle == 'NF' && Type == 'Freeplay')
            MusicBeatState.switchState(new FreeplayStateNF());
        else if (ClientPrefs.FreeplayStyle == 'NovaFlare' && Type == 'Freeplay')
            MusicBeatState.switchState(new FreeplayStateNOVA());
        else if (PlayState.IndieCrossStateType == 1 && TitleState.IndieCrossEnabled && Type == 'Freeplay')
    		MusicBeatState.switchState(new FreeplayMain());
        else if (PlayState.IndieCrossStateType == 2 && TitleState.IndieCrossEnabled && Type == 'Freeplay')
    		MusicBeatState.switchState(new FreeplayBonus());
        else if (PlayState.IndieCrossStateType == 3 && TitleState.IndieCrossEnabled && Type == 'Freeplay')
    		MusicBeatState.switchState(new FreeplayNightmare());
        else
            MusicBeatState.switchState(new FreeplayState());
	}
}