package interactive
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Trap extends FlxSprite implements ITmxObject
	{
		public var _somEspinho:Class = SomEspinho;
		
		//Identificador da caixa (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : uint;
		
		public var retract : Number = 3;
		private var _up : Boolean = false;
		
		public function Trap() 
		{
		}
		
		public function setup (objData : Object):void
		{
			this.loadGraphic(Assets.SPIKES, false, false, Jogo.getInstance().TILE_WIDTH, Jogo.getInstance().TILE_HEIGHT);
			
			//Bounding Box e Posicionamento
			this.width 				= Jogo.getInstance().TILE_WIDTH / 2;
			this.height 			= objData.height;
			this.x 					= int (objData.x) + Jogo.getInstance().TILE_WIDTH / 4;
			this.y 					= objData.y;
			this._nId				= objData.id;
			this.offset.x			= Jogo.getInstance().TILE_WIDTH / 4;
			
			this.immovable = true;
			
			addAnimation ("ACTIVATE", [0, 1, 2], 15, false);
			addAnimation ("DEACTIVATE", [2, 1, 0], 15, false);
		}
		
		public function activate () : void
		{
			play ("ACTIVATE");
			FlxG.play (_somEspinho);
			up = true;
		}
		
		override public function update():void 
		{
			if (up) 
			{
				retract -= FlxG.elapsed;
			}
			if (retract <= 0)
			{
				retract = 3;
				play ("DEACTIVATE");
			}
			
			super.update();
		}
		
		public function get up():Boolean 
		{
			return _up;
		}
		
		public function set up(value:Boolean):void 
		{
			_up = value;
		}
		
	}

}