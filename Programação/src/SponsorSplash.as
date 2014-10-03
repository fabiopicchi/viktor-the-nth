package  
{
	import assets.Assets;
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.ui.Mouse;
	import menuState.MenuState;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author arthur e fabio
	 */
	public class SponsorSplash extends FlxState
	{
		private var _loader : Loader;
		private var _splash : MovieClip;
		
		public function SponsorSplash() 
		{
			// allows us to import SWFs to use as animations
			var context : LoaderContext = new LoaderContext (false,
				ApplicationDomain.currentDomain);
			context.allowCodeImport = true;
			_loader = new Loader ();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.loadBytes (new Assets.MC_LOADER (), context);
			
			Mouse.show();
			Mouse.cursor = "button";
		}
		
		private function onComplete(e:Event):void 
		{
			FlxG.stage.addEventListener(MouseEvent.CLICK, gotoArmorGames);
			_splash = (e.target.content as MovieClip);
			(_splash.getChildAt(0) as MovieClip).gotoAndPlay(2);
			Jogo.getInstance().stage.addChild(_splash);
			_splash.addEventListener(Event.COMPLETE, function (e : Event) : void
			{				
				var url:String = FlxG.stage.loaderInfo.url;
				var arValidDomains : Array = [
					"http://games.armorgames.com",
					"http://preview.armorgames.com",
					"http://cache.armorgames.com",
					"http://cdn.armorgames.com",
					"http://gamemedia.armorgames.com",
					"http://*.armorgames.com"
				];
				//if (arValidDomains.indexOf(url) > 0) 
				//{
					FlxG.stage.removeEventListener(MouseEvent.CLICK, gotoArmorGames);
					Jogo.getInstance().stage.removeChild(_splash);
					Jogo.screenTransition(2, 0x000000, function () : void {
						FlxG.switchState(new MenuState());
					}, null, true);
				//} 
				//else 
				//{
					//(_splash.getChildAt(0) as MovieClip).play();
				//}
				
				
			});
		}
		
		private function gotoArmorGames(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://armor.ag/MoreGames"), "_blank");
		}
	}

}