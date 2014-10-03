package  foes
{
	import levelLoader.ITmxObject;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParedeInvisivel extends FlxObject implements ITmxObject
	{
		public function ParedeInvisivel() 
		{
			
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.width 				= objData.width;
			this.height 			= objData.height;
			this.x 					= objData.x;
			this.y 					= objData.y;
			
			this.immovable = true;
		}
		
	}

}