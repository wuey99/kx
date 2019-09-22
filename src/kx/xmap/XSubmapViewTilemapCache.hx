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
package kx.xmap;

	import kx.*;
	import kx.texture.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.pool.*;
	import kx.type.*;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	
//------------------------------------------------------------------------------------------
	class XSubmapViewTilemapCache extends XSubmapViewCache {
		private var m_tilemap:XSubmapTilemap;
		private var m_movieClipCacheManager:XMovieClipCacheManager;
		private var m_XRectPoolManager:XObjectPoolManager;
		
		private var m_tileScaleFactor:Float;
		
//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
	
			m_tileScaleFactor = (XSubmapModel.TX_TILE_WIDTH + 2) / XSubmapModel.TX_TILE_WIDTH;
			
			m_movieClipCacheManager = xxx.getMovieClipCacheManager ();
			m_XRectPoolManager = xxx.getXRectPoolManager ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup();
						
			m_tilemap.cleanup ();
			
			m_poolManager.returnObject (m_tilemap);
		}

//------------------------------------------------------------------------------------------
		public override function setModel (__model:XSubmapModel):Void {
			super.setModel (__model);
			
			m_tilemap.scaleX = (m_submapModel.width + 2) / m_submapModel.width;
			m_tilemap.scaleY = (m_submapModel.height + 2) / m_submapModel.height;
		}
		
//------------------------------------------------------------------------------------------
		public override function dictRefresh ():Void {
//			m_tilemap.bitmap.bitmapData.lock ();
	
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			/*
			m_tilemap.bitmap.bitmapData.fillRect (
				tempRect, 0x00000000
			);
			*/
			
			var __items:Map<XMapItemModel, Int> /* <XMapItemModel, Int> */ = m_submapModel.items ();
			var __item:XMapItemModel;
			var __bitmap:XMovieClip;
//			var __p:XPoint = new XPoint ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			
			var i:Int;
			
			XType.forEach (__items, 
				function (x:Dynamic /* */):Void {
					__item = cast x; /* as XMapItemModel */

					__bitmap = xxx.getMovieClipCacheManager ().get (__item.imageClassName);

//					trace (": imageClassName: ", __item.imageClassName, __bitmap, __bitmap.bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
				
					/*
					if (__bitmap != null) {
						if (__item.frame != 0) {
							__bitmap.gotoAndStop (__item.frame);
						}
						
						tempPoint.x = __item.x - m_submapModel.x;
						tempPoint.y = __item.y - m_submapModel.y;
						
						tempRect.width = __item.boundingRect.width;
						tempRect.height = __item.boundingRect.height;
						
						m_tilemap.bitmap.bitmapData.copyPixels (
							__bitmap.bitmap.bitmapData, tempRect, tempPoint, null, null, true
						);
					}
					*/
				}
			);
			
//			m_tilemap.bitmap.bitmapData.unlock ();
		}
		
//------------------------------------------------------------------------------------------
		public override function arrayRefresh ():Void {
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			m_tilemap.removeTiles ();
			
			var __items:Array<XMapItemModel> = m_submapModel.arrayItems ();
			var __item:XMapItemModel;
			var __movieClip:XMovieClip;
			var __srcTilemap:XTilemap;
			var __submapX:Float = m_submapModel.x;
			var __submapY:Float = m_submapModel.y;
			
//			tempRect.x = 0;
//			tempRect.y = 0;
			
			var i:Int, __length:Int = __items.length;
			
			for (i in 0 ... __length) {
				__item = __items[i];
					
				__movieClip = m_movieClipCacheManager.get (__item.imageClassName);
					
				__srcTilemap = cast __movieClip.getMovieClip (); /* as XTilemap */
				
				if (__movieClip != null) {
					var __srcTile:Tile = null;
					var __dstTile:Tile = null;
					
					if (__item.frame != 0) {
						__srcTile = __srcTilemap.m_tilemap.getTileAt (__item.frame - 1);
						
						tempPoint.x = __item.x - __submapX;
						tempPoint.y = __item.y - __submapY;
						
						__dstTile = new Tile (0, 0, 0, 1.0, 1.0, 0.0);
						__dstTile.id = __srcTile.id;
						__dstTile.tileset = __srcTile.tileset;
						__dstTile.x = tempPoint.x;
						__dstTile.y = tempPoint.y;
						
						m_tilemap.tileset = __srcTilemap.m_tilemap.tileset;
						
						m_tilemap.addTile (__dstTile);
					}
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function tileRefresh ():Void {
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;
			
			m_tilemap.removeTiles ();
			
			var __movieClip:XMovieClip;
			var __srcTilemap:XTilemap;
			var __tmap:Array<Array<Dynamic>> = m_submapModel.tmap;
			var __tileCols:Int = m_submapModel.tileCols;
			var __tileRows:Int = m_submapModel.tileRows;
			
			var __boundingRect:XRect = cast m_XRectPoolManager.borrowObject (); /* as XRect */
			
			__boundingRect.x = 0;
			__boundingRect.y = 0;
			__boundingRect.width = XSubmapModel.TX_TILE_WIDTH;
			__boundingRect.height = XSubmapModel.TX_TILE_HEIGHT;
			
			for (__row in 0 ... __tileRows) {
				for (__col in 0 ... __tileCols) {
					var __tile:Array<Dynamic> /* <Dynamic> */  = __tmap[__row * __tileCols + __col];
					
					__movieClip = m_movieClipCacheManager.get (m_submapModel.XMapLayer.getClassNameFromIndex (__tile[0]));
				
					if (__movieClip != null) {
						__srcTilemap = cast __movieClip.getMovieClip (); /* as XTilemap */
						
						var __srcTile:Tile = null;
						var __dstTile:Tile = null;
						
						if (__tile[1] != 0) {
							__srcTile = __srcTilemap.m_tilemap.getTileAt (Std.int (__tile[1]) - 1);
						}
						
						tempPoint.x = __col * XSubmapModel.TX_TILE_WIDTH;
						tempPoint.y = __row * XSubmapModel.TX_TILE_HEIGHT;
						
						__dstTile = new Tile (0, 0, 0, 1.0, 1.0, 0.0);
						__dstTile.id = __srcTile.id;
						__dstTile.tileset = __srcTile.tileset;
						__dstTile.x = tempPoint.x;
						__dstTile.y = tempPoint.y;
						__dstTile.scaleX = m_tileScaleFactor;
						__dstTile.scaleY = m_tileScaleFactor;
						
						m_tilemap.tileset = __srcTilemap.m_tilemap.tileset;
						
						m_tilemap.addTile (__dstTile);
					}
				}
			}
			
			m_XRectPoolManager.returnObject (__boundingRect);
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_tilemap = cast m_poolManager.borrowObject (); /* as XSubmapTilemap */
			x_sprite = addSpriteAt (m_tilemap, 0, 0);
			x_sprite.setDepth (getDepth ());
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
