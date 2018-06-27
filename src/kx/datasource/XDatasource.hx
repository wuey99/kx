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
package kx.datasource;
	
// flash classes
	import openfl.utils.ByteArray;

//------------------------------------------------------------------------------------------
	class XDatasource {
						
//------------------------------------------------------------------------------------------
		public function new () {	
			// super ();
		}

//------------------------------------------------------------------------------------------
//		public function setup ():void {
//		}
		
//------------------------------------------------------------------------------------------
//		public function open ():void {
//		}
		
//------------------------------------------------------------------------------------------
		public function close ():Void {
		}

//------------------------------------------------------------------------------------------
		public var position (get, set):Int;
		
		public function get_position ():Int {
			return 0;
		}
		
		public function set_position (__position:Int): Int {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------	
		public function readByte ():Int {
			return 0;
		}
		
//------------------------------------------------------------------------------------------	
		public function readBytes (__offset:Int, __length:Int):ByteArray {
			return null;
		}
		
//------------------------------------------------------------------------------------------	
		public function writeByte (__val:Int):Void {
		}
		
//------------------------------------------------------------------------------------------	
		public function writeBytes (__bytes:ByteArray, __offset:Int, __length:Int):Void {
		}

//------------------------------------------------------------------------------------------
		public function readUTFBytes (__length:Int):String {
			return null;
		}

//------------------------------------------------------------------------------------------	
		public function writeUTFBytes (__val:String):Void {
		}		
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
// }