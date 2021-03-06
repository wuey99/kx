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
	
	// X classes
	import kx.collections.*;
	import kx.task.*;
	import kx.type.*;
	import kx.world.sprite.XBitmap;
	import kx.XApp;
	
	import openfl.display.MovieClip;
	
//------------------------------------------------------------------------------------------	
	class XBitmapDataAnimManager {
		private var m_XApp:XApp;
		private var m_bitmapAnims:Map<String, XBitmapDataAnim>; // <String, XBitmapDataAnim>
		private var m_count:Map<String, Int>; // <String, Int>
		private var m_queue:Map<String, Int>; // <String, Int>
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_bitmapAnims = new Map<String, XBitmapDataAnim> (); // <String, XBitmapDataAnim>
			m_count = new Map<String, Int> (); // <String, Int>
			m_queue = new Map<String, Int> (); // <String, Int>
			
			// checked queued images and cache the ones that have loaded.
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():Void {
						XType.forEach (m_queue, 
							function (x:Dynamic /* */):Void {
								var __className:String = cast x; /* as String */
								var __class:Class<Dynamic> /* <Dynamic> */ = m_XApp.getClass (__className);
								
								if (__class != null) {
									var __bitmapAnim:XBitmapDataAnim = m_bitmapAnims.get (__className);
									
									if (__bitmapAnim == null) {
										__createBitmapAnim (__className, __class);
										
										__bitmapAnim = m_bitmapAnims.get (__className);
									}								
	
									if (__bitmapAnim.isReady ()) {
										m_queue.remove (__className);
									}
									
									m_XApp.unloadClass (__className);
								}
							}
						);
					},
						
				XTask.GOTO, "loop",
						
				XTask.RETN,
			]);
		}
					
//------------------------------------------------------------------------------------------
		public function add (__className:String):XBitmapDataAnim {
			if (m_bitmapAnims.exists (__className)) {
//				m_count[__className]++;
				var __count:Int = m_count.get (__className);
				__count++;
				m_count.set (__className, __count);
				
				// this could return null if the image is still loading.	
				return m_bitmapAnims.get (__className);
			}
							
//			m_count[__className] = 1;
			m_count.set (__className, 1);
			
			m_bitmapAnims.set (__className, null);
	
			trace (": queuing: ", __className);
			
			var __class:Class<Dynamic> /* <Dynamic> */ = m_XApp.getClass (__className);
							
			trace (": XBitmapDataAnimManager: caching: ", __className, __class);
							
			if (__class != null) {
				var __bitmapDataAnim:XBitmapDataAnim = __createBitmapAnim (__className, __class);
				
				m_XApp.unloadClass (__className);
				
				return __bitmapDataAnim;
			}
			else
			{
				// wait for image to load before caching it.
				m_queue.set (__className, 0);
			}
			
			return null;
		}


//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XApp.getXTaskManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Bool {
			return m_queue.exists (__className);	
		}
						
//------------------------------------------------------------------------------------------
		private function __createBitmapAnim (__className:String, __class:Class<Dynamic> /* <Dynamic> */):XBitmapDataAnim {
			var __movieClip:MovieClip = XType.createInstance (__class);
			__movieClip.stop ();
			
			var __XBitmapDataAnim:XBitmapDataAnim = new XBitmapDataAnim ();
			__XBitmapDataAnim.initWithScaling (m_XApp, __movieClip, 1.0);
							
			trace (": adding bitmap: ", __movieClip, __XBitmapDataAnim, __XBitmapDataAnim);
							
			m_bitmapAnims.set (__className, __XBitmapDataAnim);
							
			return __XBitmapDataAnim;			
		}
						
//------------------------------------------------------------------------------------------
		public function remove (__className:String):Void {
			if (m_bitmapAnims.exists (__className)) {
//				m_count[__className]--;
				var __count:Int = m_count.get (__className);
				__count--;
				m_count.set (__className, __count);
				
//				if (m_count[__className] == 0) {
				if (__count == 0) {
					var __XBitmapDataAnim:XBitmapDataAnim = m_bitmapAnims.get (__className);
									
					__XBitmapDataAnim.cleanup ();
									
					m_bitmapAnims.remove (__className);
				}
			}		
		}
						
	//------------------------------------------------------------------------------------------
		public function get (__className:String):XBitmapDataAnim {
			if (m_bitmapAnims.exists (__className)) {
				return m_bitmapAnims.get (__className);
			}
							
			return null;
		}
						
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
// }
