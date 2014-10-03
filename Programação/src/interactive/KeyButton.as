package interactive
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import playState.PlayState;
	
	/**
	 * ...
	 * @author 
	 */
	public class KeyButton extends FlxSprite implements ITmxObject, IActivator
	{
		public var _somAlavanca:Class = SomAlavanca;
		
		//Identificador da alavanca (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : uint;
		
		//Propriedades especificas da alavanca
		private var _bPressed : Boolean = false;
		private var _sound : Boolean = false;
		
		private var targets : Array = [];
		private var arTargets : Array = [];
		static private const WIDTH:Number = 76;
		static private const WIDTH_BOX:Number = 38;
		static private const HEIGHT:Number = 32;
		
		public var onPressedCallback : Function = null;
		
		public function KeyButton() 
		{
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.loadGraphic(Assets.KEY_BUTTON, true, false, WIDTH, HEIGHT);
			
			this.width 				= WIDTH_BOX;
			this.height 			= HEIGHT;
			this.x 					= objData.x;
			this.y 					= objData.y;
			this._nId				= objData.id;
			
			this.x += (Jogo.getInstance().TILE_WIDTH / 2 - WIDTH_BOX / 2);
			this.y += (Jogo.getInstance().TILE_HEIGHT - 0.58 * HEIGHT);
			
			this.offset.x = (WIDTH - WIDTH_BOX) / 2;
			addAnimation ("ACTIVATE", [0, 1], 15, false);
		}
		
		public function on():void 
		{
			if (!_bPressed)
			{
				play ("ACTIVATE");
				if (_sound) 
				{
					FlxG.play (_somAlavanca);
					
					if (onPressedCallback != null)
					{
						var nViktors : int = (PlayState.getInstance().save.data.generations == null ? 1 : PlayState.getInstance().save.data.generations);
                                
						switch(_nId)
						{
								case 6:
										Jogo.kongregate.stats.submit("firstCheckpoint", nViktors);
										break;
								case 17:
										Jogo.kongregate.stats.submit("secondCheckpoint", nViktors);
										break;
								case 10:
										Jogo.kongregate.stats.submit("thirdCheckpoint", nViktors);
										break;
								default:
										break;
						}
						onPressedCallback(this);
					}
				}
				for each (var activable : IActivable in arTargets)
				{
					activable.activate();
				}
				_bPressed = true;
			}
		}
		
		public function off() : void
		{
			//this button will never deactivate
		}
		
		public function get id():int 
		{
			return _nId;
		}
		
		public function addActivable (activable :IActivable) : void
		{
			(activable as MovingPlatform).platSpeed = (activable as MovingPlatform)._distance / 1.5;
			arTargets.push(activable);
		}
		
		public function get activated () : Boolean
		{
			return _bPressed;
		}
		
		override public function update():void 
		{
			if (!_sound) _sound = true;
			
			super.update();
		}
		public function get target () : FlxObject
		{
			return arTargets[0];
		}
	}

}