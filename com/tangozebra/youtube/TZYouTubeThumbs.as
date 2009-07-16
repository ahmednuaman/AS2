/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Handles YT video thumbs for you to be used in such stuff as grids or carosels
	@last-update:	12/11/2008 17:46
	@usage:			var tzImageObj:TZObjImage = new TZObjImage();
					tzImageObj.create(parent,'ytVideoId',100,100,true,true);
*/

import com.tangozebra.utils.TZTrace;

import gs.TweenLite;
import gs.easing.Expo;

class com.tangozebra.youtube.TZYouTubeThumbs 
{
	public static var NAME:String								= 'TZYouTubeThumbs';
	
	public function create(parent:MovieClip,id:String,maskWidth:Number,maskHeight:Number,resize:Boolean,preserveAspectRation:Boolean,hq:Boolean):MovieClip
	{
		var thumb:MovieClip = parent.createEmptyMovieClip(NAME + 'Thumb' + (new Date().getTime()) + parent.getNextHighestDepth(),parent.getNextHighestDepth());
		var container:MovieClip = thumb.createEmptyMovieClip(NAME + 'Container' + (new Date().getTime()) + thumb.getNextHighestDepth(),thumb.getNextHighestDepth());
		var inner:MovieClip = container.createEmptyMovieClip(NAME + 'Inner' + (new Date().getTime()) + container.getNextHighestDepth(),container.getNextHighestDepth());
		var mask:MovieClip = thumb.createEmptyMovieClip(NAME + 'Mask' + (new Date().getTime()) + thumb.getNextHighestDepth(),thumb.getNextHighestDepth());
		var url:String = 'http://i.ytimg.com/vi/' + id + '/' + (hq ? 'hq' : '') + 'default.jpg';
		var loader:MovieClipLoader = new MovieClipLoader();
		var listener:Object;
		
		TZTrace.info(NAME + ' loading thumb ' + url);
		
		listener = { 
			onLoadInit: function (mc:MovieClip):Void { 				
				container.setMask(mask); 
				
				TweenLite.from(container,1,{ _alpha: 0, ease: Expo.easeOut });
				
				if (resize)
				{
					inner._width = maskWidth;
					inner._height = (preserveAspectRation ? (maskWidth / inner._width) * maskHeight : maskHeight);
				}
			} 
		};
		
		with (mask)
		{
			beginFill(0x000000,0);
			moveTo(0,0);
			lineTo(maskWidth,0);
			lineTo(maskWidth,maskHeight);
			lineTo(0,maskHeight);
			lineTo(0,0);
			endFill();
		}
		
		loader.addListener(listener);
		
		loader.loadClip(url,inner);
		
		return thumb;
	}
}