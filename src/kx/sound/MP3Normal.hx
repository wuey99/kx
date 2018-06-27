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
	class MP3Normal extends MP3Sound  {
		public var m_soundChannel:SoundChannel;
		public var m_function:Dynamic /* Function */;
		public var m_loops:Int;
		public var m_soundTransform:SoundTransform;
		public var m_position:Float;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public override function play (__startTime:Float, __loops:Int, __soundTransform:SoundTransform):Void {
			m_loops = __loops;
			m_soundTransform = __soundTransform;
			
			m_soundChannel = m_mp3.play (__startTime, __loops, __soundTransform);
		}

//------------------------------------------------------------------------------------------
		public override function stop ():Void {
			m_soundChannel.stop ();
			
			m_soundChannel.removeEventListener(Event.SOUND_COMPLETE, m_function);
		}
		
//------------------------------------------------------------------------------------------
		public override function pause ():Void {
			m_position = m_soundChannel.position;
			
			m_soundChannel.stop ();
		}
		
//------------------------------------------------------------------------------------------
		public override function resume ():Void {
			m_soundChannel = m_mp3.play (m_position, m_loops, m_soundTransform);
		}
		
//------------------------------------------------------------------------------------------
		public override function addCompleteListener (__function:Dynamic /* Function */):Void {
			m_function = __function;
			
			m_soundChannel.addEventListener (Event.SOUND_COMPLETE, m_function);
		}

//------------------------------------------------------------------------------------------
		public function getSoundTransform ():SoundTransform {
			return m_soundChannel.soundTransform;		
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundTransform (__transform:SoundTransform):Void {
			m_soundChannel.soundTransform = __transform;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
