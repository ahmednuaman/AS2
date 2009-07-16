/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Creates a tab style navigation that feeds off XML
	@last-update:	19/11/2008 12:14
*/

import com.tangozebra.font.Arial;
import com.tangozebra.utils.TZTrace;

import mx.utils.Delegate;

class com.tangozebra.display.TZNavTabs
{
	public static var NAME:String								= 'TZNavTabs';

	public static var ROUND_TOP:String							= 'roundTop';
	public static var ROUND_BOTTOM:String						= 'roundBottom';
	public static var ROUND_TOPLEFT:String						= 'roundTopLeft';
	public static var ROUND_TOPRIGHT:String						= 'roundTopRight';
	public static var ROUND_BOTTOMLEFT:String					= 'roundBottomLeft';
	public static var ROUND_BOTTOMRIGHT:String					= 'roundBottomRight';
	public static var ROUND_LEFT:String							= 'roundLeft';	
	public static var ROUND_RIGHT:String						= 'roundRight';
	public static var ROUND_ALL:String							= 'roundAll';
	public static var ROUND_NONE:String							= 'roundNone';
	
	public var tabWidth:Number									= 150;
	public var tabHeight:Number									= 40;
	public var corners:String								 	= ROUND_TOP;
	public var cornerRadius:Number								= 10;
	public var bgColor:Number									= 0xFFFFFF;
	public var borderThickness:Number							= 0;
	public var borderColor:Number								= 0xDDDDDD;
	public var align:Number										= 0.5;
	public var fontName:String									= 'Arial';
	public var fontSize:Number									= 10;
	public var fontColor:Number									= 0x999999;
	public var fontBold:Boolean								 	= true;
	public var overAlpha:Number									= 100;
	public var overBgColor:Number								= 0x999999;
	public var overFontColor:Number								= 0xFFFFFF;
	public var downBgColor:Number								= 0x666666;
	public var downFontColor:Number								= 0xCCCCCC;
	
	public var textFormat:TextFormat;
	
	private var parent:MovieClip;
	
	public function TZNavTabs(parent:MovieClip)
	{
		TZTrace.info(NAME + ' created');
		
		this.parent = parent;
	}
	
	public function init(data:Object,clickFunction:Function):Void
	{
		var tabsContainer:MovieClip = parent.createEmptyMovieClip(NAME + 'Container' + (new Date().getTime()),parent.getNextHighestDepth());
		var tabsXML:Array = data.tabs.tab;
		var tabTextFormat:TextFormat = new TextFormat();
		var tab:MovieClip;
		var tabBg:MovieClip;
		var tabBgUp:MovieClip;
		var tabBgOver:MovieClip;
		var tabBgDown:MovieClip;
		var tabText:TextField;
		var firstTab:MovieClip;
		
		TZTrace.info(NAME + ' creating tabs');
		
		tabTextFormat.color = fontColor;
		tabTextFormat.align = 'center';
		tabTextFormat.font = fontName;
		tabTextFormat.size = fontSize;
		tabTextFormat.bold = fontBold;
		
		for (var i:Number = 0; i < tabsXML.length; i++)
		{
			TZTrace.info(NAME + ' creating tab ' + i);
			
			tab = tabsContainer.createEmptyMovieClip('tab' + i,tabsContainer.getNextHighestDepth());
			tabBg = tab.createEmptyMovieClip('bg',tab.getNextHighestDepth());
			tabBgDown = createTabBox(tabBg,'down',downBgColor);
			tabBgOver = createTabBox(tabBg,'over',overBgColor);
			tabBgUp = createTabBox(tabBg,'up',bgColor);
			tabText = tab.createTextField('text',tab.getNextHighestDepth(),0,(tab._height / 2) - (fontSize / 1.5),tab._width,fontSize * 2);
			
			tabText.text = tabsXML[i].name.data.toString();
			tabText.selectable = false;
			tabText.embedFonts = true;
			tabText.setTextFormat(tabTextFormat);
			
			tab._x = (tabWidth + borderThickness) * i ; // Padd for border
			tab.scope = this;
			
			if (tabsXML[i].href.data)
			{
				tab.linkTo = tabsXML[i].href.data;
				tab.onPress = function():Void
				{
					getURL(this.linkTo);
				}
			}
			
			if (tabsXML[i].array.item)
			{ 
				tab.array = tabsXML[i].array.item;
				tab.clickFunction = Delegate.create(this,clickFunction);
				tab.onPress = function():Void
				{	
					this.clickFunction(this.array);
				}
			}
			
			applyStates(tab);
		}
		
		firstTab = tabsContainer.getInstanceAtDepth(0);
		
		tabDown(firstTab);
		
		firstTab.onPress();		
	}
	
