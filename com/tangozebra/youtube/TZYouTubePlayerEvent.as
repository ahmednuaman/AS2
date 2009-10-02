/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Holds YT Player events
	@last-update:	13/11/2008 09:24
*/

import org.asapframework.events.Event;

class com.tangozebra.youtube.TZYouTubePlayerEvent extends Event
{
	public static var NAME:String								= 'TZYouTubePlayerEvent';
	
	public static var CONNECTED:String							= 'playerConnected';
	public static var READY:String								= 'playerReady';
	public static var STATE_CHANGED:String						= 'onStateChange';
	public static var ERROR:String								= 'onError';
	public static var PLAYER_PLAYING:String						= 'playerPlaying';
	public static var PLAYER_ENDED:String						= 'playerEnded';
	public static var PLAYER_PAUSED:String						= 'playerPaused';
	public static var PLAYER_QUEUED:String						= 'playerQueued';
	public static var PLAYER_BUFFERING:String					= 'playerBuffering';
	public static var PLAYER_NOT_STARTED:String					= 'playerNotStarted';
	
	public var type:String;
	public var data:Object;
	public var source:Object;
	
	public function TZYouTubePlayerEvent(type:String,data:Object,source:Object)
	{
		super(NAME,source);
		
		this.type = type;
		this.data = data;
		this.source = source;
	}
}