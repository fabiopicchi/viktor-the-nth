package player
{
	import org.flixel.FlxParticle;
	
	/**
	 * ...
	 * @author 
	 */
	public class LandingParticle extends FlxParticle 
	{
		
		public function LandingParticle() 
		{
			scale.x = 2.0;
			scale.x = 2.0;
			alpha = 0.2;
		}
		
		override public function update():void 
		{
			super.update();
			
			alpha = alpha + 0.2 * (0.0 - alpha);
			scale.x = scale.x + 0.2 * (3.0 - scale.x);
			scale.y = scale.y + 0.2 * (3.0 - scale.y);
		}
		
		override public function onEmit():void 
		{
			scale.x = 2.0;
			scale.x = 2.0;
			alpha = 0.2;
			
			super.onEmit();
		}
	}

}