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
package kx.world.sprite;

// X classes
	import kx.geom.*;
	import kx.world.*;
	import kx.*;
	
	import openfl.geom.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class XSprite extends XSprite0 {
		public var m_scale:Float;
		public var m_visible:Bool;
		public var m_pos:XPoint;
		public var m_rect:XRect;
		public static var g_XApp:XApp;
				
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():Void {
			m_pos = cast g_XApp.getXPointPoolManager ().borrowObject (); /* as XPoint */
			m_rect = cast g_XApp.getXRectPoolManager ().borrowObject (); /* as XRect */
			rp = cast g_XApp.getXPointPoolManager ().borrowObject (); /* as XPoint; */
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {	
			g_XApp.getXPointPoolManager ().returnObject (m_pos);
			g_XApp.getXPointPoolManager ().returnObject (m_rect);
			g_XApp.getXPointPoolManager ().returnObject (rp);			
		}

//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):Void {
			g_XApp = __XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function globalToLocalXPoint (__p:XPoint):XPoint {
			var __x:Point = globalToLocal (__p.getPoint ());
		
			return new XPoint (__x.x, __x.y);
		}
	
//------------------------------------------------------------------------------------------
		public function globalToLocalXPoint2 (__src:XPoint, __dst:XPoint):XPoint {
			var __x:Point = globalToLocal (__src.getPoint ());
		
			__dst.x = __x.x;  __dst.y = __x.y;
			
			return __dst;
		}
		
//------------------------------------------------------------------------------------------
		public function viewPort (__canvasWidth:Float, __canvasHeight:Float):XRect {
			m_rect.x = -x/m_scale;
			m_rect.y = -y/m_scale;
			m_rect.width = __canvasWidth/m_scale;
			m_rect.height = __canvasHeight/m_scale;
			
			return m_rect;
		}
		
//------------------------------------------------------------------------------------------
		public function getPos ():XPoint {
			m_pos.x = x2;
			m_pos.y = y2;
			
			return m_pos;
		}

//------------------------------------------------------------------------------------------		
		public function setPos (__p:XPoint):Void {
			x2 = __p.x;
			y2 = __p.y;
		}

//------------------------------------------------------------------------------------------
		public function setScale (__scale:Float):Void {
			m_scale = __scale;
			
			scaleX2 = __scale;
			scaleY2 = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function getScale ():Float {
			return m_scale;
		}

//------------------------------------------------------------------------------------------
		public var visible2 (get, set):Bool;
		
		public function get_visible2 ():Bool {
			return m_visible;
		}
		
		public function set_visible2 (__visible:Bool): Bool {
			m_visible = __visible;
			
			return __visible;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
