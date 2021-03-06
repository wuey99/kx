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
	import kx.world.sprite.XMovieClip;
	import kx.XApp;

	// begin include "..\\flash.h";
	import openfl.display.*;
	// end include "..\\flash.h";
	
//------------------------------------------------------------------------------------------	
	class XMovieClipCacheManager {
		private var m_XApp:XApp;
		private var m_movieClips:Map<String, XMovieClip>;  // <String, XMovieClip>
		private var m_count:Map<String, Int>; // <String, Int>
		
//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_movieClips = new Map<String, XMovieClip> ();  // <String, XMovieClip>
			m_count = new Map<String, Int> (); // <String, Int>
		}

//------------------------------------------------------------------------------------------
		public function add (__className:String):XMovieClip {
			if (m_movieClips.exists (__className)) {
//				m_count[__className]++;
				var __count:Int = m_count.get (__className);
				__count++;
				m_count.set (__className, __count);
				
				return m_movieClips.get (__className);
			}
			
//			m_count[__className] = 1;
			m_count.set (__className, 1);
			
			var __movieClip:XMovieClip = __createXMovieClip (__className);
			
			m_movieClips.set (__className, __movieClip);
			
			return __movieClip;
		}

//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Bool {
			var __movieClip:XMovieClip = m_movieClips.get (__className);
			
			if (__movieClip.getMovieClip () == null) {
				return true;
			}
			else
			{
				return false;
			}
		}

//------------------------------------------------------------------------------------------
		private function __createXMovieClip (__className:String):XMovieClip {
			var __xmovieClip:XMovieClip = new XMovieClip ();
				
			__xmovieClip.setup ();
				
			__xmovieClip.initWithClassName (null, m_XApp, __className);
				
			m_movieClips.set (__className, __xmovieClip);
								
			return __xmovieClip;
		}
		
//------------------------------------------------------------------------------------------
		public function remove (__className:String):Void {
			if (m_movieClips.exists (__className)) {
//				m_count[__className]--;
				var __count:Int = m_count.get (__className);
				__count--;
				m_count.set (__className, __count);
				
//				if (m_count[__className] == 0) {
				if (__count == 0) {
					var __movieClip:XMovieClip = m_movieClips.get (__className);
				
					__movieClip.cleanup ();
					
					m_movieClips.remove (__className);
				}
			}		
		}

//------------------------------------------------------------------------------------------
		public function get (__className:String):XMovieClip {
			if (m_movieClips.exists (__className)) {
				return m_movieClips.get (__className);
			}

			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
