package allies
{
	import assets.Assets;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NPC extends FlxSprite 
	{
		//Asset
		private var _npcPNG : Class;
		
		//Tamanho do Sprite
		protected const WIDTH 	: uint 	= 58;
		protected const HEIGHT 	: uint 	= 90;
		
		//Bounding box offset
		private const WIDTH_BOX		: uint 	= 64;
		private const HEIGHT_BOX	: uint 	= 128;
		
		public function NPC(cor : int) 
		{
			switch (cor)
			{
				case 0:
					_npcPNG = Assets.VIKTORJR;
					break;
				case 1:
					_npcPNG = Assets.VIKTORJR_CASTANHO;
					break;
				case 2:
					_npcPNG = Assets.VIKTORJR_PRETO;
					break;
				case 3:
					_npcPNG = Assets.VIKTORJR_RUIVO;
					break;
			}
			addAnimation ("IDLE", [0, 1, 2, 3], 10, true);
			
			this.loadGraphic(_npcPNG, true, true, WIDTH, HEIGHT);
		}
		
		public function setup (objData : Object, offsetX : uint = 0, offsetY : uint = 0) : void
		{
			//Bounding Box e Posicionamento
			this.width = WIDTH_BOX;
			this.height = HEIGHT_BOX;
			this.offset.x = (WIDTH - WIDTH_BOX) / 2;
			this.offset.y = (HEIGHT - HEIGHT_BOX);
			this.x = objData.x;
			this.y = objData.y;
			
			this.x += offsetX;
		}
		
		override public function draw():void 
		{	
			play ("IDLE");
			super.draw();
		}
		
	}

}