/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Creates a rectangle, woop.
	@last-update:	21/11/2008 12:31
*/

import com.tangozebra.utils.TZTrace;

class com.tangozebra.display.TZDrawRect
{
	public static var NAME:String								= 'TZDrawRect';
	
	public static function create(mc:MovieClip,rectColor:Number,rectAlpha:Number,rectWidth:Number,rectHeight:Number):MovieClip
	{
		with (mc)
		{
			beginFill(rectColor,rectAlpha);
			moveTo(0,0);
			lineTo(rectWidth,0);
			lineTo(rectWidth,rectHeight);
			lineTo(0,rectHeight);
			lineTo(0,0);
			endFill();
		}
		
		return mc;
	}
}