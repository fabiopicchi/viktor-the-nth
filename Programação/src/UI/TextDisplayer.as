package UI
{
	import assets.Assets;
	import levelLoader.ITmxObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author 
	 */
	
	//Simple class to control fade-in and fade-out of text blocks
	
	public class TextDisplayer extends FlxGroup implements ITmxObject
	{
		// Array of pages containing arrays of text blocks
		private var arTexts : Array;
		private var arTiming : Array;
		
		private var timeElapsed : Number;
		private var _bStarted : Boolean = false;
		private var _bEndAnimation : Boolean = false;
		
		private var blockIndex : int = 0;
		private var pageIndex : int = 0;
		private var numBlocks : int = 0;
		private var numPages : int = 0;
		
		private var textSeparator : RegExp = /\/breakline=(\d+)/;
		private var pageSeparator : RegExp = /\/breakpage)/;
		
		// Array of elements to fade out or to fade in
		private var arFadeOut : Array = [];
		private var arFadeIn : Array = [];
		
		public function TextDisplayer()
		{
			
		}
		
		public function startAnimation () : void
		{
			_bStarted = true;
			timeElapsed = 0;
			arFadeIn.push (arTexts[pageIndex][blockIndex]);
			add (arTexts[pageIndex][blockIndex]);
			arTexts[pageIndex][blockIndex].scrollFactor = new FlxPoint (0, 0);
			arTexts[pageIndex][blockIndex].alpha = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			var i : int = 0;
			if (_bStarted && !_bEndAnimation && !arFadeOut.length)
			{
				timeElapsed += FlxG.elapsed;
				if (arTiming[pageIndex][blockIndex] < timeElapsed)
				{
					if (++blockIndex >= numBlocks)
					{
						blockIndex = 0;
						if (++pageIndex < numPages)
						{
							numBlocks = arTexts[pageIndex].length;
						}
						else
						{
							_bEndAnimation = true;
						}
						for (i = 0; i < members.length; i++)
						{
							arFadeOut.push(members[i]);
						}
					}
					if (!_bEndAnimation)
					{
						arFadeIn.push (arTexts[pageIndex][blockIndex]);
						add (arTexts[pageIndex][blockIndex]);
						arTexts[pageIndex][blockIndex].scrollFactor = new FlxPoint (0, 0);
						arTexts[pageIndex][blockIndex].alpha = 0;
						timeElapsed = 0;
					}
				}
			}
			
			var arRemoved : Array = [];
			var removed : FlxText;
			if (!arFadeOut.length)
			{
				for each (var fadeInText : FlxText in arFadeIn)
				{
					if (fadeInText.alpha < 0.99)
					{
						fadeInText.alpha = fadeInText.alpha + (1 - fadeInText.alpha) * 0.05;
					}
					else 
					{
						arRemoved.push (fadeInText);
						fadeInText.alpha = 1.0;
					}
				}
			}
			
			for each (removed in arRemoved)
			{
				arFadeIn.splice (arFadeIn.indexOf (removed), 1);
			}
			
			arRemoved = [];
			for each (var fadeOutText : FlxText in arFadeOut)
			{
				if (fadeOutText.alpha > 0.01)
				{
					fadeOutText.alpha = fadeOutText.alpha + (0.0 - fadeOutText.alpha) * 0.05;
				}
				else 
				{
					if (members.indexOf(fadeOutText) != -1) remove (fadeOutText, true);
					fadeOutText.alpha = 0.0;
					arRemoved.push (fadeOutText);
				}
			}
			
			for each (removed in arRemoved)
			{
				arFadeOut.splice (arFadeOut.indexOf (removed), 1);
			}
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
		/* INTERFACE config.ITmxObject */
		
		public function setup(objData:Object):void 
		{
			var text : String = Assets.getText(objData.name);
			var arPages : Array = text.split(pageSeparator);
			var arSplitText : Array = [];
			var arBlocks : Array = [];
			var arTimers : Array = [];
			var flxText : FlxText;
			var accHeight : Number = 0;
			
			arTexts = [];
			arTiming = [];
			
			for (var i : int = 0; i < arPages.length; i++)
			{
				arSplitText = arPages[i].split(textSeparator);
				accHeight = 0;
				arBlocks = [];
				arTimers = [];
				for (var j : int = 0; j < arSplitText.length - 1; j++)
				{
					if (j % 2 == 0)
					{
						flxText = new FlxText (int (objData.x), int (objData.y) + accHeight, objData.width);
						flxText.font = objData.font;
						flxText.size = objData.size;
						flxText.color = objData.color;
						flxText.alignment = objData.alignment;
						
						var tmpString : String;
						do 
						{
							tmpString = arSplitText[j];
							arSplitText[j] = (arSplitText[j] as String).replace('\r' + '\n', "\n");
						}
						while (tmpString != arSplitText[j]);
						
						flxText.text = arSplitText[j];
						accHeight += flxText.height;
						arBlocks.push(flxText);
					}
					else
					{
						arTimers.push(Number(arSplitText[j]));
					}
				}
				this.arTexts.push (arBlocks);
				this.arTiming.push (arTimers);
			}
			
			numPages = arTexts.length;
			numBlocks = arTexts[0].length;
			blockIndex = 0;
			pageIndex = 0;
		}
		
		public function get bStarted():Boolean 
		{
			return _bStarted;
		}
		
		public function get bEndAnimation():Boolean 
		{
			return _bEndAnimation;
		}
	}

}