package extras.optionsNOVA.group;

class UIGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Game UI',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        ///////////////////////////////

        var option:Option = new Option(
            'Shows hud',
            'hideHud',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Combo sprite appearance',
            'showComboNum',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Rating sprite appearance',
            'showRating',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shows opponent strums on screen',
            'opponentStrums',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            "Show your judgements",
            'judgementCounter',
            BOOL
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'TimeBar',
            TEXT
        );
        follow.addOption(option);

        var TimeBarArray:Array<String> = ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled'];
        var option:Option = new Option(
            'Display type',
            'timeBarType',
            STRING,
            TimeBarArray
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'HealthBar',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Alpha',
            'healthBarAlpha',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
        'Camera',
        TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle the camera zoom in-game',
            'camZooms',
            BOOL
        );
        follow.addOption(option);
    }
}