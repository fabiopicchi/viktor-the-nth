package playState
{
	import assets.Assets;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import levelLoader.ITmxObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cloud extends FlxSprite implements ITmxObject
	{
		
		public function Cloud() 
		{
			this.loadGraphic(randomizeCloud());
			this.velocity.x = -10;
			this.scrollFactor = new FlxPoint (0.2424742268041237, 0.04983434566537824);
		}
		
		/* INTERFACE levelLoader.ITmxObject */
		
		public function setup(objData:Object):void 
		{
			this.x = Number(objData.x);
			this.y = Number(objData.y);
		}
		
		override public function postUpdate () : void
		{
			super.postUpdate();
			
			if ((this.x + this.width) < 0)
			{
				this.x = 4338 - this.width;
			}
		}
		
		private static function randomizeCloud () : Class
		{
			var num : Number = Math.floor(Math.random() * 4);
		
			switch (num)
			{
				case 0:
					return Assets.CLOUD_1;
					break;
				case 1:
					return Assets.CLOUD_2;
					break;
				case 2:
					return Assets.CLOUD_3;
					break;
				default:
				case 3:
					return Assets.CLOUD_4;
					break;
			}
		}
		
	}

}