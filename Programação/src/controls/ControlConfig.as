package controls
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class ControlConfig 
	{
		public function ControlConfig() 
		{
			
		}
		
		public function leftJustPressed () : Boolean
		{
			return (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A"));
		}
		
		public function rightJustPressed () : Boolean
		{
			return (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D"));
		}
		
		public function upJustPressed () : Boolean
		{
			return (FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("J"));
		}
		
		public function downJustPressed () : Boolean
		{
			return (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S"));
		}
		
		public function attackJustPressed () : Boolean
		{
			return (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("K"));
		}
		
		public function leftPressed () : Boolean
		{
			return (FlxG.keys.LEFT || FlxG.keys.A);
		}
		
		public function rightPressed () : Boolean
		{
			return (FlxG.keys.RIGHT || FlxG.keys.D);
		}
		
		public function upPressed () : Boolean
		{
			return (FlxG.keys.UP || FlxG.keys.W || FlxG.keys.Z || FlxG.keys.J);
		}
		
		public function downPressed () : Boolean
		{
			return (FlxG.keys.DOWN || FlxG.keys.S);
		}
		
		public function attackPressed () : Boolean
		{
			return (FlxG.keys.X || FlxG.keys.K);
		}
		
		public function wasConfirmPressed () : Boolean
		{
			return FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("SPACE");
		}
		
		public function leftJustReleased () : Boolean
		{
			return (FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("A"));
		}
		
		public function rightJustReleased () : Boolean
		{
			return (FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("D"));
		}
		
		public function upJustReleased () : Boolean
		{
			return (FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W") || FlxG.keys.justReleased("Z") || FlxG.keys.justReleased("J"));
		}
		
		public function downJustReleased () : Boolean
		{
			return (FlxG.keys.justReleased("DOWN") || FlxG.keys.justReleased("S"));
		}
		
		public function attackJustReleased () : Boolean
		{
			return (FlxG.keys.justReleased("X") || FlxG.keys.justReleased("K"));
		}
		
		
	}

}