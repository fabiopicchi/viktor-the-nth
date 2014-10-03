package playState
{
	// imports - Flixel
	import assets.Assets;
	import levelLoader.TmxLoader;
	import menuState.MenuState;
	import player.Player;
	import flash.utils.Dictionary;
	import foes.Troll;
	import foes.Wolf;
	import foes.ParedeInvisivel;
	import flash.ui.Mouse;
	import interactive.Button;
	import interactive.Crate;
	import interactive.Dart;
	import interactive.DartLauncher;
	import interactive.KeyButton;
	import interactive.Lever;
	import interactive.MovingPlatform;
	import interactive.Tomb;
	import interactive.Trap;
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSave;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import org.flixel.plugin.TimerManager;
	import UI.TextDisplayer;
	import controls.ControlConfig;
	import allies.NPC;
	
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class PlayState extends FlxState
	{
		public var _musicaClass : Class = MainTheme;
		public var _musicaEndingClass : Class = MusicaFim;
		public var _somPlataformaMovendo:Class = SomPlataformaGrande;
		public var _somTicTac:Class = SomTicTac;
		public var _musica:FlxSound;
		public var _select:Class = SomSelect;
		
		[Embed(source = "../../../Arte/Brinathyn/brinathyn.ttf", fontFamily = "VIKING", embedAsCFF = "false")] 
		public var vikingFont:String;
		
		private const OBJECT_LAYER : String = "objetos";
		private var arObjects : Array = 
		[ 
			{type : MovingPlatform, id : "plataforma", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Lever, id : "alavanca", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Crate, id : "caixa", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Wolf, id : "inimigo", layer : OBJECT_LAYER, autoIncrement : true },
			{type : ParedeInvisivel, id : "paredeinvisivel", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Trap, id : "armadilha", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : DartLauncher, id : "arrow", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Button, id : "trigger", layer : OBJECT_LAYER, autoIncrement : false  },
			{type : Troll, id : "troll", layer : OBJECT_LAYER, autoIncrement : true },
			{type : KeyButton, id : "botaoCheckpoint", layer : OBJECT_LAYER, autoIncrement : false } 
		];
		
		private var arUIObjects : Array = 
		[
			{type : TextDisplayer, id : "text", layer : "end"}
		];
		
		private var arNuvens : Array = 
		[
			{type : Cloud, id : "nuvem", layer : "nuvens"}
		];
		
		//Command
		public static var _controls : ControlConfig = new ControlConfig ();
		
		// Grouping the elements by class
		public var tombs : FlxGroup = new FlxGroup ();
		public var movingPlatforms : FlxGroup = new FlxGroup ();
		public var levers : FlxGroup = new FlxGroup ();
		public var crates : FlxGroup = new FlxGroup ();
		public var enemies : FlxGroup = new FlxGroup ();
		public var traps : FlxGroup = new FlxGroup ();
		public var buttons : FlxGroup = new FlxGroup ();
		public var dartLaunchers : FlxGroup = new FlxGroup ();
		public var darts : FlxGroup = new FlxGroup ();
		public var invisibleWalls : FlxGroup = new FlxGroup ();
		public var trolls : FlxGroup = new FlxGroup ();
		public var keyButtons : FlxGroup = new FlxGroup ();
		public var clouds : FlxGroup = new FlxGroup ();
		
		//Tilemaps
		public var _collisionMap:FlxTilemap;
		private var fundoMap:FlxTilemap;
		private var decoracaoMap:FlxTilemap;
		
		public var _player : Player;
		public static var viktorCor : int = 0;
		private static var _jogoInstance : PlayState;
		public var save : FlxSave = new FlxSave();
		public var viktorLifeSpan : Number = 0;
		
		//barra
		private var timerBar : FlxSprite = new FlxSprite (16, 16, Assets.TIMER);
		private var timeTree : FlxSprite = new FlxSprite (17, 16, Assets.ARVORE);
		private var timerText:FlxText = new FlxText (140, 48, 160);
		
		private var ceu1 : FlxSprite = new FlxSprite (0, 0, Assets.CEU1);
		private var ceu2 : FlxSprite = new FlxSprite (0, 0, Assets.CEU2);
		
		private var montanha : FlxSprite = new FlxSprite (0, 0, Assets.MONTANHA);
		
		//Pause
		private var pauseGroup:PauseScreen;
		private var bEnding:Boolean;
		private var endingTimer:Number = 0;
		private var timeEnding:Boolean = false;
		static public const LIFE_TIME:Number = 112.5;
		static private const SNOW_INTERVAL:Number = 0.5;
		
		//Lapide
		public var lapide : Lapide = new Lapide ();
		public var bLapide : Boolean = false;
		
		private var ending : FlxSprite = new FlxSprite (0, 0, Assets.ENDING);
		
		private var timer : Number = 0;
		
		//KeyButton Cutscene
		private var _kbcTimer : Number;
		private var _kbcActivated : Boolean = false;
		private var _kbcCameraShaking : Boolean = false;
		private var _kbcPrevCameraPos : FlxPoint;
		private var _kbcButton : KeyButton = null;
		
		//Intro
		public var npc : NPC;
		
		//Ending
		private var endingText : TextDisplayer;
		
		//Snow
		private var arParticles : Array = [];
		private var arParticlePool : Array = [];
		private var particles : FlxGroup = new FlxGroup ();
		private var bEraseOnEnding : Boolean = false;
		
		private function getParticle () : FlxSprite
		{
			if (arParticlePool.length > 0)
			{
				return arParticlePool.pop();
			}
			else
			{
				return new FlxSprite (0, 0, Assets.getFlake());
			}
		}
		private function recycleParticle (p : FlxSprite) : void
		{
			arParticlePool.push(p);
		}
		
		public function PlayState ()
		{
			_jogoInstance = this;
		}
		
		public static function getInstance () : PlayState
		{
			return _jogoInstance;
		}
		
		public function getDistanceFromPlayer (obj : FlxObject) : FlxPoint
		{
			var point : FlxPoint = new FlxPoint;
			point.x = FlxU.getDistance(new FlxPoint (obj.getMidpoint().x, 0), new FlxPoint (_player.viktor.getMidpoint().x, 0));
			point.y = FlxU.getDistance(new FlxPoint (0, obj.getMidpoint().y), new FlxPoint (0, _player.viktor.getMidpoint().y));
			
			return point;
		}
				
		override public function create():void 
		{	
			Mouse.cursor = "arrow";
			save.bind (Jogo.getInstance().SAVE_FILE);
			
			//Pause
			pauseGroup = new PauseScreen ();
			
			// Creates a new tilemap with no arguments
			_collisionMap = new FlxTilemap();
			
			// Initializes the map using the generated string, the tile images, and the tile size
			var tileMap : Class = Jogo.getInstance().tileMap;
			var fundo : Class = Jogo.getInstance().fundo;
			var decoracao : Class = Jogo.getInstance().decoracao;
			
			//load maps and add background
			if (tileMap)
			{
				_collisionMap.loadMap(new tileMap (), Assets.TILE_MAP2, Jogo.getInstance().TILE_WIDTH, Jogo.getInstance().TILE_HEIGHT, FlxTilemap.OFF, 1);
				
				fundoMap = new FlxTilemap();
				fundoMap.loadMap(new fundo (), Assets.TILE_MAP2, Jogo.getInstance().TILE_WIDTH, Jogo.getInstance().TILE_HEIGHT, FlxTilemap.OFF, 1);
				
				decoracaoMap = new FlxTilemap();
				decoracaoMap.loadMap(new decoracao(), Assets.TILE_MAP2, Jogo.getInstance().TILE_WIDTH, Jogo.getInstance().TILE_HEIGHT, FlxTilemap.OFF, 1);
				
				var bg : FlxGroup = new FlxGroup ();
				
				bg.add(ceu1);
				bg.add(ceu2);
				ceu1.scrollFactor = new FlxPoint (0, 0);
				ceu2.scrollFactor = new FlxPoint (0, 0);
				ceu2.alpha = 0.0;
				
				bg.add(montanha);
				montanha.y = 0;
				
				montanha.scrollFactor = new FlxPoint ((montanha.width  - Jogo.getInstance().width) / (_collisionMap.width - Jogo.getInstance().width), (montanha.height  - Jogo.getInstance().height) / (_collisionMap.height - Jogo.getInstance().height));
				
				bg.add (clouds);
				bg.add (fundoMap);
				bg.add(_collisionMap);
				_collisionMap.setTileProperties (1, FlxObject.NONE);
				bg.add (decoracaoMap);
				
				add (bg);
			}
			else
				throw new Error ("Erro ao carregar o mapa!");
			
			objDictionary = TmxLoader.loadMap(arNuvens, Jogo.getInstance().cloudTmx);
			addArrayToGroup(objDictionary["nuvem_nuvens"], clouds);
				
			FlxG.worldBounds = new FlxRect(0, 0, _collisionMap.width, _collisionMap.height);
			FlxG.playMusic(_musicaClass);
			
			var objDictionary : Dictionary = TmxLoader.loadMap (arObjects, Jogo.getInstance().tmxMap);
			
			for (var key : String in objDictionary)
			{
				if (key.indexOf("plataforma") != -1)
				{
					addArrayToGroup(objDictionary[key], movingPlatforms);
				}
				else if (key.indexOf("alavanca") != -1)
				{
					addArrayToGroup(objDictionary[key], levers);
				}
				else if (key.indexOf("caixa") != -1)
				{
					addArrayToGroup(objDictionary[key], crates);
				}
				else if (key.indexOf("inimigo") != -1)
				{
					addArrayToGroup(objDictionary[key], enemies);
				}
				else if (key.indexOf("armadilha") != -1)
				{
					addArrayToGroup(objDictionary[key], traps);
				}
				else if (key.indexOf("paredeinvisivel") != -1)
				{
					addArrayToGroup(objDictionary[key], invisibleWalls);
				}
				else if (key.indexOf("arrow") != -1)
				{
					addArrayToGroup(objDictionary[key], dartLaunchers);
				}
				else if (key.indexOf("trigger") != -1)
				{
					addArrayToGroup(objDictionary[key], buttons);
				}
				else if (key.indexOf("troll") != -1)
				{
					addArrayToGroup(objDictionary[key], trolls);
				}
				else if (key.indexOf("botaoCheckpoint") != -1)
				{
					addArrayToGroup(objDictionary[key], keyButtons);
				}
			}
			
			var plat : MovingPlatform;
			
			if (save.data.boxPositions != null) {
				for each (var crt : Crate in crates.members)
				{
					crt.x = save.data.boxPositions[crt.id].x;
					crt.y = save.data.boxPositions[crt.id].y;
				}
			}
			
			for each (var lev : Lever in levers.members)
			{
				for each (plat in movingPlatforms.members)
				{
					if (plat.id == lev.id)
					{
						lev.addActivable(plat);
					}
				}
				if (save.data.leverPulled != null && save.data.leverPulled[lev.id]) 
				{
					lev.on();
				}
			}
			
			for each (var but : Button in buttons.members)
			{			
				for each (var dart : DartLauncher in dartLaunchers.members)
				{
					if (dart.id == but.id)
					{
						but.addActivable(dart);
					}
				}
			}
			
			if (save.data.tombPositions != null) {
				for (var i : int = 1; i < save.data.generations; i++)
				{
					if (save.data.tombPositions [i])
					{
						var tomb : Tomb = new Tomb (i, save.data.tombPositions [i].deathCause, save.data.tombPositions [i].textId);
						tomb.setup ( { x : save.data.tombPositions [i].p.x, y : save.data.tombPositions [i].p.y, width : Jogo.getInstance().TILE_WIDTH, height : Jogo.getInstance().TILE_HEIGHT, id : i } );
						tombs.add (tomb);
					}
				}
			}
			
			if (save.data.enemyKilled != null) {
				for each (var en : Wolf in enemies.members)
				{
					if (save.data.enemyKilled[en.id]) en.kill();
				}
			}
			
			for each (var kButtons : KeyButton in keyButtons.members)
			{
				for each (plat in movingPlatforms.members)
				{
					if (plat.id == kButtons.id)
					{
						kButtons.addActivable(plat);
						kButtons.onPressedCallback = keyButtonCutscene;
					}
				}
				
				if (save.data.checkpointsPressed != null && save.data.checkpointsPressed[kButtons.id]) 
				{
					kButtons.on();
				}
			}
			
			_player = new Player (viktorCor);
			_player.setup (Jogo.getInstance().tmxMap.getObject(Jogo.getInstance().SPAWN_LAYER, "spawnpoint", false)[0]);
			
			add(darts);
			add(invisibleWalls);
			add(movingPlatforms);
			add(tombs);
			add(levers);
			add(trolls);
			add(crates);
			add(enemies);
			add(dartLaunchers);
			add(_player);
			add(buttons);
			add(keyButtons);
			add(traps);
			
			var rand : int = viktorCor;
			while (viktorCor == rand)
			{
				rand = Math.floor (Math.random() * 4);
			}
			viktorCor = rand;
			
			//Instancia menino
			npc = new NPC (viktorCor);
			npc.setup ( { x: _player.viktor.x - 2 * Jogo.getInstance().TILE_WIDTH, y : _player.viktor.y } );
			add (npc);
			
			setCamera ();
			
			add (particles);
			add (timerBar)
			
			timeTree.centerOffsets();
			add (timeTree);
			
			timerText.font = "VIKING";
			timerText.size = 30;
			timerText.alignment = "left";
			timerText.color = 0x583108;
			add (timerText);
			
			//prepara neve
			var tempoSimulacao : Number = 0;
			while (tempoSimulacao < 10.5)
			{
				if (timer > SNOW_INTERVAL)
				{
					insertSnow();
					timer = 0;
				}
				for each (var p : FlxSprite in arParticles)
				{
					p.x += p.velocity.x * 0.033;
					p.y += p.velocity.y * 0.033;
				}
				tempoSimulacao += 0.033;
				timer += 0.033;
			}
			
			timer = 0;
			insertSnow();
			
			objDictionary = TmxLoader.loadMap(arUIObjects, Jogo.getInstance().UITmx);
			for (key in objDictionary)
			{
				if (key.indexOf("text") != -1)
				{
					endingText = objDictionary[key][0];
				}
			}
			
			var lens : FlxSprite = new FlxSprite (0, 0, Assets.LENTE);
			lens.scrollFactor = new FlxPoint (0, 0);
			add (lens);
		}
		
		private function addArrayToGroup (ar : Array, group : FlxGroup) : void
		{
			for each (var basic : FlxBasic in ar)
			{
				group.add(basic);
			}
		}
		
		private function insertSnow () : void
		{
			if (!Jogo._bParticles) return;
			
			var particle : FlxSprite;
			var snowFactor : Number = Math.ceil(30 * ((0.85 * _collisionMap.width) - _player.viktor.x) / (0.85 * _collisionMap.width));
			
			if (snowFactor > 0)
			{
				var snowIncrement : Number = Jogo.getInstance().width / Math.ceil(30 * ((0.85 * _collisionMap.width) - _player.viktor.x) / (0.85 * _collisionMap.width));
				
				for (var i : int = snowIncrement; i < Jogo.getInstance().height; i += snowIncrement)
				{
					particle = getParticle();
					particle.scrollFactor = new FlxPoint (0, 0);
					particle.y = FlxG.camera.x + i - 50;
					particle.x = Jogo.getInstance().width + 50;
					particle.velocity = new FlxPoint ( -(100 + Math.random() * 100), (100 + Math.random() * 100));
					particle.alpha = 0.3 + 0.5 * Math.random();
					particles.add(particle);
					arParticles.push (particle);
				}
				
				for (i = snowIncrement; i < Jogo.getInstance().width; i += snowIncrement)
				{
					particle = getParticle();
					particle.scrollFactor = new FlxPoint (0, 0);
					particle.y = -10 - 50;
					particle.x = Jogo.getInstance().width - i + 50;
					particle.velocity = new FlxPoint ( -(100 + Math.random() * 100), (100 + Math.random() * 100));
					particle.alpha = 0.3 + 0.5 * Math.random();
					particles.add(particle);
					arParticles.push (particle);
				}
				var arRemoved : Array = [];
				for each (var p : FlxSprite in arParticles)
				{
					if (p.x < 0 || p.y > Jogo.getInstance().height)
					{
						arRemoved.push (p);
					}
				}
				for each (p in arRemoved)
				{
					remove(p);
					arParticles.splice (arParticles.indexOf(p), 1);
					arParticlePool.push(p);
				}
			}
		}
		
		private function setCamera():void 
		{
			FlxG.camera.follow (_player.viktor);
			FlxG.camera.deadzone = new FlxRect (FlxG.camera.width / 2 + _player.viktor.width / 2, 0.3 * FlxG.camera.height, + _player.viktor.width / 2, 0.4 * FlxG.camera.height);
			FlxG.camera.setBounds (0, 0, _collisionMap.width, _collisionMap.height);
			timerText.scrollFactor = new FlxPoint (0, 0);
			timerBar.scrollFactor = new FlxPoint (0, 0);
			timeTree.scrollFactor = new FlxPoint (0, 0);
		}
		
		public static function testFlag (state : int, flag : int) : Boolean
		{
			return ((state & flag) == flag);
		}
		
		private function keyButtonCutscene (kb : KeyButton) : void
		{
			_kbcPrevCameraPos = new FlxPoint (FlxG.camera.target.x, FlxG.camera.target.y);
			_kbcTimer = 1.0;
			FlxG.camera.follow(null);
			_kbcButton = kb;
		}
		
		override public function update():void 
		{
			ceu2.alpha = _player.viktor.x / _collisionMap.width;
			
			// O jogo acaba quando o jogador chega nos últimos 3 tiles do mapa (na direita)
			if (_player.viktor.x > _collisionMap.width -  3 * 64 && !bEnding) 
			{
				Jogo.screenTransition(5, 0xffffff, function () : void
				{
					Jogo.kongregate.stats.submit("endGame", save.data.generations);
					Jogo.kongregate.stats.submit("gameBeaten", 1);
					Jogo.kongregate.stats.submit("wolvesKilled", save.data.enemyKilled.length);
					ending.scrollFactor = new FlxPoint (0, 0);
					add (ending);
					add (endingText);
					endingText.startAnimation();
					FlxG.playMusic(_musicaEndingClass);
				}, function () : void { bEnding = true; } );
				return;
			}
			
			if (bEnding)
			{
				endingText.update();
				if (endingTimer > 14 && (FlxG.keys.justPressed("ESCAPE") || PlayState._controls.wasConfirmPressed())) 
				{
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						if (bEraseOnEnding)
						{
							save.erase ();
							save.data = { };
						}
						else
						{
							PlayState.getInstance().saveGame(false);
						}
						FlxG.switchState (new MenuState(true));
					}, null);
				}
				endingTimer += FlxG.elapsed;
				return;
			}
			
			//Pause
			if (FlxG.keys.justPressed("ESCAPE"))
				FlxG.paused = !FlxG.paused;
			
			if (FlxG.paused)
			{
				
				return pauseGroup.update ();
			}
			
			if (!_kbcButton)
			{
				if (bLapide && PlayState._controls.wasConfirmPressed())
					bLapide = false;
						
				if (bLapide)
					return lapide.update ();
				
				super.update();
				
				timer += FlxG.elapsed;
				
				if (timer > SNOW_INTERVAL)
				{
					insertSnow();
					timer = 0;
				}
				
				if (_player.lifeSpan > LIFE_TIME && !testFlag(_player.state, Player.DEAD))
				{
					_player.deathCause = Player.AGE;
					_player.kill ();
					timerText.text = "";
					timeTree.angle = 1.6 * LIFE_TIME;
				}
				else if (!testFlag(_player.state, Player.DEAD))
				{
					timerText.text = Math.ceil(Math.ceil ((LIFE_TIME - _player.lifeSpan) / 3.75)).toString() + " years";
					timeTree.angle = 1.6 * (_player.lifeSpan);
					if (_player.lifeSpan / LIFE_TIME >= 0.9)
					{
						if (!timeEnding)
						{
							FlxG.play(_somTicTac);
							timeEnding = true;
						}
						timerText.color = 0xFF0000;
						if (_player.viktor.x <= 167 * Jogo.getInstance().TILE_WIDTH || _player.viktor.y >= 60 * Jogo.getInstance().TILE_WIDTH )
						{
							if (Math.floor((_player.lifeSpan * 1000)) % 8 == 0) 
							{
								timerText.visible = !timerText.visible;
							}
						}
						else
						{
							timerText.visible = true;
						}
					}
				}
				
				if (testFlag(_player.state, Player.INPUT_BLOCKED))
				{
					if (FlxG.music.getActualVolume() == FlxG.music.volume) FlxG.music.fadeOut(25.0);
					FlxG.music.preUpdate();
					FlxG.music.update();
					FlxG.music.postUpdate();
				}
				
				FlxG.collide (enemies, _collisionMap);
				FlxG.collide (enemies, movingPlatforms);
				FlxG.collide (enemies, invisibleWalls);
				FlxG.collide (enemies);
				
				FlxG.collide (trolls, _collisionMap);
				
				FlxG.overlap (_player, crates, _player.overlapCrate);
				FlxG.overlap (_player, _collisionMap, _player.overlapMap);
				FlxG.overlap (_player, dartLaunchers, _player.overlapLaunchers);
				FlxG.overlap (_player, movingPlatforms, _player.overlapPlatforms);
				FlxG.overlap (_player, enemies, _player.overlapEnemy);
				FlxG.overlap (_player, traps, _player.overlapTrap);
				FlxG.overlap (_player, buttons, _player.overlapButtons);
				FlxG.overlap (_player, keyButtons, _player.overlapButtons);
				FlxG.overlap (_player, darts, _player.overlapDarts);
				
				if (_controls.downJustPressed())
				{
					FlxG.overlap (_player, levers, _player.overlapLever);
					FlxG.overlap (_player, tombs, _player.overlapTomb);
				}
				
				FlxG.collide (npc, _collisionMap);
				
				FlxG.overlap (crates, buttons, Crate.overlapButtons);
				FlxG.collide (crates, movingPlatforms);
				FlxG.collide (crates, dartLaunchers);
				FlxG.collide (crates, _collisionMap);
				FlxG.collide (crates, enemies);
				FlxG.collide (crates);
				
				FlxG.overlap (darts, crates, dartCollision);
				FlxG.overlap (darts, movingPlatforms, dartCollision);
				FlxG.overlap (darts, _collisionMap, dartCollision);
				FlxG.overlap (darts, darts, function (obj1 : FlxObject, obj2 : FlxObject) : void
				{
					if (obj1.overlaps(obj2))
					{
						if ((obj1.velocity.x == 0 || obj1.velocity.y == 0))
						{
							obj1.kill();
							obj1.destroy();
						}
						else if (obj2.velocity.x == 0 || obj2.velocity.y == 0)
						{
							obj2.kill();
							obj2.destroy();
						}
					}
				});
				
				FlxG.collide (tombs, _collisionMap);
			}
			else
			{
				timer += FlxG.elapsed;
				timerText.visible = true;
				
				if (timer > SNOW_INTERVAL)
				{
					insertSnow();
					timer = 0;
				}
				
				//KeyButton Cutscene
				var destX : Number;
				var destY : Number;
				var target : MovingPlatform = _kbcButton.target as MovingPlatform;
				
				if (!_kbcActivated)
				{
					if (_kbcTimer > 0)
					{
						_kbcTimer -= FlxG.elapsed;
					}
					
					else
					{
						destX = target.getMidpoint().x;
						destY = target.getMidpoint().y;
						
						if (Math.abs(0.9 * (_kbcPrevCameraPos.x - destX)) < 1 && Math.abs(0.9 * (_kbcPrevCameraPos.y - destY)) < 1)
						{
							FlxG.camera.shake(0.01, 1.0);
							_kbcCameraShaking = true;
							_kbcActivated = true;
							FlxG.play (_somPlataformaMovendo);
						}
						
						else
						{
							_kbcPrevCameraPos = new FlxPoint (destX + 0.9 * (_kbcPrevCameraPos.x - destX), destY + 0.9 * (_kbcPrevCameraPos.y - destY));
							FlxG.camera.focusOn (_kbcPrevCameraPos);
						}
					}
				}
				else
				{
					movingPlatforms.update();
					if (!target.bStopped)
					{
						FlxG.camera.focusOn (new FlxPoint (target.getMidpoint().x, target.getMidpoint().y));
					}
					else
					{
						if (_kbcCameraShaking)
						{
							_kbcCameraShaking = false;
							FlxG.camera.shake(0);
							_kbcPrevCameraPos = new FlxPoint (target.getMidpoint().x, target.getMidpoint().y);
							_kbcTimer = 1.0;
						}
						
						if (_kbcTimer > 0)
						{
							_kbcTimer -= FlxG.elapsed;
						}
						else
						{
							destX = _player.viktor.getMidpoint().x;
							destY = _player.viktor.getMidpoint().y;
							
							if (Math.abs(0.9 * (_kbcPrevCameraPos.x - destX)) < 1 && Math.abs(0.9 * (_kbcPrevCameraPos.y - destY)) < 1)
							{
								FlxG.camera.follow(_player.viktor);
								_kbcButton = null;
							}
							else
							{
								_kbcPrevCameraPos = new FlxPoint (destX + 0.9 * (_kbcPrevCameraPos.x - destX), destY + 0.9 * (_kbcPrevCameraPos.y - destY));
								FlxG.camera.focusOn (_kbcPrevCameraPos);
							}
						}
					}
				}
				
				crates.update();
				particles.update();
				keyButtons.update();
				
				FlxG.collide (crates, movingPlatforms);
				FlxG.collide (crates, _collisionMap);
			}
		}
		
		public function dartCollision (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var dart : Dart;
			var obj : FlxObject;
			if (obj1 is Dart)
			{
				dart = obj1 as Dart;
				obj = obj2;
			}
			else if (obj2 is Dart)
			{
				obj = obj1;
				dart = obj2 as Dart;
			}
			else
			{
				return;
			}
			
			if (!obj1.overlaps(obj2)) return;
			if (obj is FlxTilemap)
			{
				if (dart.facing == FlxObject.LEFT)
				{
					if ((obj as FlxTilemap).getTile(Math.round(dart.x / Jogo.getInstance().TILE_WIDTH), Math.round(dart.y / Jogo.getInstance().TILE_HEIGHT)) == 87) return;
				}
				else
				{
					if ((obj as FlxTilemap).getTile(Math.floor(dart.x / Jogo.getInstance().TILE_WIDTH), Math.floor(dart.y / Jogo.getInstance().TILE_HEIGHT)) == 87) return;
				}
			}
			
			var bImmovable : Boolean = obj.immovable;
			if (!bImmovable)
				obj.immovable = true;
			if (FlxObject.separateX(obj1, obj2) || FlxObject.separateY(obj1, obj2))
			{
				dart.velocity = new FlxPoint (0, 0);
				dart.hit = true;
			}
			if (!bImmovable)
				obj.immovable = false;
		}
		
		public function saveGame (bSalvaGeracao : Boolean = true) : void
		{
			save.data.boxPositions = [];
			save.data.leverPulled = [];
			save.data.enemyKilled = [];
			save.data.checkpointsPressed = [];
			
			if (bSalvaGeracao)
			{
				if (save.data.generations == null)
					save.data.generations = 2;
				else
					save.data.generations++;
			}
			
			for each(var a:Crate in crates.members) {
				save.data.boxPositions[a.id] = new FlxPoint(a.x, a.y);
			}
			
			for each(var c:Lever in levers.members) {
				save.data.leverPulled[c.id] = c.activated;
			}
			
			for each(var d:Wolf in enemies.members) {
				save.data.enemyKilled[d.id] = d._bDead;
			}
			
			for each(var e:KeyButton in keyButtons.members) {
				save.data.checkpointsPressed[e.id] = e.activated;
			}
		}
		
		override public function add(Object:FlxBasic):FlxBasic 
		{
			if (Object is Dart)
			{
				return darts.add (Object);
			}
			else
			{
				return super.add(Object);
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			if (bLapide)
				lapide.draw ();
			if (FlxG.paused)
			{
				pauseGroup.draw();
			}
		}
	}
}