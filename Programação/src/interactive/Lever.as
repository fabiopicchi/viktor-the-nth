package interactive 
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class Lever extends FlxSprite implements ITmxObject, IActivator
	{
		public var _somAlavanca:Class = SomAlavanca;
		
		//Asset
		private var _leverPNG : Class;
		
		//Identificador da alavanca (cada alavanca esta associado a uma porta ou plataforma)
		private var _nId : int;
		
		//Propriedades especificas da alavanca
		private var _effectDuration : Number;
		
		private var arTargets : Array = [];
		private var _bPulled : Boolean = false;
		private var _sound : Boolean = false;
		
		public function Lever() 
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
			
			_leverPNG = Assets.ALAVANCA_ASSET;
			this.immovable = true;
			
			addAnimation ("ACTIVATE", [0, 1, 2], 15, false);
			addAnimation ("DEACTIVATE", [2, 1, 0], 15, false);
			this.loadGraphic(_leverPNG, false, false, width, height);
			play ("DEACTIVATE");
		}
		
		public function on():void 
		{
			play ("ACTIVATE");	
			if (_sound) FlxG.play (_somAlavanca);
			_bPulled = true;
			
			for each (var activable : IActivable in arTargets)
			{
				activable.activate();
			}
		}
		
		public function off () : void
		{
			play ("DEACTIVATE");
			FlxG.play (_somAlavanca);
			_bPulled = false;
			
			for each (var activable : IActivable in arTargets)
			{
				activable.deactivate();
			}
		}
		
		public function get activated () : Boolean
		{
			return _bPulled;
		}
		
		public function addActivable (activable :IActivable) : void
		{
			arTargets.push(activable);
		}
		
		public function get id():int 
		{
			return _nId;
		}
		
		override public function update():void 
		{
			if (!_sound) _sound = true;
			
			super.update();
		}
	}

}