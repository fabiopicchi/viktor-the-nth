package UI
{
	import levelLoader.ITmxObject;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author 
	 */
	public class UIButton extends FlxObject implements ITmxObject
	{
		private var _id : String;
		
		
		public function UIButton() 
		{
			
		}
		
		public function setup (objData : Object) : void
		{
			this.x = objData.x;
			this.y = objData.y;
			this.width = objData.width;
			this.height = objData.height;
			this._id = objData.name;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
	}

}