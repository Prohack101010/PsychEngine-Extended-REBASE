package extras;

class CustomSwitchState //Now You Can Add and Remove Custom Menus More Easier Than Old One
{
    public static function switchMenus(Type:String)
	{
	    if (Type == 'Freeplay') //Freeplay
	    {
	        if (TitleState.IndieCrossEnabled)
	        {
	            if (PlayState.IndieCrossStateType == 1)
            		MusicBeatState.switchState(new FreeplayMain());
                else if (PlayState.IndieCrossStateType == 2)
            		MusicBeatState.switchState(new FreeplayBonus());
                else if (PlayState.IndieCrossStateType == 3)
            		MusicBeatState.switchState(new FreeplayNightmare());
                else
	                MusicBeatState.switchState(new FreeplaySelect());
	        }
	        else
	        {
        		if (ClientPrefs.data.FreeplayStyle == 'NF')
                    MusicBeatState.switchState(new FreeplayStateNF());
                else if (ClientPrefs.data.FreeplayStyle == 'NovaFlare')
                    MusicBeatState.switchState(new FreeplayStateNOVA());
                else
                    MusicBeatState.switchState(new FreeplayState());
            }
        }
        else if (Type == 'MainMenu') //MainMenu
        {
            if (TitleState.IndieCrossEnabled)
        		MusicBeatState.switchState(new MainMenuStateCROSS());
            else
            {
                if (ClientPrefs.data.MainMenuStyle == '0.6.3' || ClientPrefs.data.MainMenuStyle == 'Extended')
            		MusicBeatState.switchState(new MainMenuStateOld());
            	else if (ClientPrefs.data.MainMenuStyle == 'NovaFlare')
            	    MusicBeatState.switchState(new MainMenuStateNOVA());
            	else
            		MusicBeatState.switchState(new MainMenuState());
        	}
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