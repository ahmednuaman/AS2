/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Creates a grid of movieclips
	@last-update:	22/01/09 16:24
*/

import com.tangozebra.utils.TZTrace

class com.tangozebra.display.TZGrid
{
	public static var NAME:String								= 'TZGrid';
	
	public var maxWidth:Number									= 400;
	public var maxHeight:Number									= 800;
	public var randomiseOffset:Boolean							= true;

	public var rowHeight:Number;
	
	public function TZGrid()
	{
		TZTrace.info(NAME + ' created');
	}
	
	public function init(mcs:Array,randomXOffset:Number,randomYOffset:Number):Void
	{
		var newMc:MovieClip;
		var prevMc:MovieClip;
		var xOffset:Number;
		var yOffset:Number;
		
		TZTrace.info(NAME + ' building grid for ' + mcs.length + ' items');
		
		for (var i:Number = 0; i < mcs.length; i++)
		{
			newMc = mcs[i];
			xOffset = (randomXOffset ? randomXOffset * (randomiseOffset ? Math.random() : 1) : 0);
			yOffset = (randomYOffset ? randomYOffset * (randomiseOffset ? Math.random() : 1) : 0);
			
			if (prevMc)
			{
				if (prevMc._x + (prevMc._width * 2) <= maxWidth)
				{
					// Current row
					newMc._x = prevMc._x + prevMc._width + xOffset;
					newMc._y = prevMc._y;
				}
				else
				{
					// New row
					newMc._x = 0;
					newMc._y = prevMc._y + (rowHeight ? rowHeight : prevMc._height) + yOffset;
				}
			}
			else
			{
				// First one!
				newMc._x = 0;
				newMc._y = 0;
			}
			
			//TZTrace.info(NAME + ' aligned clip (' + newMc._x + ',' + newMc._y + ')');
			
			prevMc = newMc;
		}
	}
}