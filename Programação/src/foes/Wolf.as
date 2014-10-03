package foes
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Wolf extends FlxSprite implements ITmxObject
	{
		private var _dying : Class = SomLoboMorrendo;
		private var _sound : Boolean = false;
		
		//Asset
		private var _enemyPNG : Class;
		
		//Identificador da alavanca (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : uint;
		
		static private const SPEED:Number = 200;
		static private const WIDTH:Number = 273;
		static private const WIDTH_BOX:Number = 128;
		static private const HEIGHT:Number = 130;
		static private const HEIGHT_BOX:Number = 64;
		
		private var _timerDeath:Number = 0;;
		public var _bDead : Boolean = false;
		
		public function Wolf () 
		{
			_enemyPNG = Assets.WOLF;
			addAnimation ("WALKING", [0, 1, 2, 3, 4], 10);
			addAnimation ("DEATH", [5, 6, 7], 10, false);
			this.loadGraphic(_enemyPNG, true, true, WIDTH, HEIGHT);
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.width 				= WIDTH_BOX;
			this.height 			= HEIGHT_BOX;
			this.x 					= objData.x;
			this.y 					= objData.y;
			this._nId				= objData.id;
			this.offset.x = (WIDTH - WIDTH_BOX) / 2;
			this.offset.y = (HEIGHT - HEIGHT_BOX);
			
			this.velocity.x = -SPEED;
			this.facing = FlxObject.LEFT;
			
			this.acceleration.y = Jogo.getInstance().GRAVITY;
		}
		
		override public function update():void 
		{
			if (!_sound) _sound = true;
			
			if (isTouching (LEFT) && facing == LEFT)
			{
				velocity.x = SPEED;
				this.facing = RIGHT;
			}
			else if (isTouching (RIGHT) && facing == RIGHT)
			{
				velocity.x = -SPEED;
				this.facing = LEFT;
			}
			
			super.update();
		}

		override public function kill():void 
		{
			if (!_bDead && _sound)
			{
				FlxG.play (_dying);
			}
			_bDead = true;
			this.velocity.x = 0;
		}
		
		override public function draw():void 
		{
			if (!_bDead)
				play ("WALKING");
			else
			{
				if (_timerDeath == 0) play("DEATH");
				_timerDeath += FlxG.elapsed;
			
				if (_timerDeath >= 1 && !flickering)
				{
					flicker();
				}
					
				if (_timerDeath >= 2)
					super.kill();
			}
			super.draw();
		}
		
		public function get id():uint 
		{
			return _nId;
		}
		
	}

}