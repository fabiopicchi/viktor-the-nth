package 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.ui.Mouse;
	import levelLoader.TmxLoader
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import menuState.MenuState;
	
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;

	
	[Frame(factoryClass = "PreLoader")]
	[SWF(backgroundColor="#000000")]
	
	/**
	 * ...
	 * @author Fabio e Helo
	 */

	public class Jogo extends FlxGame 
	{
		[Embed(source = '../../GameDesign/ruina.tmx', mimeType = 'application/octet-stream')]private var tmxFile:Class;
		[Embed(source = '../../GameDesign/telas.tmx', mimeType = 'application/octet-stream')]private var tmxFile2:Class;
		[Embed(source = '../../GameDesign/nuvens.tmx', mimeType = 'application/octet-stream')]private var tmxFile3:Class;
		[Embed(source = '../../GameDesign/fase.txt', mimeType = 'application/octet-stream')]public var tileMap:Class;
		[Embed(source = '../../GameDesign/fundo.txt', mimeType = 'application/octet-stream')]public var fundo:Class;
		[Embed(source = '../../GameDesign/decoracao.txt', mimeType = 'application/octet-stream')]public var decoracao:Class;
		
		public var tmxMap : TmxLoader;
		public var UITmx : TmxLoader;
		public var cloudTmx : TmxLoader;
		
		private static var instanciou : Boolean = false;
		private static var jogoInstance : Jogo;
		public static var _bParticles : Boolean = true;
		
		public const OBJECT_LAYER : String = "objetos";
		public const TILE_MAP_LAYER : String = "tiles";
		public const SPAWN_LAYER : String = "spawn";
		public const SAVE_FILE : String = "game.vik";
		public const TILE_WIDTH : uint = 64;
		public const TILE_HEIGHT : uint = 64;
		public const GRAVITY : uint = 1600;
		
		public static var kongregate : *;
		
		public function Jogo ()
		{
			if (!instanciou)
			{
				tmxMap = new TmxLoader (new tmxFile ());
				UITmx = new TmxLoader (new tmxFile2 ());
				cloudTmx = new TmxLoader (new tmxFile3 ());
				
				super(800, 600, MenuState);
				
				FlxG.framerate = 30;
				FlxG.flashFramerate = 30;
				
				instanciou = true;
				jogoInstance = this;
				
				addEventListener(Event.ADDED_TO_STAGE, initKongAPI);
			}
			else
			{
				throw new Error ("Jogo nao pode ser instanciado, use o metodo getInstance");
			}	
		}
		
		private function initKongAPI(e:Event):void 
		{
				removeEventListener(Event.ADDED_TO_STAGE, initKongAPI);
				
				// Pull the API path from the FlashVars
				var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
				
				// The API path. The "shadow" API will load if testing locally. 
				var apiPath:String = paramObj.kongregate_api_path || 
				  "http://www.kongregate.com/flash/API_AS3_Local.swf";
				
				// Allow the API access to this SWF
				Security.allowDomain(apiPath);
				
				// Load the API
				var request:URLRequest = new URLRequest(apiPath);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				loader.load(request);
				this.addChild(loader);
				
				// This function is called when loading is complete
				function loadComplete(event:Event):void
				{
						// Save Kongregate API reference
						kongregate = event.target.content;
						
						// Connect to the back-end
						kongregate.services.connect();
						
						// You can now access the API via:
						// kongregate.services
						// kongregate.user
						// kongregate.scores
						// kongregate.stats
						// etc...
				}
		}
		
		public static function getInstance () : Jogo
		{
			return jogoInstance;
		}
		
		private static var bTransition : Boolean = false;
		private static var whiteScreen : Sprite;
		public static function screenTransition (time : Number, color : uint = 0xffffff, callbackFoward : Function = null, callbackBackward : Function = null, bForce : Boolean = false) : void
		{
			if (whiteScreen == null)
			{
				whiteScreen = new Sprite();
				whiteScreen.alpha = 0;
			}
			if (!bTransition || bForce)
			{
				if (bForce)
				{
					TweenLite.killTweensOf(whiteScreen);
				}
				whiteScreen.graphics.clear();
				whiteScreen.graphics.beginFill(color);
				whiteScreen.graphics.drawRect(0, 0, Jogo.getInstance().width, Jogo.getInstance().height);
				Jogo.getInstance().stage.addChild(whiteScreen);
				TweenLite.to (whiteScreen, (time / 2) * (1 - whiteScreen.alpha), { alpha : 1, ease : Linear.easeInOut, onComplete : function () : void {
					if (callbackFoward != null) callbackFoward();
					TweenLite.to (whiteScreen, time / 2, { alpha : 0, ease : Linear.easeInOut, onComplete : function () :void {
						if (callbackBackward != null) callbackBackward();
						Jogo.getInstance().stage.removeChild(whiteScreen);
						bTransition = false;
					}});
				}});
			}
			bTransition = true;
		}
		
		override protected function onFocus(FlashEvent:Event = null):void 
		{
			super.onFocus(FlashEvent);
			Mouse.show();
		}
		
		override protected function onFocusLost(FlashEvent:Event = null):void 
		{
			super.onFocusLost(FlashEvent);
			Mouse.show();
		}
	}
}