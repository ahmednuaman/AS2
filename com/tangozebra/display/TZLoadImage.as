/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Loads images for you!
	@last-update:	25/11/2008 10:39
*/

import com.tangozebra.utils.TZTrace;

import gs.TweenLite;

class com.tangozebra.display.TZLoadImage
{
	public static var NAME:String								= 'TZLoadImage';
	
	public static var LEFT:String								= 'left';
	public static var RIGHT:String								= 'right';
	public static var CENTER:String								= 'center';
	public static var TOP:String								= 'top';
	public static var BOTTOM:String								= 'bottom';
	public static var MIDDLE:String								= 'middle';
	
	public function TZLoadImage()
	{
		TZTrace.info(NAME + ' created');
	}
	
	public function create(parent:MovieClip,url:String,maskWidth:Number,maskHeight:Number,resize:Boolean,preserveAspectRation:Boolean,alignX:String,alignY:String):MovieClip
	{
		var thumb:MovieClip = parent.createEmptyMovieClip(NAME + 'Thumb' + (new Date().getTime()),parent.getNextHighestDepth());
		var container:MovieClip = thumb.createEmptyMovieClip(NAME + 'Container' + (new Date().getTime()),thumb.getNextHighestDepth());
		var inner:MovieClip = container.createEmptyMovieClip(NAME + 'Inner' + (new Date().getTime()),container.getNextHighestDepth());
		var mask:MovieClip = thumb.createEmptyMovieClip(NAME + 'Mask' + (new Date().getTime()),thumb.getNextHighestDepth());
		var loader:MovieClipLoader = new MovieClipLoader();
		var listener:Object;
		
		TZTrace.info(NAME + ' loading image ' + url);
		
		listener = { 
			onLoadStart: function(mc:MovieClip):Void 
			{
				TZTrace.info(NAME + ' started loading ' + mc);
			},
			onLoadError: function(mc:MovieClip,code:String,status:Number):Void 
			{
				TZTrace.info(NAME + ' failed to load ' + mc + ' with code ' + code + ' and httpstatus ' + status);
			},
			onLoadInit: function(mc:MovieClip):Void 
			{ 				
				container.setMask(mask); 
				
				TweenLite.from(container,1,{ _alpha: 0 });
				
				if (resize)
				{
					mc._width = maskWidth;
					mc._height = (preserveAspectRation ? (maskWidth / mc._width) * maskHeight : maskHeight);
				}
				
				if (alignX)
				{
					switch (alignX)
					{
						case LEFT:
						mc._x = 0;
						
						break;
						
						case RIGHT:
						mc._x = mask._width - mc._width;
						
						break;
						
						case CENTER:
						mc._x = (mask._width / 2) - (mc._width / 2);
						
						break;
					}
				}
				
				if (alignY)
				{
					switch (alignY)
					{
						case TOP:
						mc._y = 0;
						
						break;
						
						case BOTTOM:
						mc._y = mask._height - mc._height;
						
						break;
						
						case MIDDLE:
						mc._y = (mask._height / 2) - (mc._width / 2);
						
						break;
					}
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