//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
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
package gx.levels;
		
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import gx.*;
	import gx.assets.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;
	
	//------------------------------------------------------------------------------------------
	class LevelPropsX {
		public var m_props:Map<String, Dynamic>; // <String, Dynamic>
		
		//------------------------------------------------------------------------------------------
		public function new () {
			// super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (args:Array<Dynamic> /* <Dynamic> */):LevelPropsX {
			m_props = new Map<String, Dynamic> (); // <String, Dynamic>
			
			var i:Int = 0;

			while (i < args.length) {
				setProperty (args[i+0], args[i+1]);
				
				i += 2;
			}
			
			return this;
		}

		//------------------------------------------------------------------------------------------
		public function getProperty (__key:String):Dynamic /* */ {
			return m_props.get (__key);
		}
		
		//------------------------------------------------------------------------------------------
		public function setProperty (__key:String, __val:Dynamic /* */):Void {
			m_props.set (__key, __val);
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
// }