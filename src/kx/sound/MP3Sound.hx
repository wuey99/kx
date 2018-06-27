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
package kx.sound;
	
	import kx.collections.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.XApp;
	
	import openfl.events.*;
	import openfl.media.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------	
	class MP3Sound extends EventDispatcher  {
		public var m_mp3:Sound;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup (__mp3:Sound):Void {
			m_mp3 = __mp3;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public var rate (get, set):Float;

		public function get_rate():Float {
			return 0;
		}
		
		public function set_rate( value:Float ): Float {
			return 0;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var volume (get, set):Float;
		
		public function get_volume():Float {
			return 0;
		}
		
		public function set_volume( value:Float ): Float {
			return 0;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var position (get, set):Float;
		
		public function get_position():Float {
			return 0;
		}

		public function set_position(value:Float): Float {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var length (get, set):Float;
		
		public function get_length():Float {
			return 0;
		}
		
		public function set_length(value:Float): Float {
			return 0;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function play (__startTime:Float, __loops:Int, __soundTransform:SoundTransform):Void {
		}

//------------------------------------------------------------------------------------------
		public function stop ():Void {
		}

//------------------------------------------------------------------------------------------
		public function pause ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function resume ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function addCompleteListener (__function:Dynamic /* Function */):Void {	
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
