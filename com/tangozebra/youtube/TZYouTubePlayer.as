﻿/*
	@author:		Ahmed Nuaman (ahmedn@google.com)
	@description:	Handles the YT Player API to produce a chrome player for you (do I need to add chromeless?)
	@last-update:	12/11/2008 16:13
	@usage:			var mainVideo:MovieClip = stage.createEmptyMovieClip('mainVideo',stage.getNextHighestDepth());
					var tzYtPlayer:TZYouTubePlayer = new TZYouTubePlayer(mainVideo);
					tzYtPlayer.init(videoId);
*/

import com.tangozebra.string.TZReplace;
import com.tangozebra.utils.TZTrace;
import com.tangozebra.youtube.TZYouTubePlayerEvent;
import org.asapframework.events.Dispatcher;
import org.asapframework.events.Event;
import org.asapframework.events.EventDelegate;

import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.tangozebra.youtube.TZYouTubePlayer extends Dispatcher
{
	
	public static var NAME:String								= 'TZYouTubePlayer';
	
	public var autoPlay:Boolean									= true;
	public var chromeless:Boolean								= false;
	public var pars:String										= 'autoplay=0&loop=0&rel=0&showsearch=0&hd=1';
	public var playerWidth:Number								= 425;
	public var playerHeight:Number								= 344;
	
	private var remove:Boolean									= false;
	private var intervals:Array									= [ ];
	
	private var loader:MovieClipLoader;
	private var player:MovieClip;
	private var parent:MovieClip;
	private var id:String;
	private var intervalsId:String;
	
	public function TZYouTubePlayer(parent:MovieClip)
	{
		TZTrace.info(NAME + ' created');
		
		EventDispatcher.initialize(this);
		
		System.security.allowDomain( '*' );
		System.security.allowDomain( 'www.youtube.com' );
		System.security.allowDomain( 'youtube.com' );
		System.security.allowDomain( 's.ytimg.com' );
		System.security.allowDomain( 'i.ytimg.com' );
		
		loader = new MovieClipLoader();
		
		this.parent = parent;
	}
	
	public function init(id:String,noCheck:Boolean):Void
	{
		this.id = TZReplace.replace(id,' ','');
				
		TZTrace.info(NAME + ' setting: id = ' + id + ', pars = ' + pars);
		
		parent.swapDepths(parent._parent.getNextHighestDepth()); // Make the player appear at the top of everything!
		
		TZTrace.info(NAME + ' player state ' + player.getPlayerState());
		
		if (player && !noCheck)
		{	
			TZTrace.info(NAME + ' clearing old video ' + player.getPlayerState());
					
			remove = true;	
			
			if (player.getPlayerState() != 1)
			{
				destroyPlayer();
			}
			else
			{
				player.stopVideo();
			}
		} 
		else 
		{		
			loadVideo(); 
		}
	}
	
	public function resizePlayer(width:Number,height:Number):Void
	{
		if (player.isPlayerLoaded())
		{
			TZTrace.info(NAME + ' resizing player to (' + width + ',' + height + ')');
			
			player.setSize(width,height);
		}
		else
		{
			resizePlayer( width, height );
		}
	}
	
	public function stopVideo():Void
	{
		player.stopVideo();
	}
	
	public function pauseVideo():Void
	{
		player.pauseVideo();
	}

	public function resumeVideo():Void
	{
		player.playVideo();
	}
	
	private function loadVideo():Void
	{
		var url:String = (chromeless ? 'http://www.youtube.com/apiplayer' : 'http://www.youtube.com/v/' + id + '&' + pars);
		var playerName:String = NAME + 'Player' + (new Date().getTime());
		
		TZTrace.info(NAME + ' loading player ' + url);
		
		player = parent.createEmptyMovieClip(playerName,parent.getNextHighestDepth());
		
		intervalsId = playerName;
		
		intervals[intervalsId] = [ ];
		
		parent._visible = false;
		
		loader.addListener({ onLoadInit: loadInit() });
		
		loader.unloadClip(player);
		
		loader.loadClip(url,player);
	}
	
	private function loadInit():Void
	{
		TZTrace.info(NAME + ' setting load interval');
		
		intervals[intervalsId].push(setInterval(Delegate.create(this,checkPlayerLoaded),500)); 
	}
	
	public function destroyPlayer():Void
	{
		TZTrace.info(NAME + ' destorying player');
	
		intervals[intervalsId].push(setInterval(Delegate.create(this,checkPlayerDestroyed),500));
		
		remove = false;
	}
	
	private function checkPlayerLoaded():Void
	{
		TZTrace.info(NAME + ' checking for load (interval) ' + player.isPlayerLoaded());
		
		if (player.isPlayerLoaded())
		{
			TZTrace.info(NAME + ' loaded ' + player);
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.READY,null,this));
			
			if (chromeless)
			{
				player.loadVideoById(id);
			}
			
			player.addEventListener(TZYouTubePlayerEvent.STATE_CHANGED,Delegate.create(this,onPlayerStateChanged)); 
			player.addEventListener(TZYouTubePlayerEvent.ERROR,onPlayerError);
			
			resizePlayer(playerWidth,playerHeight);
			
			parent._visible = true;
			
			for (var i:Number = 0; i < intervals[intervalsId].length; i++)
			{
				clearInterval(intervals[intervalsId][i]);
			}
			
			onPlayerReady();
		}
	}
	
	private function checkPlayerDestroyed():Void
	{
		TZTrace.info(NAME + ' checking for destroyed (interval) ' + player);
		
		if (!player)
		{
			for (var i:Number = 0; i < intervals[intervalsId].length; i++)
			{
				clearInterval(intervals[intervalsId][i]);
			}
			
			init(id,true);
		}
		else
		{
			for (var players:String in parent)
			{
				parent[players].destroy();

				removeMovieClip(parent[players]);
				unloadMovie(parent[players]);

				TZTrace.info(NAME + ' deleting player ' + players);
			}
			
			player = null;
		}
	}
	
	private function onPlayerStateChanged(state:Number):Void
	{
		var message:String;
		
		switch (state)
		{
			case 0:
			message = 'ended';
			
			if (remove)
			{
				destroyPlayer();
			}
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_ENDED,null,this));
			
			break;
			
			case 1:
			message = 'playing';
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_PLAYING,null,this));
			
			break;
			
			case 2:
			message = 'paused';
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_PAUSED,null,this));
			
			break;
			
			case 3:
			message = 'buffering';
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_BUFFERING,null,this));
			
			break;
			
			case 4:
			message = 'fudge knows';
			
			break;
			
			case 5:
			message = 'video queued';
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_QUEUED,null,this));
			
			break;
			
			default:
			message = 'not started?';
			
			dispatchEvent(new TZYouTubePlayerEvent(TZYouTubePlayerEvent.PLAYER_NOT_STARTED,null,this));
			
			break;
		}
		
		TZTrace.info(NAME + ' ' + message);
	}
	
	private function onPlayerReady():Void
	{
		TZTrace.info(NAME + ' ready');
		
		if (autoPlay)
		{
			player.playVideo();
		}
	}
	
	private function onPlayerError():Void
	{
		TZTrace.info(NAME + ' error');
	}
	
	public function getCurrentTime():Number
	{
		if (player.isPlayerLoaded())
		{
			return player.getCurrentTime();
		}
	}
	
	public function getDuration():Number
	{
		if (player.isPlayerLoaded())
		{
			return player.getDuration();
		}
	}
	
	public function getVideoUrl():String
	{
		if (player.isPlayerLoaded())
		{
			return player.getVideoUrl();
		}
	}
	
	public function getPlaybackQuality():String
	{
		if (player.isPlayerLoaded())
		{
			return player.getPlaybackQuality();
		}
	}
	
	public function setPlaybackQuality(suggestedQuality:String):Void
	{
		if (player.isPlayerLoaded())
		{
			player.setPlaybackQuality(suggestedQuality);
		}
	}
}