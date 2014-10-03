package interactive
{
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import assets.Assets;
	/**
	 * ...
	 * @author 
	 */
	public class Button extends FlxSprite implements ITmxObject, IActivator
	{
		//[Embed(source = '../../../Som/FX/alavanca.mp3')]
		public var _somAlavanca:Class = SomAlavanca;
		
		//Asset
		private var _buttonPNG : Class;
		
		//Identificador da alavanca (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : uint;
		
		//Propriedades especificas da alavanca
		private var _bPressed : Boolean = false;
		private var _dirty : Boolean = false;
		
		private var targets : Array = [];
		private var arTargets : Array = [];
		static private const WIDTH:Number = 34;
		static private const WIDTH_BOX:Number = 17;
		static private const HEIGHT:Number = 18;
		
		public function Button() 
		{
			
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.loadGraphic(Assets.BUTTON, true, false, WIDTH, HEIGHT);
			
			this.width 				= WIDTH_BOX;
			this.height 			= HEIGHT;
			this.x 					= objData.x;
			this.y 					= objData.y;
			this._nId				= objData.id;
			
			this.x += (Jogo.getInstance().TILE_WIDTH / 2 - WIDTH_BOX / 2);
			this.y += (Jogo.getInstance().TILE_HEIGHT - 0.58 * HEIGHT);
			
			this.offset.x = (WIDTH - WIDTH_BOX) / 2;
			
			addAnimation ("ACTIVATE", [0, 1], 15, false);
			addAnimation ("DEACTIVATE", [1, 0], 15, false);
		}
		
		public function on():void 
		{
			if (!_bPressed)
			{
				play ("ACTIVATE");	
				FlxG.play (_somAlavanca);
				
				for each (var activable : IActivable in arTargets)
				{
					activable.activate();
				}
				_bPressed = true;
			}
			_dirty = true;
		}
		
		public function off() : void
		{
			if (_bPressed)
			{
				play ("DEACTIVATE");
				_bPressed = false;
			}
		}
		
		override public function update():void 
		{
			if (_dirty)
			{
				_dirty = false;
			}
			else
			{
				off();
			}
			super.update();
		}
		
		public function get id():int 
		{
			return _nId;
		}
		
		public function addActivable (activable :IActivable) : void
		{
			arTargets.push(activable);
		}
		
		public function get activated () : Boolean
		{
			return _bPressed;
		}
		
	}

}