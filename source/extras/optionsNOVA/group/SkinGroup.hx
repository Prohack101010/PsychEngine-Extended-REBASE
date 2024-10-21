package extras.optionsNOVA.group;

class SkinGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Skin',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);
        
        var noteSkins:Array<String> = [];
        if(Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared').length > 0)
			noteSkins = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		else
			noteSkins = CoolUtil.coolTextFile(Paths.getSharedPath('shared/images/noteSkins/list.txt'));			
		if(noteSkins.length > 0)
        {
		    noteSkins.insert(0, ClientPrefs.defaultData.noteSkin);

            var option:Option = new Option(
                'Change your current noteSkin',
                'noteSkin',
                STRING,
                noteSkins
            );
            follow.addOption(option);
        }

        var option:Option = new Option(
            'Note color setup',
            'NotesSubState',
            STATE,
        );
        follow.addOption(option);

        ///////////////////////////////

        var noteSplashes:Array<String> = [];
		if(Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared').length > 0)
			noteSplashes = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared');
		else
			noteSplashes = CoolUtil.coolTextFile(Paths.getSharedPath('shared/images/noteSplashes/list.txt'));
			
		if(noteSplashes.length > 0)
		{
		    noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin);

            var option:Option = new Option(
                'Change your current splashSkin',
                'splashSkin',
                STRING,
                noteSplashes
            );
            follow.addOption(option);
        }

        var option:Option = new Option(
            'Show on sick/marvelous judge',
            'showSplash',
            BOOL
        );
        follow.addOption(option);
    }
}