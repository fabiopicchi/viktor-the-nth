package menuState
{
	import assets.Assets;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import levelLoader.TmxLoader;
	import org.flixel.FlxSound;
	import playState.PlayState;
	import flash.display.StageDisplayState;
	import flash.system.System;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import levelLoader.TmxLoader;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import UI.TextDisplayer;
	import UI.UIButton;
	import UI.UIText;
	import utils.NumberUtils;
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class MenuState extends FlxState
	{
		[Embed(source = "../../../Arte/Brinathyn/brinathyn.ttf", fontFamily = "VIKING", embedAsCFF = "false")] public var vikingFont:String;
		
		private var arObjects : Array = [{type : UIButton, id : "button", layer : "mainmenu"},
										{type : UIButton, id : "button", layer : "options"},
										{type : UIButton, id : "button", layer : "credits"},
										{type : UIButton, id : "button", layer : "howto" },
										{type : UIText, id : "text", layer : "mainmenu" },
										{type : UIText, id : "text", layer : "intro" },
										{type : TextDisplayer, id : "intro", layer : "intro"}];
		
		public var _musica:Class = MusicaMenu;
		public var _select:Class = SomSelect;
		
		private const textBoxWidth:uint = 200;
		static private const SPLASH_TIME:Number = 3;
		private var _menu:FlxSprite = new FlxSprite (0, 0, Assets.MAIN_MENU);
		private var _menuItems:FlxSprite = new FlxSprite (0, 0, Assets.MENU_ITEMS);
		private var _logo:FlxSprite = new FlxSprite (0, 0, Assets.LOGO);
		private var _cursor : FlxSprite = new FlxSprite (0, 0, Assets.ARROW);
		private var catavento : FlxSprite = new FlxSprite (0, 0, Assets.SPLASH);
		private var carta : FlxSprite = new FlxSprite (0, 0, Assets.LETTER);
		private var sure : FlxSprite = new FlxSprite (0, 0, Assets.SURE);
		private var textLetter : TextDisplayer;
		
		private static const START : String = "start";
		private static const HOW_TO : String = "howto";
		private static const CREDITS : String = "credits";
		private static const OPTIONS : String = "options";
		private static const BACK : String = "back";
		private static const DELETE : String = "delete";
		private static const SOUND : String = "sound";
		private static const PARTICLES : String = "particles";
		private var arMain : Array = [START, HOW_TO, OPTIONS, CREDITS];
		private var arOptions : Array = [BACK, DELETE, SOUND, PARTICLES];
		private var index : int = 0;
		
		private var buttons: FlxGroup = new FlxGroup ();
		private var number : UIText;
		private var skipText : UIText;
		
		private var save : FlxSave = new FlxSave();
		
		private var _bHowTo : Boolean = false;
		private var _howToG : FlxSprite = new FlxSprite (0, 0, Assets.HOW_TO);
		private var _arHowTo : Array = [];
		
		private var _bOptions : Boolean = false;
		private var _optionsG : FlxSprite = new FlxSprite (0, 0, Assets.OPTIONS);
		private var _arOptions : Array = [];
		
		private var _bCredits : Boolean = false;
		private var _creditsG : FlxSprite = new FlxSprite (0, 0, Assets.CREDITS);
		private var _arCreadits : Array = [];
		
		private var _bIntro : Boolean = true;
		private var _bTimer : Number = 0;
		private var bAnimate : Boolean = false;
		private var bStraightToMenu : Boolean = false;
		
		private var selectedObject : String;
		
		private var _onOff1 : FlxSprite;
		private var _onOff2 : FlxSprite;
		
		private var _confirm : Boolean = false;
		private var _linkRemoved : Boolean = false;
		
		public function MenuState (bStraightToMenu : Boolean = false, bAnimate : Boolean = false)
		{
			this.bAnimate = bAnimate;
			this.bStraightToMenu = bStraightToMenu;
			init();
			if (bStraightToMenu)
			{
				catavento.visible = false;
				carta.visible = false;
				_bTimer = 100;
			}
			else
			{
				FlxG.stage.addEventListener(MouseEvent.CLICK, gotoCatavento);
			}
		}
		
		private function gotoCatavento(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://catavento.art.br"), "_blank");
			FlxG.stage.removeEventListener(MouseEvent.CLICK, gotoCatavento);
			_linkRemoved = true;
			Mouse.cursor = "arrow";
		}
		
		private function init () : void
		{
			//FlxG.mouse.hide();
			Mouse.show();
			Mouse.cursor = "button";
			
			var objLoaded : Dictionary = TmxLoader.loadMap(arObjects, Jogo.getInstance().UITmx);
			
			for (var id : String in objLoaded)
			{
				var layer : String = id.split("_")[1];
				var i : int = 0;
				switch (layer)
				{
					case "mainmenu":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							if (objLoaded[id][i] is UIButton)
								buttons.add (objLoaded[id][i]);
							else
								number = objLoaded[id][i];
						}
						break;
					case "options":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							_arOptions.push (objLoaded[id][i]);
						}
						break;
					case "credits":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							_arCreadits.push (objLoaded[id][i]);
						}
						break;
					case "howto":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							_arHowTo.push (objLoaded[id][i]);
						}
						break;
					case "intro":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							if (objLoaded[id][i] is UIText)
								skipText = objLoaded[id][i];
							else
								textLetter = objLoaded[id][i];
						}
						break;
				}
			}
			
			save.bind (Jogo.getInstance().SAVE_FILE);
			if (save.data.mute)
			{
				FlxG.mute = save.data.mute;
			}
			if (save.data.particles)
			{
				Jogo._bParticles = save.data.particles;
			}
			
			add (_menu);
			add (buttons);
			
			_menuItems.x = 290;
			_menuItems.y = 325;
			add (_menuItems);
			
			_logo.x = 216;
			_logo.y = 13;
			add (_logo);
			
			add (number);
			
			_howToG.visible = false;
			add (_howToG);
			_creditsG.visible = false;
			add (_creditsG);
			
			_onOff1 = new FlxSprite (240, 272);
			_onOff1.loadGraphic(Assets.ON_OFF, true, false, 77, 36);
			_onOff1.scrollFactor = new FlxPoint(0, 0);
			_onOff1.addAnimation ("ON", [0]);
			_onOff1.addAnimation ("OFF", [1]);
			_onOff1.play ("ON");
			add(_onOff1);
			
			_onOff2 = new FlxSprite (480, 345);
			_onOff2.loadGraphic(Assets.ON_OFF, true, false, 77, 36);
			_onOff2.scrollFactor = new FlxPoint(0, 0);
			_onOff2.addAnimation ("ON", [0]);
			_onOff2.addAnimation ("OFF", [1]);
			_onOff2.play ("ON");
			add(_onOff2);
			
			_optionsG.visible = false;
			_onOff1.visible = false;
			_onOff2.visible = false;
			
			add (_optionsG);
			
			add (_cursor);
			
			_cursor.visible = false;
			
			if (bAnimate)
			{
				number.text.text = NumberUtils.romanize (int(save.data.generations) - 1);
				_logo.visible = false;
				_menuItems.visible = false;
				number.visible = false;
				
				TweenLite.delayedCall(0.5, function () : void
				{
					_logo.visible = true;
					_menuItems.visible = true;
					number.visible = true;
					TweenLite.from (_logo, 0.5, { delay : 0.25, y : -500, ease : Back.easeOut } );
					TweenLite.from (number.text, 0.5, { delay : 0.25, y : -500, ease : Back.easeOut } );
					TweenLite.from (_menuItems, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut});
					
					TweenLite.to (number.text.scale, 0.5, { delay:1.0, x : 0, onComplete : function () : void {
						number.text.text = NumberUtils.romanize (save.data.generations);
						TweenLite.to (number.text.scale, 0.25, { x : 1, onComplete : function () : void {
							bAnimate = false;
							_cursor.visible = true;
						}});
					}});
				});
			}
			else
			{
				number.text.text = NumberUtils.romanize ((save.data.generations) ? save.data.generations : 1);
				if (bStraightToMenu)
				{
					_logo.visible = true;
					_menuItems.visible = true;
					number.visible = true;
					TweenLite.from (_logo, 0.5, { delay : 0.25, y : -500, ease : Back.easeOut } );
					TweenLite.from (number.text, 0.5, { delay : 0.25, y : -500, ease : Back.easeOut } );
					TweenLite.from (_menuItems, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut, onComplete : function () : void {
						_cursor.visible = true;
					}});
				}
			}
			
			add (carta);
			add (textLetter);
			skipText.text.text = "Press Enter or Esc to skip";
			skipText.text.size = 24;
			skipText.text.color = 0xFFFFFF;
			skipText.text.alignment= "center";
			skipText.text.alpha = 0;
			add (skipText);
			add (catavento);
			
			select (START);
		}
		
		override public function create():void
        {
			FlxG.playMusic(_musica);
		}
		
		private function noMenu () : Boolean
		{
			return (!_bHowTo && !_bOptions && !_bCredits);
		}
		
		override public function update():void 
		{
			if (catavento.visible || carta.visible)
			{
				_bTimer += FlxG.elapsed;
				if (_bTimer < SPLASH_TIME && (PlayState._controls.wasConfirmPressed() || FlxG.keys.justPressed ("ESCAPE")))
				{
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						catavento.visible = false;
						if (!_linkRemoved) FlxG.stage.removeEventListener(MouseEvent.CLICK, gotoCatavento);
						Mouse.cursor = "arrow";
						textLetter.startAnimation();
						_bTimer = SPLASH_TIME;
					}, null, true);
				}
				else if (_bTimer > SPLASH_TIME  && !catavento.visible && (PlayState._controls.wasConfirmPressed() || FlxG.keys.justPressed ("ESCAPE")))
				{
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						carta.visible = false;
						textLetter.visible = false;
						remove (skipText);
						_bTimer = Infinity;
						bAnimate = false;						
						_logo.visible = true;
						_menuItems.visible = true;
						number.visible = true;
						TweenLite.from (_logo, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut } );
						TweenLite.from (number.text, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut } );
						TweenLite.from (_menuItems, 0.5, { delay : 0.75, y : -500, ease : Back.easeOut , onComplete : function () : void
						{
							_cursor.visible = true;
						}} );
					}, null, true);
				}
				
				if (_bTimer > SPLASH_TIME + 15)
				{
					skipText.text.alpha = skipText.text.alpha + 0.05 * (1.0 - skipText.text.alpha);
				}
			}
				
			if (_bTimer > SPLASH_TIME + 30 && !carta.visible && !catavento.visible && !bAnimate)
			{
				if (_cursor.visible && PlayState._controls.wasConfirmPressed())
				{
					if (selectedObject == START)
					{
						FlxG.play (_select);
						Jogo.screenTransition(2, 0x000000, function () : void {
							FlxG.switchState (new PlayState ());
						}, null, true);
						bAnimate = true;
					}
					else if (selectedObject == HOW_TO)
					{
						_bHowTo = true;
						enterOptionScreen (_howToG);
						select (BACK);
						FlxG.play (_select);
					}
					else if (selectedObject == OPTIONS)
					{
						_bOptions = true;
						enterOptionScreen (_optionsG);
						index = 0;
						select (BACK);
						FlxG.play (_select);
					}
					else if (selectedObject == CREDITS)
					{
						_bCredits = true;
						enterOptionScreen (_creditsG);
						select (BACK);
						FlxG.play (_select);
					}
					else if (_bHowTo && selectedObject == BACK)
					{
						_bHowTo = false;
						select (START);
						leaveOptionScreen(_howToG);
						FlxG.play (_select);
					}
					else if (_bOptions && selectedObject == BACK)
					{
						_bOptions = false;
						select (START);
						leaveOptionScreen(_optionsG);
						number.text.text = NumberUtils.romanize ((save.data.generations) ? save.data.generations : 1);
						FlxG.play (_select);
					}
					else if (_bCredits && selectedObject == BACK)
					{
						_bCredits = false;
						select (START);
						leaveOptionScreen(_creditsG);
						FlxG.play (_select);
					}
					else if (_bOptions && selectedObject == DELETE)
					{
						if (!_confirm)
						{
							add(sure);
							sure.x = 542;
							sure.y = 200;
							_confirm = true;
							_cursor.x = 502;
							_cursor.y = 230;
						}
						else
						{
							if (_cursor.x == 502)
							{
								save.erase ();
								save.data = { };
								number.text.text = NumberUtils.romanize ((save.data.generations) ? save.data.generations : 1);
							}
							_confirm = false;
							remove(sure);
						}
						FlxG.play (_select);
					}	
					else if (_bOptions && selectedObject == SOUND)
					{
						FlxG.mute = !FlxG.mute;
						if (FlxG.mute)
							_onOff1.play ("OFF");
						else
							_onOff1.play ("ON");
						save.data.mute = FlxG.mute;
					}	
					else if (_bOptions && selectedObject == PARTICLES)
					{
						Jogo._bParticles = !Jogo._bParticles;
						if (Jogo._bParticles)
							_onOff2.play ("ON");
						else
							_onOff2.play ("OFF");
						save.data.particles = Jogo._bParticles;
					}	
				}
				
				if (!_confirm)
				{
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						if (_bHowTo)
						{
							_bHowTo = false;
							select (START);
							leaveOptionScreen(_howToG);
							FlxG.play (_select);
						}
						else if (_bOptions)
						{
							_bOptions = false;
							select (START);
							leaveOptionScreen(_optionsG);
							number.text.text = NumberUtils.romanize ((save.data.generations) ? save.data.generations : 1);
							FlxG.play (_select);
						}
						else if (_bCredits)
						{
							_bCredits = false;
							select (START);
							leaveOptionScreen(_creditsG);
							FlxG.play (_select);
						}
					}
					
					//Teclado
					if (PlayState._controls.downJustPressed())
					{
						if (noMenu())
						{
							index++;
							if (index >= arMain.length)
								index = 0;
						}
						else if (_bOptions)
						{
							index++;
							if (index >= arOptions.length)
								index = 0;
						}
					}
					
					if (PlayState._controls.upJustPressed())
					{
						if (noMenu())
						{
							index--;
							if (index < 0)
								index = arMain.length - 1;
						}
						else if (_bOptions)
						{
							index--;
							if (index < 0)
								index = arOptions.length - 1;
						}
					}
					
					
					if (noMenu ())
					{
						select (arMain[index]);
					}
					else if (_bOptions)
					{
						select (arOptions[index]);
					}
				}
				else
				{
					if (PlayState._controls.rightJustPressed() || PlayState._controls.leftJustPressed())
					{
						if (_cursor.x == 502) _cursor.x = 632;
						else _cursor.x = 502;
					}
					
					
					if (FlxG.keys.justPressed("ESCAPE"))
					{
						_confirm = false;
						remove(sure);
						select(DELETE);
					}
				}
			}
			else
			{
				if (_bTimer > SPLASH_TIME && catavento.visible)
				{
					bAnimate = true;
					Jogo.screenTransition(2, 0x000000, function () : void
					{
						catavento.visible = false;
						if (!_linkRemoved) FlxG.stage.removeEventListener(MouseEvent.CLICK, gotoCatavento);
						Mouse.cursor = "arrow";
						textLetter.startAnimation();
					});
				}
				else if (_bTimer > 45 && carta.visible)
				{
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						carta.visible = false;
						textLetter.visible = false;
						remove (skipText);
						_bTimer = Infinity;
						bAnimate = false;						
						_logo.visible = true;
						_menuItems.visible = true;
						number.visible = true;
						TweenLite.from (_logo, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut } );
						TweenLite.from (number.text, 0.5, { delay : 0.5, y : -500, ease : Back.easeOut } );
						TweenLite.from (_menuItems, 0.5, { delay : 0.75, y : -500, ease : Back.easeOut , onComplete : function () : void
						{
							_cursor.visible = true;
						}} );
					}, null);
				}
			}
			super.update();
		}
		
		private function select (id : String) : void
		{
			var obj : FlxObject;
			if (_bHowTo)
			{
				for each (obj in _arHowTo)
				{
					if (obj is UIButton && id == (obj as UIButton).id)
					{
						_cursor.x = obj.x - _cursor.width - 5;
						_cursor.y = obj.y + (obj.height - _cursor.height) / 2;
						selectedObject = id;
					}
				}
			}
			
			else if (_bOptions)
			{
				for each (obj in _arOptions)
				{
					if (obj is UIButton && id == (obj as UIButton).id)
					{
						_cursor.x = obj.x - _cursor.width - 5;
						_cursor.y = obj.y + (obj.height - _cursor.height) / 2;
						selectedObject = id;
					}
				}
			}
				
			else if (_bCredits)
			{
				for each (obj in _arCreadits)
				{
					if (obj is UIButton && id == (obj as UIButton).id)
					{
						_cursor.x = obj.x - _cursor.width - 5;
						_cursor.y = obj.y + (obj.height - _cursor.height) / 2;
						selectedObject = id;
					}
				}
			}
			
			else
			{
				for each (obj in buttons.members)
				{
					if (obj is UIButton && id == (obj as UIButton).id)
					{
						_cursor.x = obj.x - _cursor.width - 5;
						_cursor.y = obj.y + (obj.height - _cursor.height) / 2;
						selectedObject = id;
					}
				}
			}
			
		}
		
		private function leaveOptionScreen (screen : FlxSprite) : void
		{
			_cursor.visible = false;
			
			TweenLite.to (screen, 0.5, {x : -1024, ease : Back.easeIn, onComplete : function () : void
			{
				screen.x = 0;
				screen.visible = false;
				
				_menuItems.visible = true;
				_logo.visible = true;
				number.text.visible = true;
				_onOff1.visible = false;
				_onOff2.visible = false;
			}});
			TweenLite.from(_menuItems, 0.5, { delay: 0.75,  y : -500, ease : Back.easeOut, onComplete : function () : void
			{
				_cursor.visible = true;
			}} );
			TweenLite.from(_logo, 0.5, {delay: 0.5,  y : -500, ease : Back.easeOut } );
			TweenLite.from(number.text, 0.5, { delay: 0.5,  y : -500, ease : Back.easeOut } );
			
			if (screen == _optionsG)
			{
				TweenLite.to (_onOff1, 0.5, {x : -784, ease : Back.easeIn});
				TweenLite.to (_onOff2, 0.5, {x : -544, ease : Back.easeIn});
			}
		}
		
		private function enterOptionScreen (screen : FlxSprite) : void
		{
			var initMenuY : Number = _menuItems.y;
			var initLogoY : Number = _logo.y;
			var initNumberY : Number = number.text.y;
			
			_cursor.visible = false;
			
			TweenLite.from (screen, 0.5, { delay: 0.75, x : -1024, ease : Back.easeOut, onComplete : function () : void
			{
				_cursor.visible = true;
			}});
			TweenLite.to(_menuItems, 0.5, {delay: 0.25, y : -300, ease : Back.easeIn, onComplete : function () : void
			{
				_menuItems.y = initMenuY;
				_menuItems.visible = false;
				screen.visible = true;
			}});
			TweenLite.to(_logo, 0.5, { y : -500, ease : Back.easeIn , onComplete : function () : void
			{
				_logo.y = initLogoY;
				_logo.visible = false;
			}});
			TweenLite.to (number.text, 0.5, { y : -500, ease : Back.easeIn , onComplete : function () : void
			{
				number.text.y = initNumberY;
				number.text.visible = false;
			}});
			
			if (screen == _optionsG)
			{
				_onOff1.visible = true;
				_onOff2.visible = true;
				if (FlxG.mute)
					_onOff1.play ("OFF");
				else
					_onOff1.play ("ON");
				if (Jogo._bParticles)
					_onOff2.play ("ON");
				else
					_onOff2.play ("OFF");
				
				TweenLite.from (_onOff1, 0.5, { delay: 0.75, x : -784, ease : Back.easeOut});
				TweenLite.from (_onOff2, 0.5, { delay: 0.75, x : -544, ease : Back.easeOut } );
			}
		}
		
		override public function draw():void 
		{		
			super.draw();
		}
		
	}

}