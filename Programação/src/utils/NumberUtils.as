package utils
{
	//Author Josh Spoon
	public class NumberUtils
	{
		public function NumberUtils(){}
 
		public static function romanize(num:int):String {
			var numerals:Array = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X",
										"IX", "V", "IV", "I"];
 
			var numbers:Array  = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
 
			var lookup:Object = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1}
 
			var roman:String = "";
 
			var i:int;
 
			  for( i = 0; i < numbers.length; i++)
			  {
				while(num >= numbers[i])
				{
					roman += numerals[i];
					num -= numbers[i];
				}
			  }
			  return roman;
			}
 
		public static function deromanize( roman:String ):int {
 
			var numerals:Array = ["I", "V", "X", "L", "C", "D", "M"];
 
			var numbers:Array  = [1, 5, 10, 50, 100, 500, 1000];
 
			var roman:String = roman.toUpperCase();
 
			var arabic:int = 0;
 
			var i:int = roman.length;
 
		    var compare1:int;
			var compare2:int;
 
			while (i--) {
 
		  	var letter:String;
	  		var listLetter:String;
 
		  	for (var j:int = 0; j <= numerals.length - 1; j++)
		  	{
		  		letter = roman.charAt(i);
		  		listLetter = numerals[j];
		  		if(listLetter == letter)
		  		{
		  			compare1 = numbers[j];
		  		}
		  	}
 
		  	for (j = 0; j <= numerals.length - 1; j++)
		  	{
		  		letter = roman.charAt(i + 1);
		  		listLetter = numerals[j];
		  		if(listLetter == letter)
		  		{
		  			compare2 = numbers[j];
		  		}
		  	}
 
		    if (compare1 < compare2 )
		      arabic -= compare1;
		    else
		      arabic += compare1;
		  }
		  return arabic;
		}
 
	}

}