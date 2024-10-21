package extras.optionsNOVA.group;

class WatermarkGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Watermark',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        ///////////////////////////////

        var option:Option = new Option(
            'FPS counter',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Show your FPS',
            'showFPS',
            BOOL
        );
        follow.addOption(option);

    }
}