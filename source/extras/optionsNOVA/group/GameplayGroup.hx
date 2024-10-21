package extras.optionsNOVA.group;

class GameplayGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Gameplay',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        var option:Option = new Option(
            'Notes go Down instead of Up, simple enough',
            'downScroll',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Put your lane in the center or on the right',
            'middleScroll',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Filp chart for playing',
            'filpChart',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle counting pressing a directional input when no arrow is there as a miss',
            'ghostTapping',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            "Hold Notes can't be pressed if you miss",
            'guitarHeroSustains',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle pressing R to gameover',
            'noReset',
            BOOL
        );
        follow.addOption(option);
    }
}