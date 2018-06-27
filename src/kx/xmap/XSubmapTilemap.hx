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
package kx.xmap;

	import openfl.display.*;
	import openfl.geom.*;
	import openfl.utils.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.world.*;
	import kx.world.sprite.*;
	
	
//------------------------------------------------------------------------------------------	
	class XSubmapTilemap extends Tilemap {
		public static var g_XApp:XApp;
		
//------------------------------------------------------------------------------------------
		public function new (__width:Int, __height:Int, __tileset:Tileset) {
			super (__width, __height, __tileset);
		}

//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			/*
			var __tile:Tile;
			
			var i:Int;
			
			for (i in 0 ... numTiles) {
				__tile = getTileAt (i);
				
				g_XApp.getTilePoolManager ().returnObject (__tile);
			}
			*/
			
			removeTiles ();
		}
		
		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):Void {
			g_XApp = __XApp;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
