package interactive
{
	import assets.Assets;
	import levelLoader.TmxLoader;
	import flash.utils.Dictionary;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import playState.PlayState;
	import UI.UIText;
	import utils.NumberUtils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Tomb extends FlxSprite 
	{
		
		//Asset
		private var _tombPNG : Class;
		
		
		private var _deathCause : int;
		private var _textId : int;
		private var _generation : int;
		
		private const WIDTH_BOX : Number = 52;
		private const WIDTH : Number = 64;
		
		public static var arSentences : Array = [
			["He never liked surprises.",
			"You might want to avoid following his footsteps.",
			"Foot landed on the wrong place.",
			"Found his career as a supporting role.", 
			"Hnnnnnngggg."],
			
			["Was more of a cat-person himself.",
			"Part of something fiercer.",
			"At least got himself a fur coat before the end.",
			"Morbid curiosity regarding Epitaphs."],
			
			["Trolled!",
			"That's what happens when you feed the trolls"],
			
			["Had to wait.",
			"Wandered too much.", 
			"Got lost.",
			"Wanted to speedrun, but failed.",
			"Enjoyed long and lonely treks into the mountains.",
			"Kind of a slow-pacer."],
			
			["He never liked surprises.",
			"You might want to avoid following his footsteps.",
			"Foot landed on the wrong place.",
			"Found his career as a supporting role.", 
			"Hnnnnnngggg."],
		];
		
		public function Tomb(generation : int, deathCause : int, textId : int) 
		{
			_tombPNG = Assets.TOMB;
			this._generation = generation;
			this._deathCause = deathCause;
			this._textId = textId;
		}
		
		public function setup (objData : Object):void
		{	
			//Bounding Box e Posicionamento
			this.width 				= WIDTH_BOX;
			this.height 			= objData.height;
			this.x 					= objData.x - width / 2;
			this.y 					= objData.y - height / 2;
			
			this.offset.x = (WIDTH - WIDTH_BOX) / 2;
			
			this.acceleration.y = Jogo.getInstance().GRAVITY;
			this.loadGraphic(_tombPNG, false, false, WIDTH, height);
		}
		
		public function read () : void
		{
			PlayState.getInstance().bLapide = true;
			PlayState.getInstance().lapide.message = arSentences [this._deathCause][this._textId];
			PlayState.getInstance().lapide.generation = NumberUtils.romanize(_generation);
		}
		
	}

}