	private function createTabBox(tab:MovieClip,name:String,color:Number):MovieClip
	{
		var tabBg:MovieClip;
		
		tabBg = tab.createEmptyMovieClip(name,tab.getNextHighestDepth());
		
		tabBg.beginFill(color);
		
		if (borderThickness > 0)
		{
			tabBg.lineStyle(borderThickness,borderColor,100,true,'none','round','round');
		}
		tabBg.moveTo(0,0);			
		
		if (corners == ROUND_TOP || corners == ROUND_TOPLEFT || corners == ROUND_LEFT || corners == ROUND_ALL)
		{
			tabBg.moveTo(0,cornerRadius);
			tabBg.curveTo(0,0,cornerRadius,0);
		}
		
		tabBg.lineTo(tabWidth - cornerRadius,0);
		
		if (corners == ROUND_TOP || corners == ROUND_TOPRIGHT || corners == ROUND_RIGHT || corners == ROUND_ALL)
		{
			tabBg.curveTo(tabWidth,0,tabWidth,cornerRadius);
		}
		else if (cornerRadius > 0)
		{
			tabBg.lineTo(tabWidth,0);
		}
		
		tabBg.lineTo(tabWidth,tabHeight - cornerRadius);
		
		if (corners == ROUND_BOTTOM || corners == ROUND_BOTTOMRIGHT || corners == ROUND_RIGHT || corners == ROUND_ALL)
		{
			tabBg.curveTo(tabWidth,tabHeight,tabWidth - cornerRadius,tabHeight);
		}
		else if (cornerRadius > 0)
		{
			tabBg.lineTo(tabWidth,tabHeight);
		}
		
		tabBg.lineTo(cornerRadius,tabHeight);
		
		if (corners == ROUND_BOTTOM || corners == ROUND_BOTTOMLEFT || corners == ROUND_LEFT || corners == ROUND_ALL)
		{
			tabBg.curveTo(0,tabHeight,0,tabHeight - cornerRadius);
		}
		else if (cornerRadius > 0)
		{
			tabBg.lineTo(0,tabHeight);
		}
		
		tabBg.endFill();
		
		return tabBg;
	}
	
	private function applyStates(tab:MovieClip):Void
	{
		tab.onRollOver = function():Void
		{
			this.scope.tabOver(this);
		}

		tab.onRollOut = function():Void
		{
			this.scope.tabOut(this);
		}
		
		tab.onRelease = function():Void
		{
			this.scope.tabDown(this);					
		}
	}
	
	private function removeStates(tab:MovieClip):Void
	{
		delete(tab.onRollOver);
		delete(tab.onRollOut);
		delete(tab.onRelease);
	}
	
	private function tabOver(tab:MovieClip):Void
	{
		tab.text.textColor = overFontColor;
		
		tab.bg._alpha = overAlpha;
		tab.bg.over.swapDepths(tab.bg.getNextHighestDepth());
	}

	private function tabOut(tab:MovieClip):Void
	{
		tab.text.textColor = fontColor;
		
		tab.bg._alpha = 100;
		tab.bg.up.swapDepths(tab.bg.getNextHighestDepth());
	}
	
	private function tabDown(tab:MovieClip):Void
	{ 
		var totalTabs:Number = tab._parent.getNextHighestDepth();
		var qTab:MovieClip;
		
		for (var i:Number = 0; i < totalTabs/*tabs.length*/; i++)
		{
			qTab = tab._parent.getInstanceAtDepth(i);
			
			if (tab == qTab)
			{ 
				tab.text.textColor = downFontColor;
				
				tab.bg.down.swapDepths(tab.bg.getNextHighestDepth());
				
				removeStates(tab);
			}
			else
			{
				qTab.text.textColor = fontColor;
				
				qTab.bg.up.swapDepths(qTab.bg.getNextHighestDepth());
				
				applyStates(qTab);
			}
		}
	}
}