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
        	else if (TitleState.IndieCrossEnabled)
        	    MusicBeatState.switchState(new FreeplaySelect());
            else
                MusicBeatState.switchState(new FreeplayState());
        }
        else if (Type == 'MainMenu') //MainMenu
        {
            if (ClientPrefs.MainMenuStyle == '0.6.3' || ClientPrefs.MainMenuStyle == 'Extended')
        		MusicBeatState.switchState(new MainMenuStateOld());
        	else if (TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new MainMenuStateCROSS());
        	else if (ClientPrefs.MainMenuStyle == 'NovaFlare')
        	    MusicBeatState.switchState(new MainMenuStateNOVA());
        	else
        		MusicBeatState.switchState(new MainMenuState());
        }
        else if (Type == 'StoryMenu') //StoryMenu
        {
            if (TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new StoryMenuStateCROSS());
        	else
			    MusicBeatState.switchState(new StoryMenuState());
        }
        else if (Type == 'Options') //Options
        {
            LoadingState.loadAndSwitchState(new options.OptionsState());
        }
        else if (Type == 'Credits') //Credits
        {
            MusicBeatState.switchState(new CreditsState());
        }
	}
}