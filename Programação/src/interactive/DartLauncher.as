package interactive
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author 
	 */
	public class DartLauncher extends FlxGroup implements IActivable, ITmxObject
	{
		private var _launch : Class = SomFlecha;
		
		public static const DART_SPEED:int = 1600;
		static private const WIDTH:Number = 69;
		static private const WIDTH_BOX:Number = 64;
		static private const HEIGHT:Number = 68;
		static private const HEIGHT_BOX:Number = 64;
		
		private var launcher : FlxSprite = new FlxSprite ();
		private var _launcherPNG : Class;
		private var _way : int = 0;
		private var _id : int = 0;
		private var _dart : Dart;
		
		//Constantes para determinar o sentido da plataforma
		private static const LEFT : uint = 0;
		private static const UP : uint = 1;
		private static const RIGHT : uint = 2;
		private static const DOWN : uint = 3;
		
		private static const DELAY : Number = 0.5;
		private var _timer : Number;
		private var _bActive : Boolean = false;
		
		public function DartLauncher() 
		{
			_launcherPNG = Assets.DART_LAUNCHER;
		}
		
		public function setup(objData:Object):void 
		{
			launcher.loadGraphic(_launcherPNG, true, true, WIDTH, HEIGHT);
			
			launcher.width 				= WIDTH_BOX;
			launcher.height 			= HEIGHT_BOX;
			launcher.x 					= objData.x;
			launcher.y 					= objData.y;
			
			launcher.offset.x = (WIDTH - WIDTH_BOX) / 2;
			launcher.offset.y = (HEIGHT - HEIGHT_BOX) / 2;
			
			add (launcher);
			
			this._id = objData.id;
			_way = objData.sentido;
			_timer = 0;
			
			switch (_way)
			{
				case LEFT:
					launcher.facing = FlxObject.LEFT;
					break;
				case RIGHT:
					launcher.facing = FlxObject.RIGHT;
					break;
				case UP:
					launcher.facing = FlxObject.LEFT;
					launcher.angle = 90;
					break;
				case DOWN:
					launcher.angle = 90;
					break;
			}
			launcher.immovable = true;
		}
		
		public function activate():void 
		{
			_timer = DELAY;
			switch (_way)
			{
				case LEFT:
					_dart = new Dart (Assets.DART, 43, 12, 43, 12);
					_dart.facing = FlxObject.LEFT;
					_dart.x = launcher.x - 25;
					_dart.y = launcher.y + 25;
					break;
				case RIGHT:
					_dart = new Dart (Assets.DART, 43, 12, 43, 12);
					_dart.x = launcher.x + launcher.width / 2 + 11;
					_dart.y = launcher.y + 25;
					break;
				case UP:
					_dart = new Dart (Assets.DART, 43, 12, 12, 43);
					_dart.facing = FlxObject.LEFT;
					_dart.angle = 90;
					_dart.x = launcher.x + 26;
					_dart.y = launcher.y - 25;
					break;
				case DOWN:
					_dart = new Dart (Assets.DART, 43, 12, 12, 43);
					_dart.angle = 90;
					_dart.x = launcher.x + 26;
					_dart.y = launcher.y + launcher.height / 2 + 11;
					break;
			}
			_bActive = true;
		}
		
		private function shoot () : void
		{
			FlxG.play (_launch);
			switch (_way)
			{
				case LEFT:
					_dart.velocity.x = -DART_SPEED;
					break;
				case RIGHT:
					_dart.velocity.x = DART_SPEED;
					break;
				case UP:
					_dart.velocity.y = -DART_SPEED;
					break;
				case DOWN:
					_dart.velocity.y = DART_SPEED;
					break;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (_timer > 0)
			{
				_timer -= FlxG.elapsed;
			}
			else if (_bActive)
			{
				shoot();
				_timer = 0;
				_bActive = false;
			}
		}
		
		public function deactivate():void 
		{
			
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}