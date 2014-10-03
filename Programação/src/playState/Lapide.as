package playState
{
	import assets.Assets;
	import levelLoader.TmxLoader;
	import flash.utils.Dictionary;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import UI.UIText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Lapide extends FlxGroup 
	{
		[Embed(source = "../../../Arte/Brinathyn/brinathyn.ttf", fontFamily = "VIKING", embedAsCFF = "false")] public var vikingFont:String;
		
		private var _message : UIText;
		private var _generation : UIText;
		public var background : FlxSprite = new FlxSprite (0, 0, Assets.LAPIDE);
		
		private var arObjects : Array = [
			{type : UIText, id : "text", layer : "lapide"}
		];
		
		public function loadScreenPositions () : void
		{
			var objLoaded : Dictionary = TmxLoader.loadMap(arObjects, Jogo.getInstance().UITmx);
			
			for (var id : String in objLoaded)
			{
				var layer : String = id.split("_")[1];
				var i : int = 0;
				switch (layer)
				{
					case "lapide":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							if (objLoaded[id][i] is UIText)
							{
								if (objLoaded[id][i].fieldName == "numero")
								{
									_generation = objLoaded[id][i];
								}
								else
								{
									_message = objLoaded[id][i];
								}
							}
						}
						break;
				}
			}
		}
		
		public function Lapide() 
		{
			add (background);
			background.scrollFactor = new FlxPoint;
			loadScreenPositions();
			add (_message);
			_message.text.scrollFactor = new FlxPoint;
			_message.text.size = 24;
			_message.text.color = 0x583108;
			add (_generation);
			_generation.text.scrollFactor = new FlxPoint;
			_generation.text.size = 72;
			_generation.text.color = 0x583108;
			
		}
		
		public function set message (value : String) : void
		{
			_message.text.text = value;
		}
		
		public function set generation (value : String) : void
		{
			_generation.text.text = value;
		}
		
	}

}