/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Does a simple replace, fucking AS2!
	@last-update:	25/11/2008 10:58
*/

import com.tangozebra.utils.TZTrace

class com.tangozebra.string.TZReplace {
	
	public static var NAME:String								= 'TZReplace';
	
	public static function replace(str:String,find:String,replace:String):String
	{
		return str.split(find).join(replace);
	}
}