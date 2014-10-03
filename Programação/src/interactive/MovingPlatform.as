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
	public class MovingPlatform extends FlxSprite implements ITmxObject, IActivable
	{
		
		//asset
		private var _movingPlatformPNG : Class;
		
		//Constantes para determinar o sentido da plataforma
		private static const LEFT : uint = 0;
		private static const UP : uint = 1;
		private static const RIGHT : uint = 2;
		private static const DOWN : uint = 3;
		
		public var platSpeed:Number = 80;
		
		//Identificador para botao ou alavanca
		private var _nId : int;
		
		//Propriedades especificas da Plataforma Móvel
		private var _initX : uint;
		private var _initY : uint;
		private var _way : uint;
		public var _distance : Number;
		private var _period : Number;
		public var bStopped : Boolean = true;
		
		public function MovingPlatform() 
		{
		}
		
		public function setup (objData : Object):void
		{	
			_nId = objData.id;
			_way = objData.sentido;
			
			//Bounding Box e Posicionamento
			this.x = objData.x;
			this.y = objData.y;
			this.width = objData.width;
			this.height = objData.height;
			this._distance = objData.distancia * Jogo.getInstance().TILE_HEIGHT;
			this._period = objData.periodo;
			
			platSpeed = _distance / _period;
			
			_initX = x;
			_initY = y;
			
			this.immovable = true;
			
			if (!objData.checkpoint)
			{
				if (this.height / Jogo.getInstance().TILE_HEIGHT == 2)
					_movingPlatformPNG = Assets.VER2;
				if (this.height / Jogo.getInstance().TILE_HEIGHT == 3)
					_movingPlatformPNG = Assets.VER3;
				if (this.height / Jogo.getInstance().TILE_HEIGHT == 4)
					_movingPlatformPNG = Assets.VER4;
				if (this.height / Jogo.getInstance().TILE_HEIGHT == 5)
					_movingPlatformPNG = Assets.VER5;
				
				if (this.width / Jogo.getInstance().TILE_WIDTH == 2)
					_movingPlatformPNG = Assets.HOR2;
				if (this.width / Jogo.getInstance().TILE_WIDTH == 3)
					_movingPlatformPNG = Assets.HOR3;
				if (this.width / Jogo.getInstance().TILE_WIDTH == 4)
					_movingPlatformPNG = Assets.HOR4;
				if (this.width / Jogo.getInstance().TILE_WIDTH == 5)
					_movingPlatformPNG = Assets.HOR5;
			}
			else
			{
				if (this.height / Jogo.getInstance().TILE_HEIGHT == 4)
				{
					_movingPlatformPNG = Assets.CHECK_VER_4;
					this.height = 255;
					this.offset.y = -0.5;
				}
				
				if (this.width / Jogo.getInstance().TILE_WIDTH == 3)
				{
					_movingPlatformPNG = Assets.CHECK_HOR_3;
					this.width = 190;
					this.offset.x = -1;
				}
				if (this.width / Jogo.getInstance().TILE_WIDTH == 5)
				{
					_movingPlatformPNG = Assets.CHECK_HOR_5;
					this.width = 316;
					this.offset.x = -2;
				}
			}
			
			this.loadGraphic(_movingPlatformPNG, false, false, width, height);
		}
		
		override public function postUpdate():void 
		{
			super.postUpdate();
		
			switch (_way)
			{
				case LEFT:
					if (velocity.x < 0 && x <= _initX - _distance)
					{
						velocity.x = 0;
						x = _initX - _distance;
						bStopped = true;
					}
					else if (velocity.x > 0 && x >= _initX) 
					{
						velocity.x = 0;
						x = _initX;
						bStopped = true;
					}
					break;
				case RIGHT:
					if (velocity.x > 0 && x >= _initX + _distance)
					{
						velocity.x = 0;
						x = _initX + _distance;
						bStopped = true;
					}
					else if (velocity.x < 0 && x <= _initX) 
					{
						velocity.x = 0;
						x = _initX;
						bStopped = true;
					}
					break;
				case UP:
					if (velocity.y < 0 && y <= _initY - _distance)
					{
						velocity.y = 0;
						y = _initY - _distance;
						bStopped = true;
					}
					else if (velocity.y > 0 && y >= _initY)
					{
						velocity.y = 0;
						y = _initY;
						bStopped = true;
					}
					break;
				case DOWN:
					if (velocity.y > 0 && y >= _initY + _distance)
					{
						velocity.y = 0;
						y = _initY + _distance;
						bStopped = true;
					}
					else if (velocity.y < 0 && y <= _initY)
					{
						velocity.y = 0;
						y = _initY;
						bStopped = true;
					}
					break;
			}
		}
		
		/* INTERFACE IActivable */
		
		public function activate():void 
		{
			bStopped = false;
			switch (_way)
			{
				case LEFT:
					velocity.x = -platSpeed;
					break;
				case RIGHT:
					velocity.x = platSpeed;
					break;
				case UP:
					velocity.y = -platSpeed;
					break;
				case DOWN:
					velocity.y = platSpeed;
					break;
			}
		}
		
		public function deactivate():void 
		{
			switch (_way)
			{
				case LEFT:
					velocity.x = platSpeed;
					break;
				case RIGHT:
					velocity.x = -platSpeed;
					break;
				case UP:
					velocity.y = platSpeed;
					break;
				case DOWN:
					velocity.y = -platSpeed;
					break;
			}
		}
		
		public function get id():int 
		{
			return _nId;
		}
	}

}