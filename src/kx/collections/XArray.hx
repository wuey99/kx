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
package kx.collections;

//------------------------------------------------------------------------------------------
	class XArray {
		private var m_array:Array<Dynamic>; // <Dynamic>
		
//------------------------------------------------------------------------------------------
		public function new () {
			super();
			
			m_array = new Array<Dynamic> (); // <Dynamic>
		}

//------------------------------------------------------------------------------------------
		public function setup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
	
//------------------------------------------------------------------------------------------
		public function push (__val:Dynamic /* */):Void {
			m_array.push (__val);
		}
		
//------------------------------------------------------------------------------------------
		public function pop ():Dynamic /* */ {
			return m_array.pop ();
		}
	
//------------------------------------------------------------------------------------------
		public function get (__key:Int):Dynamic /* */ {
			return m_array[__key];
		}
	
//------------------------------------------------------------------------------------------
		public function put (__key:Int, __val:Dynamic /* */):Void {
			m_array[__key] = __val;
		}	
		
//------------------------------------------------------------------------------------------
		public function remove (__key:Int):Void {
		}
		
//------------------------------------------------------------------------------------------
		public function length ():Int {
			return m_array.length;
		}
			
//------------------------------------------------------------------------------------------
		public function indexOf (__val:Dynamic /* */):Int {
			return m_array.indexOf (__val);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }