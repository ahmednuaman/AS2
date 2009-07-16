/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Creates an image obj.
	@last-update:	18/11/2008 15:06
*/

import com.tangozebra.utils.TZTrace;
import com.tangozebra.youtube.TZYouTubePlayer;

class com.tangozebra.display.TZObjImages
{
	public static var NAME:String								= 'TZObjImages';
	
	public var imageSourceArray:Array							= [ ];
	
	public var imageFunction:Function;
	public var noImageFunction:Function;
	public var player:TZYouTubePlayer;
	
	public function create(parent:MovieClip,size:Number):MovieClip
	{
		var obj:MovieClip = noImageFunction(parent,size);
		var images:Number = imageSourceArray.length;
		var image:String = (images > 0 ? imageSourceArray[images - 1] : null);
		
		if (image)
		{
			imageFunction(obj,image,size,size,true,true);
			
			obj.player = player;
			obj.video = image;
			obj.onRelease = function():Void
			{
				player.init(this.video);
			}
			
			imageSourceArray.pop();
		}
		
		return obj;
	}
}