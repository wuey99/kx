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
package kx.display;
	import kx.collections.*;
	import kx.geom.*;
	
	//------------------------------------------------------------------------------------------	
	class Sprite5 extends DisplayObjectContainer5 {
		public var alpha:Float;
		public var rotation:Float;
		public var scaleX:Float;
		public var scaleY:Float;
		public var visible:Bool;
		public var width:Int;
		public var height:Int;
		public var m_mouseX:Float;
		public var m_mouseY:Float;
		public var m_stageX:Float;
		public var m_stageY:Float;
		public var stage:Dynamic /* */;
		public var x:Float;
		public var y:Float;
		public var regX:Float;
		public var regY:Float;
		public var mouseEnabled:Bool;
		public var m_isOver:Bool;
		public var m_numChildEvents:Int;

		public var m_CLICKS:Map<{}, Int>;	// <Dynamic, Int>
		public var m_DOUBLE_CLICKS:Map<{}, Int>; // <Dynamic, Int>
		public var m_MOUSE_DOWNS:Map<{}, Int>; // <Dynamic, Int>
		public var m_MOUSE_MOVES:Map<{}, Int>; // <Dynamic, Int>
		public var m_MOUSE_OUTS:Map<{}, Int>; // <Dynamic, Int>
		public var m_MOUSE_OVERS:Map<{}, Int>; // <Dynamic, Int>
		public var m_MOUSE_UPS:Map<{}, Int>; // <Dynamic, Int>

		//------------------------------------------------------------------------------------------
		public function new () {
			alpha = 1.0;
			rotation = 0.0;
			scaleX = 1.0;
			scaleY = 1.0;
			visible = false;
			width = 0;
			height = 0;
			m_mouseX = 0;
			m_mouseY = 0;
			m_stageX = 0;
			m_stageY = 0;
			x = 0;
			y = 0;
			regX = 0;
			regY = 0;
			mouseEnabled = false;
			m_isOver = false;
			m_numChildEvents = 0;
			
			m_CLICKS = Map<{}, Int> (); // <Dynamic, Int>
			m_DOUBLE_CLICKS = new Map<{}, Int> (); // <Dynamic, Int>
			m_MOUSE_DOWNS = new Map<{}, Int> (); // <Dynamic, Int>
			m_MOUSE_MOVES = new Map<{}, Int> (); // <Dynamic, Int>
			m_MOUSE_OUTS = new Map<{}, Int> (); // <Dynamic, Int>
			m_MOUSE_OVERS = new Map<{}, Int> (); // <Dynamic, Int>
			m_MOUSE_UPS = new Map<{}, Int> (); // <Dynamic, Int>
		}

		//------------------------------------------------------------------------------------------	
		public function globalToLocal (__point:XPoint):XPoint {	
			var __m:XMatrix = getConcatenatedMatrix ();
			__m.invert ();
			__m.append (new XMatrix (1, 0, 0, 1, __point.x, __point.y));
			
			return new XPoint (__m.tx, __m.ty);
		}
		
		//------------------------------------------------------------------------------------------	
		public function localToGlobal (__point:XPoint):XPoint {
			var __m:XMatrix  = getConcatenatedMatrix ();
			__m.append (new XMatrix (1, 0, 0, 1, __point.x, __point.y));
			
			return new XPoint (__m.tx, __m.ty);
		}

		//------------------------------------------------------------------------------------------	
		public function getConcatenatedMatrix ():XMatrix {
			var __m:XMatrix = new XMatrix ();
			
			var __sprite:Sprite5 = this;
			
			do {
				var __r:Float = __sprite.rotation * Math.PI/180;
				var __cos:Float = Math.cos (__r);
				var __sin:Float = Math.sin (__r);
				
				__m.concat (XMatrix.createTranslation (-__sprite.regX, -__sprite.regY));
				
				__m.concat (
					new XMatrix (
						__cos * __sprite.scaleX,
						__sin * __sprite.scaleX,
						-__sin * __sprite.scaleY,
						__cos * __sprite.scaleY,
						__sprite.x,
						__sprite.y
					)
				);
				
				__sprite = __sprite.parent;
			} while (__sprite != null);
			
			return __m;
		}
		
		//------------------------------------------------------------------------------------------
		public var mouseX (get, set):Float;
		
		public function get_mouseX ():Float {
			return m_mouseX;
		}
		
		public function set_mouseX (__val:Float): Float {
			m_mouseX = __val;
			
			return 0;			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
		public var mouseY (get, set):Float;
		
		public function get_mouseY ():Float {
			return m_mouseY;
		}
		
		public function set_mouseY (__val:Float): Float {
			m_mouseY = __val;
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var stageX (get, set):Float;
		
		public function get_stageX ():Float {
			return m_stageX;
		}
		
		public function set_stageX (__val:Float): Float {
			m_mouseX = __val;
			
			return 0;			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
		/* @:get, set stageY Float*/
		
		public function get_stageY ():Float {
			return m_stageY;
		}
		
		public function set_stageY (__val:Float):  {
			m_mouseY = __val;
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var numChildEvents (get, set):Int;
		
		public function get_numChildEvents ():Int {
			return m_numChildEvents;
		}
		
		public function set_numChildEvents (__val:Int): Int {
			m_numChildEvents = __val;
			
			return 0;			
		}
		/* @:end */
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
// }