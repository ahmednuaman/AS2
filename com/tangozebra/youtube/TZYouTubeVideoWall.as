/*
@author:		Ahmed Nuaman (ahmedn@google.com)
@date:			2009-01-22
*/

import com.tangozebra.data.TZXML;
import com.tangozebra.data.TZXMLEvent;
import com.tangozebra.display.TZGrid;
import com.tangozebra.string.TZReplace;
import com.tangozebra.utils.TZMovieClipUtil
import com.tangozebra.utils.TZTrace;
import com.tangozebra.youtube.TZYouTubePlayer;
import com.tangozebra.youtube.TZYouTubeThumbs;

import mx.utils.Delegate;

class com.tangozebra.youtube.TZYouTubeVideoWall
{
	static var NAME:String										= 'TZYouTubeVideoWall';
	
	public var callback:Function;
	public var firstVideo:Object;
	
	private var parent:MovieClip;
	private var player:TZYouTubePlayer;
	private var playlistURL:String;
	private var entries:Array;
	private var maxItems:Number;
	private var currentSet:Number;
	
	function TZYouTubeVideoWall(parent:MovieClip, player:TZYouTubePlayer, playlistURL:String, maxItems:Number)
	{
		super(NAME);
		
		TZTrace.info(NAME + ' created');
		
		this.parent = parent;
		this.player = player;
		this.playlistURL = playlistURL;
		this.maxItems = ( maxItems ? maxItems : 6 );
		
		this.parent.wall.master._visible = false;
		
		this.parent.wallMask._height = Math.ceil( maxItems / 3 ) * 125;
		
		this.parent.wall.setMask(this.parent.wallMask);
		
		this.parent.more._y = this.parent.wallMask._height + 10;
		this.parent.more.func = Delegate.create(this,moreVideos);
		this.parent.more.onRelease = function():Void
		{
			this.func();
		}
		
		this.parent.previous._y = this.parent.wallMask._height + 10;
		this.parent.previous.func = Delegate.create(this,previousVideos);
		this.parent.previous.onRelease = function():Void
		{
			this.func();
		}
	}
	
	public function init(callbackFunc):Void
	{
		var tzXML:TZXML = new TZXML();
		
		TZTrace.info(NAME + ' loading ' + playlistURL);
		
		tzXML.addEventListener(TZXMLEvent.COMPLETE,Delegate.create(this,handlePlaylistXML));
		
		tzXML.init(playlistURL);
	}
	
	private function handlePlaylistXML(e:TZXMLEvent):Void
	{
		entries = e.data.feed.entry;
		
		firstVideo = entries.shift();
		
		callback();
		
		buildTiles(1);
	}
	
	private function buildTiles(set:Number):Void
	{
		var tzThumbs:TZYouTubeThumbs = new TZYouTubeThumbs();
		var tzGrid:TZGrid = new TZGrid();
		var master:MovieClip = parent.wall.master;
		var tiles:Array = [ ];
		var duplicate:MovieClip;
		var videoId:String;
		
		tzGrid.maxWidth = 400;
		tzGrid.randomiseOffset = false;
		
		if ((entries.length / maxItems) > (set - 1)  && set > 0)
		{ 
			TZMovieClipUtil.removeChildren(parent.wall);
			
			currentSet = set;
		
			for (var i:Number = (set - 1) * maxItems; i < set * maxItems; i++)
			{
				if (entries[i])
				{
					duplicate = master.duplicateMovieClip('duplicate' + i,parent.wall.getNextHighestDepth());
			
					videoId = entries[i]['media:group']['yt:videoid'].data;
			 
					duplicate.username.text = entries[i].title.data; //['media:group']//['media:credit'].data;
					duplicate.views.text = entries[i]['yt:statistics'].attributes.viewCount;
			
					tzThumbs.create(duplicate,videoId,120,80);
			
					duplicate._visible = true;
					duplicate.videoId = videoId;
					duplicate.func = Delegate.create(this,loadVideo);
					duplicate.onRelease = function():Void
					{
						this.func(this.videoId,this.username.text,this.views.text);
					}
			
					tiles.push(duplicate);
				}
			}

			tzGrid.init(tiles,10,10);
			
			TZTrace.info(NAME + ' current set '  + currentSet);
		}		
	}
	
	private function loadVideo(id:String,title:String,views:Number):Void
	{
		_root.home.views.text = views;
		_root.home.username.text = title;
		
		player.init(id);
	}
	
	private function moreVideos():Void
	{
		buildTiles(currentSet + 1);
	}
	
	private function previousVideos():Void
	{
		buildTiles(currentSet - 1);
	}
}

/* End of file HomeVideoWall.as */
/* Location: ./Davos Channel/src/HomeVideoWall.as */