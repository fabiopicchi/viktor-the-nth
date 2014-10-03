package foes
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import interactive.Dart;
	import playState.PlayState;
	/**
	 * ...
	 * @author 
	 */
	public class Troll extends FlxSprite implements ITmxObject
	{
		private static const SHOOT_INTERVAL : Number = 3;
		private var hidden : Boolean = false;
		private var timeAcc : Number = 0;
		private var _enemyPNG : Class;
		private var _nId : int;
		private var _bShot : Boolean = false;
		
		private static const IDLE : int = 1;
		private static const SHOOT : int = 2;
		private static const HIDING : int = 4;
		private static const HIDDEN : int = 8;
		private static const SHOW : int = 16;
		private static const DEAD : int = 32;
		private var _state:int;
		private var _nextState:int;
		
		static private const WIDTH:Number = 141;
		static private const WIDTH_BOX:Number = 64;
		static private const HEIGHT:Number = 125;
		static private const HEIGHT_BOX:Number = 128;
		static private const MIN_RADIUS:Number = 3;
		static private const MAX_RADIUS:Number = 12;
		static private const SPRITE_OFFSET:Number = 26;
		
		public function Troll() 
		{
			_enemyPNG = Assets.TROLL;
			addAnimation ("IDLE", [0], 10, false);
			addAnimation ("SHOOT", [1, 2, 3, 4, 5, 6], 10, false);
			addAnimation ("HIDING", [7, 8, 9], 10, false);
			addAnimation ("HIDDEN", [10], 10, false);
			addAnimation ("SHOW", [11, 12, 13, 0], 10, false);
			addAnimation ("DIE", [14, 15, 16, 17], 10, false);
			this.loadGraphic(_enemyPNG, true, true, WIDTH, HEIGHT);
			_state = IDLE;
			_nextState = IDLE;
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.width 				= WIDTH_BOX;
			this.height 			= HEIGHT_BOX;
			this.x 					= objData.x;
			this.y 					= objData.y;
			this._nId				= objData.id;
			this.offset.x = (WIDTH - WIDTH_BOX) / 2 - SPRITE_OFFSET;
			this.offset.y = (HEIGHT - HEIGHT_BOX);
			
			this.acceleration.y = Jogo.getInstance().GRAVITY;
		}
		
		override public function update():void 
		{
			//Transition - Executed only once
			if (_state != _nextState)
			{
				if (PlayState.testFlag (_nextState, SHOOT) || PlayState.testFlag (_nextState, SHOW))
				{
					timeAcc = 1;
				}
				
				_state = _nextState;
			}
			
			super.update();
			
			if (!PlayState.testFlag(_state, HIDING) && !PlayState.testFlag(_state, HIDDEN))
			{
				timeAcc += FlxG.elapsed;
				if (timeAcc >= SHOOT_INTERVAL)
				{
					timeAcc = 0;
					_nextState = SHOOT;
					_bShot = false;
				}
			}
			
			if (PlayState.testFlag (_state, HIDING) && finished)
			{
				_nextState = HIDDEN;
			}
			
			if (PlayState.testFlag (_state, SHOOT) && finished)
			{
				_nextState = IDLE;
			}
			
			if (PlayState.testFlag (_state, SHOW) && finished)
			{
				_nextState = IDLE;
			}
			
			if ((PlayState.getInstance().getDistanceFromPlayer(this).x <= MAX_RADIUS * Jogo.getInstance().TILE_WIDTH && PlayState.getInstance().getDistanceFromPlayer(this).y <= MAX_RADIUS * Jogo.getInstance().TILE_HEIGHT) &&
				(PlayState.getInstance().getDistanceFromPlayer(this).x >= MIN_RADIUS * Jogo.getInstance().TILE_WIDTH || PlayState.getInstance().getDistanceFromPlayer(this).y >= MIN_RADIUS * Jogo.getInstance().TILE_HEIGHT)	&&
				(PlayState.testFlag(_state, HIDING) || PlayState.testFlag(_state, HIDDEN)))
			{
				_nextState = SHOW;
			}
			else if ((PlayState.getInstance().getDistanceFromPlayer(this).x > MAX_RADIUS * Jogo.getInstance().TILE_WIDTH || PlayState.getInstance().getDistanceFromPlayer(this).y > MAX_RADIUS * Jogo.getInstance().TILE_HEIGHT)|| 
					(PlayState.getInstance().getDistanceFromPlayer(this).x < MIN_RADIUS * Jogo.getInstance().TILE_WIDTH && PlayState.getInstance().getDistanceFromPlayer(this).y < MIN_RADIUS * Jogo.getInstance().TILE_HEIGHT) &&
					(!PlayState.testFlag(_state, HIDING) && !PlayState.testFlag(_state, HIDDEN)))
			{
				_nextState = HIDING;
			}
			
			if (PlayState.testFlag (_state, SHOOT))
			{
				if (_curFrame >= 4 && !_bShot)
				{
					shoot();
				}
			}
		}
		
		override public function draw():void 
		{
			if (PlayState.testFlag(_state, SHOW) || PlayState.testFlag(_state, IDLE))
			{
				if (FlxG.camera.target.x < x)
				{
					if (facing != LEFT)
						offset.x += SPRITE_OFFSET;
					facing = LEFT;
				}
				else
				{
					if (facing != RIGHT)
						offset.x -= SPRITE_OFFSET;
					facing = RIGHT;
				}
			}
			
			if (_state != _nextState)
			{
				var changedState : int = _nextState & (~_state);
				
				if (PlayState.testFlag(changedState, HIDING))
				{
					play ("HIDING");
				}
				else if (PlayState.testFlag(changedState, SHOOT))
				{
					play ("SHOOT");
				}
				else if (PlayState.testFlag(changedState, SHOW))
				{
					play ("SHOW");
				}
			}
			
			if (PlayState.testFlag (_nextState, IDLE))
			{
				play ("IDLE");
			}
			
			else if (PlayState.testFlag (_nextState, HIDDEN))
			{
				play ("HIDDEN");
			}
				
			super.draw();
		}
		
		private function shoot():void 
		{
			var dart : Dart = new Dart (Assets.SNOW_BALL, 60, 56, 30, 26);
			
			if (facing == LEFT)
			{
				dart.velocity.x = -350;
				dart.angularVelocity = -500;
			}
			else
			{
				dart.velocity.x = 350;
				dart.angularVelocity = 500;
			}
			
			dart.x = x + (facing == FlxObject.LEFT ? ( -20) : (WIDTH/2 + 20));
			dart.y = y+20;
			dart.addDestroyAnimation ([1, 2, 3], 10);
			
			_bShot = true;
		}
		
	}

}