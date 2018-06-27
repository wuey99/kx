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
	
	import openfl.display.*;
	import openfl.geom.*;
	
	
	//------------------------------------------------------------------------------------------
	// this class manages XSubMovieClipCacheManagers
	//------------------------------------------------------------------------------------------
	class XTextureManager {
		private var m_XApp:XApp;
		
		private var m_subManagers:Map<String, XSubTextureManager>; // <String, XSubTextureManager>
			
		//------------------------------------------------------------------------------------------
		public function new (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_subManagers = new Map<String, XSubTextureManager> (); // <String, XSubTextureManager>
		}

		//------------------------------------------------------------------------------------------
		public function setup ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

		//------------------------------------------------------------------------------------------
		public function createSubManager (__name:String, __width:Int=2048, __height:Int=2048):XSubTextureManager {
			var __subManager:XSubTextureManager = new XTileSubTextureManager (m_XApp, __width, __height);
			m_subManagers.set (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeSubManager (__name:String):Void {	
			if (m_subManagers.exists (__name)) {
				var __subManager:XSubTextureManager = m_subManagers.get (__name);
				__subManager.cleanup ();
			
				m_subManagers.remove (__name);
			}
		}

		//------------------------------------------------------------------------------------------
		public function getSubManager (__name:String):XSubTextureManager {
			return m_subManagers.get (__name) /* as XSubTextureManager */;
		}
		
		//------------------------------------------------------------------------------------------
		// TODO: figure out a better way of deciding which dynamic texture manager to use
		// to create the MovieClip to.  Currently, it'll always use the first one.  It might
		// make sense to only support one dynamic texture manager?
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):Dynamic /* */ {
			var __tilemap:Tilemap = null;
		
			var __dynamicSubManagers:Array<XSubTextureManager> = new Array<XSubTextureManager> ();
			
			for (__key__ in m_subManagers.keys ()) {
				function (x:Dynamic):Void {
					if (__tilemap == null) {
						var __subManager:XSubTextureManager = m_subManagers.get (cast x);
						
						__tilemap = cast __subManager.createMovieClip (__className);
					}
				} (__key__);
			}
		
			return __tilemap;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
// }
