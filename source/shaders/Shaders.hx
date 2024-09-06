package shaders;
import openfl.filters.ShaderFilter;
import #if android shaders.FlxShader as ImportedFlxShader; #else flixel.system.FlxAssets.FlxShader as ImportedFlxShader; #end


class BloomHandler
{
	public static var bloomShader:ShaderFilter = new ShaderFilter(new Bloom());

	public static function setThreshold(value:Float)
		bloomShader.shader.data.threshold.value = [value];
	
	public static function setIntensity(value:Float)
		bloomShader.shader.data.intensity.value = [value];
	
	public static function setBlurSize(value:Float)
		bloomShader.shader.data.blurSize.value = [value];
}

class Bloom extends ImportedFlxShader
{
	@:glFragmentSource('
		#pragma header  

		uniform float threshold;
        uniform float intensity;
        uniform float blurSize;

        vec4 BlurColor (in vec2 Coord, in sampler2D Tex, in float MipBias)
        {
            vec2 TexelSize = MipBias / vec2(1280, 720);
            
            vec4 Color = texture(Tex, Coord, MipBias);
            
            for (int i = 0; i < 2; i++) {
                float mul = (float(i)+1.0) / 2.0;
                
                Color += texture(Tex, Coord + vec2(TexelSize.x*mul,0.0), MipBias);
                Color += texture(Tex, Coord + vec2(-TexelSize.x*mul,0.0), MipBias);
                Color += texture(Tex, Coord + vec2(0.0,TexelSize.y*mul), MipBias);
                Color += texture(Tex, Coord + vec2(0.0,-TexelSize.y*mul), MipBias);
                Color += texture(Tex, Coord + vec2(TexelSize.x*mul,TexelSize.y*mul), MipBias);
                Color += texture(Tex, Coord + vec2(-TexelSize.x*mul,TexelSize.y*mul), MipBias);
                Color += texture(Tex, Coord + vec2(TexelSize.x*mul,-TexelSize.y*mul), MipBias);
                Color += texture(Tex, Coord + vec2(-TexelSize.x*mul,-TexelSize.y*mul), MipBias);
            }

            return Color/17.0;
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec4 Color = texture(bitmap, uv);

            if (intensity > 0.0)
            {
                vec4 Highlight = clamp(BlurColor(uv, bitmap, blurSize)-threshold,0.0,1.0)*1.0/(1.0-threshold);
                gl_FragColor = 1.0-(1.0-Color)*(1.0-Highlight*intensity);
            }
            else
            {
                gl_FragColor = Color;
            }
        }')
	
    public function new()
	{
		super();

        threshold.value = [0.4];
        intensity.value = [1.0];
        blurSize.value = [10.0];
	}
}





class BrightHandler
{
	public static var brightShader:ShaderFilter = new ShaderFilter(new Bright());

	public static function setBrightness(brightness:Float):Void
	{
		brightShader.shader.data.brightness.value = [brightness];
	}
	
	public static function setContrast(contrast:Float):Void
	{
		brightShader.shader.data.contrast.value = [contrast];
	}
}

class Bright extends ImportedFlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float brightness;
		uniform float contrast;

		void main()
		{
			vec4 col = texture2D(bitmap, openfl_TextureCoordv);
			col.rgb = col.rgb * contrast;
			col.rgb = col.rgb + brightness;

			gl_FragColor = col;
		}')
	public function new()
	{
		super();
	}
}





class ChromaHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());
	
	public static function setChrome(chromeOffset:Float):Void
	{
		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [0.0];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset * -1];
	}
}

class ChromaticAberration extends ImportedFlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 col = vec4(1.0);
			
			col.r = texture2D(bitmap, openfl_TextureCoordv - vec2(rOffset, 0.0)).r;
			col.ga = texture2D(bitmap, openfl_TextureCoordv - vec2(gOffset, 0.0)).ga;
			col.b = texture2D(bitmap, openfl_TextureCoordv - vec2(bOffset, 0.0)).b;

			gl_FragColor = col;
		}')
	public function new()
	{
		super();

		rOffset.value = [0.0];
		gOffset.value = [0.0];
		bOffset.value = [0.0];
	}
}
