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

	import openfl.display.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import kx.*;
	import kx.bitmap.XBitmapCacheManager;
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.XObjectPoolManager;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
//------------------------------------------------------------------------------------------	
// instead of maintaining an XLogicObject for an XMapItemModel (for the view), maintain a 
// bitmap/view-cache for eash Submap.  On initialization, all XMapItemModel's that flagged
// for caching are drawing directly into the Submap's bitmap/view-cache.
//
// pros:
//
// 1) performance gains because all cached XMapItem's are now baked into a single bitmap.
//
// cons:
//
// 1) lack of fine-grained control of z-ordering
//
// 2) since the image is baked into the bitmap, there is no ability to animate (or change image's appearance)
//    without having to recache the image.
//
// 3) possibly large set-up times (each Submap is 512 x 512 pixels by default)
//------------------------------------------------------------------------------------------
	class XSubmapViewCache extends XLogicObject {
		private var m_poolManager:XObjectPoolManager;
		private var m_submapModel:XSubmapModel;
		
		private var x_sprite:XDepthSprite;
	
		private var tempRect:XRect;
		private var tempPoint:XPoint;

		private var m_delay:Int;
		
		private var m_scaleFactor:Float;
		
//------------------------------------------------------------------------------------------	
		public function new () {
			super ();
			
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_poolManager = getArg (args, 0);
	
			m_scaleFactor = getArg (args, 1);
			
			createSprites ();
			
			tempRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
			tempPoint = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */

			m_delay = 4;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			returnBorrowedObjects ();
			
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

//x------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):Void {
			m_submapModel = __model;
			
			m_boundingRect = m_submapModel.boundingRect.cloneX ();
			
			refresh ();
		}

//------------------------------------------------------------------------------------------
		public function refresh ():Void {
			if (m_submapModel.useArrayItems) {
// for now only support tileRefresh.  In the future, we might support optional array or tile refresh
//				arrayRefresh ();
				
				tileRefresh ();
			}
			else
			{
				dictRefresh ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function dictRefresh ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function arrayRefresh ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function tileRefresh ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function tileRefreshScaled ():Void {
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():Void {
			if (m_delay > 0) {
				m_delay--;
				
				return;
			}

// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect ();
						
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (m_viewPortRect);
			m_viewPortRect.inflate (256, 256);
			
			m_boundingRect.copy2 (m_selfRect);
			m_selfRect.offsetPoint (getPos ());
			
			if (m_viewPortRect.intersects (m_selfRect)) {
				return;
			}

// yep, kill it
//			trace (": ---------------------------------------: ");
//			trace (": cull: ", this);
	
			killLater ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
// }
