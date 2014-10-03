package player
{
	import assets.Assets;
	import foes.Wolf;
	import interactive.Button;
	import interactive.Dart;
	import interactive.IActivator;
	import interactive.KeyButton;
	import interactive.Lever;
	import interactive.Crate;
	import interactive.MovingPlatform;
	import interactive.Tomb;
	import interactive.Trap;
	import menuState.MenuState;
	import org.flixel.FlxBasic;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import playState.PlayState;
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class Player extends FlxGroup
	{	
		//States
		public static const WALK_RIGHT : int = 1;
		public static const WALK_LEFT : int = 2;
		public static const JUMP : int  = 4;
		public static const FALL : int  = 8;
		public static const HIT : int = 16;
		public static const PUSH_RIGHT : int = 32;
		public static const PUSH_LEFT : int = 64;
		public static const DEAD : int = 128;
		public static const IDLE : int = 256;
		public static const LANDING : int  = 512;
		public static const INPUT_BLOCKED : int = 1024;
		
		public var _damage:Class = SomDano;
		public var _attack:Class = SomAtacando;
		public var _landing:Class = SomCaindo;
		
		//Fisica
		private static const MAX_VELOCITY_X : uint 		= 400;
		private static const MAX_VELOCITY_Y : uint		= 600;
		private static const FRICTION 		: uint 		= 2 * MAX_VELOCITY_X; //Não está sendo usado atrito
		private static const JUMP_HEIGHT 	: Number	= (9/2) * Jogo.getInstance().TILE_HEIGHT; //Tres tiles e meio de altura de pulo
		
		//Tamanho do Sprite
		public static const WIDTH 	: uint 	= 250;
		public static const HEIGHT 	: uint 	= 145;
		
		//Death Causes
		static public const DART	: int = 0;
		static public const WOLF	: int = 1;
		static public const AGE		: int = 3;
		static public const TROLL	: int = 2;
		static public const TRAP	: int = 4;
		
		//Bounding box offset
		private const WIDTH_BOX	: uint = 52;
		private const HEIGHT_BOX : uint = 120;
		private const SPEED : uint = 400;
		
		
		//Viktor FSM
		private var _state : int = IDLE;
		private var _nextState : int = IDLE;
		
		//Assets
		protected var _playerPNG : Class;
		
		//Crate Carried
		private var crateHandle : Crate;
		private var _crateHitbox : FlxObject;
		
		private var _vikAttackArea : FlxObject;
		public var viktor : FlxSprite;
		private var barba : FlxSprite;
		private var viktorVelho : FlxSprite;
		
		private var closeGame : Number = 2;
		
		private var leverInRange : Boolean = false;
		private var _deathCause : int;
		private var emitter:FlxEmitter;
		private var particles:int;
		public var timeStamp : Number = 0;
		public var lifeSpan : Number = 0;
		private var fallHeight : Number = 0;
		private const NUM_VIKTORS : int = 7;
		private var timerViktorGhost : Number = 0;
		private var numViktors : int = 0;
		private var arViktors : Array = [];
		
		/* 
		 * controlsuração de controles varia de 1 a 3
		 * (o resto é inválido)
		*/
		
		public function Player(cor : int) 
		{
			_playerPNG = null;
			
			emitter = new FlxEmitter(0, 0 + HEIGHT_BOX); //x and y of the emitter
			emitter.setYSpeed(-100, -150);
			emitter.setXSpeed( -150, 150);
			emitter.gravity = 120;
			
			particles = 40;
			 
			for(var i:int = 0; i < particles; i++)
			{
				var particle:LandingParticle = new LandingParticle();
				particle.exists = false;
				particle.loadGraphic(Assets.getFlake(), false, false, 7, 7);
				emitter.add(particle);
			}
		
			switch (cor)
			{
				case 1:
					_playerPNG = Assets.VIKTOR_CASTANHO;
					break;
				case 2:
					_playerPNG = Assets.VIKTOR_PRETO;
					break;
				case 3:
					_playerPNG = Assets.VIKTOR_RUIVO;
					break;
			}
			
			viktor = new FlxSprite ();
			viktorVelho = new FlxSprite ();
			barba = new FlxSprite();
			
			viktor.loadGraphic(Assets.VIKTOR, true, true, WIDTH, HEIGHT);
			viktor.addAnimation ("IDLE", [0, 1], 1.5, true);
			viktor.addAnimation ("WALKING", [2, 3, 4, 5, 6, 7], 15, true);
			viktor.addAnimation ("WALKING_SLOWLY", [2, 3, 4, 5, 6, 7], 7.5, true);
			viktor.addAnimation ("JUMP", [3], 15, true);
			viktor.addAnimation ("FALL", [8], 15, true);
			viktor.addAnimation ("ATTACK", [9, 10, 11, 12, 13, 14 ,15 ,16, 9], 20, false);
			viktor.addAnimation ("PUSH", [17, 18, 19], 7.5, false);
			viktor.addAnimation ("DEATH", [20, 21 , 22, 23], 7.5, false);
			viktor.addAnimation ("LANDING", [17], 15, false);
			
			add (viktor);
			
			if (_playerPNG)
			{
				barba.loadGraphic(_playerPNG, true, true, 89, 60);
				barba.addAnimation ("IDLE", [0, 1], 1.5, true);
				barba.addAnimation ("WALKING", [2, 3, 4, 5, 6, 7], 15, true);
				barba.addAnimation ("WALKING_SLOWLY", [2, 3, 4, 5, 6, 7], 7.5, true);
				barba.addAnimation ("JUMP", [3], 15, true);
				barba.addAnimation ("FALL", [8], 15, true);
				barba.addAnimation ("ATTACK", [9, 10, 11, 12, 13, 14 ,15 ,16, 9], 20, false);
				barba.addAnimation ("PUSH", [17, 18, 19], 7.5, false);
				barba.addAnimation ("DEATH", [20, 21 , 22, 23], 7.5, false);
				barba.addAnimation ("LANDING", [17], 15, false);
				add (barba);
			}
			
			viktorVelho.loadGraphic(Assets.VIKTOR_VELHO, true, true, 89, 60);
			viktorVelho.addAnimation ("IDLE", [0, 1], 1.5, true);
			viktorVelho.addAnimation ("WALKING", [2, 3, 4, 5, 6, 7], 15, true);
			viktorVelho.addAnimation ("WALKING_SLOWLY", [2, 3, 4, 5, 6, 7], 7.5, true);
			viktorVelho.addAnimation ("JUMP", [3], 15, true);
			viktorVelho.addAnimation ("FALL", [8], 15, true);
			viktorVelho.addAnimation ("ATTACK", [9, 10, 11, 12, 13, 14 ,15 ,16, 9], 20, false);
			viktorVelho.addAnimation ("PUSH", [17, 18, 19], 7.5, false);
			viktorVelho.addAnimation ("DEATH", [20, 21 , 22, 23], 7.5, false);
			viktorVelho.addAnimation ("LANDING", [17], 15, false);
			viktorVelho.alpha = 0;
			add (viktorVelho);	
			
			add(emitter);
		}
		
		public function setup (objData : Object) : void
		{
			//Bounding Box e Posicionamento
			viktor.width = WIDTH_BOX;
			viktor.height = HEIGHT_BOX;
			viktor.offset.x = (WIDTH - WIDTH_BOX) / 2;
			viktor.offset.y = (HEIGHT - HEIGHT_BOX);
			viktor.x = objData.x;
			viktor.y = objData.y;
			
			_vikAttackArea = new FlxObject ((WIDTH - WIDTH_BOX) / 2, 0.15 * viktor.height, WIDTH, 0.7 * viktor.height);
			add (_vikAttackArea);
			//Física
			viktor.acceleration.y = Jogo.getInstance().GRAVITY;
			viktor.maxVelocity.x = SPEED;
		}
		
		private function salvaTumba():void 
		{
			if (PlayState.getInstance().save.data.tombPositions == null)
				PlayState.getInstance().save.data.tombPositions = [];
				
			if (PlayState.getInstance().save.data.generations == null)
				PlayState.getInstance().save.data.tombPositions [1] = { p : viktor.getMidpoint(), deathCause : _deathCause, textId : Math.floor (Math.random() * Tomb.arSentences[_deathCause].length)};
				
			else
				PlayState.getInstance().save.data.tombPositions [PlayState.getInstance().save.data.generations] = { p : viktor.getMidpoint(), deathCause : _deathCause, textId : Math.floor (Math.random() * Tomb.arSentences[_deathCause].length)};
		}
		
		override public function kill():void 
		{
			FlxG.play (_damage);
			_nextState = DEAD;
			
			viktor.velocity = new FlxPoint (0, viktor.velocity.y);
			if (viktor.velocity.y < 0)
				viktor.velocity.y = 0;
			viktor.acceleration = new FlxPoint (0, viktor.acceleration.y);
			
			salvaTumba();
		}
		
		override public function preUpdate():void 
		{
			leverInRange = false;
			viktor.preUpdate();
			emitter.preUpdate();
			
			if (PlayState.testFlag(_nextState, Player.PUSH_LEFT) || PlayState.testFlag(_nextState, Player.PUSH_RIGHT))   
			{
				if (PlayState.testFlag(_nextState, Player.PUSH_LEFT))
				{
					viktor.x = _crateHitbox.x + crateHandle.width;
					crateHandle.x = _crateHitbox.x;
				}
				if (PlayState.testFlag(_nextState, Player.PUSH_RIGHT))
				{
					viktor.x = _crateHitbox.x;
					crateHandle.x = viktor.x + viktor.width;
				}
			}
		}
		
		override public function update():void 
		{
			emitter.update();
			//Transition - Executed only once
			if (_state != _nextState)
			{
				var changedState : int = _nextState & (~_state);
				
				if (PlayState.testFlag(changedState, FALL))
				{
					_nextState &= (~JUMP);
				}
				
				else if (PlayState.testFlag(changedState, JUMP))
				{
					viktor.velocity.y = - Math.ceil(Math.sqrt(2 * Jogo.getInstance().GRAVITY * JUMP_HEIGHT));
				}
				
				if (PlayState.testFlag(changedState, HIT))
				{
					FlxG.play (_attack);
				}
				
				
				if (PlayState.testFlag(changedState, PUSH_LEFT))
				{
					this._crateHitbox.velocity.x = -SPEED / 2;
					this._crateHitbox.velocity.y = viktor.velocity.y;
				}
				else if (PlayState.testFlag(changedState, PUSH_RIGHT))
				{
					this._crateHitbox.velocity.x = SPEED / 2;
					this._crateHitbox.velocity.y = viktor.velocity.y;
				}
				
				if (PlayState.testFlag(changedState, HIT))
				{
					FlxG.play (_attack);
				}
				
				if (PlayState.testFlag(changedState, LANDING))
				{
					if (Jogo._bParticles) emitter.start(true, 0.5, 0.1, 20);
					FlxG.play(_landing);
				}
				
				if (PlayState.testFlag(changedState, DEAD))
				{
						switch (_deathCause)
						{
								case DART:
										Jogo.kongregate.stats.submit("killedByDarts", 1);
										break;
								case TRAP:
										Jogo.kongregate.stats.submit("killedBySpikes", 1);
										break;
								case WOLF:
										Jogo.kongregate.stats.submit("killedByWolves", 1);
										break;
								case TROLL:
										Jogo.kongregate.stats.submit("killedByTrolls", 1);
										break;
								case AGE:
										Jogo.kongregate.stats.submit("agedToDeath", 1);
										break;
						}                                       
				}
				
				_state = _nextState;
			}
			
			if (PlayState.testFlag(_state, DEAD))
			{
				closeGame -= FlxG.elapsed;
				if (closeGame <= 0)
				{
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						PlayState.getInstance().saveGame();
						FlxG.switchState (new MenuState(true, true));
					}, null);
				}
			}
			
			else
			{
				
				if (viktor.x <= 167 * Jogo.getInstance().TILE_WIDTH || viktor.y >= 60 * Jogo.getInstance().TILE_WIDTH )
				{
					lifeSpan += FlxG.elapsed;
				}
				
				if (!PlayState.testFlag(_state, INPUT_BLOCKED))
				{
					inputUpdate();
				}
				
				if (PlayState.testFlag(_state, JUMP))
				{				
					if (PlayState._controls.upJustReleased())
					{
						viktor.velocity.y /= 2;
					}
				}
				
				//Movimentação Esquerda e Direita
				if(PlayState.testFlag(_state, WALK_LEFT))
				{
					if (!PlayState.testFlag(_state, HIT)) viktor.facing = FlxObject.LEFT;
					viktor.acceleration.x = -SPEED / FlxG.elapsed;	
					
					if (!PlayState.testFlag(_state, INPUT_BLOCKED) && (!PlayState._controls.leftPressed() || PlayState._controls.rightPressed()))
					{
						_nextState &= (~WALK_LEFT);
						if (PlayState._controls.rightPressed() && !PlayState._controls.leftPressed())
						{
							_nextState |= WALK_RIGHT;
						}
					}
				}
				else if(PlayState.testFlag(_state, WALK_RIGHT))
				{
					if (!PlayState.testFlag(_state, HIT)) viktor.facing = FlxObject.RIGHT;
					viktor.acceleration.x = SPEED / FlxG.elapsed;
					
					if (!PlayState.testFlag(_state, INPUT_BLOCKED) && (!PlayState._controls.rightPressed() || PlayState._controls.leftPressed()))
					{
						_nextState &= (~WALK_RIGHT);
						if (PlayState._controls.leftPressed() && !PlayState._controls.rightPressed())
						{
							_nextState |= WALK_LEFT;
						}
					}
				}
				else
				{
					viktor.velocity.x = 0;
					viktor.acceleration.x = 0;
				}
				
				if (PlayState.testFlag(_state, INPUT_BLOCKED))
				{
					viktor.acceleration.x = 0;
					viktor.velocity.x = SPEED / 2;
				}
				
				if (PlayState.testFlag(_state, PUSH_RIGHT))
				{
					if (_state == PUSH_RIGHT)
					{
						//Walk away from crate
						if (!PlayState._controls.rightPressed() || PlayState._controls.leftPressed())
						{
							_nextState &= (~PUSH_RIGHT);
							this.crateHandle = null;
							if (PlayState._controls.leftPressed() && !PlayState._controls.rightPressed())
							{
								_nextState |= WALK_LEFT;
							}
						}
						else if (crateHandle.y > viktor.y + viktor.height)
						{
							_nextState &= (~PUSH_RIGHT);
							this.crateHandle = null;
						}
					}
					//Jump , hit or starts falling
					else
					{
						_nextState &= (~PUSH_RIGHT);
						this.crateHandle = null;
					}
				}
				
				else if (PlayState.testFlag(_state, PUSH_LEFT))
				{
					if (_state == PUSH_LEFT)
					{
						//Walk away from crate
						if (!PlayState._controls.leftPressed() || PlayState._controls.rightPressed())
						{
							_nextState &= (~PUSH_LEFT);
							this.crateHandle = null;
							if (PlayState._controls.rightPressed() && !PlayState._controls.leftPressed())
							{
								_nextState |= WALK_RIGHT;
							}
						}
						else if (crateHandle.y > viktor.y + viktor.height)
						{
							_nextState &= (~PUSH_LEFT);
							this.crateHandle = null;
						}
					}
					//Jump , hit or starts falling
					else
					{
						_nextState &= (~PUSH_LEFT);
						this.crateHandle = null;
					}
				}
				
				if (PlayState.testFlag(_state, HIT))
				{
					viktor.velocity.x /= 2;
					if (viktor.finished)
						_nextState &= (~HIT);
				}
				
				if (PlayState.testFlag(_state, LANDING))
				{
					if (viktor.finished)
						_nextState &= (~LANDING);
				}
			}
		}
		
		override public function postUpdate():void 
		{
			viktor.postUpdate();
			viktorVelho.postUpdate();
			emitter.postUpdate();
			
			for (var i: int = 0; i < arViktors.length; i++)
			{
				arViktors[i].postUpdate();
				arViktors[i].alpha = arViktors[i].alpha + 0.05 * (0.2 * (1.0 - i / (NUM_VIKTORS + 1)) - arViktors[i].alpha);
			}
			
			if (barba) barba.postUpdate();
			_vikAttackArea.x = viktor.x - (WIDTH - WIDTH_BOX) / 2;
			_vikAttackArea.y = viktor.y + (HEIGHT_BOX - _vikAttackArea.height) / 2;
			
			if (PlayState.testFlag(_nextState, PUSH_LEFT) || PlayState.testFlag(_nextState, PUSH_RIGHT))   
			{
				_crateHitbox.postUpdate();
			}
			
			if (viktor.x >= 203 * Jogo.getInstance().TILE_WIDTH && viktor.y <= 59 * Jogo.getInstance().TILE_WIDTH && !PlayState.testFlag(_state, INPUT_BLOCKED))
			{
				endingMode();
			}
			if (viktor.velocity.y > 0 && !PlayState.testFlag(_state, FALL))
			{
				_nextState |= FALL;
				fallHeight = viktor.y;
			}
		}
		
		private function inputUpdate():void 
		{
			if (PlayState._controls.leftPressed() && !PlayState._controls.rightPressed() && !PlayState.testFlag(_state, PUSH_LEFT))
				_nextState |= WALK_LEFT;
				
			else if (PlayState._controls.rightPressed() && !PlayState._controls.leftPressed() && !PlayState.testFlag(_state, PUSH_RIGHT))
				_nextState |= WALK_RIGHT
			
			if (PlayState._controls.upJustPressed()  && 
					!PlayState.testFlag(_state, JUMP) && 
					!PlayState.testFlag(_state, FALL))
			{
				_nextState |= JUMP;
			}
				
			if (PlayState._controls.attackJustPressed() && !PlayState.testFlag(_state, HIT))
				_nextState |= HIT;
		}
		
		public function overlapButtons (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var button : IActivator;
			if (obj1 == viktor)
			{
				button = obj2 as IActivator;
			}
			else if (obj2 == viktor)
			{
				button = obj1 as IActivator;
			}
			else
			{
				return;
			}
			
			if (!PlayState.testFlag(_state, JUMP))
				button.on();
		}
		
		public function overlapDarts (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			if (!PlayState.testFlag (_state, DEAD))
			{
				if (obj1 == viktor)
				{
					if (obj1.overlaps(obj2) && !(obj2 as Dart).hit)
					{
						(obj2 as Dart).hit = true;
						
						if ((obj2 as Dart).dartPNG == Assets.SNOW_BALL)
							_deathCause = TROLL;
						else
							_deathCause = DART;
						
						kill();
					}
				}
				else if (obj2 == viktor)
				{
					if (obj2.overlaps(obj1) && !(obj1 as Dart).hit)
					{
						(obj1 as Dart).hit = true;
						
						if ((obj1 as Dart).dartPNG == Assets.SNOW_BALL)
							_deathCause = TROLL;
						else
							_deathCause = DART;
							
						kill();
					}
				}
			}
		}
		
		public function overlapMap (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var map : FlxObject;
			if (obj1 == viktor)
			{
				map = obj2;
			}
			else if (obj2 == viktor)
			{
				map = obj1;
			}
			else
			{
				return;
			}
			if (PlayState.testFlag(_nextState, Player.PUSH_LEFT) || PlayState.testFlag(_nextState, Player.PUSH_RIGHT))   
			{
				FlxObject.separateX(_crateHitbox, map);
			}
			else
			{
				FlxObject.separateX(viktor, map);
			}
			
			FlxObject.separateY(viktor, map);
			testFalling ();
		}
		
		private function testFalling () : void
		{
			if (PlayState.testFlag(_nextState, FALL))
			{
				if (viktor.isTouching (FlxObject.DOWN))
				{
					_nextState &= (~FALL);
					if ((viktor.y - fallHeight) > 2 * Jogo.getInstance().TILE_HEIGHT && PlayState.testFlag(_state, FALL) && !PlayState.testFlag(_state, DEAD))
					{
						_nextState |= LANDING;
					}
					fallHeight = 0;
				}
			}
		}
		
		public function overlapPlatforms (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var platform : FlxObject;
			if (obj1 == viktor)
			{
				platform = obj2;
			}
			else if (obj2 == viktor)
			{
				platform = obj1;
			}
			else
			{
				return;
			}
			
			FlxObject.separateX(viktor, platform);
			FlxObject.separateY(viktor, platform);
			
			testFalling ()
		}
		
		public function overlapLaunchers (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var launcher : FlxObject;
			if (obj1 == viktor)
			{
				launcher = obj2;
			}
			else if (obj2 == viktor)
			{
				launcher = obj1;
			}
			else
			{
				return;
			}
			
			FlxObject.separateX(viktor, launcher);
			FlxObject.separateY(viktor, launcher);
			
			testFalling ()
		}
		
		public function overlapCrate (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var crate : Crate;
			if (obj1 == viktor)
			{
				crate = obj2 as Crate;
			}
			else if (obj2 == viktor)
			{
				crate = obj1 as Crate;
			}
			else
			{
				return;
			}
			crate.immovable = true;
			
			FlxObject.separateY(obj1, obj2);
			
			testFalling ()
			
			if (FlxObject.separateX (obj1, obj2))
			{
				if (!PlayState.testFlag(_state, JUMP) && !PlayState.testFlag(_state, FALL) && !PlayState.testFlag(_state, HIT))
				{
					if (PlayState.testFlag(_state, WALK_LEFT) && !PlayState.testFlag(_state, PUSH_LEFT))
					{
						_nextState = PUSH_LEFT;
						crateHandle = crate;
						_crateHitbox = new FlxObject (crate.x, crate.y, viktor.width + crate.width, crate.height - 1);
					}
					else if (PlayState.testFlag(_state, WALK_RIGHT) && !PlayState.testFlag(_state, PUSH_RIGHT))
					{
						_nextState = PUSH_RIGHT;
						crateHandle = crate;
						_crateHitbox = new FlxObject (viktor.x, crate.y, viktor.width + crate.width, crate.height - 1);
					}
				}
			}
			
			crate.immovable = false;
		}
		
		public function overlapEnemy (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var enemy : Wolf;	
			if (obj1 is Wolf)
			{
				enemy = obj1 as Wolf;
			}
			else if (obj2 is Wolf)
			{
				enemy = obj2 as Wolf;
			}
			
			if (PlayState.testFlag(_state, Player.HIT))
			{
				if (_vikAttackArea.overlaps (enemy))
				{
					enemy.kill();
				}
			}
			else if (obj1 == viktor || obj2 == viktor)
			{
				if (!enemy._bDead && !PlayState.testFlag(_state, DEAD))
				{
					_deathCause = WOLF;
					kill();
				}
			}
		}
		
		public function overlapTrap (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var trap : Trap;
			if (obj1 == viktor)
			{
				trap = obj2 as Trap;
			}
			else if (obj2 == viktor)
			{
				trap = obj1 as Trap;
			}
			else
			{
				return;
			}
			
			if (viktor.overlaps (trap) && viktor.isTouching (FlxObject.DOWN) && !trap.up)
			{
				trap.activate();
				_deathCause = TRAP;
				kill();
			}
		}
		
		public function overlapTomb (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var tomb : Tomb;
			if (obj1 == viktor)
			{
				tomb = obj2 as Tomb;
			}
			else if (obj2 == viktor)
			{
				tomb = obj1 as Tomb;
			}
			else
			{
				return;
			}
			if (!leverInRange)
				tomb.read();
		}
		
		public function overlapLever (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var lever : Lever;
			if (obj1 == viktor)
			{
				lever = obj2 as Lever;
			}
			else if (obj2 == viktor)
			{
				lever = obj1 as Lever;
			}
			else
			{
				return;
			}
			
			leverInRange = true;
			
			if (lever.finished)
			{
				if (!lever.activated)
				{
					lever.on();
				}
				else
					lever.off();
			}
		}
		
		override public function draw():void 
		{	
			if (barba)
			{
				if (viktor.facing == FlxObject.RIGHT)
				{	
					barba.x = viktor.x + 84 - viktor.offset.x;
					barba.y = viktor.y + 45 - viktor.offset.y;
				}
				else
				{
					barba.x = viktor.x + 77 - viktor.offset.x;
					barba.y = viktor.y + 45 - viktor.offset.y;
				}
				barba.facing = viktor.facing;
			}
			
			if (viktor.facing == FlxObject.RIGHT)
			{	
				viktorVelho.x = viktor.x + 84 - viktor.offset.x;
				viktorVelho.y = viktor.y + 45 - viktor.offset.y;
			}
			else
			{
				viktorVelho.x = viktor.x + 77 - viktor.offset.x;
				viktorVelho.y = viktor.y + 45 - viktor.offset.y;
			}
			viktorVelho.facing = viktor.facing;
			viktorVelho.alpha = lifeSpan / PlayState.LIFE_TIME;
			
			if (viktor.facing == FlxObject.RIGHT)
			{
				viktor.offset.x = (WIDTH - WIDTH_BOX) / 2;
				emitter.x = viktor.x - viktor.offset.x + WIDTH / 2 - 3.5;
				emitter.y = viktor.y + viktor.height;
			}
			else
			{
				viktor.offset.x = (WIDTH - WIDTH_BOX) / 2 + 14;
				emitter.x = viktor.x - viktor.offset.x + WIDTH / 2 + 3.5;
				emitter.y = viktor.y + viktor.height;
			}
			
			
			if (_state != _nextState)
			{
				var changedState : int = _nextState & (~_state);
				
				if (PlayState.testFlag(changedState, DEAD))
				{
					viktor.play ("DEATH");
					viktorVelho.play ("DEATH");
					barba.play ("DEATH");
				}
				else if (PlayState.testFlag(changedState, HIT))
				{
					viktor.play ("ATTACK");
					viktorVelho.play ("ATTACK");
					barba.play ("ATTACK");
				}
				else if (PlayState.testFlag(changedState, LANDING))
				{
					viktor.play ("LANDING");
					viktorVelho.play ("LANDING");
					barba.play ("LANDING");
				}
			}
			
			if (!PlayState.testFlag(_nextState, HIT) && !PlayState.testFlag(_nextState, DEAD) && !PlayState.testFlag(_nextState, LANDING))
			{
				if (PlayState.testFlag(_state, JUMP))
				{
					viktor.play ("JUMP");
					viktorVelho.play ("JUMP");
					barba.play ("JUMP");
				}
				else if (PlayState.testFlag(_state, FALL))
				{
					viktor.play ("FALL");
					viktorVelho.play ("FALL");
					barba.play ("FALL");
				}
				else if (PlayState.testFlag(_state, PUSH_LEFT) || PlayState.testFlag(_state, PUSH_RIGHT))
				{
					viktor.play ("PUSH");
					viktorVelho.play ("PUSH");
					barba.play ("PUSH");
				}
				else if (PlayState.testFlag(_state, WALK_LEFT) || PlayState.testFlag(_state, WALK_RIGHT))
				{
					if (!PlayState.testFlag(_state, INPUT_BLOCKED))
					{
						viktor.play ("WALKING");
						viktorVelho.play ("WALKING");
						barba.play ("WALKING");
					}
					else
					{
						viktor.play ("WALKING_SLOWLY");
						viktorVelho.play ("WALKING_SLOWLY");
						barba.play ("WALKING_SLOWLY");
					}
				}
				else
				{
					viktor.play ("IDLE");
					viktorVelho.play ("IDLE");
					barba.play ("IDLE");
				}
			}
			
			if (PlayState.testFlag (_state, INPUT_BLOCKED))
			{
				if (timerViktorGhost > 0)
				{
					timerViktorGhost -= FlxG.elapsed;
				}
				else if (numViktors < NUM_VIKTORS)
				{
					var spr : FlxSprite = new FlxSprite ((arViktors.length > 0 ? arViktors[arViktors.length - 1].x : viktor.x) - WIDTH/ 2 - (80 * Math.random()), 60 * Jogo.getInstance().TILE_HEIGHT - viktor.height);
					
					spr.loadGraphic(Assets.VIKTOR, true, true, WIDTH, HEIGHT);
					spr.addAnimation ("WALKING", [2, 3, 4, 5, 6, 7], 7.5, true);
					
					spr.width = WIDTH_BOX;
					spr.height = HEIGHT_BOX;
					spr.offset.x = (WIDTH - WIDTH_BOX) / 2;
					spr.offset.y = (HEIGHT - HEIGHT_BOX);
					spr.velocity.x = SPEED / 2;
					
					spr.play("WALKING");
					spr.alpha = 0.0;
					
					timerViktorGhost = 1.2 + (-0.4 + 0.8 * Math.random());
					
					add (spr);
					remove (viktor);
					add (viktor);
					arViktors.push (spr);
					numViktors++;
				}
			}
			
			super.draw();
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function get deathCause():int 
		{
			return _deathCause;
		}
		
		public function set deathCause(value:int):void 
		{
			_deathCause = value;
		}
		
		public function endingMode () : void
		{
			_nextState = INPUT_BLOCKED;
			_nextState |= WALK_RIGHT;
			timerViktorGhost = 1.2 + (-0.4 + 0.8 * Math.random());
			
			if (PlayState.testFlag(_state, JUMP))
			{
				_nextState |= JUMP;
			}
		}
	}

}