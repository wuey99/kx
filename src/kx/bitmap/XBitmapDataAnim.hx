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
package kx.bitmap;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	
	import openfl.display.*;
	import openfl.geom.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------	
	class XBitmapDataAnim {
		public var m_bitmaps:Array<BitmapData>; // <BitmapData>
		public var m_dx:Float;
		public var m_dy:Float;
		public var m_ready:Bool;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			// super ();

			m_bitmaps = new Array<BitmapData> (); // <BitmapData>
			
			m_ready = false;
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {	
			var i:Int;
			
			for (i in 0 ... m_bitmaps.length) {
				m_bitmaps[i].dispose ();
				m_bitmaps[i] = null;
			}
			
			m_bitmaps = null;
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScaling (__XApp:XApp, __movieClip:MovieClip, __scale:Float):Void {
			initWithScalingXY (__XApp, __movieClip, __scale, __scale);
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScalingXY (__XApp:XApp, __movieClip:MovieClip, __scaleX:Float, __scaleY:Float):Void {
			var i:Int;
			var __width:Float, __height:Float;
			var __rect:Rectangle = null;
			
			__width = 0;
			__height = 0;
			
			for (i in 0 ... __movieClip.totalFrames) {
				__movieClip.gotoAndStop (i+1);
				__rect = __movieClip.getBounds (__movieClip);
				__width = Math.max (__width, __rect.width);
				__height = Math.max (__height, __rect.height);
			}
		 
			for (i in 0 ... __movieClip.totalFrames) {
				var __bitmap:BitmapData = new BitmapData (Std.int (__width*__scaleX), Std.int (__height*__scaleY), true, 0xffffff);
				m_bitmaps.push (__bitmap);
			}
		
			m_dx = -__rect.x*__scaleX;
			m_dy = -__rect.y*__scaleY;
			
			var __index:Int;

			__XApp.getXTaskManager ().addTask ([		
				function ():Void {
					__index = 0;
				},
				
				XTask.LABEL, "loop",
					function ():Void {
						__movieClip.gotoAndStop (__index + 1);
					}, 

					function ():Void {
						if (m_bitmaps != null && m_bitmaps[__index] != null) {
							__rect = __movieClip.getBounds (__movieClip);
							var __matrix:Matrix = new Matrix ();
							__matrix.scale (__scaleX, __scaleY);
							__matrix.translate (-__rect.x*__scaleX, -__rect.y*__scaleY);
							m_bitmaps[__index].draw (__movieClip, __matrix);
						}
						__index += 1;
					},
					
					XTask.FLAGS, function (__task:XTask):Void {
						__task.ifTrue (__index == __movieClip.totalFrames);
					},
					
					XTask.BNE, "loop",
					
					function ():Void {
						m_ready = true;
					},
					
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public function isReady ():Bool {
			return m_ready;
		}
		
		//------------------------------------------------------------------------------------------
		public function getNumBitmaps ():Int {
			return m_bitmaps.length;
		}
		
		//------------------------------------------------------------------------------------------
		public function getBitmap (__frame:Int):BitmapData {
			return m_bitmaps[__frame];
		}		

		//------------------------------------------------------------------------------------------
		public var dx (get, set):Float;
		
		public function get_dx ():Float {
			return m_dx;
		}
		
		public function set_dx (__val:Float): Float {
			return 0;	
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public var dy (get, set):Float;
		
		public function get_dy ():Float {
			return m_dy;
		}

		public function set_dy (__val:Float): Float {
			return 0;	
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
// }
