import Math;

var DEFAULT_BOP_INTENSITY = 1.105;

var rate:Float = 0;
var intensity = [0, 0];

function onCreatePost() game.camZooming = false;

function onEvent(e, v1, v2) {
    if (e == "SetCameraBop") {
        rate = Std.parseFloat(v1);
        intensity[0] = (DEFAULT_BOP_INTENSITY - 1.0) * Std.parseFloat(v2) / 6;
        intensity[1] = (DEFAULT_BOP_INTENSITY - 1.0) * Std.parseFloat(v2) * 2.0 / 8;

        trace(intensity[0]);

        if (rate > 0)  game.triggerEvent("Add Camera Zoom", intensity[0], intensity[1]);
    }
}

function onBeatHit() {
    if (rate > 0 && curBeat % rate == 0) {
        if (isTweening) game.triggerEvent("Add Camera Zoom", "0", intensity[1]); else game.triggerEvent("Add Camera Zoom", intensity[0], intensity[1]);
    }
}

function onUpdate(e) {
    if (!isTweening) FlxG.camera.zoom = FlxMath.lerp(game.defaultCamZoom, FlxG.camera.zoom, Math.exp(-e * 3.125 * game.camZoomingDecay * game.playbackRate));
    game.camHUD.zoom = FlxMath.lerp(1, game.camHUD.zoom, Math.exp(-e * 3.125 * game.camZoomingDecay * game.playbackRate));
}