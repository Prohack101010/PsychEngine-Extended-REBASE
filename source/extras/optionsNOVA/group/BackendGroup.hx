package extras.optionsNOVA.group;

class BackendGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Backend',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        ///////////////////////////////

        var option:Option = new Option(
            'Gameplay backend',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Reduce Long Note length',
            'fixLNL',
            INT,
            0,
            2
        );
        follow.addOption(option);

        var PauseMusicArray:Array<String> = ['None', 'Breakfast', 'Tea Time'];
        var option:Option = new Option(
            'Pause Screen song type',
            'pauseMusic',
            STRING,
            PauseMusicArray
        );
        follow.addOption(option);

        var hitsoundArray:Array<String> = ['Default'];             
        for (folder in Paths.directoriesWithFile(Paths.getSharedPath(), 'sounds/hitsounds/'))
			for (file in FileSystem.readDirectory(folder))
			{				
				if(file.endsWith('.ogg'))
					hitsoundArray.push(file.replace('.ogg', ''));				
			}

        var option:Option = new Option(
            "Hitsound Volume",
            'hitsoundVolume',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Reduced version to use hscript work for runhaxecode',
            'oldHscriptVersion',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Add pauseButton in game',
            'pauseButton',
            BOOL
        );
        follow.addOption(option);

        #if android
        var option:Option = new Option(
            'Device will vibrate at game over',
            'gameOverVibration',
            BOOL
        );
        follow.addOption(option);
        #end

        var option:Option = new Option(
            'Changes rate offset',
            'ratingOffset',
            INT,
            -500,
            500,
            'MS'
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Changes music offset and judgement position',
            'NoteOffsetState',
            STATE,
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Changes how many frames you have for hitting a note earlier or late',
            'safeFrames',
            FLOAT,
            0,
            10,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'How many milliseconds are in the MARVELOUS judge',
            'marvelousWindow',
            INT,
            0,
            166,
            'MS'
        );
        follow.addOption(option);

        var option:Option = new Option(
            'How many milliseconds are in the SICK judge',
            'sickWindow',
            INT,
            0,
            166,
            'MS'
        );
        follow.addOption(option);

        var option:Option = new Option(
            'How many milliseconds are in the GOOD judge',
            'goodWindow',
            INT,
            0,
            166,
            'MS'
        );
        follow.addOption(option);

        var option:Option = new Option(
            'How many milliseconds are in the BAD judge',
            'badWindow',
            INT,
            0,
            166,
            'MS'
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Extend marvelous judge for playing',
            'marvelousRating',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Marvelous judge will also use "sick!" judge sprite',
            'marvelousSprite',
            BOOL
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'App backend',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Show the Application from your \"Playing\" box on Discord',
            'discordRPC',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Check app version',
            'checkForUpdates',
            BOOL
        );
        follow.addOption(option);

        #if android
        var fileLoadArray:Array<String> = ["NovaFlare Engine", "NF Engine", "PsychEngine", "OS Engine", "TG Engine", "SB Engine"];
        var option:Option = new Option(
            'Change file load path',
            'fileLoad',
            STRING,
            fileLoadArray
        );
        follow.addOption(option);
        #end

        #if moblie
        var option:Option = new Option(
            'Phone will sleep after going inactive for few seconds',
            'screensaver',
            BOOL
        );
        follow.addOption(option);
        #end
        
        #if moblie
        var option:Option = new Option(
            'Check game whether miss files',
            'filesCheck',
            BOOL
        );
        follow.addOption(option);
        #end
    }
}