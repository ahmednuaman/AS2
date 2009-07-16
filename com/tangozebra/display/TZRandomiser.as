/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Creates an random appearing grid of images
	@last-update:	19/11/2008 15:09
*/

import com.tangozebra.utils.TZTrace;

import gs.TweenLite;
import gs.easing.Expo;

class com.tangozebra.display.TZRandomiser
{
	public static var NAME:String								= 'TZRandomiser';
	
	public var maxWidth:Number									= 400;
	public var maxHeight:Number									= 800;
	public var minMcSize:Number									= 10;
	public var maxMcSize:Number									= 50;
	public var stageAlignPointX:Number							= 0.5;
	public var stageAlignPointY:Number							= 0.5;
	public var minRadius:Number									= 100;
	public var maxRadius:Number									= 200;
	public var idealDistDom:Number								= 0.5;
	public var accuracy:Number									= 150;
	public var appearTime:Number								= 2;
	
	private var counter:Number									= 0;
	
	public function TZRandomiser()
	{
		TZTrace.info(NAME + ' created');
	}
	
	public function init(mcs:Array,parent:MovieClip,creationFunction:Function):Void
	{
		var totalMcs:Number = mcs.length;
		var newMcs:Array = [ ];
		
		parent.scope = this;
		parent.onEnterFrame = function():Void {
			var maxWidth:Number = this.scope.maxWidth;
			var maxHeight:Number = this.scope.maxHeight;
			var stageAlignPointX:Number = this.scope.stageAlignPointX;
			var stageAlignPointY:Number = this.scope.stageAlignPointY;
			var minRadius:Number = this.scope.minRadius;
			var maxRadius:Number = this.scope.maxRadius;
			var idealDistDom:Number = this.scope.idealDistDom;
			var appearTime:Number = this.scope.appearTime;
			var newMc:MovieClip;
			var mc1:MovieClip;
			var mc2:MovieClip;
			var idealXDist:Number;
			var idealYDist:Number;
			var idealDist:Number;
			var diffX:Number;
			var diffY:Number;
			var diffDist:Number;
			
			TZTrace.info(NAME + ' running onEnterFrame ' + newMcs.length + ' ' + mcs.length);
			
			if (newMcs.length < mcs.length)
			{
				newMc = creationFunction(this,this.scope.maxMcSize);
				newMc._width = newMc._height = this.scope.minMcSize + (Math.random() * newMc._width);
				newMc._x = (maxWidth * stageAlignPointX) - minRadius + (maxRadius * Math.random());
				newMc._y = (maxHeight * stageAlignPointY) - minRadius + (maxRadius * Math.random());
				
				newMcs.push(newMc);
				
				//TweenLite.from(newMc,appearTime,{ _alpha: 0, ease: Expo.easeOut });
			}
			
			for (var i:Number = 0; i < newMcs.length; i++)
			{
				mc1 = newMcs[i];
				
				for (var j:Number = i + 1; j < newMcs.length; j++) 
				{
					mc2 = newMcs[j];
					
					idealXDist = (mc1._width * idealDistDom) + (mc2._width * idealDistDom);
					idealYDist = (mc1._height * idealDistDom) + (mc2._height * idealDistDom);
					idealDist = Math.sqrt(Math.pow(idealXDist,2) + Math.pow(idealYDist,2));
					diffX = mc1._x - mc2._x;
					diffY = mc1._y - mc2._y;
					diffDist = Math.sqrt(Math.pow(diffX,2) + Math.pow(diffY,2));
					
					if (diffDist < idealDist) {
						mc2._x += idealDistDom * (diffDist - idealDist) * diffX / diffDist;
						mc1._x -= idealDistDom * (diffDist - idealDist) * diffX / diffDist;
						mc2._y += idealDistDom * (diffDist - idealDist) * diffY / diffDist;
						mc1._y -= idealDistDom * (diffDist - idealDist) * diffY / diffDist;
					}
				}
				
				diffX = maxWidth * stageAlignPointX - mc1._x;
				diffY = maxHeight * stageAlignPointY - mc1._y;
				mc1._x += diffX * .001;
				mc1._y += diffY * .001;
				
				if (mc1._x /*- mc1._width * 0.5*/ < 0) {
					mc1._x = 0; //mc1._width * 0.5;
				}
				if (mc1._x + mc1._width /** 0.5*/ > maxWidth) {
					mc1._x = maxWidth - mc1._width; // * 0.5;
				}
				if (mc1._y /*- mc1._height * 0.5*/ < 0) {
					mc1._y = 0; //mc1._height * 0.5;
				}
				if (mc1._y + mc1._height /** 0.5*/ > maxHeight) {
					mc1._y = maxHeight - mc1._height; // * 0.5;
				}
			}
			
			if (this.scope.counter > this.scope.accuracy)
			{
				TZTrace.info(NAME + ' deleting onEnterFrame at ' + this.scope.counter);
				
				delete(this.onEnterFrame);
			}
			
			this.scope.counter++;
		};
	}
}