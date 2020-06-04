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
package kx.game;
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.*;
	import kx.world.logic.*;
	import kx.world.XWorld;
	import kx.xmap.*;
	import kx.type.*;
	
//------------------------------------------------------------------------------------------
	class XBulletCollisionList {
		private var xxx:XWorld;
		private var m_rects:Array<Map<XLogicObject, XRect>>; // <Map<XLogicObject, XRect>>
		private var m_XSubRectPoolManager:XSubObjectPoolManager;
		
//------------------------------------------------------------------------------------------
		public function new () {
			// super ();
			
			xxx = null;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld):Void {
			xxx = __xxx;		
			m_rects = new Array<Map<XLogicObject, XRect>> ();  // <Map<XLogicObject, XRect>>
			
			var i:Int;
			
			for (i in 0 ... xxx.getMaxLayers ()) {
				m_rects[i] = new Map<XLogicObject, XRect> (); // <XLogicObject, XRect>
			}
			
			m_XSubRectPoolManager = new XSubObjectPoolManager (xxx.getXRectPoolManager ());
			
			clear ();
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			clear ();
		}

//------------------------------------------------------------------------------------------		
		public function clear ():Void {
			var i:Int;

			for (i in 0 ... xxx.getMaxLayers ()) {
				XType.removeAllKeys (m_rects[i]);
			}
			
			m_XSubRectPoolManager.returnAllObjects ();
		}
	
//------------------------------------------------------------------------------------------
		public function addCollision (
			__layer:Int,
			__logicObject:XLogicObject,
			__srcPoint:XPoint, __srcRect:XRect
			):Void {

			var __rect:XRect = cast m_XSubRectPoolManager.borrowObject (); /* as XRect */
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);
			m_rects[__layer].set (__logicObject, __rect);
		}

//------------------------------------------------------------------------------------------
		public function findCollision (
			__layer:Int,
			__srcPoint:XPoint,
			__srcRect:XRect
		):XLogicObject {
			
			var __logicObject:XLogicObject = null;
			
			var __rect:XRect = cast m_XSubRectPoolManager.borrowObject (); /* as XRect */
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);
			
			XType.forEach (m_rects[__layer], 
				function (x:Dynamic /* */):Void {
					var __dstRect:XRect = cast m_rects[__layer].get (x);
					
					if (__dstRect.intersects (__rect)) {
						__logicObject = cast x; /* as XLogicObject */
					}
				}
			);	
			
			m_XSubRectPoolManager.returnObject (__rect);
	
			return __logicObject;
		}
		
//------------------------------------------------------------------------------------------
		public function findCollisions (
			__layer:Int,
			__srcPoint:XPoint,
			__srcRect:XRect
			):Array<XLogicObject> /* <XLogicObject> */ {
	
			var __logicObjects:Array<XLogicObject> /* <XLogicObject> */ = new Array<XLogicObject> (); // <XLogicObject>

			var __rect:XRect = cast m_XSubRectPoolManager.borrowObject (); /* as XRect */
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);

			XType.forEach (m_rects[__layer], 
				function (x:Dynamic /* */):Void {
					var __dstRect:XRect = cast m_rects[__layer].get (x);
					
					if (__dstRect.intersects (__rect)) {
						__logicObjects.push (x);
					}
				}
			);	
			
			m_XSubRectPoolManager.returnObject (__rect);
			
			return __logicObjects;
		}
		
//------------------------------------------------------------------------------------------
		public function getRects (__layer:Int):Map<XLogicObject, XRect> /* <XLogicObject, XRect> */ {
			return m_rects[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getList (__layer:Int):Map<XLogicObject, XRect> /* <XLogicObject, XRect> */ {
			return m_rects[__layer];
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
