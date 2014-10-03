package UI
{
	import levelLoader.ITmxObject;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author 
	 */
	public class UIText extends FlxGroup implements ITmxObject
	{
		private var _id : String;
		private var _text : FlxText;
		private var _fieldName : String;
		
		public function UIText() 
		{
		}
		
		public function setup (objData : Object) : void
		{
			_text = new FlxText (objData.x, objData.y, objData.width);
			this._fieldName = objData.name;
			add (_text);
			
			_text.font = "VIKING";
			_text.size = 80;
			_text.alignment = "center";
			_text.color = 0xbb824b;
			
			this._id = objData.name;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get text():FlxText 
		{
			return _text;
		}
		
		public function get fieldName():String 
		{
			return _fieldName;
		}
		
	}

}