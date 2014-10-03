package interactive
{
	import assets.Assets;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author 
	 */
	public class Dart extends FlxSprite
	{
		static private const EXIST_RADIUS : int = 2;
		
		private var _hit : Boolean = false;
		private var _hitTimer : Number = 0;
		private var _destroySnowBall:Class = SomTroll;
		
		private var _dartPNG : Class;
		
		public function Dart(graphicClass : Class, width : int, height : int, hitboxW : int, hitboxH : int)
		{
			_dartPNG = graphicClass;
			this.loadGraphic(_dartPNG, true, true, width, height);
			
			this.width = hitboxW;
			this.height = hitboxH;
			this.offset.x = (width - hitboxW) / 2;
			this.offset.y = (height- hitboxH) / 2;
			
			addAnimation ("IDLE", [0]);
			play ("IDLE");
			FlxG.state.add (this);
		}
		
		public function addDestroyAnimation (frames : Array, framerate : int) : void
		{
			addAnimation ("DESTROY", frames, framerate, false);
		}
		
		override public function update():void 
		{
			if (_hitTimer > 0)
			{
				_hitTimer -= FlxG.elapsed;
			}
			else if (_hit)
			{
				alpha = 0.75 * alpha;
			}			
			
			super.update();
		}
		
		override public function postUpdate():void 
		{		
			super.postUpdate();
			
			if (_alpha < 0.01)
			{
				FlxG.state.remove(this);
				kill();
				destroy();
			}
			
			if (x > FlxG.camera.target.x + EXIST_RADIUS * FlxG.camera.width ||
				x < FlxG.camera.target.x - EXIST_RADIUS * FlxG.camera.width ||
				y > FlxG.camera.target.y + EXIST_RADIUS * FlxG.camera.height ||
				y < FlxG.camera.target.y - EXIST_RADIUS * FlxG.camera.height)
			{
				kill();
				destroy();
			}
		}
		
		public function set hit(value:Boolean):void 
		{
			_hit = value;
			if (value)
			{
				angularVelocity = 0;
				if ((_dartPNG == Assets.SNOW_BALL) && _curAnim.name != "DESTROY")
					FlxG.play(_destroySnowBall);
				play("DESTROY");
				_hitTimer = 1;
			}
		}
		
		public function get hit():Boolean 
		{
			return _hit;
		}
		
		public function get dartPNG():Class 
		{
			return _dartPNG;
		}
	}

}