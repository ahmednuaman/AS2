/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Helper class for handling XML
	@last-update:	12/11/2008 16:13
*/

import com.tangozebra.data.TZXMLEvent;
import com.tangozebra.utils.TZTrace;

import org.asapframework.data.loader.DataLoader;
import org.asapframework.data.loader.DataLoaderEvent;
import org.asapframework.data.loader.URLData;
import org.asapframework.events.Dispatcher;
import org.asapframework.events.Event;
import org.asapframework.events.EventDelegate;

import mx.events.EventDispatcher;
import mx.data.binding.ObjectDumper;

class com.tangozebra.data.TZXML extends Dispatcher
{
	public static var NAME:String								= 'TZXML';
	
	private var handleEventDelegate:Function;
	
	public var data:Object;
	
	private var dataLoader:DataLoader;
	
	public function TZXML()
	{
		TZTrace.info(NAME + ' created');
		
		EventDispatcher.initialize(this);
		
		dataLoader = DataLoader.getInstance();
	}
	
	public function init(url:String):Void
	{
		var name:String = NAME + 'Request' + (new Date().getTime());
		var urlData:URLData = new URLData(name,url);
		
		TZTrace.info(NAME + ' loading XML request ' + name + ' to ' + url);
		
		handleEventDelegate = EventDelegate.create(this,handleLoaderEvent);
		
		dataLoader.addLoaderListener(handleEventDelegate);
		
		dispatchEvent(new TZXMLEvent(TZXMLEvent.CREATE,null,this));
		
		dataLoader.loadXML(urlData);
	}
	
	private function handleLoaderEvent(e:DataLoaderEvent):Void
	{
		TZTrace.info(NAME + ' handling loader event ' + e.name);
		
		switch (e.type)
		{
			case DataLoaderEvent.EVENT_DATALOADER:
			handleResult(e);
			
			break;
			
			case DataLoaderEvent.ERROR:
			handleError(e);
			
			break;
		}
		
		dataLoader.removeLoaderListener(handleEventDelegate);
	}
	
	private function handleResult(e:DataLoaderEvent):Void
	{
		TZTrace.info(NAME + ' handling result event');
		
		this.data = e.data;
		
		dispatchEvent(new TZXMLEvent(TZXMLEvent.COMPLETE,e.data,this));
	}
	
	private function handleError(e:DataLoaderEvent):Void
	{
		TZTrace.info(NAME + ' handling error event');
		TZTrace.dump(e);
		
		this.data = { };
		
		dispatchEvent(new TZXMLEvent(TZXMLEvent.ERROR,this.data,this));
	}
}