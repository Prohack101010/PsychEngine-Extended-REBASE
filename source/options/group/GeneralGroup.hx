package options.group;

class GeneralGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'General',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Change your FPS cap.',
            'framerate',
            INT,
            24,
            500,
            'FPS'
        );
        follow.addOption(option);

        var colorblindFilterArray:Array<String> = ['None', 'Protanopia', 'Protanomaly', 'Deuteranopia','Deuteranomaly','Tritanopia','Tritanomaly','Achromatopsia','Achromatomaly'];
        var option:Option = new Option(
            'Colorblind filter more playable for colorblind people.',
            'colorblindMode',
            STRING,
            colorblindFilterArray
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Turn off some object on stages.',
            'lowQuality',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Change game quality for screen.',
            'gameQuality',
            INT,
            0,
            3
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle antialiasing, improving graphics quality at a slight performance penalty.',
            'antialiasing',
            BOOL
        );
        follow.addOption(option);
        
        var option:Option = new Option(
            'Toggle flashing lights that can cause epileptic seizures and strain.',
            'flashing',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shaders used for some visual effects.',
            'shaders',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'If checked, allows the GPU to be used for caching textures, decreasing RAM usage.',
            'cacheOnGPU',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Stops game, when its unfocused.',
            'autoPause',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Add a LoadingScreen for PlayState and load faster.',
            'loadingScreen',
            BOOL
        );
        follow.addOption(option);
    }
}