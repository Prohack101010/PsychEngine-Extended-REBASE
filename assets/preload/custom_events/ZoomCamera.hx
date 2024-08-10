import backend.Conductor;
import psychlua.LuaUtils;

var defaultZoom:Float = 0;
var isTweening:Bool = false;
var glowShit:Int = 0;

function onDumbShit() {
    defaultZoom = FlxG.camera.zoom;
    game.setOnScripts('isTweening', isTweening);
}

function onEvent(e, v1, v2) {
    if (e == "ZoomCamera") {
        var val1 = v1.split(',');
        var val2 = v2.split(',');

        var zoom = defaultZoom * Std.parseFloat(val2[1]);
        if (zoom < defaultZoom - 0.1) zoom = defaultZoom;

        if (val1[0] == 0) {
            game.defaultCamZoom = zoom;
        } else {
            isTweening = true;
            FlxTween.cancelTweensOf(FlxG.camera);
            game.modchartTweens["zoom " + FlxG.random.float(0, 5000)] = FlxTween.tween(FlxG.camera, {zoom: zoom}, Conductor.stepCrochet * val1[0] / 1000, {ease: LuaUtils.getTweenEaseByString(val1[1]), onComplete: function(twn) {
                game.defaultCamZoom = FlxG.camera.zoom;
                isTweening = false;
            }});
        }

        if (game.curSong == "Blammed Erect" && game.curStep >= 512 && game.curStep <= 768) {
            game.triggerEvent("Philly Glow", "2", "");
            glowShit += 1;

            if (glowShit == 1) {
                game.triggerEvent("Philly Glow", "1", "");
                glowShit = -1;
            }
        }
    }
}