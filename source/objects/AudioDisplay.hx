package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplay extends FlxSpriteGroup
{
    var analyzer:SpectralAnalyzer;

    public var snd:FlxSound;
    var _height:Int;
    var gap:Float = 2;
    var line:Int;

    public function new(snd:FlxSound, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, Color:FlxColor)
    {
      super(X, Y);
  
      this.snd = snd;
      this.line = line;

      for (i in 0...line)
      {
        var newLine = new FlxSprite().makeGraphic(Std.int(Width / line - gap), 1, Color);
        newLine.x = (Std.int(Width / line) + gap) * i;
        add(newLine);
      }
      _height = Height;

      @:privateAccess
      if (snd._channel != null) 
      {
        analyzer = new SpectralAnalyzer(snd._channel.__audioSource, line, 1, 5);
  
        // On desktop it uses FFT stuff that isn't as optimized as the direct browser stuff we use on HTML5
        // So we want to manually change it!
        analyzer.fftN = 256;  
      }
    }

    override function update(elapsed:Float)
    {
        addAnalyzer();
        if (analyzer == null) {
          return;
        }  
        var levels = analyzer.getLevels();

        for (i in 0...members.length)
        {
        var animFrame:Int = Math.round(levels[i].value * _height);

        #if desktop
        animFrame = Math.round(animFrame * FlxG.sound.volume);
        #end

        members[i].scale.y = FlxMath.lerp(animFrame, members[i].scale.y, Math.exp(-elapsed * 16));
        members[i].y = this.y -members[i].scale.y / 2;
        }
        super.update(elapsed);
    }

    function addAnalyzer() {
      @:privateAccess
      if (snd._channel != null && analyzer == null) 
      {
        analyzer = new SpectralAnalyzer(snd._channel.__audioSource, line, 1, 5);

        // On desktop it uses FFT stuff that isn't as optimized as the direct browser stuff we use on HTML5
        // So we want to manually change it!
        analyzer.fftN = 256;       
      }
    }
}