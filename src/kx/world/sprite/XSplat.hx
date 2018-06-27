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
	
	import kx.*;
	import kx.collections.*;
	import kx.bitmap.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------	
	class XSplat extends Sprite implements XRegistration {
		public var m_className:String;
		public var m_frame:Int;
		public var m_scale:Float;
		public var m_visible:Bool;
		public var m_pos:XPoint;
		public var m_rect:XRect;
		public var theParent:Dynamic /* */;
		public var rp:XPoint;
		
		public static var g_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		// begin include "..\\Sprite\\XRegistration_impl.h";
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
// import kx.geom.XPoint;

//------------------------------------------------------------------------------------------
		public function globalToParent():Point {
// unused
			return null;
		}

//------------------------------------------------------------------------------------------
		public function setRegistration(x:Float=0, y:Float=0):Void {
			rp.x = x;
			rp.y = y;
		}

//------------------------------------------------------------------------------------------
		public function getRegistration():XPoint {
			return rp;
		}
				
//------------------------------------------------------------------------------------------
		public var x2 (get, set):Float;
				
		public function get_x2 ():Float {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.x;
		}

		public function set_x2 (value:Float): Float {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x += value - p.x;
			
			return 0;	
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var y2 (get, set):Float;
		
		// [Inline]
		public function get_y2():Float {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.y;
		}

		// [Inline]
		public function set_y2(value:Float):  Float {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.y += value - p.y;
			
			return 0;	
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var scaleX2 (get, set):Float;
		
		// [Inline]
		public function get_scaleX2():Float {
			return this.scaleX;
		}

		// [Inline]
		public function set_scaleX2(value:Float): Float {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleX = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			return 0;	
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var scaleY2 (get, set):Float;
		
		// [Inline]
		public function get_scaleY2():Float {
			return this.scaleY;
		}

		// [Inline]
		public function set_scaleY2(value:Float): Float {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleY = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			return 0;	
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var rotation2 (get, set):Float;
		
		// [Inline]
		public function get_rotation2():Float {
			return this.rotation;
		}

		// [Inline]
		public function set_rotation2(value:Float): Float {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.rotation = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			return 0;	
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var mouseX2 (get, set):Float;
		
		public function get_mouseX2():Float {
			return Math.round (this.mouseX - rp.x);
		}
		
		public function set_mouseX2(value:Float): Float {
			return 0;	
		}
		/* @:end */		

//------------------------------------------------------------------------------------------
		public var mouseY2 (get, set):Float;
		
		public function get_mouseY2():Float {
			return Math.round (this.mouseY - rp.y);
		}
		
		public function set_mouseY2(value:Float): Float {
			return 0;	
		}
		/* @:end */	
		
//------------------------------------------------------------------------------------------
		public function setProperty2(prop:String, n:Float):Void {			
// unused
		}
		
		// end include "..\\Sprite\\XRegistration_impl.h";
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():Void {
			m_pos = cast g_XApp.getXPointPoolManager ().borrowObject (); /* as XPoint */
			m_rect = cast g_XApp.getXRectPoolManager ().borrowObject (); /* as XRect */
			rp = cast g_XApp.getXPointPoolManager ().borrowObject (); /* as XPoint */
			
			setRegistration ();

			x = y = 0;
			rotation = 0.0;
			scaleX = scaleY = m_scale = 1.0;
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
		public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):Void {
		}
				
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Int):Void {
			goto (__frame);
		}
		
		//------------------------------------------------------------------------------------------
		public function goto (__frame:Int):Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoX (__name:String):Void {
		}
		
		//------------------------------------------------------------------------------------------
		public var dx (get, set):Float;
		
		public function get_dx ():Float {
			return 0;
		}
		
		public function set_dx (__val:Float): Float {
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var dy (get, set):Float;
		
		public function get_dy ():Float {
			return 0;
		}
		
		public function set_dy (__val:Float): Float {
			return 0;			
		}
		/* @:end */
		
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
		
		//------------------------------------------------------------------------------------------	
	}
					
//------------------------------------------------------------------------------------------
// }