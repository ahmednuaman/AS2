/*
@author:		Ahmed Nuaman (ahmedn@google.com)
@date:			2009-01-26
@usage:			This is how you use it
*/

import com.tangozebra.utils.TZTrace;

class com.tangozebra.utils.TZMovieClipUtil
{
	static var NAME:String										= 'MovieClipUtil';

	public static function removeChildren(mc:MovieClip):Void
	{
		var children:Number = mc.getNextHighestDepth();
		
		if (children > 0)
		{
			TZTrace.info(NAME + ' removing ' + children + ' children from ' + mc);
			
			for (var i:Number = 0; i < children; i++)
			{
				removeMovieClip(mc.getInstanceAtDepth(i));
			}
		}
	}
}

/* End of file MovieClipUtil.as */
/* Location: ./Users/ahmedn/Sites/__Useful Stuff/Flash/AS2/com/tangozebra/utils/MovieClipUtil.as */