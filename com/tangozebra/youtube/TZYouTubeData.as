/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Handles any data requests to YT
	@last-update:	18/11/2008 15:22
*/

import com.tangozebra.data.TZXML;
import com.tangozebra.data.TZXMLEvent;
import com.tangozebra.utils.TZTrace;

import mx.utils.Delegate;

class com.tangozebra.youtube.TZYouTubeData
{
	public static var NAME:String								= 'TZYouTubeData';
	
	private var resultFunction:Function;
	private var errorFunction:Function;
	private var optParams:Object;
	private var tzXML:TZXML;
	
	
	public function TZYouTubeData()
	{
		TZTrace.info(NAME + ' created');
	}
	
	public function init(url:String,resultFunction:Function,errorFunction:Function,optParams:Object):Void
	{
		tzXML = new TZXML();
		
		this.resultFunction = resultFunction;
		this.errorFunction = errorFunction;
		this.optParams = optParams;
		
		tzXML.addEventListener(TZXMLEvent.COMPLETE,Delegate.create(this,handleResult));
		tzXML.addEventListener(TZXMLEvent.ERROR,Delegate.create(this,handleError));
		
		tzXML.init(url);
	}

	private function handleResult(e:TZXMLEvent):Void
	{
		TZTrace.info(NAME + ' result event');
		
		removeListeners();
		
		resultFunction(e.data,optParams);
	}
	
	private function handleError(e:TZXMLEvent):Void
	{
		TZTrace.info(NAME + ' error event');
		
		removeListeners();
		
		errorFunction();
	}
	
	private function removeListeners():Void
	{ 
		tzXML.removeEventListener(TZXMLEvent.COMPLETE,Delegate.create(this,handleResult));
		tzXML.removeEventListener(TZXMLEvent.ERROR,Delegate.create(this,handleError));		
	}
}