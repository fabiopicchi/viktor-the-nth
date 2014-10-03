package levelLoader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Fabio e Helo
	 */
	public class TmxLoader
	{
		private var tmxFile : XML;
		private var outPut : String = '';
		private var i : uint = 0;
		private var j : uint = 0;
		private var layerWidth : uint = 0;
		private var layerHeight : uint = 0;
		private var tileData : XMLList;
		
		public function TmxLoader(xmlObject : String) 
		{
			tmxFile = new XML (xmlObject);
		}
		
		public function get tileWidth () : uint
		{
			return tmxFile.child("tileset").@tilewidth;
		}
		
		public function get tileHeight () :uint
		{
			return tmxFile.child("tileset").@tileheight;
		}
		
		public function getLayerWidth (layer : String) : uint
		{
			for each (var obj : XML in tmxFile.child("layer"))
			{
				if (obj.@name == layer)
					return obj.@width;
			}
			
			return null;
		}
		
		public function getLayerHeight (layer : String) : uint
		{
			for each (var obj : XML in tmxFile.child("layer"))
			{
				if (obj.@name == layer)
					return obj.@height;
			}
			
			return null;
		}
		
		public function getCollisionMap (layer : String) : void
		{
			this.outPut = new String ();
			
			for each (var obj : XML in tmxFile.child("layer"))
			{
				if (obj.@name == layer)
				{
					this.layerWidth = getLayerWidth (layer);
					this.layerHeight = getLayerHeight (layer);
					this.tileData = obj.child ("data");
					this.i = 0;
					
					WriteToFile.getInstance().addEventListener (Event.ENTER_FRAME, readLine);
					break;
				}
			}
		}
		
		private function readLine(e:Event):void 
		{
			if (this.i < this.layerHeight)
			{
				for (var j : uint = 0; j < this.layerWidth; j++)
				{
					outPut += (tileData.child("tile")[(i * this.layerWidth) + j].@gid);
					if (j + 1 != this.layerWidth) outPut += ",";
				}
				if (i + 1 != this.layerHeight)
					outPut += "\n";
				this.i++;
			}
			else
			{
				var evt : MapReadEvent = new MapReadEvent (MapReadEvent.COMPLETE);
				evt.map = this.outPut;
				WriteToFile.getInstance().dispatchEvent(evt);
				WriteToFile.getInstance().removeEventListener (Event.ENTER_FRAME, readLine);
			}
		}
		
		public function getObject (objectGroup : String, objectType : String, autoIncrement : Boolean) : Array
		{
			var arReturn : Array = [];
			var object : Object;
			var inc : int = 0;
			
			for each (var obj : XML in tmxFile.child("objectgroup"))
			{
				if (obj.@name == objectGroup)
				{
					for each (var elem : XML in obj.child("object"))
					{
						if (elem.@type == objectType)
						{
							object = { };
							object["x"] = elem.@x;
							object["y"] = elem.@y;
							object["width"] = elem.@width;
							object["height"] = elem.@height;
							object["name"] = elem.@name;
							
							for each (var prop : XML in elem.child("properties").child("property"))
							{
								object[prop.@name] = prop.@value;
							}
							
							if (autoIncrement)
							{
								object["id"] = inc++;
							}
							
							arReturn.push(object);
						}
					}
				}
			}
			return arReturn;
		}
		
		public static function loadMap (arObjects : Array, map : TmxLoader) : Dictionary
		{
			var retDict : Dictionary = new Dictionary ();
			for each (var obj : Object in arObjects)
			{
				retDict[obj.id + "_" + obj.layer] = loadObjects (obj.type, obj.id, map, obj.layer, obj.autoIncrement);
			}
			return retDict;
		}
		
		private static function loadObjects (cl : Class, id : String, map : TmxLoader, layer : String, autoIncrement : Boolean) : Array
		{
			var object : ITmxObject;
			var retAr : Array = [];
			for each (var objData : Object in map.getObject (layer, id, autoIncrement))
			{
				object = new cl ();
				object.setup (objData);
				retAr.push (object);
			}
			return retAr;
		}
	}

}