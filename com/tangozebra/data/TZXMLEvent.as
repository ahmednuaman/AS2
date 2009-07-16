/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	XML Helper's events
	@last-update:	14/11/2008 14:28
*/

import org.asapframework.events.Event;

class com.tangozebra.data.TZXMLEvent extends Event
{
	public static var NAME:String								= 'TZXMLEvent';
	
	public static var CREATE:String								= 'onCreate';
	public static var COMPLETE:String							= 'onComplete';
	public static var ERROR:String								= 'onError';
	
	public var type:String;
	public var data:Object;
	public var source:Object;
	
	public function TZXMLEvent(type:String,data:Object,source:Object)
	{
		super(NAME,source);
		
		this.type = type;
		this.data = data;
		this.source = source;
	}
}