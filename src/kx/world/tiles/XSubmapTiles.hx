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
package kx.world.tiles;

	import kx.*;
	import kx.geom.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.pool.*;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
// primarily used in TikiEdit
//
// this class handles the view and caching of CX (collision tiles) and represents a Submap's
// collision data.
//------------------------------------------------------------------------------------------
	class XSubmapTiles extends XLogicObject {
		private var m_submapModel:XSubmapModel;
		
		private var m_bitmap:XBitmap;
		private var x_sprite:XDepthSprite;
		
		private var cx_sprite:MovieClip;
		private var cx_bitmap:XBitmap;
		
		private var tempRect:XRect;
		private var tempPoint:XPoint;

		private var m_poolManager:XObjectPoolManager;

//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
			
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_poolManager = getArg (args, 0);
			
			createSprites ();
			
			tempRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
			tempPoint = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
			
			cx_bitmap = xxx.getBitmapCacheManager ().get ("CX:CXClass");
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {	
			returnBorrowedObjects ();
			
			m_poolManager.returnObject (m_bitmap);
					
			xxx.getXRectPoolManager ().returnObject (tempRect);
			xxx.getXPointPoolManager ().returnObject (tempPoint);

			if (m_submapModel != null) {
				fireKillSignal (m_submapModel);
							
				m_submapModel.inuse--;
				
				m_submapModel = null;
			}
			
			removeAll ();
			
			if (m_poolClass != null) {
				xxx.getXLogicObjectPoolManager ().returnObject (m_poolClass, this);
			}
			
			isDead = true;
			cleanedUp = true;
		}
		
//------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):Void {
			m_submapModel = __model;
			
			m_boundingRect = m_submapModel.boundingRect.cloneX ();
						
			refresh ();
		}
				
//------------------------------------------------------------------------------------------
		public function refresh ():Void {
			var __width:Int = m_submapModel.width;
			var __height:Int = m_submapModel.height;
			
			function __tiles ():Void {
				var __col:Int;
				var __row:Int;
				var __rect:XRect;
//				var __p:XPoint = new XPoint ();
		
//				__rect = new XRect (0, 0, XSubmapModel.CX_TILE_WIDTH, XSubmapModel.CX_TILE_HEIGHT);
	
				tempRect.x = 0;
				tempRect.y = 0;
				tempRect.width = XSubmapModel.CX_TILE_WIDTH;
				tempRect.height = XSubmapModel.CX_TILE_HEIGHT;
							
				for (__row in 0 ... m_submapModel.rows) {
					for (__col in 0 ... m_submapModel.cols) {
						cx_bitmap.gotoAndStop (m_submapModel.getCXTile (__col, __row)+1);
																					
						tempPoint.x = __col << 4;
						tempPoint.y = __row << 4;
						
						m_bitmap.bitmap.bitmapData.copyPixels (
							cx_bitmap.bitmap.bitmapData, tempRect, tempPoint, null, null, true
						);
					}
				}
			}
			
			function __vline (__x:Int):Void {
				var __y:Int;
				
				for (__y in 0 ... __height) {
					m_bitmap.bitmap.bitmapData.setPixel32 (__x, __y, 0xffff00ff);
				}
			}
			
			function __hline (__y:Int):Void {
				var __x:Int;
				
				for (__x in 0 ... __width) {
					m_bitmap.bitmap.bitmapData.setPixel32 (__x, __y, 0xffff00ff);
				}
			}
			
			m_bitmap.bitmap.bitmapData.lock ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;
			
			m_bitmap.bitmap.bitmapData.fillRect (
				//				new XRect (0, 0, m_submapModel.width, m_submapModel.height), 0x00000000
				tempRect, 0x00000000
			);
			
			__vline (0);
			__vline (__width-1);
			__hline (0);
			__hline (__height-1);
			
			__tiles ();
			
			m_bitmap.bitmap.bitmapData.unlock ();
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():Void {

// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect ();

			var r:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect; */
			var i:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
										
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (r);
			r.inflate (256, 256);
			
			m_boundingRect.copy2 (i);
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				xxx.getXRectPoolManager ().returnObject (r);
				xxx.getXRectPoolManager ().returnObject (i);
				
				return;
			}
			
			xxx.getXRectPoolManager ().returnObject (r);
			xxx.getXRectPoolManager ().returnObject (i);
					
// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_bitmap = cast m_poolManager.borrowObject (); /* as XBitmap */
// !STARLING!
			if (true /* CONFIG::flash */) {
				x_sprite = addSpriteAt (m_bitmap, 0, 0);
				x_sprite.setDepth (getDepth ());
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
