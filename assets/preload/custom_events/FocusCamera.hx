import psychlua.LuaUtils;
import backend.Conductor;
var oldSpeed:Float = 0;

using StringTools;

function onCreatePost() {
    game.moveCamera(true);
    oldSpeed = game.cameraSpeed;
    if (game.curSong == "Roses Erect" || game.curSong == "Senpai Erect" || game.curSong == "Thorns Erect") game.cameraSpeed = 1000;

    game.isCameraOnForcedPos = true;
}

function onEvent(e, v1, v2) {
    if (e == "FocusCamera") {
        var duration:Float = 0;

        var val2 = ["0", "0"];
        if (StringTools.contains(v2, ",")) val2 = v2.split(',');

        if (val2[0] != "" && Std.parseFloat(val2[0]) > 0) duration = Std.parseFloat(v2);

        if (val2[1] == "CLASSIC" || val2[1] == " 0" || val2[1] == "0" || v2 == "4" || v2 == "4, CLASSIC" || v2 == "0, 4") {
            FlxTween.cancelTweensOf(game.camFollow);
            if (v1 == "1") {
                game.moveCamera(true);
            } else if (v1 == "0") {
                game.moveCamera(false); 
            } else if (v1 == "2") {
                game.camFollow.setPosition(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
                game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
                game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
            }
        } else {
            var guy = [game.dad, game.opponentCameraOffset];
            if (v1 == "0") {
                guy = [game.boyfriend, game.boyfriendCameraOffset];
                game.camFollow.setPosition(guy[0].getMidpoint().x - 100, guy[0].getMidpoint().y - 100);
            }

            if (v1 == "2") {
                guy = [game.gf, game.girlfriendCameraOffset];
                game.camFollow.setPosition(guy[0].getMidpoint().x - 100, guy[0].getMidpoint().y - 100);
            }
  
            if (v1 == "1") game.camFollow.setPosition(guy[0].getMidpoint().x + 150, guy[0].getMidpoint().y - 100);

            var otherDumbShit = [game.camFollow.x + guy[0].cameraPosition[0] + guy[1][0], game.camFollow.y + guy[0].cameraPosition[1] + guy[1][1] + 100];
            if (v1 == "0") otherDumbShit = [game.camFollow.x - guy[0].cameraPosition[0] - guy[1][0] - 150, game.camFollow.y + guy[0].cameraPosition[1] + guy[1][1]];

            game.modchartTweens["focus " + FlxG.random.float(0, 5000)] = FlxTween.tween(game.camFollow, {x: otherDumbShit[0], y: otherDumbShit[1]}, 
                Conductor.stepCrochet * duration / 1000, {ease: LuaUtils.getTweenEaseByString(val2[1])});
        }
    }
}

function onSongStart() game.cameraSpeed = oldSpeed;

function onUpdatePost(e) game.isCameraOnForcedPos = true;