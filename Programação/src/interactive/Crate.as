package  interactive
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Crate extends FlxSprite implements ITmxObject
	{
		//Asset
		private var _cratePNG : Class;
		
		//Identificador da caixa (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : uint;
		
		
		private var blocked : Boolean = false;
		
		public function Crate() 
		{
			
		}
		
		public function setup (objData : Object):void
		{
			//Bounding Box e Posicionamento
			this.width 				= objData.width;
			this.height 			= objData.height;
			this.x 					= objData.x;
			this.y 					= objData.y;
			this._nId				= objData.id;
			
			_cratePNG = Assets.TOTEM;
			
			//Física
			this.acceleration.y = Jogo.getInstance().GRAVITY;
			this.loadGraphic(_cratePNG, false, false, width, height);
		}
		
		public function get id():uint 
		{
			return _nId;
		}
		
		public static function overlapButtons (obj1 : FlxObject, obj2 : FlxObject) : void
		{
			var button : IActivator;
			if (obj1 is Crate)
			{
				button = obj2 as IActivator;
			}
			else if (obj2 is Crate)
			{
				button = obj1 as IActivator;
			}
			else
			{
				return;
			}
			
			button.on();
		}
	}

}