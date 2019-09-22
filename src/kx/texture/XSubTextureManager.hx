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
package kx.texture;
	
	// X classes
	import kx.collections.*;
	import kx.task.*;
	import kx.world.sprite.*;
	import kx.XApp;
	import kx.texture.*;
	import kx.type.*;
	
	import openfl.display.BitmapData;
	import openfl.geom.*;
	
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	class XSubTextureManager {
		private var m_XApp:XApp;
		
		private var TEXTURE_WIDTH:Int = 2048;
		private var TEXTURE_HEIGHT:Int = 2048;
			
		private var m_queue:Map<String, Int>; // <String, Int>
		
		private var m_count:Int;
		
		//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp, __width:Int=2048, __height:Int=2048) {
			m_XApp = __XApp;
			
			TEXTURE_WIDTH = __width;
			TEXTURE_HEIGHT = __height;
			
			m_count = 0;
			
			m_queue = new Map<String, Int> ();  // <String, Int>
			
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					function ():Void {
						XType.forEach (m_queue, 
							function (x:Dynamic /* */):Void {
								var __className:String = cast x; /* as String */
								var __class:Class<Dynamic> /* <Dynamic> */ = m_XApp.getClass (__className);
							
								if (__class != null) {
									createTexture (__className, __class);
								
									m_queue.remove (__className);
								
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
		public function cleanup ():Void {
			reset ();
		}

		//------------------------------------------------------------------------------------------
		public function reset ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function start ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function finish ():Void {
		}

		//------------------------------------------------------------------------------------------
		public function isDynamic ():Bool {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public function add (__className:String):Void {	
		}	

		//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Bool {
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function movieClipExists (__className:String):Bool {
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function createTexture (__className:String, __class:Class<Dynamic> /* <Dynamic> */):Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):Dynamic /* */ /* <Dynamic> */ {
			return null;
		}

		//------------------------------------------------------------------------------------------
		private function __begin ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		private function __end ():Void {	
		}

		//------------------------------------------------------------------------------------------
		private function __generateIndex (__index:Int):String {
			var __indexString:String = Std.string (__index);
			
			switch (__indexString.length) {
				case 1:
					return "00" + __indexString;
					// break;
				case 2:
					return "0" + __indexString;
					// break;
				case 3:
					return __indexString;
					// break;
			}
			
			return __indexString;
		}
		
		//------------------------------------------------------------------------------------------
		private function __getRealBounds(clip:flash.display.DisplayObject):Rectangle {
			var bounds:Rectangle = clip.getBounds(clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);
			
			var _margin:Float = 2.0;
			
			var realBounds:Rectangle = new Rectangle(0, 0, bounds.width + _margin * 2, bounds.height + _margin * 2);
			var tmpBData:BitmapData;
			
			// Checking filters in case we need to expand the outer bounds
			if (clip.filters.length > 0)
			{
				// filters
				var j:Int = 0;
				//var clipFilters:Array /* <Dynamic> */ = clipChild.filters.concat();
				var clipFilters:Array<Dynamic> /* <Dynamic> */ = clip.filters;
				var clipFiltersLength:Int = clipFilters.length;
				var filterRect:Rectangle;
				
				tmpBData = new BitmapData (Std.int (realBounds.width), Std.int (realBounds.height), false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				tmpBData.dispose();
				
				while (++j < clipFiltersLength)
				{
					tmpBData = new BitmapData (Std.int (filterRect.width), Std.int (filterRect.height), true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}
			
			realBounds.offset (bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);
			
			tmpBData = null;
			return realBounds;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
// }
