package extras.optionsNOVA.group;

import shaders.ColorblindFilter;

class GeneralGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'General',
            TITLE
        );
        follow.addOption(option);
       

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        var option:Option = new Option(
            'Change your FPS cap',
            'framerate',
            INT,
            24,
            500,
            'FPS'
        );
        follow.addOption(option);
        option.onChange = onChangeFramerate;

        var option:Option = new Option(
            'Turn off some object on stages',
            'lowQuality',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle antialiasing, improving graphics quality at a slight performance penalty',
            'antialiasing',
            BOOL
        );
        follow.addOption(option);
        
        var option:Option = new Option(
            'Toggle flashing lights that can cause epileptic seizures and strain',
            'flashing',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shaders used for some visual effects',
            'shaders',
            BOOL
        );
        follow.addOption(option);
    }

    static function onChangeFramerate()
    {
        if(ClientPrefs.data.framerate > FlxG.drawFramerate)
        {
            FlxG.updateFramerate = ClientPrefs.data.framerate;
            FlxG.drawFramerate = ClientPrefs.data.framerate;
        }
        else
        {
            FlxG.drawFramerate = ClientPrefs.data.framerate;
            FlxG.updateFramerate = ClientPrefs.data.framerate;
        }
    }
}


    