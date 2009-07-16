/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Randomises an array!
	@last-update:	25/11/2008 10:58
*/

import com.tangozebra.utils.TZTrace

class com.tangozebra.array.TZRandomise {
	
	public static var NAME:String								= 'TZRandomise';
	
	public static function randomise(array:Array):Array
	{
		var i:Number = array.length;
		var j:Number;
		var t1;
		var t2;
		
		if (i == 0)
		{
			return [ ];
		}
		else
		{
			while (--i)
			{
				j = Math.floor(Math.random() * (i + 1));
				
				t1 = array[i];
				t2 = array[j];
				
				array[i] = t2;
				array[j] = t1;
			}
			
			return array;
		}
	}
}