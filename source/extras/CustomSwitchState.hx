package extras;

class CustomSwitchState //Now You Can Add and Remove Custom Menus More Easier Than Old One
{
    public static function switchMenus(Type:String)
	{
	    if (Type == 'Freeplay') //Freeplay
	    {
    		if (ClientPrefs.FreeplayStyle == 'NF')
                MusicBeatState.switchState(new FreeplayStateNF());
            else if (ClientPrefs.FreeplayStyle == 'NovaFlare')
                MusicBeatState.switchState(new FreeplayStateNOVA());
            else if (PlayState.IndieCrossStateType == 1 && TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new FreeplayMain());
            else if (PlayState.IndieCrossStateType == 2 && TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new FreeplayBonus());
            else if (PlayState.IndieCrossStateType == 3 && TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new FreeplayNightmare());
            else
                MusicBeatState.switchState(new FreeplayState());
        }
        elseif (Type == 'MainMenu') //MainMenu
        {
            else if (ClientPrefs.MainMenuStyle == '0.6.3' || ClientPrefs.MainMenuStyle == 'Extended')
        		MusicBeatState.switchState(new MainMenuStateOld());
        	else if (TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new MainMenuStateCROSS());
        	else
        		MusicBeatState.switchState(new MainMenuState());
        }
	}
}