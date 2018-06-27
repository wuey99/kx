//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package kx.texture;
	
	// flash classes
	import openfl.display.*;
	import openfl.geom.*;
	
	import kx.XApp;
	import kx.collections.*;
	import kx.task.*;
	import kx.texture.MaxRectPacker;
	import kx.texture.MovieClipMetadata;
	import kx.type.*;
	import kx.world.sprite.*;
	import kx.xml.*;

	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates HaXe/OpenFl texture/atlases
	//------------------------------------------------------------------------------------------
	class XTileSubTextureManager extends XSubTextureManager {
		private var m_movieClips:Map<String, MovieClipMetadata>; // <String, MovieClipMetadata>
		
		private var m_testers:Array<MaxRectPacker>; // <MaxRectPacker>
		private var m_packers:Array<MaxRectPacker>; // <MaxRectPacker>
		private var m_tilesets:Array<Tileset>; // <Tileset>
		
		private var m_currentTester:MaxRectPacker;
		private var m_currentPacker:MaxRectPacker;
		private var m_currentBitmap:BitmapData;
		private var m_currentBitmapIndex:Int;
		
		private var wrapFlag:Bool;
		
		//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp, __width:Int=2048, __height:Int=2048) {
			super (__XApp, __width, __height);
			
			wrapFlag = false;
		}
		
		//------------------------------------------------------------------------------------------
		public override function reset ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public override function start ():Void {
			reset ();
			
			m_movieClips = new Map<String, MovieClipMetadata> ();  // <String, MovieClipMetadata>
			m_testers = new Array<MaxRectPacker> (); // <MaxRectPacker>
			m_packers = new Array<MaxRectPacker> (); // <MaxRectPacker>
			m_tilesets = new Array<Tileset> (); // <Tileset>
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function finish ():Void {
			if (!wrapFlag) {
				__finishFit ();
			}
			else
			{
				__finishWrap ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __finishFit ():Void {
			__end ();
			
			var i:Int;
			
			var __scaleX:Float = 1.0;
			var __scaleY:Float = 1.0;
			var __padding:Float = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle;
			
			var __index:Int;
			var __movieClip:flash.display.MovieClip;
			
			//------------------------------------------------------------------------------------------
			for (m_currentBitmapIndex in 0 ... m_count) {
				__rect = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap.fillRect (__rect, 0x00000000);
				
				//------------------------------------------------------------------------------------------
				for (__key__ in m_movieClips.keys ()) {
					function (x:Dynamic /* */):Void {
						var __className:String = cast x; /* as String */
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						if (__index == m_currentBitmapIndex) {
							for (i in 0 ... __movieClip.totalFrames) {
								__movieClip.gotoAndStop (i+1);
								__rect = __movieClipMetadata.getRect (i);
								var __matrix:Matrix = new Matrix ();
								__matrix.scale (__scaleX, __scaleY);
								__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y);
								m_currentBitmap.draw (__movieClip, __matrix);
							}
						}
					} (__key__);
				}	
				
				//------------------------------------------------------------------------------------------
				var __tileset:Tileset = new Tileset (m_currentBitmap);
				var __tileId:Int;
				
				m_tilesets.push (__tileset);
				
				//------------------------------------------------------------------------------------------
				for (__key__ in m_movieClips.keys ()) {
					function (x:Dynamic /* */):Void {
						var __className:String = cast x; /* as String */
						
						trace (": ===================================================: ");
						trace (": finishing: ", __className);
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						trace (": index: ", __index);
						trace (": tileset: ", __tileset);
						trace (": movieClip: ", __movieClip);
						trace (": realBounds: ", __realBounds);
						
						if (__index == m_currentBitmapIndex) {
							__movieClipMetadata.setMasterTileset (__tileset);
							
							for (i in 0 ... __movieClip.totalFrames) {
								__rect = __movieClipMetadata.getRect (i);
								__tileId = __tileset.addRect (__rect);
								__movieClipMetadata.setTileId (i, __tileId);
								__movieClipMetadata.setTileset (i, __tileset);
								
								trace (":    frame: ", i);
								trace (":    tileId: ", __tileId);
								trace (":    rect: ", __rect);
							}
						}
					} (__key__);
				}	
				
				//------------------------------------------------------------------------------------------
//				m_currentBitmap.dispose ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __finishWrap ():Void {
			__end ();
			
			var i:Int;
			
			var __scaleX:Float = 1.0;
			var __scaleY:Float = 1.0;
			var __padding:Float = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle;
			
			var __index:Int;
			var __movieClip:flash.display.MovieClip;
			
			//------------------------------------------------------------------------------------------
			for (m_currentBitmapIndex in 0 ... m_count) {
				__rect = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap.fillRect (__rect, 0x00000000);
				
				//------------------------------------------------------------------------------------------
				for (__key__ in m_movieClips.keys ()) {
					function (x:Dynamic /* */):Void {
						var __className:String = cast x; /* as String */
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						for (i in 0 ... __movieClip.totalFrames) {
							__index = __movieClipMetadata.getTilesetIndex (i);
							
							if (__index == m_currentBitmapIndex) {
								__movieClip.gotoAndStop (i+1);
								__rect = __movieClipMetadata.getRect (i);
								var __matrix:Matrix = new Matrix ();
								__matrix.scale (__scaleX, __scaleY);
								__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y);
								m_currentBitmap.draw (__movieClip, __matrix);
							}
						}
					} (__key__);
				}	
				
				//------------------------------------------------------------------------------------------
				var __tileset:Tileset = new Tileset (m_currentBitmap);
				var __tileId:Int;
				
				m_tilesets.push (__tileset);
				
				//------------------------------------------------------------------------------------------
				for (__key__ in m_movieClips.keys ()) {
					function (x:Dynamic /* */):Void {
						var __className:String = cast x; /* as String */
						
						trace (": ===================================================: ");
						trace (": finishing: ", __className);
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						trace (": index: ", __index);
						trace (": tileset: ", __tileset);
						trace (": movieClip: ", __movieClip);
						trace (": realBounds: ", __realBounds);
						
						for (i in 0 ... __movieClip.totalFrames) {
							__index = __movieClipMetadata.getTilesetIndex (i);
							
							if (__index == m_currentBitmapIndex) {
								__rect = __movieClipMetadata.getRect (i);
								__tileId = __tileset.addRect (__rect);
								__movieClipMetadata.setTileId (i, __tileId);
								__movieClipMetadata.setTileset (i, __tileset);
									
								trace (":    frame: ", i);
								trace (":    tileId: ", __tileId);
								trace (":    rect: ", __rect);
							}
						}
					} (__key__);
				}	
				
				//------------------------------------------------------------------------------------------
				// m_currentBitmap.dispose ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function isDynamic ():Bool {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):Void {
			var __class:Class<Dynamic> /* <Dynamic> */ = m_XApp.getClass (__className);
			
			m_movieClips.set (__className, null);
			
			if (__class != null) {
				createTexture (__className, __class);
				
				m_XApp.unloadClass (__className);
			}
			else
			{
				m_queue.set (__className, 0);
			}
		}
		
		//------------------------------------------------------------------------------------------		
		public override function isQueued (__className:String):Bool {
			return m_movieClips.exists (__className);
		}
		
		//------------------------------------------------------------------------------------------
		public override function movieClipExists (__className:String):Bool {
			if (m_movieClips.exists (__className)) {
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function createMovieClip (__className:String):Dynamic /* */ /* <Dynamic> */ {
			if (!isQueued (__className)) {
				return null;
			}
			
			var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
			
			var __tileset:Tileset = __movieClipMetadata.getMasterTileset ();
			var __frames:Int = __movieClipMetadata.getTotalFrames ();
			var __realBounds:Rectangle = __movieClipMetadata.getRealBounds ();
			
			var __tilemap:Tilemap = new Tilemap (Std.int (__realBounds.width), Std.int (__realBounds.height));
			__tilemap.tileset = __tileset;
			
			var i:Int;
			
			var __tileId:Int;
			var __tile:Tile;
			var __rect:Rectangle;
			
			for (i in 0 ... __frames) {
				__tileset = __movieClipMetadata.getTileset (i);
				__rect = __movieClipMetadata.getRect (i);
				__tileId = __movieClipMetadata.getTileId (i);
				
//				__tile = new Tile (0, 0, 0, 1.0, 1.0, 0.0);				
				__tile = cast m_XApp.getTilePoolManager ().borrowObject (); /* as Tile */
				__tile.id = __tileId;
				
				__tile.x = 0;
				__tile.y = 0;
				
				if (wrapFlag) {
					__tile.tileset = __tileset;
				}
				
				__tilemap.addTileAt (__tile, i);
			}
			
			__tilemap.x = __realBounds.x;
			__tilemap.y = __realBounds.y;
			
			return __tilemap;
		}

		//------------------------------------------------------------------------------------------
		private function findFreeTexture (__movieClip:flash.display.MovieClip):Int {
			var __scaleX:Float = 1.0;
			var __scaleY:Float = 1.0;
			var __padding:Float = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;
			
			var __free:Bool;
			
			var __index:Int;
			
			for (__index in 0 ... m_count) {
				var __tester:MaxRectPacker = cast m_testers[__index]; /* as MaxRectPacker */
				var __packer:MaxRectPacker = cast m_packers[__index]; /* as MaxRectPacker */
				
				__tester.copyFrom (__packer.freeRectangles);
			
				__free = true;
				
				var i:Int = 0;
				
				while (i < __movieClip.totalFrames && __free) {
					__movieClip.gotoAndStop (i+1);
					
					__realBounds = __getRealBounds (__movieClip);
					
					__rect = __tester.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
					
					if (__rect == null) {
						__free = false;
					}
					
					i++;
				}
				
				if (__free) {
					return __index;
				}
			}
			
			__end (); __begin ();
			
			return m_count - 1;
		}
		
		//------------------------------------------------------------------------------------------
		public override function createTexture (__className:String, __class:Class<Dynamic> /* <Dynamic> */):Void {	
			if (!wrapFlag) {
				__createTextureFit (__className, __class);	
			}
			else
			{
				__createTextureWrap (__className, __class);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __createTextureFit (__className:String, __class:Class<Dynamic> /* <Dynamic> */):Void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Float = 1.0;
			var __scaleY:Float = 1.0;
			var __padding:Float = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;

			var i:Int;
			
			trace (": XTileSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			var __index:Int = findFreeTexture (__movieClip);
			
			m_currentPacker = cast m_packers[__index]; /* as MaxRectPacker */
			
			var __movieClipMetadata:MovieClipMetadata = new MovieClipMetadata ();
			__movieClipMetadata.setup (
				__index,					// TilesetIndex
				null,						// Tileset
				__movieClip,				// MovieClip
				__movieClip.totalFrames,	// totalFrames
				__realBounds				// realBounds
				);
			
			for (i in 0 ... __movieClip.totalFrames) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __className, __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_currentPacker.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				trace (": rect: ", __rect);
				
				__movieClipMetadata.addTile (0, __index, __rect);
			}
			
			__movieClipMetadata.setRealBounds (__realBounds);
			
			m_movieClips.set (__className, __movieClipMetadata);
		}	
		
		//------------------------------------------------------------------------------------------
		private function __createTextureWrap (__className:String, __class:Class<Dynamic> /* <Dynamic> */):Void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Float = 1.0;
			var __scaleY:Float = 1.0;
			var __padding:Float = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;
			
			var i:Int;
			
			trace (": XTileSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			var __index:Int = m_count - 1;
			
			m_currentPacker = cast m_packers[__index]; /* as MaxRectPacker */
			
			var __movieClipMetadata:MovieClipMetadata = new MovieClipMetadata ();
			__movieClipMetadata.setup (
				__index,					// TilesetIndex
				null,						// Tileset
				__movieClip,				// MovieClip
				__movieClip.totalFrames,	// totalFrames
				__realBounds				// realBounds
			);
			
			for (i in 0 ... __movieClip.totalFrames) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __className, __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_currentPacker.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				if (__rect == null) {
					trace (": split @: ", m_count, __className, i);
					
					__end (); __begin ();
					
					__index = m_count - 1;
					
					m_currentPacker = cast m_packers[__index]; /* as MaxRectPacker */
					
					__rect = m_currentPacker.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
				}
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				trace (": rect: ", __rect);
				
				__movieClipMetadata.addTile (0, __index, __rect);
			}
			
			__movieClipMetadata.setRealBounds (__realBounds);
			
			m_movieClips.set (__className, __movieClipMetadata);
		}	
		
		//------------------------------------------------------------------------------------------
		private override function __begin ():Void {
			var __tester:MaxRectPacker = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);			
			var __packer:MaxRectPacker = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);

			m_testers[m_count] = __tester;
			m_packers[m_count] = __packer;
			
			m_count++;
			
			trace (": XTileSubTextureManager: count: ", m_count);
		}
		
		//------------------------------------------------------------------------------------------
		private override function __end ():Void {	
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
// }
