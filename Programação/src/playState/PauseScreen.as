package playState
{
	import assets.Assets;
	import levelLoader.TmxLoader;
	import flash.utils.Dictionary;
	import levelLoader.TmxLoader;
	import menuState.MenuState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import UI.UIButton;
	/**
	 * ...
	 * @author 
	 */
	public class PauseScreen extends FlxGroup
	{
		public var _select:Class = SomSelect;
		
		private var _cursor : FlxSprite = new FlxSprite (218, 441, Assets.ARROW);
		private var _bg : FlxSprite = new FlxSprite (0, 0, Assets.PAUSE);
		
		private var _buttons : FlxGroup = new FlxGroup;
		private static const RESUME : String = "resume";
		private static const SOUND : String = "sound";
		private static const QUIT : String = "quit";
		private var _onOff : FlxSprite;
		
		private var _selectedObject : String = RESUME;
		
		private var _arObjects : Array = [{type : UIButton, id : "button", layer : "pause"}]
		
		public function PauseScreen() 
		{
			var objLoaded : Dictionary = TmxLoader.loadMap(_arObjects, Jogo.getInstance().UITmx);
			var i : int = 0;
			
			for (var id : String in objLoaded)
			{
				var layer : String = id.split("_")[1];
				switch (layer)
				{
					case "pause":
						for (i = 0; i < objLoaded[id].length; i++)
						{
							if (objLoaded[id][i] is UIButton)
							{
								_buttons.add (objLoaded[id][i]);
							}
						}
						break;
				}
			}
			
			add(_buttons);
			add(_bg);
			add(_cursor);
			
			_onOff = new FlxSprite (450, 356);
			_onOff.loadGraphic(Assets.ON_OFF, true, false, 77, 36);
			_onOff.scrollFactor = new FlxPoint(0, 0);
			_onOff.addAnimation ("ON", [0]);
			_onOff.addAnimation ("OFF", [1]);
			if (FlxG.mute)
				_onOff.play ("OFF");
			else
				_onOff.play ("ON");
			add(_onOff);
			
			for (i = 0; i < _buttons.length; i++)
			{
				_buttons.members[i].scrollFactor = new FlxPoint;
			}
			
			_bg.scrollFactor = new FlxPoint (0, 0);
			_cursor.scrollFactor = new FlxPoint (0, 0);
			
			select (RESUME);
		}
		
		override public function update():void 
		{
			if (PlayState._controls.wasConfirmPressed())
			{
				//_cursor.visible = false;
				FlxG.play (_select);
				if (_selectedObject == QUIT)
				{
					FlxG.paused = !FlxG.paused;
					Jogo.screenTransition(2, 0x000000, function (): void
					{
						PlayState.getInstance().saveGame();
						FlxG.switchState (new MenuState(true, true));
					}, null);
				}	
				else if (_selectedObject == SOUND)
				{
					FlxG.mute = !FlxG.mute;
					if (FlxG.mute)
						_onOff.play ("OFF");
					else
						_onOff.play ("ON");
					
				}
				else
				{
					FlxG.paused = !FlxG.paused;
				}
			}
			
			//Teclado
			if (((_selectedObject == QUIT && FlxG.keys.justPressed("DOWN"))
					|| (_selectedObject == SOUND && FlxG.keys.justPressed("UP"))))
			{
				select (RESUME);
			}
			else if (((_selectedObject == RESUME && FlxG.keys.justPressed("DOWN"))
					|| (_selectedObject == QUIT && FlxG.keys.justPressed("UP"))))
			{
				select (SOUND);
			}
			else if (((_selectedObject == SOUND && FlxG.keys.justPressed("DOWN"))
					|| (_selectedObject == RESUME && FlxG.keys.justPressed("UP"))))
			{
				select (QUIT);
			}
			
			super.update();
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
		private function select (id : String) : void
		{
			_cursor.visible = true;
			for each (var obj : Object in _buttons.members)
			{
				if (obj is UIButton && id == (obj as UIButton).id)
				{
					_cursor.x = obj.x - _cursor.width - 5;
					_cursor.y = obj.y + (obj.height - _cursor.height) / 2;
					_selectedObject = id;
				}
			}
		}
	}

}