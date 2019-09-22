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
	import kx.world.*;
	import kx.geom.*;
	
// flash classes
	import openfl.geom.*;
	
	// begin include "..\\..\\flash.h";
	import openfl.display.*;
	// end include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
	class XSprite0 extends Sprite {
		public var m_xxx:XWorld;
		public var rp:XPoint;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
			
			mouseEnabled = false;
		}
		
//------------------------------------------------------------------------------------------
		public var xxx (get, set):XWorld;
		
		public function get_xxx ():XWorld {
			return m_xxx;
		}
		
		public function set_xxx (__XWorld:XWorld): XWorld {
			m_xxx = __XWorld;
			
			return m_xxx;			
		}
		/* @:end */
		
//-----------------------------------------------------------------------------------------
		public var childList (get, set):Sprite;
	
		public function get_childList ():Sprite {
			return this;
		}
		
		public function set_childList (__val:Sprite): Sprite {
			
			return null;			
		}
		/* @:end */
			
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
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
